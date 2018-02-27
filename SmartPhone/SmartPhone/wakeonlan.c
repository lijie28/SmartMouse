//
//  wakeonlan.c
//  SmartPhone
//
//  Created by JackLee on 2018/2/27.
//  Copyright © 2018年 Jack. All rights reserved.
//

#include "wakeonlan.h"

#include <arpa/inet.h>
#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <getopt.h>
#include <unistd.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>

/* Sends Wake-On-LAN packet to given address with the given options, where the
 * address is in the form "XX:XX:XX:XX:XX:XX" (the colons are optional).
 *
 * Returns 0 on success, -1 on error. */
int send_wol(const char *hardware_addr, unsigned port, unsigned long bcast);

static void print_usage(const char *progname)
{
    fprintf(stderr,
            "Usage: %s [-q] [-b <bcast>] [-p <port>] <dest>\n",
            progname);
}

typedef enum {
    OPT_ARG_REQUIRED,
    OPT_ADDRESS_REQUIRED,
    OPT_INT_REQUIRED,
    OPT_INVALID
} option_err;

static void print_option_error(const char opt, option_err err)
{
    switch (err) {
        case OPT_ARG_REQUIRED:
            fprintf(stderr, "Option -%c requires an argument.\n", opt);
            break;
        case OPT_ADDRESS_REQUIRED:
            fprintf(stderr, "Option -%c requires address as argument\n", opt);
            break;
        case OPT_INT_REQUIRED:
            fprintf(stderr, "Option -%c requires integer as argument\n", opt);
            break;
        case OPT_INVALID:
            fprintf(stderr, "Unknown option '-%c'.\n", opt);
            break;
    }
}

//int main(int argc, char * const argv[])
//{
//    int c;
//    unsigned port = 60000;
//    char quiet = 0;
//    unsigned long bcast = 0xFFFFFFFF;
//
//    while ((c = getopt(argc, argv, "hqb:p:d:")) != -1) {
//        switch (c) {
//            case 'h': /* help */
//                print_usage(argv[0]);
//                return 1;
//            case 'q': /* quiet */
//                quiet = 1;
//                break;
//            case 'b': /* bcast */
//                bcast = inet_addr(optarg);
//                if (bcast == INADDR_NONE) {
//                    print_option_error(optopt, OPT_ADDRESS_REQUIRED);
//                    return 1;
//                }
//                break;
//            case 'p': /* port */
//                port = strtol(optarg, NULL, 0);
//                if (port == 0 && errno != 0) {
//                    print_option_error(optopt, OPT_INT_REQUIRED);
//                    return 1;
//                }
//                break;
//            case '?': /* unrecognized option */
//                if (optopt == 'b' || optopt == 'p' || optopt == 'd') {
//                    return print_option_error(optopt, OPT_ARG_REQUIRED), 1;
//                } else {
//                    return print_option_error(optopt, OPT_INVALID), 1;
//                }
//            default:
//                abort();
//        }
//    }
//
//    /* Parse any remaining arguments (not options). */
//    if (optind == argc - 1) {
//        if (send_wol(argv[optind], port, bcast) < 0) {
//            fputs("Error sending packet.\n", stderr);
//            return 1;
//        } else if (!quiet) {
//            printf("Packet sent to %08X-%s on port %d\n", htonl(bcast),
//                   argv[optind],
//                   port);
//        }
//    } else {
//        print_usage(argv[0]);
//        return 1;
//    }
//
//    return 0;
//}

static int get_ether(const char *hardware_addr, unsigned char *dest);

int send_wol(const char *hardware_addr, unsigned port, unsigned long bcast)
{
    unsigned char ether_addr[8];
    unsigned char message[102];
    unsigned char *message_ptr = message;
    int packet;
    int optval = 1;
    size_t i;
    struct sockaddr_in addr;
    
    /* Fetch the hardware address. */
    if (get_ether(hardware_addr, ether_addr) < 0) {
        fprintf(stderr,
                "\"%s\" is not a valid ether address!\n", hardware_addr);
        return -1;
    }
    
    if ((packet = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0) {
        perror("socket");
        return -1;
    }
    
    /* Build the message to send.
     (6 * 0XFF followed by 16 * destination address.) */
    memset(message_ptr, 0xFF, 6);
    message_ptr += 6;
    for (i = 0; i < 16; ++i) {
        memcpy(message_ptr, ether_addr, 6);
        message_ptr += 6;
    }
    
    /* Check for inadvertent programmer-error buffer overflow. */
    assert((message_ptr - message) <= sizeof(message) / sizeof(message[0]));
    
    /* Set socket options. */
    if (setsockopt(packet, SOL_SOCKET, SO_BROADCAST,
                   &optval, sizeof optval) < 0) {
        perror("setsockopt");
        close(packet);
        return -1;
    }
    
    /* Set up broadcast address */
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = bcast;
    addr.sin_port = htons(port);
    
    /* Send the packet out. */
    if (sendto(packet, (char *)message, sizeof message, 0,
               (struct sockaddr *)&addr, sizeof addr) < 0) {
        perror("sendto");
        close(packet);
        return -1;
    }
    
    close(packet);
    return 0;
}

/* Attempts to extract hexadecimal from ASCII string.
 * Returns characters read on success, or 0 on error. */
static size_t get_hex_from_string(const char *buf, size_t buflen, unsigned *hex)
{
    size_t i;
    
    assert(hex != NULL);
    *hex = 0;
    for (i = 0; i < buflen && buf[i] != '\0'; ++i) {
        *hex <<= 4;
        if (isdigit(buf[i])) {
            *hex |= buf[i] - '0';
        } else if (buf[i] >= 'a' && buf[i] <= 'f') {
            *hex |= buf[i] - 'a' + 10;
        } else if (buf[i] >= 'A' && buf[i] <= 'F') {
            *hex |= buf[i] - 'A' + 10;
        } else {
            return 0; /* Error */
        }
    }
    return i;
}

/* Extract inet address from hardware address.
 * |dest| must be at least 8 characters long. */
static int get_ether(const char *hardware_addr, unsigned char *dest)//检测mac地址是否正确
{
    const char *orig = hardware_addr;
    size_t i;
    
    assert(hardware_addr != NULL);
    assert(dest != NULL);
    for (i = 0; *hardware_addr != '\0' && i < 6; ++i) {
        /* Parse two characters at a time. */
        unsigned hex;
        size_t chars_read = get_hex_from_string(hardware_addr, 2, &hex);
        if (chars_read == 0) {
            return -1;
        } else {
            hardware_addr += chars_read;
        }
        
        *dest++ = (unsigned char)(hex & 0xFF);
        
        /* We might get a colon here, but it is not required. */
        if (*hardware_addr == ':') ++hardware_addr;
    }
    
    return (hardware_addr - orig == 17) ? 0 : -1;
}

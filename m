From: Michael Deegan <michael-nf@cnspc18.murdoch.edu.au>
Subject: libipq and NF_ACCEPT
Date: Tue, 29 Oct 2002 17:25:00 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021029092500.GC3457@zaphod.murdoch.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm working on some traffic accounting software, and while debugging I
noticed that queued traffic marked NF_ACCEPT doesn't seem to traverse the
rest of my firewall rules.

This is my test client (which incidentally serves as an example for those
wanting to use select() with their ipq clients):

/* just some testing code for the netfilter packet queuing to userspace 
   Based on code (C) 2000 by Harald Welte <laforge@sunbeam.franken.de>

   This code is licensed under GPL conditions 
   
   For your makefile:
   nfqtest: nfqtest.c
        gcc -Wall nfqtest.c -o nfqtest -lipq
           
*/

#include <stdio.h>
#include <stdlib.h>
#include <libipq/libipq.h>
#include <linux/netfilter.h>
#include <sys/socket.h>
#include <sys/un.h>

#include <linux/icmp.h>
#include <linux/ip.h>

#define IPQ_BUF_SIZE 10240

#if 1
#define CAPTURE_SIZE IPQ_BUF_SIZE
#else
#define CAPTURE_SIZE sizeof (struct iphdr)
#endif

#if 1
#define DEBUGP  printf
#else
#define DEBUGP(format, args...)
#endif

static  struct ipq_handle *qh;

void handle_packet(ipq_packet_msg_t *packet) {
    int ret;
    struct iphdr *ip=(struct iphdr *)packet->payload;
    int i;
    int verdict;

#ifdef DROP_TEST
    static int count;
#endif

    DEBUGP("PACKET id:0x%lX mark:%lu timestamp:%ld hook:%d indev:'%s' outdev:'%s' hw_protocol:%u datalen:%d\n",
           packet->packet_id, packet->mark, packet->timestamp_sec, packet->hook, packet->indev_name,
           packet->outdev_name, packet->hw_protocol, packet->data_len);
    
    printf("IP     size=%d src=0x%X dest=0x%X",ntohs(ip->tot_len),ntohl(ip->saddr),ntohl(ip->daddr));
    for (i=0;i<packet->data_len;++i) {
        if (!(i&31))
            printf("\n0x%04X ",i);
        else if (!(i&7))
            putchar(' ');
        else if (!(i&3))
            putchar(':');
        printf("%02X",packet->payload[i]);
    }
    putchar('\n');
    putchar('\n');

#ifdef DROP_TEST
    verdict=(++count&3)?NF_ACCEPT:NF_DROP; /* drop every fourth packet */
#else
    verdict=NF_ACCEPT;
#endif

#if CAPTURE_SIZE
    /* this will break if packet->data_len!=ip->tot_len (ie. CAPTURE_SIZE is too small) */
    ret = ipq_set_verdict(qh, packet->packet_id, verdict, packet->data_len, packet->payload);
#else
    /* actually, you could also use this branch if you're not modifying the packet */
    ret = ipq_set_verdict(qh, packet->packet_id, verdict, 0, NULL);
#endif
    if (ret < 0) {
        printf("error setting verdict\n");
        ipq_perror(NULL);
    }
}

int main() {
    ssize_t len;
    unsigned char *buf;

    int nready;
    fd_set rset, allset;

    qh = ipq_create_handle(0,PF_INET);
    if (!qh) {
        printf("can't create netlink socket\n");
        ipq_perror(NULL);
        exit(1);
    }
#if CAPTURE_SIZE
    if (ipq_set_mode(qh, IPQ_COPY_PACKET, CAPTURE_SIZE) < 0) {
#else
    if (ipq_set_mode(qh, IPQ_COPY_META, 0) < 0) {
#endif
        printf("can't set netlink mode\n");
        ipq_perror(NULL);
        exit(2);
    }

    FD_ZERO(&allset);
    FD_SET(qh->fd, &allset); /* hack! */

    buf = (unsigned char *) malloc(IPQ_BUF_SIZE);
    while (1) {
        rset=allset;
        nready = select(FD_SETSIZE, &rset, NULL, NULL, NULL);
        
        if (FD_ISSET(qh->fd, &rset)) {
            int ptype,error;
            ipq_packet_msg_t *packet;

            len = ipq_read(qh, buf, IPQ_BUF_SIZE, 0);
            if (len < 0) {
                printf("len < 0\n");
                break;
            } else if (len == 0) {
                printf("timeout exceeded\n");
            } else {
                ptype = ipq_message_type(buf);
                packet = ipq_get_packet(buf);
                DEBUGP("received packet, length=%d, type=%d, mark=%lx\n", len, ptype,packet->mark);
                DEBUGP("received packet: type=%d length=%d '%s'->'%s' mark:%lX hook:%d proto:%u datalen:%d\n",
                       ptype, len, packet->indev_name, packet->outdev_name, packet->mark, packet->hook, packet->hw_protocol, packet->data_len);
                switch (ptype) {
                    case NLMSG_ERROR:
                        error = ipq_get_msgerr(buf);
                        printf("NLMSG_ERROR: (%d) %s\n",error,strerror(error));
                        exit(3);
                        break;

                    case IPQM_PACKET:
                        handle_packet(packet);
                        break;

                    default:
                        printf("Unknown packet type %d!\n",ptype);
                }
            }
        } else
            printf("Gah, select() returned but nothing to do!\n");
    }
    ipq_perror(NULL);
    return 0;
}

Partial 'iptables -L -v' output:

Chain FORWARD (policy ACCEPT 122 packets, 7094 bytes)
 pkts bytes target     prot opt in     out     source               destination
    4   240 LOG        icmp --  any    any     anywhere             anywhere           LOG level warning prefix `prequeued: '
    4   240 QUEUE      icmp --  any    any     anywhere             anywhere
    0     0 LOG        icmp --  any    any     anywhere             anywhere           LOG level warning prefix `postqueued: '
    0     0 ACCEPT     icmp --  any    any     anywhere             anywhere

(in practice these rules will probably live in the POSTROUTING chain of the
mangle table)

I'm filtering only ICMP so that I can just use ping from a box that is
routed through the routing box. From the above it looks like that the QUEUE
target is a 'terminating' rule. Is it possible to get 'non-terminating'
behaviour instead? It makes it hard to tell whether changes (whether to the
packets themselves or metadata such as the nfmark) are actually occurring
properly. I can put the queuing rule in a separate table but I still notice
that flow does not return to the calling table.

I'm using kernel 2.4.20-pre11, iptables 1.2.6a-5 and Debian.

TIA,

-MD

-- 
_____________________________________________________________________________
Michael Deegan, Unix Support Officer, Murdoch University, Ph. +61 8 9360 6967

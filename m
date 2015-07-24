From: Tarik Demirci <tarik@tarikdemirci.com>
Subject: IPv4 IPv6 parallel dns lookup in combination with nfqueue is problematic
Date: Fri, 24 Jul 2015 13:34:19 +0300
Message-ID: <CAMxdDZBwqRxZjywAfHUm-bbe-0veLPqPwAfFpw90cb0As80Dmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:35259 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbbGXKeU convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jul 2015 06:34:20 -0400
Received: by obbop1 with SMTP id op1so13675818obb.2
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jul 2015 03:34:19 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Everyone,

Problem:
I have a simple daemon listening for packets coming from nfqueue. When
a client issues  parallel dns requests for IPv4 and IPv6 addresses
(since glibc 2.9 this is default behaviour), IPv6 request is dropped
on its way in gateway. Client, after 5 seconds timeout, sends these
requests sequentially and there is no problem in this case.

Workaround:
I applied a kernel patch from an earlier mail (
http://www.spinics.net/lists/netfilter-devel/msg15860.html ) to kernel
version 3.16. This patch solves the problem but I'm unaware of the
performance and security implications of this solution. I hope to find
a better solution that doesn't require patching kernel.


Regards,
Tarik.

Related links to the problem:
https://bbs.archlinux.org/viewtopic.php?id=3D75770
https://www.astaro.org/gateway-products/management-networking-logging-r=
eporting/51569-slow-dns-queries-parallel-requests-ipv6.html
http://www.spinics.net/lists/netfilter-devel/msg15860.html

Extra info:
I insert packets to nfqueue in mangle table (rather than raw) because
the daemon will need to process connection marks in the future.
Currently, it reads packets from queue, marks them and allows them to
pass (NF_ACCEPT).

Network topology:
In my topology, a client (10.21.0.100) sends dns requests to 8.8.4.4
via gateway (10.21.0.1). Gateway performs snat (to 10.100.0.21) and
sends packets. The daemon runs on gateway.
10.21.0.100 (client)  ---->  10.21.0.1 (gw internal interface) ------>
(snat) 10.100.0.21 (gw external interface) -----> 8.8.4.4

Iptables rule:
iptables -t mangle -A FORWARD -m mark --mark 0x0/0x3000000 -j NFQUEUE
--queue-num 10 --queue-bypass

--------

tcpdump output (unpatched kernel):
11:08:13.580903 IP 10.21.0.100.40004 > 8.8.4.4.53:  34824+ A? httpbin.o=
rg. (29)
11:08:13.580958 IP 10.21.0.100.40004 > 8.8.4.4.53:  17101+ AAAA?
httpbin.org. (29)
11:08:13.581084 IP 10.100.0.21.40004 > 8.8.4.4.53:  34824+ A? httpbin.o=
rg. (29)
11:08:13.604559 IP 8.8.4.4.53 > 10.100.0.21.40004:  34824 1/0/0 A
54.175.222.246 (45)
11:08:13.604607 IP 8.8.4.4.53 > 10.21.0.100.40004:  34824 1/0/0 A
54.175.222.246 (45)
11:08:18.585022 IP 10.21.0.100.40004 > 8.8.4.4.53:  34824+ A? httpbin.o=
rg. (29)
11:08:18.585097 IP 10.100.0.21.40004 > 8.8.4.4.53:  34824+ A? httpbin.o=
rg. (29)
11:08:18.606474 IP 8.8.4.4.53 > 10.100.0.21.40004:  34824 1/0/0 A
54.175.222.246 (45)
11:08:18.606563 IP 8.8.4.4.53 > 10.21.0.100.40004:  34824 1/0/0 A
54.175.222.246 (45)
11:08:18.607175 IP 10.21.0.100.40004 > 8.8.4.4.53:  17101+ AAAA?
httpbin.org. (29)
11:08:18.607246 IP 10.100.0.21.40004 > 8.8.4.4.53:  17101+ AAAA?
httpbin.org. (29)
11:08:18.664119 IP 8.8.4.4.53 > 10.100.0.21.40004:  17101 0/1/0 (110)
11:08:18.664201 IP 8.8.4.4.53 > 10.21.0.100.40004:  17101 0/1/0 (110)

----

tcpdump output (patched kernel):

15:39:53.141114 IP 10.21.0.100.58891 > 8.8.4.4.53:  43314+ A? httpbin.o=
rg. (29)
15:39:53.141247 IP 10.21.0.100.58891 > 8.8.4.4.53:  25492+ AAAA?
httpbin.org. (29)
15:39:53.141362 IP 10.100.0.21.58891 > 8.8.4.4.53:  43314+ A? httpbin.o=
rg. (29)
15:39:53.141672 IP 10.100.0.21.58891 > 8.8.4.4.53:  25492+ AAAA?
httpbin.org. (29)
15:39:53.166438 IP 8.8.4.4.53 > 10.100.0.21.58891:  25492 0/1/0 (110)
15:39:53.166507 IP 8.8.4.4.53 > 10.21.0.100.58891:  25492 0/1/0 (110)
15:39:53.167052 IP 8.8.4.4.53 > 10.100.0.21.58891:  43314 1/0/0 A
54.175.219.8 (45)
15:39:53.167095 IP 8.8.4.4.53 > 10.21.0.100.58891:  43314 1/0/0 A
54.175.219.8 (45)

-------


Kernel patch(3.16.3):

diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/ipta=
ble_nat.c
index f1787c0..b9f282a 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -18,6 +18,11 @@
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_l3proto.h>

+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_extend.h>
+#include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 static const struct xt_table nf_nat_ipv4_table =3D {
        .name           =3D "nat",
        .valid_hooks    =3D (1 << NF_INET_PRE_ROUTING) |
@@ -107,6 +112,20 @@ nf_nat_ipv4_fn(const struct nf_hook_ops *ops,
                }
                /* Fall thru... (Only ICMPs can be IP_CT_IS_REPLY) */
        case IP_CT_NEW:
+               /* Nasty asynchronous DNS hack: Avoid NAT and
conntrack_confirm race */
+               if (!nf_ct_is_confirmed(ct) && CTINFO2DIR(ctinfo) =3D=3D
IP_CT_DIR_ORIGINAL &&
+
ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum =3D=3D IPPROTO_UDP=
) {
+                       struct nf_conntrack_tuple_hash *h =3D
nf_conntrack_find_get(
+                                       nf_ct_net(ct),
+                                       NF_CT_DEFAULT_ZONE,
+
&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+                       if (h) {
+                               ct =3D nf_ct_tuplehash_to_ctrack(h);
+                               nf_conntrack_put(skb->nfct);
+                               skb->nfct =3D &ct->ct_general;
+                       }
+               }
+
                /* Seen it before?  This can happen for loopback, retra=
ns,
                 * or local packets.
                 */


-------

Source code of daemon:

#include <stdlib.h>
#include <signal.h>
#include <poll.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <arpa/inet.h>
#include <linux/netfilter.h>
#include <libnetfilter_queue/libnetfilter_queue.h>
#include <syslog.h>


#define CUSTOM_MARK 0x2000000

/* how long to wait for a new packet */
#define POLL_TIME 10

int g_shutdown =3D 0;

int nfq_callback_handler(struct nfq_q_handle *queue_handler, struct
nfgenmsg *nfmsg, struct nfq_data *tb, void *arg){
    unsigned char *data;
    int datalen =3D nfq_get_payload(tb, &data);
    if (datalen > 0)
    {

        struct nfqnl_msg_packet_hdr *hdr =3D nfq_get_msg_packet_hdr(tb)=
;

        nfq_set_verdict2(queue_handler,
                         hdr ? ntohl(hdr->packet_id) : 0,
                         NF_ACCEPT,
                         CUSTOM_MARK,
                         0,
                         NULL);
    }
    return 0;
}

void initialize_queue() {
    struct nfq_handle *nfqh=3D NULL;
    struct nfq_q_handle *queue_handler =3D NULL;
    unsigned int queue_num =3D 10;
    if ((nfqh =3D nfq_open()) =3D=3D 0){
        syslog(LOG_ERR, "nfq_open failed.");
    }
    else
    {
        /* ignore return code for this since it's inconsistent between
kernel versions */
        /* see http://www.spinics.net/lists/netfilter/msg42063.html */
        nfq_unbind_pf(nfqh, AF_INET);

        if (nfq_bind_pf(nfqh, AF_INET) < 0){
            syslog(LOG_ERR,"nfq_bind_pf failed.");
        }
        else if ((queue_handler =3D nfq_create_queue(nfqh, queue_num,
&nfq_callback_handler, NULL)) =3D=3D 0){
            syslog(LOG_ERR,"nfq_create_queue on %u failed.", queue_num)=
;
        }
        else if (nfq_set_mode(queue_handler, NFQNL_COPY_PACKET, 0xffff)=
 < 0) {
            syslog(LOG_ERR,"failed to set NFQNL_COPY_PACKET.");
        }
        else
        {
            /* get the file descriptor for netlink queue */
            int fd =3D nfnl_fd(nfq_nfnlh(nfqh));

            //set buf size
            int on =3D 1024 * 1024;
            unsigned int queue_size =3D 10000;
            if (setsockopt(fd, SOL_SOCKET, SO_RCVBUF, &on, sizeof(int))=
 =3D=3D -1 ){
                syslog(LOG_WARNING,"Buffer size could not be set");
            }

            //set queue size that is given by -s option
            if((nfq_set_queue_maxlen(queue_handler, queue_size)) =3D=3D=
 -1){
                syslog(LOG_WARNING,"Queue size could not be set.");
            }

            ssize_t ret;
            char buf[10000];
            struct pollfd pollinfo;
            while (!g_shutdown)
            {
                pollinfo.fd =3D fd;
                pollinfo.events =3D POLLIN;

                ret =3D poll(&pollinfo, 1, POLL_TIME);
                if ((ret < 0) && (errno !=3D EINTR))
                {
                    syslog(LOG_ERR,"poll error nfq fd %d (%d/%s)", fd,
errno, strerror(errno));
                    break;
                }

                while ((ret =3D recv(fd, buf, sizeof(buf), MSG_DONTWAIT=
)) > 0) {
                    nfq_handle_packet(nfqh, buf, (int)ret);
                }

                if (ret =3D=3D -1)
                {
                    if (errno =3D=3D EAGAIN || errno =3D=3D EINTR || er=
rno =3D=3D ENOBUFS)
                        ;
                    else
                    {
                        syslog(LOG_ERR, "recv error nfq fd %d
(%d/%s)", fd, errno, strerror(errno));
                        break;
                    }
                }
                else if (ret =3D=3D 0)
                {
                    syslog(LOG_ERR,"nfq socket closed");
                    break;
                }
            }
            nfq_destroy_queue(queue_handler);
            nfq_close( nfqh );
            queue_handler =3D NULL;
            nfqh =3D NULL;
        }
    }
}

static void sig_handler(int signum){
    /**
     * This function handles cathed signals
     *
     * @param signum : Sended signal
     * @return void
     */

    if(signum =3D=3D SIGINT){
        g_shutdown =3D 1;
        syslog(LOG_INFO,"Interrupted.");

    }
    else if(signum =3D=3D SIGTERM){
        g_shutdown =3D 1;
        syslog(LOG_INFO,"Killed.");

    }
}

int main(int argc, char *argv[]){
    int logOpt =3D LOG_PID;

    signal(SIGINT, sig_handler);  //sig number 2
    signal(SIGTERM, sig_handler); //sig number 15
    signal(SIGHUP, sig_handler);  //sig number 1
    signal(SIGUSR1, sig_handler);  //sig number 10
    openlog("sniffer", logOpt, LOG_USER);

    syslog(LOG_INFO, "Program is  started.");
    initialize_queue();
    closelog();

    return 0;
}



--=20
Tar=C4=B1k Demirci
tarikdemirci.com
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Joern Heissler <nfdevel@joern.heissler.de>
Subject: Possible bug in __nfnl_handle_msg
Date: Thu, 26 Jun 2014 22:50:23 +0200
Message-ID: <20140626205023.GA32347@joerntop.localnet>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="zhXaljGHf11kAtnf"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kappa.tutnicht.de ([87.230.93.31]:55178 "EHLO kappa.tutnicht.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbaFZU5I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:57:08 -0400
Received: from port-7387.pppoe.wtnet.de ([84.46.28.247] helo=joerntop.localnet)
	by kappa.tutnicht.de with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <nfdevel@joern.heissler.de>)
	id 1X0Gco-0008LA-A4
	for netfilter-devel@vger.kernel.org; Thu, 26 Jun 2014 22:50:30 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I'm trying to use libnetfilter_log and I think I might have found a bug :)

Whenever two or more packets are received at the same time, the
nflog_handle_packet function returns -1 instead of 0.
All example programs (including ulogd2) ignore the return value.

The code that fails is in function __nfnl_handle_msg:
if (type >= ssh->cb_count)
    return -1;

The first two invocations of that function succeed, but the third fails.
type is 3, ssh->cb_count is 0.

Some gdb output:

(gdb) print *h
$1 = {fd = 3,
  local = {nl_family = 16, nl_pad = 0, nl_pid = 32531, nl_groups = 0},
  peer = {nl_family = 16, nl_pad = 0, nl_pid = 0, nl_groups = 0},
  subscriptions = 0, seq = 1403814923, dump = 0,
  rcv_buffer_size = 8192, flags = 0, last_nlhdr = 0x0, subsys = {
    {nfnlh = 0x0, subscriptions = 0, subsys_id = 0 '\000',
      cb_count = 0 '\000', cb = 0x0},
    {nfnlh = 0x0, subscriptions = 0, subsys_id = 0 '\000',
      cb_count = 0 '\000', cb = 0x0},
    {nfnlh = 0x0, subscriptions = 0, subsys_id = 0 '\000',
      cb_count = 0 '\000', cb = 0x0},
    {nfnlh = 0x0, subscriptions = 0, subsys_id = 0 '\000',
      cb_count = 0 '\000', cb = 0x0},
    {nfnlh = 0x602010, subscriptions = 0, subsys_id = 4 '\004',
      cb_count = 2 '\002', cb = 0x602210},
    {nfnlh = 0x0, subscriptions = 0, subsys_id = 0 '\000',
      cb_count = 0 '\000', cb = 0x0}
  <repeats 12 times>}}

(gdb) print *nlh
$2 = {nlmsg_len = 20, nlmsg_type = 3, nlmsg_flags = 0, nlmsg_seq = 0,
      nlmsg_pid = 0}

Steps to reproduce:

# iptables -A OUTPUT -j NFLOG --nflog-group 42 --nflog-range 20

Run attached test case, then run ping -i 0.01 <someip>

Output for me:

msg = 54 00 00 00 00 04 00 00  00 00 00 00 00 00 00 00    T...............
      02 00 00 2a 08 00 01 00  00 00 03 00 05 00 0a 00    ...*............
      00 00 00 00 08 00 05 00  00 00 00 03 08 00 0b 00    ................
      00 00 03 e8 08 00 0e 00  00 00 03 e8 18 00 09 00    ................
      45 00 00 54 92 1b 40 00  40 01 31 bf c0 a8 b2 22    E..T..@.@.1...."
      02 02 02 02                                         ....
Got packet
nflog_handle_packet returned: 0
msg = 54 00 00 00 00 04 00 00  00 00 00 00 00 00 00 00    T...............
      02 00 00 2a 08 00 01 00  00 00 03 00 05 00 0a 00    ...*............
      00 00 00 00 08 00 05 00  00 00 00 03 08 00 0b 00    ................
      00 00 00 00 08 00 0e 00  00 00 00 00 18 00 09 00    ................
      45 00 00 54 9b 3b 40 00  40 01 2a a1 c0 a8 b2 22    E..T.;@.@.*...."
      01 01 01 01 54 00 00 00  00 04 00 00 00 00 00 00    ....T...........
      00 00 00 00 02 00 00 2a  08 00 01 00 00 00 03 00    .......*........
      05 00 0a 00 00 00 00 00  08 00 05 00 00 00 00 03    ................
      08 00 0b 00 00 00 03 e8  08 00 0e 00 00 00 03 e8    ................
      18 00 09 00 45 00 00 54  92 1c 40 00 40 01 31 be    ....E..T..@.@.1.
      c0 a8 b2 22 02 02 02 02  14 00 00 00 03 00 00 00    ..."............
      00 00 00 00 00 00 00 00  00 00 00 00                ............
Got packet
Got packet
nflog_handle_packet returned: -1


System information:
* Debian unstable
* Linux joerntop 3.14-1-amd64 #1 SMP Debian 3.14.7-1 (2014-06-16) x86_64 GNU/Linux
* libnetfilter-log1 version 1.0.0-1
* libnfnetlink0 version 1.0.1-3

Cheers
Joern Heissler

--zhXaljGHf11kAtnf
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="testnflog.c"

#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <unistd.h>
#include <netinet/in.h>
#include <libnetfilter_log/libnetfilter_log.h>

static void printhex(const unsigned char *p, size_t len, const char *descr)
{
    int dlen = descr ? (int) strlen(descr) + 3 : 0;
    if(dlen) printf("%s = %s", descr, len ? "" : "\n");
    while(len) {
        const unsigned char *q = p;
        for(int j = 0; j < 16; ++j) {
            if(len) {
                printf("%02x ", *q++);
                --len;
            } else {
                printf("   ");
            }
            if(j == 7) putchar(' ');
        }
        printf("   ");
        for(; p < q; ++p) putchar(isprint(*p) ? *p : '.');
        putchar('\n');
        if(len && dlen) printf("%*s", dlen, "");
    }
}

static int cb(struct nflog_g_handle *gh, struct nfgenmsg *nfmsg, struct nflog_data *nfd, void *data)
{
    (void) gh; (void) nfmsg; (void) nfd; (void) data;
    puts("Got packet");
    return 0;
}

int main(void)
{
    struct nflog_handle *h = nflog_open();
    if (! h) abort();

    if (nflog_bind_pf(h, AF_INET) < 0) abort();
    
    struct nflog_g_handle *gh = nflog_bind_group(h, 42);
    if (! gh) abort();

    if (nflog_set_mode(gh, NFULNL_COPY_PACKET, 20) < 0) abort();
    nflog_callback_register(gh, cb, NULL);

    if (nflog_set_nlbufsiz(gh, 65535) < 0) abort();

    if (nflog_set_timeout(gh, 10) < 0) abort();

    if (nflog_set_qthresh(gh, 2) < 0) abort();

    int fd = nflog_fd(h);
    if (fd < 0) abort();

    char buf[4096];
    ssize_t rv;
    while (rv = recv(fd, buf, sizeof buf, 0), rv > 0) {
        printhex((unsigned char *)buf, rv, "msg");
        int ret = nflog_handle_packet(h, buf, rv);
        printf("nflog_handle_packet returned: %d\n", ret);
    }
    return 0;
}

--zhXaljGHf11kAtnf--

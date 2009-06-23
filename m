From: Bernhard Schmidt <berni@birkenwald.de>
Subject: null-pointer deref in ulogd2
Date: Tue, 23 Jun 2009 07:27:45 +0000 (UTC)
Message-ID: <h1q05h$o8h$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:40847 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbZFWH14 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:27:56 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MJ0Q8-0003JI-RX
	for netfilter-devel@vger.kernel.org; Tue, 23 Jun 2009 07:27:56 +0000
Received: from ppp-82-135-84-171.dynamic.mnet-online.de ([82.135.84.171])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2009 07:27:56 +0000
Received: from berni by ppp-82-135-84-171.dynamic.mnet-online.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2009 07:27:56 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

we have just now tried to migrate the flow logging of our central NAT
gateway from conntrack -L | logger to ulogd2 and a PostgreSQL database.

4 CPU Xeon (64bit)
SLES 11
libnfnetlink 0.0.41
libnetfilter_log 0.0.16
libnetfilter_conntrack 0.0.99
ulogd2 2.0.0beta3

The system is pretty heavily used, at the moment it does about 200 Mbps
bandwidth, 30k concurrent sessions and maybe 500 new connections/s (hard
to tell).  ulogd is pretty much the vanilla config logging NFCT into
PGSQL.

Problem: ulogd crashes within seconds after the start. A gdb backtrace
looks like this:

Program received signal SIGSEGV, Segmentation fault.
0x00007ffff7ffc634 in ?? ()
(gdb) bt full
#0  0x00007ffff7ffc634 in ?? ()
No symbol table info available.
#1  0x00007ffff7ffc826 in gettimeofday ()
No symbol table info available.
#2  0x00007ffff76f96ea in gettimeofday () from /lib64/libc.so.6
No symbol table info available.
#3  0x00007ffff6e54106 in event_handler (type=NFCT_T_NEW, ct=0x72a3f0,
data=0x6161f0)
    at ulogd_inpflow_NFCT.c:599
	upi = (struct ulogd_pluginstance *) 0x6161f0
	cpi = (struct nfct_pluginstance *) 0x616268
	ts = (struct ct_timestamp *) 0x0
	tmp = {time = {{tv_sec = 0, tv_usec = 0}, {tv_sec = 0, tv_usec =
0}}, ct = 0x72a3f0}
#4  0x00007ffff6c42fb4 in __callback (nlh=0x7fffffffc1d0,
nfa=0x7fffffffc0d0, data=0x620e70)
    at callback.c:33
	ret = <value optimized out>
	ct = <value optimized out>
#5  0x00007ffff70594b9 in nfnl_step (h=<value optimized out>,
nlh=0x7fffffffc1d0) at libnfnetlink.c:1318
	err = <value optimized out>
	type = <value optimized out>
	subsys_id = <value optimized out>
#6  0x00007ffff705964f in nfnl_process (h=0x621c90, buf=<value optimized
out>, len=196)
    at libnfnetlink.c:1363
	ret = 76
	nlh = (struct nlmsghdr *) 0x7fffffffc1d0
	__PRETTY_FUNCTION__ = "nfnl_process"
#7  0x00007ffff705a5d6 in nfnl_catch (h=0x621c90) at libnfnetlink.c:1517
	ret = 196
	__PRETTY_FUNCTION__ = "nfnl_catch"
#8  0x00007ffff6e54340 in read_cb_nfct (fd=9, what=1, param=0x616268) at
ulogd_inpflow_NFCT.c:664
	cpi = (struct nfct_pluginstance *) 0x616268
	upi = (struct ulogd_pluginstance *) 0x6161f0
#9  0x00000000004050ca in ulogd_select_main (tv=0x7fffffffe440) at
select.c:110
	flags = 1
	ufd = (struct ulogd_fd *) 0x616280
	rds_tmp = {__fds_bits = {1536, 0 <repeats 15 times>}}
	wrs_tmp = {__fds_bits = {0 <repeats 16 times>}}

as you can see there is a nullpointer deref. We protected the two
crashpoints so far with a very simple workaround

diff -ur ulogd-2.0.0beta3/input/flow/ulogd_inpflow_NFCT.c
ulogd-2.0.0beta3-patched/input/flow/ulogd_inpflow_NFCT.c
--- ulogd-2.0.0beta3/input/flow/ulogd_inpflow_NFCT.c	2009-03-06
18:54:04.000000000 +0100
+++ ulogd-2.0.0beta3-patched/input/flow/ulogd_inpflow_NFCT.c
2009-06-23 08:51:51.912520684 +0200
@@ -596,7 +596,8 @@
 	switch(type) {
 	case NFCT_T_NEW:
 		ts = hashtable_add(cpi->ct_active, &tmp);
-		gettimeofday(&ts->time[START], NULL);
+		if (ts)
+			gettimeofday(&ts->time[START], NULL);
 		return NFCT_CB_STOLEN;
 	case NFCT_T_UPDATE:
 		ts = hashtable_get(cpi->ct_active, &tmp);
@@ -734,7 +735,8 @@
 	/* if it does not exist, add it */
 	if (!hashtable_get(cpi->ct_active, &tmp)) {
 		ts = hashtable_add(cpi->ct_active, &tmp);
-		gettimeofday(&ts->time[START], NULL); /* do our best
		here */
+		if (ts)
+			gettimeofday(&ts->time[START], NULL); /* do our
best here */
 		return NFCT_CB_STOLEN;
 	}


now it seems to work okay. In the database about 90% of the flows have
flow_end_sec NULL.

Can anyone see at the first glance why ts isn't set here? Is this some
overload issue?

Thanks,
Bernhard


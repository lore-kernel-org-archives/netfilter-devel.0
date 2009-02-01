From: Pete Whiting <pete@whitings.org>
Subject: trying to test libnetfilter_queue on openwrt kamikaze_RC2 - failing
	with "connection refused"
Date: Sat, 31 Jan 2009 21:47:05 -0700
Message-ID: <3ba156dd0901312047s3f54f6a4t3b43a36025103dfe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:10759 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZBAErH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Jan 2009 23:47:07 -0500
Received: by wf-out-1314.google.com with SMTP id 27so1166070wfd.4
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Jan 2009 20:47:05 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am trying to build/test libnetfilter_queue for a user-space app
running on openwrt. Compile failed in the utils subdirectory until I
modified Makefile.in to include libnfnetlink.so:

--- original-libnetfilter_queue-0.0.16/utils/Makefile.in	2008-06-27
04:07:44.000000000 -0600
+++ libnetfilter_queue-0.0.16/utils/Makefile.in	2009-01-31
18:29:03.000000000 -0700
@@ -48,7 +48,7 @@ nfqnl_test_OBJECTS = $(am_nfqnl_test_OBJ
 nfqnl_test_DEPENDENCIES = ../src/libnetfilter_queue.la
 nfqnl_test_LINK = $(LIBTOOL) --tag=CC $(AM_LIBTOOLFLAGS) \
 	$(LIBTOOLFLAGS) --mode=link $(CCLD) $(AM_CFLAGS) $(CFLAGS) \
-	$(nfqnl_test_LDFLAGS) $(LDFLAGS) -o $@
+	$(nfqnl_test_LDFLAGS) $(LDFLAGS) -o $@ libnfnetlink.so
 DEFAULT_INCLUDES = -I.@am__isrc@
 depcomp = $(SHELL) $(top_srcdir)/depcomp
 am__depfiles_maybe = depfiles

I'm sure there is a better way to do this.

Once built and installed I tried running nfqnl_test as root:
root@Kamikaze_RC2:~# ./nfqnl_test
opening library handle
unbinding existing nf_queue handler for AF_INET (if any)
nfnl_talk: sendmsg(netlink) Connection refused
error during nfq_unbind_pf()

I verified that xt_NFQUEUE is installed:
root@Kamikaze_RC2:~# lsmod | grep QUEUE
xt_NFQUEUE               672  0
x_tables                8976  16
xt_NFQUEUE,ipt_ULOG,xt_string,xt_layer7,ipt_ipp2p,ipt_MASQUERADE,iptable_nat,xt_state,ipt_REJECT,xt_TCPMSS,ipt_LOG,xt_multiport,xt_mac,xt_limit,ip_tables,xt_tcpudp

strace shows the following:
socket(PF_NETLINK, SOCK_RAW, 12)        = 3
getsockname(3, {sa_family=AF_NETLINK, pid=0, groups=00000000}, [12]) = 0
time(NULL)                              = 1232458046
bind(3, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 0
getsockname(3, {sa_family=AF_NETLINK, pid=1065, groups=00000000}, [12]) = 0
bind(3, {sa_family=AF_NETLINK, pid=1065, groups=00000000}, 12) = 0
write(1, "unbinding existing nf_queue hand"..., 57) = 57
sendmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0,
groups=00000000},
msg_iov(1)=[{"\34\0\0\0\2\3\5\0@\321uI\0\0\0\0\0\0\0\0\10\0\1\0\4\10\0\2",
28}], msg_controllen=0, msg_flags=0}, 0) = -1 ECONNREFUSED (Connection
refused)
write(2, "nfnl_talk", 9nfnl_talk)                = 9
write(2, ": sendmsg(netlink) ", 19: sendmsg(netlink) )     = 19
write(2, "Connection refused", 18Connection refused)      = 18
write(2, "\n", 1
)                       = 1

kernel version is 2.6.25.17

thanks for any suggestions.
pete

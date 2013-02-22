From: Eric Leblond <eric@regit.org>
Subject: [Ulogd2 PATCH 3/4] Update README
Date: Fri, 22 Feb 2013 11:25:57 +0100
Message-ID: <1361528758-16674-4-git-send-email-eric@regit.org>
References: <1361528758-16674-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:39922 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab3BVK0e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:26:34 -0500
In-Reply-To: <1361528758-16674-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Get rid of ULOG only documentation and adds some new stuffs.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 README |  113 ++++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 60 insertions(+), 53 deletions(-)

diff --git a/README b/README
index 369c264..1acc200 100644
--- a/README
+++ b/README
@@ -15,29 +15,8 @@ userspace process.  This includes
 	- logging of connection startup/teardown (kernel 2.6.14+)
 	- connection-based accounting  (kernel 2.6.14+)
 
-The to-be-logged information
-
-from passing packets from the kernel to userspace 
-to do some logging there. It should work like that:
-
-- Register a target called ULOG with iptables
-- if the target is hit: 
-	- send the packet out using netlink multicast facility
-	- return NF_CONTINUE immediately
-
-New with ipt_ULOG 0.8 we can accumulate packets in userspace and send
-them in small batches (1-50) to userspace. This reduces the amount of
-expensive context switches.
-
-More than one logging daemon may listen to the netlink multicast address.
-
 ===> CONTENTS
 
-= Ulog library (libipulog.a)
-Just a little library like libipq.a which provides a convenient way to 
-write userspace logging daemons. The functions provided are described 
-in the source code, a small demo program (ulog_test) is also included.
-
 = ulogd daemon (ulogd) 
 A sophisticated logging daemon core which uses a plugin for about anything. The
 daemon provides a plugin API for
@@ -51,53 +30,81 @@ please actually make use of it and read it :)
 
 ===> USAGE
 
-The kernel part of the userspace logging facility (ipt_ULOG.o) is included
-in kernels >= 2.4.18-pre8.  If you are running older kernel versions, you MUST
-install the ulog-patch from netfilter patch-o-matic FIRST !!
+To be able to build ulogd, you need to have working developement files and
+and libraries for:
+ - libnfnetlink
+ - libmnl
+ - libnetfilter_log 		[optional]
+ - libnetfilter_conntrack	[optional]
+ - libnetfilter_acct		[optional]
+
+Output plugins are build if the needed library and headers are found. This
+includes:
+ - PCAP: libpcap
+ - PGSQL: libpq
+ - MySQL: libmysqlclient
+ - SQLITE3: libsqlite3
+ - DBI: libdbi
+
+The build procedure is standard:
+ $ ./configure
+ $ make
+ $ sudo make install
+
+After build, you need to edit the ulogd.conf file to define a stack or more
+to use.
 
-Please go to the netfilter homepage (http://www.netfilter.org/)
-and download the latest iptables package.  There is a system called
-patch-o-matic, which manages recent netfilter development, which has
-not been included in the stock kernel yet.
+===> EXAMPLES
 
-Just apply the ulog-patch from patch-o-matic (there is some documentation
-included in the iptables package how to use patch-o-matic).
+= NFLOG usage
 
-Next you have to enable the kernel config option CONFIG_IP_NF_TARGET_ULOG in
-the netfilter subsection of the network options. 
+At first a simple example, which passes every outgoing packet to the 
+userspace logging, using nfnetlink group 3.
 
-Then recompile the kernel or just recompile the netfilter modules using 'make
-modules SUBDIRS=net/ipv4/netfilter'.  Next step is installing the module using
-'make modules_install'
+iptables -A OUTPUT -j NFLOG --nflog-group 3
 
-It is also a good idea to recompile and re-install the iptables package,
-if you don't already have libipt_ULOG.so in /usr/local/lib/iptables or
-/usr/lib/iptables
+A more advanced one, passing all incoming tcp packets with destination 
+port 80 to the userspace logging daemon listening on netlink multicast 
+group 32. All packets get tagged with the ulog prefix "inp"
 
-Now You are ready to go. You may now insert logging rules to every chain.
-To see the full syntax, type 'iptables -j ULOG -h'
+iptables -A INPUT -j NFLOG -p tcp --dport 80 --nflog-group 32 --nflog-prefix inp
 
-===> EXAMPLES
+See iptables -j NFLOG -h for complete information about NFLOG.
 
-At first a simple example, which passes every outgoing packet to the 
-userspace logging, using netlink multicast group 3.
+= NFCT usage
 
-iptables -A OUTPUT -j ULOG --ulog-nlgroup 3
+To use connection logging, simply activate in ulogd.conf one stack using
+the NFCT plugin.
 
-A more advanced one, passing all incoming tcp packets with destination 
-port 80 to the userspace logging daemon listening on netlink multicast 
-group 32. All packets get tagged with the ulog prefix "inp"
+For example, the following stack will do flow-based logging via
+LOGEMU:
+
+ stack=ct1:NFCT,ip2str1:IP2STR,print1:PRINTFLOW,emu1:LOGEMU
+
+= NFACCT usage
+
+On ulogd side, activate a stack using the NFACCT module.
+
+You then need to create counters:
+ # nfacct add ipv4.tcp
+ # nfacct add ipv6.tcp.443
+
+Once this is done, you can then create iptables matching rule that will increment
+each time a packet hit them:
 
-iptables -A INPUT -j ULOG -p tcp --dport 80 --ulog-nlgroup 32 --ulog-prefix inp
+ # iptables -A FORWARD -p tcp -m nfacct --nfacct-name ipv4.tcp
+ # ip6tables -A FORWARD -p tcp  --dport 443 -m nfacct --nfacct-name ipv6.tcp.443
+ # ip6tables -A FORWARD -p tcp  --sport 443 -m nfacct --nfacct-name ipv6.tcp.443
 
-Since version 0.2,  I added another parameter (--ulog-cprange). 
-Using this parameter You are able to specify how much octets of the 
-packet should be copied from the kernel to userspace. 
-Setting --ulog-cprange to 0 does always copy the whole packet. Default is 0
+NFACCT plugin will then dump periodically the counters and trigger an update of the
+output corresponding to the active stacks.
 
 ===> COPYRIGHT + CREDITS
 
-The code and documentation is (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
+The code and documentation is
+	(C) 2000-2006 by Harald Welte <laforge@gnumonks.org>
+	(C) 2008-2012 Pablo Neira Ayuso <pablo@netfilter.org>
+	(C) 2008-2013 Eric Leblond <eric@regit.org>
 
 Thanks also to the valuable contributions of Daniel Stone, Alexander Janssen,
 Michael Stolovitzsky and Jozsef Kadlecsik.
-- 
1.7.10.4


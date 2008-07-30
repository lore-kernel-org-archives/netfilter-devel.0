From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/7] connection tracking helper name persistent aliases
Date: Wed, 30 Jul 2008 13:03:28 +0200
Message-ID: <48904A80.4040006@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000604060003030802070409"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57741 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753551AbYG3LDe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:03:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000604060003030802070409
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[PATCH] connection tracking helper name persistent aliases

This patch adds the macro MODULE_ALIAS_NFCT_HELPER that defines a
way to provide generic and persistent aliases for the connection
tracking helpers.

This next patch requires this patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------000604060003030802070409
Content-Type: text/x-diff;
 name="02.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.patch"

[PATCH] connection tracking helper name persistent aliases

This patch adds the macro MODULE_ALIAS_NFCT_HELPER that defines a
way to provide generic and persistent aliases for the connection
tracking helpers.

This next patch requires this patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-next-2.6.git/include/net/netfilter/nf_conntrack.h
===================================================================
--- net-next-2.6.git.orig/include/net/netfilter/nf_conntrack.h	2008-07-29 14:30:10.000000000 +0200
+++ net-next-2.6.git/include/net/netfilter/nf_conntrack.h	2008-07-29 14:30:12.000000000 +0200
@@ -292,5 +292,8 @@ do {							\
 	local_bh_enable();				\
 } while (0)
 
+#define MODULE_ALIAS_NFCT_HELPER(helper) \
+        MODULE_ALIAS("nfct-helper-" helper)
+
 #endif /* __KERNEL__ */
 #endif /* _NF_CONNTRACK_H */
Index: net-next-2.6.git/net/netfilter/nf_conntrack_amanda.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_amanda.c	2008-07-29 14:30:10.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_amanda.c	2008-07-29 14:30:12.000000000 +0200
@@ -30,6 +30,7 @@ MODULE_AUTHOR("Brian J. Murrell <netfilt
 MODULE_DESCRIPTION("Amanda connection tracking module");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_amanda");
+MODULE_ALIAS_NFCT_HELPER("amanda");
 
 module_param(master_timeout, uint, 0600);
 MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
Index: net-next-2.6.git/net/netfilter/nf_conntrack_ftp.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_ftp.c	2008-07-29 14:30:10.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_ftp.c	2008-07-29 14:30:12.000000000 +0200
@@ -29,6 +29,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
 MODULE_DESCRIPTION("ftp connection tracking helper");
 MODULE_ALIAS("ip_conntrack_ftp");
+MODULE_ALIAS_NFCT_HELPER("ftp");
 
 /* This is slow, but it's simple. --RR */
 static char *ftp_buffer;
Index: net-next-2.6.git/net/netfilter/nf_conntrack_h323_main.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_h323_main.c	2008-07-29 14:30:10.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_h323_main.c	2008-07-29 14:30:12.000000000 +0200
@@ -1829,3 +1829,4 @@ MODULE_AUTHOR("Jing Min Zhao <zhaojingmi
 MODULE_DESCRIPTION("H.323 connection tracking helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_h323");
+MODULE_ALIAS_NFCT_HELPER("h323");
Index: net-next-2.6.git/net/netfilter/nf_conntrack_irc.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_irc.c	2008-07-29 14:30:10.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_irc.c	2008-07-29 14:30:12.000000000 +0200
@@ -41,6 +41,7 @@ MODULE_AUTHOR("Harald Welte <laforge@net
 MODULE_DESCRIPTION("IRC (DCC) connection tracking helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_irc");
+MODULE_ALIAS_NFCT_HELPER("irc");
 
 module_param_array(ports, ushort, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of IRC servers");
Index: net-next-2.6.git/net/netfilter/nf_conntrack_netbios_ns.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_netbios_ns.c	2008-07-29 14:30:10.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_netbios_ns.c	2008-07-29 14:30:12.000000000 +0200
@@ -37,6 +37,7 @@ MODULE_AUTHOR("Patrick McHardy <kaber@tr
 MODULE_DESCRIPTION("NetBIOS name service broadcast connection tracking helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_netbios_ns");
+MODULE_ALIAS_NFCT_HELPER("netbios_ns");
 
 static unsigned int timeout __read_mostly = 3;
 module_param(timeout, uint, 0400);
Index: net-next-2.6.git/net/netfilter/nf_conntrack_pptp.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_pptp.c	2008-07-29 14:30:10.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_pptp.c	2008-07-29 14:30:12.000000000 +0200
@@ -37,6 +37,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("Netfilter connection tracking helper module for PPTP");
 MODULE_ALIAS("ip_conntrack_pptp");
+MODULE_ALIAS_NFCT_HELPER("pptp");
 
 static DEFINE_SPINLOCK(nf_pptp_lock);
 
Index: net-next-2.6.git/net/netfilter/nf_conntrack_sip.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_sip.c	2008-07-29 14:30:10.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_sip.c	2008-07-29 14:30:12.000000000 +0200
@@ -28,6 +28,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
 MODULE_DESCRIPTION("SIP connection tracking helper");
 MODULE_ALIAS("ip_conntrack_sip");
+MODULE_ALIAS_NFCT_HELPER("sip");
 
 #define MAX_PORTS	8
 static unsigned short ports[MAX_PORTS];
Index: net-next-2.6.git/net/netfilter/nf_conntrack_tftp.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_tftp.c	2008-07-29 14:30:10.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_tftp.c	2008-07-29 14:30:12.000000000 +0200
@@ -22,6 +22,7 @@ MODULE_AUTHOR("Magnus Boden <mb@ozaba.mi
 MODULE_DESCRIPTION("TFTP connection tracking helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_tftp");
+MODULE_ALIAS_NFCT_HELPER("tftp");
 
 #define MAX_PORTS 8
 static unsigned short ports[MAX_PORTS];
Index: net-next-2.6.git/net/netfilter/nf_conntrack_sane.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_sane.c	2008-07-30 08:50:29.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_sane.c	2008-07-30 08:51:02.000000000 +0200
@@ -30,6 +30,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michal Schmidt <mschmidt@redhat.com>");
 MODULE_DESCRIPTION("SANE connection tracking helper");
+MODULE_ALIAS_NFCT_HELPER("sane");
 
 static char *sane_buffer;
 

--------------000604060003030802070409--

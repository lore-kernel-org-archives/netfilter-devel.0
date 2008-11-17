From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/8] [PATCH] connection tracking helper name persistent aliases
Date: Mon, 17 Nov 2008 09:40:33 +0100
Message-ID: <20081117084033.11368.90083.stgit@Decadence>
References: <20081117083924.11368.38741.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55848 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752571AbYKQIkk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:40:40 -0500
In-Reply-To: <20081117083924.11368.38741.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the macro MODULE_ALIAS_NFCT_HELPER that defines a
way to provide generic and persistent aliases for the connection
tracking helpers.

This next patch requires this patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack.h    |    3 +++
 net/netfilter/nf_conntrack_amanda.c     |    1 +
 net/netfilter/nf_conntrack_ftp.c        |    1 +
 net/netfilter/nf_conntrack_h323_main.c  |    1 +
 net/netfilter/nf_conntrack_irc.c        |    1 +
 net/netfilter/nf_conntrack_netbios_ns.c |    1 +
 net/netfilter/nf_conntrack_pptp.c       |    1 +
 net/netfilter/nf_conntrack_sane.c       |    1 +
 net/netfilter/nf_conntrack_sip.c        |    1 +
 net/netfilter/nf_conntrack_tftp.c       |    1 +
 10 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index b76a868..f11255e 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -298,5 +298,8 @@ do {							\
 	local_bh_enable();				\
 } while (0)
 
+#define MODULE_ALIAS_NFCT_HELPER(helper) \
+        MODULE_ALIAS("nfct-helper-" helper)
+
 #endif /* __KERNEL__ */
 #endif /* _NF_CONNTRACK_H */
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 38aedee..4f8fcf4 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -30,6 +30,7 @@ MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 MODULE_DESCRIPTION("Amanda connection tracking module");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_amanda");
+MODULE_ALIAS_NFCT_HELPER("amanda");
 
 module_param(master_timeout, uint, 0600);
 MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 6295009..703a437 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -29,6 +29,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
 MODULE_DESCRIPTION("ftp connection tracking helper");
 MODULE_ALIAS("ip_conntrack_ftp");
+MODULE_ALIAS_NFCT_HELPER("ftp");
 
 /* This is slow, but it's simple. --RR */
 static char *ftp_buffer;
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 99bc803..687bd63 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1827,3 +1827,4 @@ MODULE_AUTHOR("Jing Min Zhao <zhaojingmin@users.sourceforge.net>");
 MODULE_DESCRIPTION("H.323 connection tracking helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_h323");
+MODULE_ALIAS_NFCT_HELPER("h323");
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 4d681a0..409c8be 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -41,6 +41,7 @@ MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("IRC (DCC) connection tracking helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_irc");
+MODULE_ALIAS_NFCT_HELPER("irc");
 
 module_param_array(ports, ushort, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of IRC servers");
diff --git a/net/netfilter/nf_conntrack_netbios_ns.c b/net/netfilter/nf_conntrack_netbios_ns.c
index 08404e6..5af4273 100644
--- a/net/netfilter/nf_conntrack_netbios_ns.c
+++ b/net/netfilter/nf_conntrack_netbios_ns.c
@@ -37,6 +37,7 @@ MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("NetBIOS name service broadcast connection tracking helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_netbios_ns");
+MODULE_ALIAS_NFCT_HELPER("netbios_ns");
 
 static unsigned int timeout __read_mostly = 3;
 module_param(timeout, uint, 0400);
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 1bc3001..9e169ef 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -37,6 +37,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("Netfilter connection tracking helper module for PPTP");
 MODULE_ALIAS("ip_conntrack_pptp");
+MODULE_ALIAS_NFCT_HELPER("pptp");
 
 static DEFINE_SPINLOCK(nf_pptp_lock);
 
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index a94294b..dcfecbb 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -30,6 +30,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michal Schmidt <mschmidt@redhat.com>");
 MODULE_DESCRIPTION("SANE connection tracking helper");
+MODULE_ALIAS_NFCT_HELPER("sane");
 
 static char *sane_buffer;
 
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 6813f1c..4b57216 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -28,6 +28,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
 MODULE_DESCRIPTION("SIP connection tracking helper");
 MODULE_ALIAS("ip_conntrack_sip");
+MODULE_ALIAS_NFCT_HELPER("sip");
 
 #define MAX_PORTS	8
 static unsigned short ports[MAX_PORTS];
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index f57f6e7..46e646b 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -22,6 +22,7 @@ MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
 MODULE_DESCRIPTION("TFTP connection tracking helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_tftp");
+MODULE_ALIAS_NFCT_HELPER("tftp");
 
 #define MAX_PORTS 8
 static unsigned short ports[MAX_PORTS];


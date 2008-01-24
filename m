From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 5/8] conntrack: get rid of sparse warnings
Date: Thu, 24 Jan 2008 10:15:41 -0800
Message-ID: <20080124181628.315779855@vyatta.com>
References: <20080124181536.446214111@vyatta.com>
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([216.93.170.194]:48253 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbYAXSYV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:24:21 -0500
Content-Disposition: inline; filename=nf-conntrack-sparse.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Teach sparse about locking here, and fix signed/unsigned warnings.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/net/netfilter/nf_conntrack_standalone.c	2008-01-23 10:06:11.000000000 -0800
+++ b/net/netfilter/nf_conntrack_standalone.c	2008-01-23 10:06:33.000000000 -0800
@@ -93,6 +93,7 @@ static struct hlist_node *ct_get_idx(str
 }
 
 static void *ct_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(nf_conntrack_lock)
 {
 	read_lock_bh(&nf_conntrack_lock);
 	return ct_get_idx(seq, *pos);
@@ -105,6 +106,7 @@ static void *ct_seq_next(struct seq_file
 }
 
 static void ct_seq_stop(struct seq_file *s, void *v)
+	__releases(nf_conntrack_lock)
 {
 	read_unlock_bh(&nf_conntrack_lock);
 }
--- a/net/netfilter/nf_conntrack_expect.c	2008-01-23 10:07:46.000000000 -0800
+++ b/net/netfilter/nf_conntrack_expect.c	2008-01-23 10:08:21.000000000 -0800
@@ -427,6 +427,7 @@ static struct hlist_node *ct_expect_get_
 }
 
 static void *exp_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(nf_conntrack_lock)
 {
 	read_lock_bh(&nf_conntrack_lock);
 	return ct_expect_get_idx(seq, *pos);
@@ -439,6 +440,7 @@ static void *exp_seq_next(struct seq_fil
 }
 
 static void exp_seq_stop(struct seq_file *seq, void *v)
+	__releases(nf_conntrack_lock)
 {
 	read_unlock_bh(&nf_conntrack_lock);
 }
--- a/net/netfilter/nf_conntrack_irc.c	2008-01-23 10:12:33.000000000 -0800
+++ b/net/netfilter/nf_conntrack_irc.c	2008-01-23 10:14:55.000000000 -0800
@@ -23,7 +23,7 @@
 
 #define MAX_PORTS 8
 static unsigned short ports[MAX_PORTS];
-static int ports_c;
+static unsigned int ports_c;
 static unsigned int max_dcc_channels = 8;
 static unsigned int dcc_timeout __read_mostly = 300;
 /* This is slow, but it's simple. --RR */
--- a/net/netfilter/nf_conntrack_proto_sctp.c	2008-01-23 10:11:29.000000000 -0800
+++ b/net/netfilter/nf_conntrack_proto_sctp.c	2008-01-23 10:11:42.000000000 -0800
@@ -624,7 +624,7 @@ static struct nf_conntrack_l4proto nf_co
 #endif
 };
 
-int __init nf_conntrack_proto_sctp_init(void)
+static int __init nf_conntrack_proto_sctp_init(void)
 {
 	int ret;
 
@@ -647,7 +647,7 @@ int __init nf_conntrack_proto_sctp_init(
 	return ret;
 }
 
-void __exit nf_conntrack_proto_sctp_fini(void)
+static void __exit nf_conntrack_proto_sctp_fini(void)
 {
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_sctp6);
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_sctp4);
--- a/net/netfilter/nf_conntrack_proto_tcp.c	2008-01-23 10:10:47.000000000 -0800
+++ b/net/netfilter/nf_conntrack_proto_tcp.c	2008-01-23 10:11:15.000000000 -0800
@@ -1098,16 +1098,16 @@ static const struct nla_policy tcp_nla_p
 
 static int nlattr_to_tcp(struct nlattr *cda[], struct nf_conn *ct)
 {
-	struct nlattr *attr = cda[CTA_PROTOINFO_TCP];
+	struct nlattr *pattr = cda[CTA_PROTOINFO_TCP];
 	struct nlattr *tb[CTA_PROTOINFO_TCP_MAX+1];
 	int err;
 
 	/* updates could not contain anything about the private
 	 * protocol info, in that case skip the parsing */
-	if (!attr)
+	if (!pattr)
 		return 0;
 
-	err = nla_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, attr, tcp_nla_policy);
+	err = nla_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, pattr, tcp_nla_policy);
 	if (err < 0)
 		return err;
 
--- a/net/netfilter/nf_conntrack_sip.c	2008-01-23 10:14:38.000000000 -0800
+++ b/net/netfilter/nf_conntrack_sip.c	2008-01-23 10:15:23.000000000 -0800
@@ -28,7 +28,7 @@ MODULE_ALIAS("ip_conntrack_sip");
 
 #define MAX_PORTS	8
 static unsigned short ports[MAX_PORTS];
-static int ports_c;
+static unsigned int ports_c;
 module_param_array(ports, ushort, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of SIP servers");
 
@@ -407,7 +407,7 @@ static int sip_help(struct sk_buff *skb,
 	unsigned int dataoff, datalen;
 	const char *dptr;
 	int ret = NF_ACCEPT;
-	int matchoff, matchlen;
+	unsigned int matchoff, matchlen;
 	u_int16_t port;
 	enum sip_header_pos pos;
 	typeof(nf_nat_sip_hook) nf_nat_sip;
--- a/net/netfilter/nf_conntrack_tftp.c	2008-01-23 10:15:35.000000000 -0800
+++ b/net/netfilter/nf_conntrack_tftp.c	2008-01-23 10:15:50.000000000 -0800
@@ -25,7 +25,7 @@ MODULE_ALIAS("ip_conntrack_tftp");
 
 #define MAX_PORTS 8
 static unsigned short ports[MAX_PORTS];
-static int ports_c;
+static unsigned int ports_c;
 module_param_array(ports, ushort, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "Port numbers of TFTP servers");
 

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>


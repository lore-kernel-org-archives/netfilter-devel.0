From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 27/69]: conntrack: get rid of sparse warnings
Date: Wed, 30 Jan 2008 21:17:36 +0100 (MET)
Message-ID: <20080130201733.29874.24945.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60708 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758777AbYA3URh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:37 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: conntrack: get rid of sparse warnings

Teach sparse about locking here, and fix signed/unsigned warnings.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a56984be5dde4c3ab631f9c66e15c1fa7a12f17e
tree 686c306b6e89f19951950a971d69785256387b2d
parent 7f16025ab2a78e16a58f5c4d655d568945ecc9dc
author Stephen Hemminger <shemminger@vyatta.com> Tue, 29 Jan 2008 16:22:06 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:19 +0100

 net/netfilter/nf_conntrack_irc.c        |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c |    4 ++--
 net/netfilter/nf_conntrack_proto_tcp.c  |    6 +++---
 net/netfilter/nf_conntrack_sip.c        |    4 ++--
 net/netfilter/nf_conntrack_standalone.c |    2 ++
 net/netfilter/nf_conntrack_tftp.c       |    2 +-
 6 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index dfaed4b..c336b07 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -23,7 +23,7 @@
 
 #define MAX_PORTS 8
 static unsigned short ports[MAX_PORTS];
-static int ports_c;
+static unsigned int ports_c;
 static unsigned int max_dcc_channels = 8;
 static unsigned int dcc_timeout __read_mostly = 300;
 /* This is slow, but it's simple. --RR */
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 21d29e7..7017b16 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -624,7 +624,7 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 __read_mostly = {
 #endif
 };
 
-int __init nf_conntrack_proto_sctp_init(void)
+static int __init nf_conntrack_proto_sctp_init(void)
 {
 	int ret;
 
@@ -647,7 +647,7 @@ int __init nf_conntrack_proto_sctp_init(void)
 	return ret;
 }
 
-void __exit nf_conntrack_proto_sctp_fini(void)
+static void __exit nf_conntrack_proto_sctp_fini(void)
 {
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_sctp6);
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_sctp4);
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 64c9b91..8e22075 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1098,16 +1098,16 @@ static const struct nla_policy tcp_nla_policy[CTA_PROTOINFO_TCP_MAX+1] = {
 
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
 
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 47d8947..775f7d4 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
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
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 696074a..28c5ae8 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -93,6 +93,7 @@ static struct hlist_node *ct_get_idx(struct seq_file *seq, loff_t pos)
 }
 
 static void *ct_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(nf_conntrack_lock)
 {
 	read_lock_bh(&nf_conntrack_lock);
 	return ct_get_idx(seq, *pos);
@@ -105,6 +106,7 @@ static void *ct_seq_next(struct seq_file *s, void *v, loff_t *pos)
 }
 
 static void ct_seq_stop(struct seq_file *s, void *v)
+	__releases(nf_conntrack_lock)
 {
 	read_unlock_bh(&nf_conntrack_lock);
 }
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index e894aa1..176f769 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -25,7 +25,7 @@ MODULE_ALIAS("ip_conntrack_tftp");
 
 #define MAX_PORTS 8
 static unsigned short ports[MAX_PORTS];
-static int ports_c;
+static unsigned int ports_c;
 module_param_array(ports, ushort, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "Port numbers of TFTP servers");
 

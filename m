From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 04/10] [NETFILTER]: annotate nf_{conntrack,nat}_pptp with
 const
Date: Sat, 26 Jan 2008 02:37:25 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801260237160.15243@fbirervta.pbzchgretzou.qr>
References: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48216 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbYAZBh1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jan 2008 20:37:27 -0500
In-Reply-To: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter/nf_conntrack_pptp.h |    2 +-
 net/ipv4/netfilter/nf_nat_pptp.c            |   10 +++++-----
 net/netfilter/nf_conntrack_pptp.c           |   14 ++++++++------
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_pptp.h b/include/linux/netfilter/nf_conntrack_pptp.h
index 2343549..3bbde0c 100644
--- a/include/linux/netfilter/nf_conntrack_pptp.h
+++ b/include/linux/netfilter/nf_conntrack_pptp.h
@@ -4,7 +4,7 @@
 
 #include <linux/netfilter/nf_conntrack_common.h>
 
-extern const char *pptp_msg_name[];
+extern const char *const pptp_msg_name[];
 
 /* state of the control session */
 enum pptp_ctrlsess_state {
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index e63b944..3a1e6d6 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -40,11 +40,11 @@ MODULE_ALIAS("ip_nat_pptp");
 static void pptp_nat_expected(struct nf_conn *ct,
 			      struct nf_conntrack_expect *exp)
 {
-	struct nf_conn *master = ct->master;
+	const struct nf_conn *master = ct->master;
 	struct nf_conntrack_expect *other_exp;
 	struct nf_conntrack_tuple t;
-	struct nf_ct_pptp_master *ct_pptp_info;
-	struct nf_nat_pptp *nat_pptp_info;
+	const struct nf_ct_pptp_master *ct_pptp_info;
+	const struct nf_nat_pptp *nat_pptp_info;
 	struct nf_nat_range range;
 
 	ct_pptp_info = &nfct_help(master)->help.ct_pptp_info;
@@ -186,7 +186,7 @@ static void
 pptp_exp_gre(struct nf_conntrack_expect *expect_orig,
 	     struct nf_conntrack_expect *expect_reply)
 {
-	struct nf_conn *ct = expect_orig->master;
+	const struct nf_conn *ct = expect_orig->master;
 	struct nf_ct_pptp_master *ct_pptp_info;
 	struct nf_nat_pptp *nat_pptp_info;
 
@@ -217,7 +217,7 @@ pptp_inbound_pkt(struct sk_buff *skb,
 		 struct PptpControlHeader *ctlh,
 		 union pptp_ctrl_union *pptpReq)
 {
-	struct nf_nat_pptp *nat_pptp_info;
+	const struct nf_nat_pptp *nat_pptp_info;
 	u_int16_t msg;
 	__be16 new_pcid;
 	unsigned int pcid_off;
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 099b6df..b5cb8e8 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -67,7 +67,7 @@ EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_expectfn);
 
 #ifdef DEBUG
 /* PptpControlMessageType names */
-const char *pptp_msg_name[] = {
+const char *const pptp_msg_name[] = {
 	"UNKNOWN_MESSAGE",
 	"START_SESSION_REQUEST",
 	"START_SESSION_REPLY",
@@ -136,7 +136,7 @@ static void pptp_expectfn(struct nf_conn *ct,
 
 static int destroy_sibling_or_exp(const struct nf_conntrack_tuple *t)
 {
-	struct nf_conntrack_tuple_hash *h;
+	const struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_expect *exp;
 	struct nf_conn *sibling;
 
@@ -168,7 +168,7 @@ static int destroy_sibling_or_exp(const struct nf_conntrack_tuple *t)
 /* timeout GRE data connections */
 static void pptp_destroy_siblings(struct nf_conn *ct)
 {
-	struct nf_conn_help *help = nfct_help(ct);
+	const struct nf_conn_help *help = nfct_help(ct);
 	struct nf_conntrack_tuple t;
 
 	nf_ct_gre_keymap_destroy(ct);
@@ -497,9 +497,11 @@ conntrack_pptp_help(struct sk_buff *skb, unsigned int protoff,
 
 {
 	int dir = CTINFO2DIR(ctinfo);
-	struct nf_ct_pptp_master *info = &nfct_help(ct)->help.ct_pptp_info;
-	struct tcphdr _tcph, *tcph;
-	struct pptp_pkt_hdr _pptph, *pptph;
+	const struct nf_ct_pptp_master *info = &nfct_help(ct)->help.ct_pptp_info;
+	const struct tcphdr *tcph;
+	struct tcphdr _tcph;
+	const struct pptp_pkt_hdr *pptph;
+	struct pptp_pkt_hdr _pptph;
 	struct PptpControlHeader _ctlh, *ctlh;
 	union pptp_ctrl_union _pptpReq, *pptpReq;
 	unsigned int tcplen = skb->len - protoff;
-- 
1.5.3.4


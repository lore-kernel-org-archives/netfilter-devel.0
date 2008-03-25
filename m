From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: commit 720350a38b1dbd43c907d5d81decd6edd6725d81
Date: Tue, 25 Mar 2008 19:06:07 +0100
Message-ID: <1206468391-368-5-git-send-email-jengelh@computergmbh.de>
References: <alpine.LNX.1.10.0803251903230.31276@fbirervta.pbzchgretzou.qr>
 <1206468391-368-1-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-2-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-3-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-4-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52538 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758252AbYCYSGd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:06:33 -0400
In-Reply-To: <1206468391-368-4-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

    [NETFILTER]: annotate rest of nf_nat_* with const
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/ipv4/netfilter/nf_nat_core.c       |    8 ++++----
 net/ipv4/netfilter/nf_nat_snmp_basic.c |   17 ++++++++---------
 net/ipv4/netfilter/nf_nat_standalone.c |    8 ++++----
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 0d5fa3a..9c8aa8d 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -150,9 +150,9 @@ find_appropriate_src(const struct nf_conntrack_tuple *tuple,
 		     const struct nf_nat_range *range)
 {
 	unsigned int h = hash_by_src(tuple);
-	struct nf_conn_nat *nat;
-	struct nf_conn *ct;
-	struct hlist_node *n;
+	const struct nf_conn_nat *nat;
+	const struct nf_conn *ct;
+	const struct hlist_node *n;
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(nat, n, &bysource[h], bysource) {
@@ -426,7 +426,7 @@ int nf_nat_icmp_reply_translation(struct nf_conn *ct,
 		struct icmphdr icmp;
 		struct iphdr ip;
 	} *inside;
-	struct nf_conntrack_l4proto *l4proto;
+	const struct nf_conntrack_l4proto *l4proto;
 	struct nf_conntrack_tuple inner, target;
 	int hdrlen = ip_hdrlen(skb);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index 000e080..5daefad 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -220,7 +220,7 @@ static unsigned char asn1_length_decode(struct asn1_ctx *ctx,
 		if (ch < 0x80)
 			*len = ch;
 		else {
-			cnt = (unsigned char) (ch & 0x7F);
+			cnt = ch & 0x7F;
 			*len = 0;
 
 			while (cnt > 0) {
@@ -618,8 +618,7 @@ struct snmp_cnv
 	int syntax;
 };
 
-static struct snmp_cnv snmp_conv [] =
-{
+static const struct snmp_cnv snmp_conv[] = {
 	{ASN1_UNI, ASN1_NUL, SNMP_NULL},
 	{ASN1_UNI, ASN1_INT, SNMP_INTEGER},
 	{ASN1_UNI, ASN1_OTS, SNMP_OCTETSTR},
@@ -644,7 +643,7 @@ static unsigned char snmp_tag_cls2syntax(unsigned int tag,
 					 unsigned int cls,
 					 unsigned short *syntax)
 {
-	struct snmp_cnv *cnv;
+	const struct snmp_cnv *cnv;
 
 	cnv = snmp_conv;
 
@@ -904,7 +903,7 @@ static inline void mangle_address(unsigned char *begin,
 		u_int32_t old;
 
 		if (debug)
-			memcpy(&old, (unsigned char *)addr, sizeof(old));
+			memcpy(&old, addr, sizeof(old));
 
 		*addr = map->to;
 
@@ -999,7 +998,7 @@ err_id_free:
  *
  *****************************************************************************/
 
-static void hex_dump(unsigned char *buf, size_t len)
+static void hex_dump(const unsigned char *buf, size_t len)
 {
 	size_t i;
 
@@ -1080,7 +1079,7 @@ static int snmp_parse_mangle(unsigned char *msg,
 	if (cls != ASN1_CTX || con != ASN1_CON)
 		return 0;
 	if (debug > 1) {
-		unsigned char *pdus[] = {
+		static const unsigned char *const pdus[] = {
 			[SNMP_PDU_GET] = "get",
 			[SNMP_PDU_NEXT] = "get-next",
 			[SNMP_PDU_RESPONSE] = "response",
@@ -1232,8 +1231,8 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 {
 	int dir = CTINFO2DIR(ctinfo);
 	unsigned int ret;
-	struct iphdr *iph = ip_hdr(skb);
-	struct udphdr *udph = (struct udphdr *)((u_int32_t *)iph + iph->ihl);
+	const struct iphdr *iph = ip_hdr(skb);
+	const struct udphdr *udph = (struct udphdr *)((__be32 *)iph + iph->ihl);
 
 	/* SNMP replies and originating SNMP traps get mangled */
 	if (udph->source == htons(SNMP_PORT) && dir != IP_CT_DIR_REPLY)
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 99b2c78..9fba42d 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -30,8 +30,8 @@
 #ifdef CONFIG_XFRM
 static void nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 {
-	struct nf_conn *ct;
-	struct nf_conntrack_tuple *t;
+	const struct nf_conn *ct;
+	const struct nf_conntrack_tuple *t;
 	enum ip_conntrack_info ctinfo;
 	enum ip_conntrack_dir dir;
 	unsigned long statusbit;
@@ -189,7 +189,7 @@ nf_nat_out(unsigned int hooknum,
 	   int (*okfn)(struct sk_buff *))
 {
 #ifdef CONFIG_XFRM
-	struct nf_conn *ct;
+	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 #endif
 	unsigned int ret;
@@ -223,7 +223,7 @@ nf_nat_local_fn(unsigned int hooknum,
 		const struct net_device *out,
 		int (*okfn)(struct sk_buff *))
 {
-	struct nf_conn *ct;
+	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	unsigned int ret;
 

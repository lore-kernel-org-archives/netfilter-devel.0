From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 10/10] [NETFILTER]: annotate nf_conntrack_l3proto_* with
 const
Date: Sat, 26 Jan 2008 02:38:06 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801260238010.15243@fbirervta.pbzchgretzou.qr>
References: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48230 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbYAZBiI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jan 2008 20:38:08 -0500
In-Reply-To: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/net/netfilter/nf_conntrack_core.h          |    4 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |   14 ++++++-----
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    8 +++---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |    7 +++--
 net/netfilter/nf_conntrack_standalone.c            |   10 ++++----
 5 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 7ad0828..b884b3f 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -68,8 +68,8 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 
 int
 print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
-	    struct nf_conntrack_l3proto *l3proto,
-	    struct nf_conntrack_l4proto *proto);
+            const struct nf_conntrack_l3proto *l3proto,
+            const struct nf_conntrack_l4proto *proto);
 
 extern struct hlist_head *nf_conntrack_hash;
 extern rwlock_t nf_conntrack_lock ;
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index ac3d61d..a65b845 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -27,7 +27,8 @@
 static int ipv4_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			     struct nf_conntrack_tuple *tuple)
 {
-	__be32 _addrs[2], *ap;
+	const __be32 *ap;
+	__be32 _addrs[2];
 	ap = skb_header_pointer(skb, nhoff + offsetof(struct iphdr, saddr),
 				sizeof(u_int32_t) * 2, _addrs);
 	if (ap == NULL)
@@ -76,7 +77,8 @@ static int nf_ct_ipv4_gather_frags(struct sk_buff *skb, u_int32_t user)
 static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 			    unsigned int *dataoff, u_int8_t *protonum)
 {
-	struct iphdr _iph, *iph;
+	const struct iphdr *iph;
+	struct iphdr _iph;
 
 	iph = skb_header_pointer(skb, nhoff, sizeof(_iph), &_iph);
 	if (iph == NULL)
@@ -111,8 +113,8 @@ static unsigned int ipv4_conntrack_help(unsigned int hooknum,
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
-	struct nf_conn_help *help;
-	struct nf_conntrack_helper *helper;
+	const struct nf_conn_help *help;
+	const struct nf_conntrack_helper *helper;
 
 	/* This is where we call the helper: as the packet goes out. */
 	ct = nf_ct_get(skb, &ctinfo);
@@ -299,8 +301,8 @@ static ctl_table ip_ct_sysctl_table[] = {
 static int
 getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 {
-	struct inet_sock *inet = inet_sk(sk);
-	struct nf_conntrack_tuple_hash *h;
+	const struct inet_sock *inet = inet_sk(sk);
+	const struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
 
 	NF_CT_TUPLE_U_BLANK(&tuple);
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 543c02b..c07c4e1 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -94,8 +94,8 @@ static int ct_seq_show(struct seq_file *s, void *v)
 {
 	const struct nf_conntrack_tuple_hash *hash = v;
 	const struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(hash);
-	struct nf_conntrack_l3proto *l3proto;
-	struct nf_conntrack_l4proto *l4proto;
+	const struct nf_conntrack_l3proto *l3proto;
+	const struct nf_conntrack_l4proto *l4proto;
 
 	NF_CT_ASSERT(ct);
 
@@ -243,7 +243,7 @@ static void exp_seq_stop(struct seq_file *seq, void *v)
 static int exp_seq_show(struct seq_file *s, void *v)
 {
 	struct nf_conntrack_expect *exp;
-	struct hlist_node *n = v;
+	const struct hlist_node *n = v;
 
 	exp = hlist_entry(n, struct nf_conntrack_expect, hnode);
 
@@ -324,7 +324,7 @@ static void ct_cpu_seq_stop(struct seq_file *seq, void *v)
 static int ct_cpu_seq_show(struct seq_file *seq, void *v)
 {
 	unsigned int nr_conntracks = atomic_read(&nf_conntrack_count);
-	struct ip_conntrack_stat *st = v;
+	const struct ip_conntrack_stat *st = v;
 
 	if (v == SEQ_START_TOKEN) {
 		seq_printf(seq, "entries  searched found new invalid ignore delete delete_list insert insert_failed drop early_drop icmp_error  expect_new expect_create expect_delete\n");
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 2d7b024..3717bdf 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -30,7 +30,8 @@
 static int ipv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			     struct nf_conntrack_tuple *tuple)
 {
-	u_int32_t _addrs[8], *ap;
+	const u_int32_t *ap;
+	u_int32_t _addrs[8];
 
 	ap = skb_header_pointer(skb, nhoff + offsetof(struct ipv6hdr, saddr),
 				sizeof(_addrs), _addrs);
@@ -146,8 +147,8 @@ static unsigned int ipv6_confirm(unsigned int hooknum,
 				 int (*okfn)(struct sk_buff *))
 {
 	struct nf_conn *ct;
-	struct nf_conn_help *help;
-	struct nf_conntrack_helper *helper;
+	const struct nf_conn_help *help;
+	const struct nf_conntrack_helper *helper;
 	enum ip_conntrack_info ctinfo;
 	unsigned int ret, protoff;
 	unsigned int extoff = (u8 *)(ipv6_hdr(skb) + 1) - skb->data;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 696074a..db74ea3 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -31,8 +31,8 @@ MODULE_LICENSE("GPL");
 #ifdef CONFIG_PROC_FS
 int
 print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
-	    struct nf_conntrack_l3proto *l3proto,
-	    struct nf_conntrack_l4proto *l4proto)
+            const struct nf_conntrack_l3proto *l3proto,
+            const struct nf_conntrack_l4proto *l4proto)
 {
 	return l3proto->print_tuple(s, tuple) || l4proto->print_tuple(s, tuple);
 }
@@ -114,8 +114,8 @@ static int ct_seq_show(struct seq_file *s, void *v)
 {
 	const struct nf_conntrack_tuple_hash *hash = v;
 	const struct nf_conn *conntrack = nf_ct_tuplehash_to_ctrack(hash);
-	struct nf_conntrack_l3proto *l3proto;
-	struct nf_conntrack_l4proto *l4proto;
+	const struct nf_conntrack_l3proto *l3proto;
+	const struct nf_conntrack_l4proto *l4proto;
 
 	NF_CT_ASSERT(conntrack);
 
@@ -242,7 +242,7 @@ static void ct_cpu_seq_stop(struct seq_file *seq, void *v)
 static int ct_cpu_seq_show(struct seq_file *seq, void *v)
 {
 	unsigned int nr_conntracks = atomic_read(&nf_conntrack_count);
-	struct ip_conntrack_stat *st = v;
+	const struct ip_conntrack_stat *st = v;
 
 	if (v == SEQ_START_TOKEN) {
 		seq_printf(seq, "entries  searched found new invalid ignore delete delete_list insert insert_failed drop early_drop icmp_error  expect_new expect_create expect_delete\n");
-- 
1.5.3.4

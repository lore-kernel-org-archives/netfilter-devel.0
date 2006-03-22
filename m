From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/10]: ctnetlink: Fix expectaction mask dumping
Date: Wed, 22 Mar 2006 19:47:46 +0100 (MET)
Message-ID: <20060322184745.5655.24038.sendpatchset@localhost.localdomain>
References: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: ctnetlink: Fix expectaction mask dumping

The expectation mask has some particularities that requires a different
handling. The protocol number fields can be set to non-valid protocols,
ie. l3num is set to 0xFFFF. Since that protocol does not exist, the mask
tuple will not be dumped. Moreover, this results in a kernel panic when
nf_conntrack accesses the array of protocol handlers, that is PF_MAX (0x1F)
long.

This patch introduces the function ctnetlink_exp_dump_mask, that correctly
dumps the expectation mask. Such function uses the l3num value from the
expectation tuple that is a valid layer 3 protocol number. The value of the
l3num mask isn't dumped since it is meaningless from the userspace side.

Thanks to Yasuyuki Kozakai and Patrick McHardy for the feedback.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6d2aea55c0f19c86b8c983b1a14c746c763c480e
tree 00536a34cef48732b0faaf5a990ff0a537480f93
parent f50d6f98c2dbfa3472c1650dee11758b60b651ce
author Pablo Neira Ayuso <pablo@netfilter.org> Tue, 21 Mar 2006 22:30:19 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 21 Mar 2006 22:30:19 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |   72 +++++++++++++++++++------
 net/netfilter/nf_conntrack_netlink.c      |   84 +++++++++++++++++++++--------
 2 files changed, 117 insertions(+), 39 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 5ce2e3f..730c095 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -4,7 +4,7 @@
  * (C) 2001 by Jay Schulist <jschlst@samba.org>
  * (C) 2002-2005 by Harald Welte <laforge@gnumonks.org>
  * (C) 2003 by Patrick Mchardy <kaber@trash.net>
- * (C) 2005 by Pablo Neira Ayuso <pablo@eurodev.net>
+ * (C) 2005-2006 by Pablo Neira Ayuso <pablo@eurodev.net>
  *
  * I've reworked this stuff to use attributes instead of conntrack 
  * structures. 5.44 am. I need more tea. --pablo 05/07/11.
@@ -53,20 +53,18 @@ static char __initdata version[] = "0.90
 
 static inline int
 ctnetlink_dump_tuples_proto(struct sk_buff *skb, 
-			    const struct ip_conntrack_tuple *tuple)
+			    const struct ip_conntrack_tuple *tuple,
+			    struct ip_conntrack_protocol *proto)
 {
-	struct ip_conntrack_protocol *proto;
 	int ret = 0;
+	struct nfattr *nest_parms = NFA_NEST(skb, CTA_TUPLE_PROTO);
 
 	NFA_PUT(skb, CTA_PROTO_NUM, sizeof(u_int8_t), &tuple->dst.protonum);
 
-	/* If no protocol helper is found, this function will return the
-	 * generic protocol helper, so proto won't *ever* be NULL */
-	proto = ip_conntrack_proto_find_get(tuple->dst.protonum);
 	if (likely(proto->tuple_to_nfattr))
 		ret = proto->tuple_to_nfattr(skb, tuple);
 	
-	ip_conntrack_proto_put(proto);
+	NFA_NEST_END(skb, nest_parms);
 
 	return ret;
 
@@ -75,28 +73,41 @@ nfattr_failure:
 }
 
 static inline int
-ctnetlink_dump_tuples(struct sk_buff *skb, 
-		      const struct ip_conntrack_tuple *tuple)
+ctnetlink_dump_tuples_ip(struct sk_buff *skb,
+			 const struct ip_conntrack_tuple *tuple)
 {
-	struct nfattr *nest_parms;
-	int ret;
+	struct nfattr *nest_parms = NFA_NEST(skb, CTA_TUPLE_IP);
 	
-	nest_parms = NFA_NEST(skb, CTA_TUPLE_IP);
 	NFA_PUT(skb, CTA_IP_V4_SRC, sizeof(u_int32_t), &tuple->src.ip);
 	NFA_PUT(skb, CTA_IP_V4_DST, sizeof(u_int32_t), &tuple->dst.ip);
-	NFA_NEST_END(skb, nest_parms);
 
-	nest_parms = NFA_NEST(skb, CTA_TUPLE_PROTO);
-	ret = ctnetlink_dump_tuples_proto(skb, tuple);
 	NFA_NEST_END(skb, nest_parms);
 
-	return ret;
+	return 0;
 
 nfattr_failure:
 	return -1;
 }
 
 static inline int
+ctnetlink_dump_tuples(struct sk_buff *skb,
+		      const struct ip_conntrack_tuple *tuple)
+{
+	int ret;
+	struct ip_conntrack_protocol *proto;
+
+	ret = ctnetlink_dump_tuples_ip(skb, tuple);
+	if (unlikely(ret < 0))
+		return ret;
+
+	proto = ip_conntrack_proto_find_get(tuple->dst.protonum);
+	ret = ctnetlink_dump_tuples_proto(skb, tuple, proto);
+	ip_conntrack_proto_put(proto);
+
+	return ret;
+}
+
+static inline int
 ctnetlink_dump_status(struct sk_buff *skb, const struct ip_conntrack *ct)
 {
 	u_int32_t status = htonl((u_int32_t) ct->status);
@@ -1135,6 +1146,33 @@ nfattr_failure:
 }			
 
 static inline int
+ctnetlink_exp_dump_mask(struct sk_buff *skb,
+			const struct ip_conntrack_tuple *tuple,
+			const struct ip_conntrack_tuple *mask)
+{
+	int ret;
+	struct ip_conntrack_protocol *proto;
+	struct nfattr *nest_parms = NFA_NEST(skb, CTA_EXPECT_MASK);
+
+	ret = ctnetlink_dump_tuples_ip(skb, mask);
+	if (unlikely(ret < 0))
+		goto nfattr_failure;
+
+	proto = ip_conntrack_proto_find_get(tuple->dst.protonum);
+	ret = ctnetlink_dump_tuples_proto(skb, mask, proto);
+	ip_conntrack_proto_put(proto);
+	if (unlikely(ret < 0))
+		goto nfattr_failure;
+
+	NFA_NEST_END(skb, nest_parms);
+
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
+static inline int
 ctnetlink_exp_dump_expect(struct sk_buff *skb,
                           const struct ip_conntrack_expect *exp)
 {
@@ -1144,7 +1182,7 @@ ctnetlink_exp_dump_expect(struct sk_buff
 
 	if (ctnetlink_exp_dump_tuple(skb, &exp->tuple, CTA_EXPECT_TUPLE) < 0)
 		goto nfattr_failure;
-	if (ctnetlink_exp_dump_tuple(skb, &exp->mask, CTA_EXPECT_MASK) < 0)
+	if (ctnetlink_exp_dump_mask(skb, &exp->tuple, &exp->mask) < 0)
 		goto nfattr_failure;
 	if (ctnetlink_exp_dump_tuple(skb,
 				 &master->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 5eadf00..508b31e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -4,7 +4,7 @@
  * (C) 2001 by Jay Schulist <jschlst@samba.org>
  * (C) 2002-2006 by Harald Welte <laforge@gnumonks.org>
  * (C) 2003 by Patrick Mchardy <kaber@trash.net>
- * (C) 2005 by Pablo Neira Ayuso <pablo@eurodev.net>
+ * (C) 2005-2006 by Pablo Neira Ayuso <pablo@eurodev.net>
  *
  * I've reworked this stuff to use attributes instead of conntrack 
  * structures. 5.44 am. I need more tea. --pablo 05/07/11.
@@ -55,20 +55,18 @@ static char __initdata version[] = "0.93
 
 static inline int
 ctnetlink_dump_tuples_proto(struct sk_buff *skb, 
-			    const struct nf_conntrack_tuple *tuple)
+			    const struct nf_conntrack_tuple *tuple,
+			    struct nf_conntrack_protocol *proto)
 {
-	struct nf_conntrack_protocol *proto;
 	int ret = 0;
+	struct nfattr *nest_parms = NFA_NEST(skb, CTA_TUPLE_PROTO);
 
 	NFA_PUT(skb, CTA_PROTO_NUM, sizeof(u_int8_t), &tuple->dst.protonum);
 
-	/* If no protocol helper is found, this function will return the
-	 * generic protocol helper, so proto won't *ever* be NULL */
-	proto = nf_ct_proto_find_get(tuple->src.l3num, tuple->dst.protonum);
 	if (likely(proto->tuple_to_nfattr))
 		ret = proto->tuple_to_nfattr(skb, tuple);
 	
-	nf_ct_proto_put(proto);
+	NFA_NEST_END(skb, nest_parms);
 
 	return ret;
 
@@ -77,33 +75,44 @@ nfattr_failure:
 }
 
 static inline int
-ctnetlink_dump_tuples(struct sk_buff *skb, 
-		      const struct nf_conntrack_tuple *tuple)
+ctnetlink_dump_tuples_ip(struct sk_buff *skb,
+			 const struct nf_conntrack_tuple *tuple,
+			 struct nf_conntrack_l3proto *l3proto)
 {
-	struct nfattr *nest_parms;
-	struct nf_conntrack_l3proto *l3proto;
 	int ret = 0;
-	
-	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
-	
-	nest_parms = NFA_NEST(skb, CTA_TUPLE_IP);
+	struct nfattr *nest_parms = NFA_NEST(skb, CTA_TUPLE_IP);
+
 	if (likely(l3proto->tuple_to_nfattr))
 		ret = l3proto->tuple_to_nfattr(skb, tuple);
+
 	NFA_NEST_END(skb, nest_parms);
 
+	return ret;
+
+nfattr_failure:
+	return -1;
+}
+
+static inline int
+ctnetlink_dump_tuples(struct sk_buff *skb,
+		      const struct nf_conntrack_tuple *tuple)
+{
+	int ret;
+	struct nf_conntrack_l3proto *l3proto;
+	struct nf_conntrack_protocol *proto;
+
+	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
+	ret = ctnetlink_dump_tuples_ip(skb, tuple, l3proto);
 	nf_ct_l3proto_put(l3proto);
 
 	if (unlikely(ret < 0))
 		return ret;
 
-	nest_parms = NFA_NEST(skb, CTA_TUPLE_PROTO);
-	ret = ctnetlink_dump_tuples_proto(skb, tuple);
-	NFA_NEST_END(skb, nest_parms);
+	proto = nf_ct_proto_find_get(tuple->src.l3num, tuple->dst.protonum);
+	ret = ctnetlink_dump_tuples_proto(skb, tuple, proto);
+	nf_ct_proto_put(proto);
 
 	return ret;
-
-nfattr_failure:
-	return -1;
 }
 
 static inline int
@@ -1153,6 +1162,37 @@ nfattr_failure:
 }			
 
 static inline int
+ctnetlink_exp_dump_mask(struct sk_buff *skb,
+			const struct nf_conntrack_tuple *tuple,
+			const struct nf_conntrack_tuple *mask)
+{
+	int ret;
+	struct nf_conntrack_l3proto *l3proto;
+	struct nf_conntrack_protocol *proto;
+	struct nfattr *nest_parms = NFA_NEST(skb, CTA_EXPECT_MASK);
+
+	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
+	ret = ctnetlink_dump_tuples_ip(skb, mask, l3proto);
+	nf_ct_l3proto_put(l3proto);
+
+	if (unlikely(ret < 0))
+		goto nfattr_failure;
+
+	proto = nf_ct_proto_find_get(tuple->src.l3num, tuple->dst.protonum);
+	ret = ctnetlink_dump_tuples_proto(skb, mask, proto);
+	nf_ct_proto_put(proto);
+	if (unlikely(ret < 0))
+		goto nfattr_failure;
+
+	NFA_NEST_END(skb, nest_parms);
+
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
+static inline int
 ctnetlink_exp_dump_expect(struct sk_buff *skb,
                           const struct nf_conntrack_expect *exp)
 {
@@ -1162,7 +1202,7 @@ ctnetlink_exp_dump_expect(struct sk_buff
 
 	if (ctnetlink_exp_dump_tuple(skb, &exp->tuple, CTA_EXPECT_TUPLE) < 0)
 		goto nfattr_failure;
-	if (ctnetlink_exp_dump_tuple(skb, &exp->mask, CTA_EXPECT_MASK) < 0)
+	if (ctnetlink_exp_dump_mask(skb, &exp->tuple, &exp->mask) < 0)
 		goto nfattr_failure;
 	if (ctnetlink_exp_dump_tuple(skb,
 				 &master->tuplehash[IP_CT_DIR_ORIGINAL].tuple,

From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC] [PATCH] Fix expectation mask dumping (Was Re: expectation mask
 handling in nfctnetlink)
Date: Thu, 02 Feb 2006 01:45:09 +0100
Message-ID: <43E15615.2070508@netfilter.org>
References: <200601200457.k0K4vvAI001787@toshiba.co.jp>	<43E01851.4040306@netfilter.org>	<43E095A2.1040908@trash.net>
	<200602011335.k11DZHwj018072@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020606000104060300060301"
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200602011335.k11DZHwj018072@toshiba.co.jp>
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

This is a multi-part message in MIME format.
--------------020606000104060300060301
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

This patch introduces the function ctnetlink_exp_dump_mask, that
correctly dumps the expectation mask. Such function uses the l3num value
from the expectation tuple that is a valid layer 3 protocol number.

Besides, this modification introduces the attribute CTA_IP_L3NUM.
Although the layer 3 protocol information is sent in the nfnetlink
header, if the message contains information about an expectation, it
will contain information about the master conntrack (just one of the
tuples), the expectation tuple and the expectation mask. In this case,
the value of l3num in the expectation mask is not the same that is set
in the nfnetlink message. That is why we need another field that contain
the value of l3num.

Now libnetfilter_conntrack can use the CTA_IP_L3NUM attribute, but if
this attribute is not present in the message, it can use the information
available in the nfnetlink header message.

comments?

cheers,
Pablo

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris


--------------020606000104060300060301
Content-Type: text/plain;
 name="y"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="y"

[RFC][CTNETLINK] Fix expectaction mask dumping

The expectation mask has some particularities that make handle in a different
way. The protocol number fields can be set to non-valid protocols, ie. l3num
is set to 0xFFFF. Since that protocol does not exist, the mask tuple will not
be dumped. Moreover, this results in a kernel panic when nf_conntrack accesses
the array of protocol handlers, that is PF_MAX (0x1F) long.

This patch introduces the function ctnetlink_exp_dump_mask, that correctly
dumps the expectation mask. Such function uses the l3num value from the
expectation tuple that is a valid layer 3 protocol number.

Besides, this modification introduces the attribute CTA_IP_L3NUM. Although
the layer 3 protocol information is sent in the nfnetlink header, if the
message contains information about an expectation, it will contain information
about the master conntrack (just one of the tuples), the expectation tuple and
the expectation mask. In this case, the value of l3num in the expectation mask
is not the same that is set in the nfnetlink message. That is why we need 
another field that contain the value of l3num.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2006-02-01 20:17:05.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2006-02-02 01:28:09.000000000 +0100
@@ -55,20 +55,18 @@ static char __initdata version[] = "0.92
 
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
 
@@ -77,33 +75,46 @@ nfattr_failure:
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
+	NFA_PUT(skb, CTA_IP_L3NUM, sizeof(u_int16_t), &tuple->src.l3num);
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
+	int ret = 0;
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
@@ -1150,6 +1161,29 @@ nfattr_failure:
 }			
 
 static inline int
+ctnetlink_exp_dump_mask(struct sk_buff *skb, 
+			const struct nf_conntrack_tuple *tuple,
+			const struct nf_conntrack_tuple *mask)
+{
+	int ret = 0;
+	struct nf_conntrack_l3proto *l3proto;
+	struct nf_conntrack_protocol *proto;
+
+	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
+	ret = ctnetlink_dump_tuples_ip(skb, mask, l3proto);
+	nf_ct_l3proto_put(l3proto);
+
+	if (unlikely(ret < 0))
+		return ret;
+
+	proto = nf_ct_proto_find_get(tuple->src.l3num, tuple->dst.protonum);
+	ret = ctnetlink_dump_tuples_proto(skb, mask, proto);
+	nf_ct_proto_put(proto);
+
+	return ret;
+}
+
+static inline int
 ctnetlink_exp_dump_expect(struct sk_buff *skb,
                           const struct nf_conntrack_expect *exp)
 {
@@ -1159,7 +1193,7 @@ ctnetlink_exp_dump_expect(struct sk_buff
 
 	if (ctnetlink_exp_dump_tuple(skb, &exp->tuple, CTA_EXPECT_TUPLE) < 0)
 		goto nfattr_failure;
-	if (ctnetlink_exp_dump_tuple(skb, &exp->mask, CTA_EXPECT_MASK) < 0)
+	if (ctnetlink_exp_dump_mask(skb, &exp->tuple, &exp->mask) < 0)
 		goto nfattr_failure;
 	if (ctnetlink_exp_dump_tuple(skb,
 				 &master->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
Index: net-2.6.git/include/linux/netfilter/nfnetlink_conntrack.h
===================================================================
--- net-2.6.git.orig/include/linux/netfilter/nfnetlink_conntrack.h	2006-02-01 20:01:44.000000000 +0100
+++ net-2.6.git/include/linux/netfilter/nfnetlink_conntrack.h	2006-02-01 20:52:05.000000000 +0100
@@ -52,6 +52,7 @@ enum ctattr_ip {
 	CTA_IP_V4_DST,
 	CTA_IP_V6_SRC,
 	CTA_IP_V6_DST,
+	CTA_IP_L3NUM,
 	__CTA_IP_MAX
 };
 #define CTA_IP_MAX (__CTA_IP_MAX - 1)

--------------020606000104060300060301--

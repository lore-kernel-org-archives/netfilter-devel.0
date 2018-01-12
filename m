From: Ahmed Abdelsalam <amsalam20@gmail.com>
Subject: [nf-next 1/3] netfilter: export SRH processing functions from seg6local
Date: Fri, 12 Jan 2018 05:39:34 +0100
Message-ID: <1515731976-6338-1-git-send-email-amsalam20@gmail.com>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ahmed Abdelsalam <amsalam20@gmail.com>
To: pablo@netfilter.org, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Some functions of seg6local are very useful to process SRv6
encapsulated packets

This patch exports some functions of seg6local that are useful and
can be re-used at different parts of the kernel, including netfilter.

The set of exported functions are:
(1) seg6_get_srh()
(2) seg6_advance_nextseg()
(3) seg6_lookup_nexthop

Signed-off-by: Ahmed Abdelsalam <amsalam20@gmail.com>
---
 include/net/seg6.h    |  5 +++++
 net/ipv6/seg6_local.c | 37 ++++++++++++++++++++-----------------
 2 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/include/net/seg6.h b/include/net/seg6.h
index 099bad5..b637778 100644
--- a/include/net/seg6.h
+++ b/include/net/seg6.h
@@ -63,5 +63,10 @@ extern bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len);
 extern int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh,
 			     int proto);
 extern int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh);
+extern struct ipv6_sr_hdr *seg6_get_srh(struct sk_buff *skb);
+extern void seg6_advance_nextseg(struct ipv6_sr_hdr *srh,
+				struct in6_addr *daddr);
+extern void seg6_lookup_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
+				u32 tbl_id);
 
 #endif
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index ba3767e..1f1eaa3 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -59,7 +59,7 @@ static struct seg6_local_lwt *seg6_local_lwtunnel(struct lwtunnel_state *lwt)
 	return (struct seg6_local_lwt *)lwt->data;
 }
 
-static struct ipv6_sr_hdr *get_srh(struct sk_buff *skb)
+struct ipv6_sr_hdr *seg6_get_srh(struct sk_buff *skb)
 {
 	struct ipv6_sr_hdr *srh;
 	int len, srhoff = 0;
@@ -82,12 +82,13 @@ static struct ipv6_sr_hdr *get_srh(struct sk_buff *skb)
 
 	return srh;
 }
+EXPORT_SYMBOL_GPL(seg6_get_srh);
 
 static struct ipv6_sr_hdr *get_and_validate_srh(struct sk_buff *skb)
 {
 	struct ipv6_sr_hdr *srh;
 
-	srh = get_srh(skb);
+	srh = seg6_get_srh(skb);
 	if (!srh)
 		return NULL;
 
@@ -107,7 +108,7 @@ static bool decap_and_validate(struct sk_buff *skb, int proto)
 	struct ipv6_sr_hdr *srh;
 	unsigned int off = 0;
 
-	srh = get_srh(skb);
+	srh = seg6_get_srh(skb);
 	if (srh && srh->segments_left > 0)
 		return false;
 
@@ -131,7 +132,7 @@ static bool decap_and_validate(struct sk_buff *skb, int proto)
 	return true;
 }
 
-static void advance_nextseg(struct ipv6_sr_hdr *srh, struct in6_addr *daddr)
+void seg6_advance_nextseg(struct ipv6_sr_hdr *srh, struct in6_addr *daddr)
 {
 	struct in6_addr *addr;
 
@@ -139,9 +140,10 @@ static void advance_nextseg(struct ipv6_sr_hdr *srh, struct in6_addr *daddr)
 	addr = srh->segments + srh->segments_left;
 	*daddr = *addr;
 }
+EXPORT_SYMBOL_GPL(seg6_advance_nextseg);
 
-static void lookup_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
-			   u32 tbl_id)
+void seg6_lookup_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
+			 u32 tbl_id)
 {
 	struct net *net = dev_net(skb->dev);
 	struct ipv6hdr *hdr = ipv6_hdr(skb);
@@ -188,6 +190,7 @@ static void lookup_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
 	skb_dst_drop(skb);
 	skb_dst_set(skb, dst);
 }
+EXPORT_SYMBOL_GPL(seg6_lookup_nexthop);
 
 /* regular endpoint function */
 static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
@@ -198,9 +201,9 @@ static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 	if (!srh)
 		goto drop;
 
-	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+	seg6_advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
 
-	lookup_nexthop(skb, NULL, 0);
+	seg6_lookup_nexthop(skb, NULL, 0);
 
 	return dst_input(skb);
 
@@ -218,9 +221,9 @@ static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 	if (!srh)
 		goto drop;
 
-	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+	seg6_advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
 
-	lookup_nexthop(skb, &slwt->nh6, 0);
+	seg6_lookup_nexthop(skb, &slwt->nh6, 0);
 
 	return dst_input(skb);
 
@@ -237,9 +240,9 @@ static int input_action_end_t(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 	if (!srh)
 		goto drop;
 
-	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+	seg6_advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
 
-	lookup_nexthop(skb, NULL, slwt->table);
+	seg6_lookup_nexthop(skb, NULL, slwt->table);
 
 	return dst_input(skb);
 
@@ -331,7 +334,7 @@ static int input_action_end_dx6(struct sk_buff *skb,
 	if (!ipv6_addr_any(&slwt->nh6))
 		nhaddr = &slwt->nh6;
 
-	lookup_nexthop(skb, nhaddr, 0);
+	seg6_lookup_nexthop(skb, nhaddr, 0);
 
 	return dst_input(skb);
 drop:
@@ -380,7 +383,7 @@ static int input_action_end_dt6(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
 		goto drop;
 
-	lookup_nexthop(skb, NULL, slwt->table);
+	seg6_lookup_nexthop(skb, NULL, slwt->table);
 
 	return dst_input(skb);
 
@@ -406,7 +409,7 @@ static int input_action_end_b6(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
-	lookup_nexthop(skb, NULL, 0);
+	seg6_lookup_nexthop(skb, NULL, 0);
 
 	return dst_input(skb);
 
@@ -426,7 +429,7 @@ static int input_action_end_b6_encap(struct sk_buff *skb,
 	if (!srh)
 		goto drop;
 
-	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+	seg6_advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
 
 	skb_reset_inner_headers(skb);
 	skb->encapsulation = 1;
@@ -438,7 +441,7 @@ static int input_action_end_b6_encap(struct sk_buff *skb,
 	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
-	lookup_nexthop(skb, NULL, 0);
+	seg6_lookup_nexthop(skb, NULL, 0);
 
 	return dst_input(skb);
 
-- 
2.1.4

From: fgao@ikuai8.com
Subject: [PATCH nf-next 3/4] netfilter: helper: Use the bool instead of int type
Date: Fri, 17 Mar 2017 14:49:32 +0800
Message-ID: <80b66c9b398a477309b5139aab9bc7785c7d3051.1489726438.git.fgao@ikuai8.com>
References: <cover.1489726438.git.fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG252.QQ.COM ([183.60.52.105]:56002 "EHLO smtpbg252.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751049AbdCQGwZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 02:52:25 -0400
In-Reply-To: <cover.1489726438.git.fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

Use the bool type instead of the int type in the codes of
nf_nat_helper.h/c.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 include/net/netfilter/nf_nat_helper.h | 36 +++++++++++++++----------------
 net/netfilter/nf_nat_helper.c         | 40 +++++++++++++++++------------------
 2 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/include/net/netfilter/nf_nat_helper.h b/include/net/netfilter/nf_nat_helper.h
index 01bcc6b..fbfa5ac 100644
--- a/include/net/netfilter/nf_nat_helper.h
+++ b/include/net/netfilter/nf_nat_helper.h
@@ -7,31 +7,31 @@
 struct sk_buff;
 
 /* These return true or false. */
-int __nf_nat_mangle_tcp_packet(struct sk_buff *skb, struct nf_conn *ct,
-			       enum ip_conntrack_info ctinfo,
-			       unsigned int protoff, unsigned int match_offset,
-			       unsigned int match_len, const char *rep_buffer,
-			       unsigned int rep_len, bool adjust);
+bool __nf_nat_mangle_tcp_packet(struct sk_buff *skb, struct nf_conn *ct,
+				enum ip_conntrack_info ctinfo,
+				unsigned int protoff, unsigned int match_offset,
+				unsigned int match_len, const char *rep_buffer,
+				unsigned int rep_len, bool adjust);
 
-static inline int nf_nat_mangle_tcp_packet(struct sk_buff *skb,
-					   struct nf_conn *ct,
-					   enum ip_conntrack_info ctinfo,
-					   unsigned int protoff,
-					   unsigned int match_offset,
-					   unsigned int match_len,
-					   const char *rep_buffer,
-					   unsigned int rep_len)
+static inline bool nf_nat_mangle_tcp_packet(struct sk_buff *skb,
+					    struct nf_conn *ct,
+					    enum ip_conntrack_info ctinfo,
+					    unsigned int protoff,
+					    unsigned int match_offset,
+					    unsigned int match_len,
+					    const char *rep_buffer,
+					    unsigned int rep_len)
 {
 	return __nf_nat_mangle_tcp_packet(skb, ct, ctinfo, protoff,
 					  match_offset, match_len,
 					  rep_buffer, rep_len, true);
 }
 
-int nf_nat_mangle_udp_packet(struct sk_buff *skb, struct nf_conn *ct,
-			     enum ip_conntrack_info ctinfo,
-			     unsigned int protoff, unsigned int match_offset,
-			     unsigned int match_len, const char *rep_buffer,
-			     unsigned int rep_len);
+bool nf_nat_mangle_udp_packet(struct sk_buff *skb, struct nf_conn *ct,
+			      enum ip_conntrack_info ctinfo,
+			      unsigned int protoff, unsigned int match_offset,
+			      unsigned int match_len, const char *rep_buffer,
+			      unsigned int rep_len);
 
 /* Setup NAT on this expected conntrack so it follows master, but goes
  * to port ct->master->saved_proto. */
diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index 211661c..607a373 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -70,15 +70,15 @@ static void mangle_contents(struct sk_buff *skb,
 }
 
 /* Unusual, but possible case. */
-static int enlarge_skb(struct sk_buff *skb, unsigned int extra)
+static bool enlarge_skb(struct sk_buff *skb, unsigned int extra)
 {
 	if (skb->len + extra > 65535)
-		return 0;
+		return false;
 
 	if (pskb_expand_head(skb, 0, extra - skb_tailroom(skb), GFP_ATOMIC))
-		return 0;
+		return false;
 
-	return 1;
+	return true;
 }
 
 /* Generic function for mangling variable-length address changes inside
@@ -89,26 +89,26 @@ static int enlarge_skb(struct sk_buff *skb, unsigned int extra)
  * skb enlargement, ...
  *
  * */
-int __nf_nat_mangle_tcp_packet(struct sk_buff *skb,
-			       struct nf_conn *ct,
-			       enum ip_conntrack_info ctinfo,
-			       unsigned int protoff,
-			       unsigned int match_offset,
-			       unsigned int match_len,
-			       const char *rep_buffer,
-			       unsigned int rep_len, bool adjust)
+bool __nf_nat_mangle_tcp_packet(struct sk_buff *skb,
+				struct nf_conn *ct,
+				enum ip_conntrack_info ctinfo,
+				unsigned int protoff,
+				unsigned int match_offset,
+				unsigned int match_len,
+				const char *rep_buffer,
+				unsigned int rep_len, bool adjust)
 {
 	const struct nf_nat_l3proto *l3proto;
 	struct tcphdr *tcph;
 	int oldlen, datalen;
 
 	if (!skb_make_writable(skb, skb->len))
-		return 0;
+		return false;
 
 	if (rep_len > match_len &&
 	    rep_len - match_len > skb_tailroom(skb) &&
 	    !enlarge_skb(skb, rep_len - match_len))
-		return 0;
+		return false;
 
 	SKB_LINEAR_ASSERT(skb);
 
@@ -128,7 +128,7 @@ int __nf_nat_mangle_tcp_packet(struct sk_buff *skb,
 		nf_ct_seqadj_set(ct, ctinfo, tcph->seq,
 				 (int)rep_len - (int)match_len);
 
-	return 1;
+	return true;
 }
 EXPORT_SYMBOL(__nf_nat_mangle_tcp_packet);
 
@@ -142,7 +142,7 @@ int __nf_nat_mangle_tcp_packet(struct sk_buff *skb,
  * XXX - This function could be merged with nf_nat_mangle_tcp_packet which
  *       should be fairly easy to do.
  */
-int
+bool
 nf_nat_mangle_udp_packet(struct sk_buff *skb,
 			 struct nf_conn *ct,
 			 enum ip_conntrack_info ctinfo,
@@ -157,12 +157,12 @@ int __nf_nat_mangle_tcp_packet(struct sk_buff *skb,
 	int datalen, oldlen;
 
 	if (!skb_make_writable(skb, skb->len))
-		return 0;
+		return false;
 
 	if (rep_len > match_len &&
 	    rep_len - match_len > skb_tailroom(skb) &&
 	    !enlarge_skb(skb, rep_len - match_len))
-		return 0;
+		return false;
 
 	udph = (void *)skb->data + protoff;
 
@@ -176,13 +176,13 @@ int __nf_nat_mangle_tcp_packet(struct sk_buff *skb,
 
 	/* fix udp checksum if udp checksum was previously calculated */
 	if (!udph->check && skb->ip_summed != CHECKSUM_PARTIAL)
-		return 1;
+		return true;
 
 	l3proto = __nf_nat_l3proto_find(nf_ct_l3num(ct));
 	l3proto->csum_recalc(skb, IPPROTO_UDP, udph, &udph->check,
 			     datalen, oldlen);
 
-	return 1;
+	return true;
 }
 EXPORT_SYMBOL(nf_nat_mangle_udp_packet);
 
-- 
1.9.1


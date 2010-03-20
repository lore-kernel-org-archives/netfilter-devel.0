From: Christoph Paasch <christoph.paasch@gmail.com>
Subject: [PATCH] Netfilter: remove inlining of resolve_normal_ct
Date: Sat, 20 Mar 2010 15:55:19 +0100
Message-ID: <1269096919-12193-1-git-send-email-christoph.paasch@gmail.com>
Cc: Christoph Paasch <christoph.paasch@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51647 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab0CTOzX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:55:23 -0400
Received: by bwz1 with SMTP id 1so745159bwz.21
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Mar 2010 07:55:22 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

According to the Linux CodingStyle-Guidelines, inlining of functions with more
than 3 lines is discouraged.

Gcc is able to optimize itself the unique call to resolve_normal_ct. Thus, the
inline statement just increases the complexity of the code.

Signed-off-by: Christoph Paasch <christoph.paasch@gmail.com>
---
 net/netfilter/nf_conntrack_core.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0c9bbe9..9358025 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -730,16 +730,15 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 }
 
 /* On success, returns conntrack ptr, sets skb->nfct and ctinfo */
-static inline struct nf_conn *
-resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
-		  struct sk_buff *skb,
-		  unsigned int dataoff,
-		  u_int16_t l3num,
-		  u_int8_t protonum,
-		  struct nf_conntrack_l3proto *l3proto,
-		  struct nf_conntrack_l4proto *l4proto,
-		  int *set_reply,
-		  enum ip_conntrack_info *ctinfo)
+static struct nf_conn *resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
+					 struct sk_buff *skb,
+					 unsigned int dataoff,
+					 u_int16_t l3num,
+					 u_int8_t protonum,
+					 struct nf_conntrack_l3proto *l3proto,
+					 struct nf_conntrack_l4proto *l4proto,
+					 int *set_reply,
+					 enum ip_conntrack_info *ctinfo)
 {
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_tuple_hash *h;
-- 
1.6.3.3


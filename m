Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94163C433B4
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Apr 2021 16:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 735076135F
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Apr 2021 16:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238615AbhDSQRo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 12:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238875AbhDSQR3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 12:17:29 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3940C06138B
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Apr 2021 09:16:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lYWZz-0002f0-7q; Mon, 19 Apr 2021 18:16:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nat: move nf_xfrm_me_harder to where it is used
Date:   Mon, 19 Apr 2021 18:16:49 +0200
Message-Id: <20210419161649.24120-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

remove the export and make it static.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_nat.h |  2 --
 net/netfilter/nf_nat_core.c    | 37 ---------------------------------
 net/netfilter/nf_nat_proto.c   | 38 ++++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 0d412dd63707..987111ae5240 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -104,8 +104,6 @@ unsigned int
 nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state);
 
-int nf_xfrm_me_harder(struct net *n, struct sk_buff *s, unsigned int family);
-
 static inline int nf_nat_initialized(struct nf_conn *ct,
 				     enum nf_nat_manip_type manip)
 {
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index b7c3c902290f..7de595ead06a 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -146,43 +146,6 @@ static void __nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 		return;
 	}
 }
-
-int nf_xfrm_me_harder(struct net *net, struct sk_buff *skb, unsigned int family)
-{
-	struct flowi fl;
-	unsigned int hh_len;
-	struct dst_entry *dst;
-	struct sock *sk = skb->sk;
-	int err;
-
-	err = xfrm_decode_session(skb, &fl, family);
-	if (err < 0)
-		return err;
-
-	dst = skb_dst(skb);
-	if (dst->xfrm)
-		dst = ((struct xfrm_dst *)dst)->route;
-	if (!dst_hold_safe(dst))
-		return -EHOSTUNREACH;
-
-	if (sk && !net_eq(net, sock_net(sk)))
-		sk = NULL;
-
-	dst = xfrm_lookup(net, dst, &fl, sk, 0);
-	if (IS_ERR(dst))
-		return PTR_ERR(dst);
-
-	skb_dst_drop(skb);
-	skb_dst_set(skb, dst);
-
-	/* Change in oif may mean change in hh_len. */
-	hh_len = skb_dst(skb)->dev->hard_header_len;
-	if (skb_headroom(skb) < hh_len &&
-	    pskb_expand_head(skb, hh_len - skb_headroom(skb), 0, GFP_ATOMIC))
-		return -ENOMEM;
-	return 0;
-}
-EXPORT_SYMBOL(nf_xfrm_me_harder);
 #endif /* CONFIG_XFRM */
 
 /* We keep an extra hash for each conntrack, for fast searching. */
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 4731d21fc3ad..48cc60084d28 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -659,6 +659,44 @@ nf_nat_ipv4_pre_routing(void *priv, struct sk_buff *skb,
 	return ret;
 }
 
+#ifdef CONFIG_XFRM
+static int nf_xfrm_me_harder(struct net *net, struct sk_buff *skb, unsigned int family)
+{
+	struct sock *sk = skb->sk;
+	struct dst_entry *dst;
+	unsigned int hh_len;
+	struct flowi fl;
+	int err;
+
+	err = xfrm_decode_session(skb, &fl, family);
+	if (err < 0)
+		return err;
+
+	dst = skb_dst(skb);
+	if (dst->xfrm)
+		dst = ((struct xfrm_dst *)dst)->route;
+	if (!dst_hold_safe(dst))
+		return -EHOSTUNREACH;
+
+	if (sk && !net_eq(net, sock_net(sk)))
+		sk = NULL;
+
+	dst = xfrm_lookup(net, dst, &fl, sk, 0);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
+
+	skb_dst_drop(skb);
+	skb_dst_set(skb, dst);
+
+	/* Change in oif may mean change in hh_len. */
+	hh_len = skb_dst(skb)->dev->hard_header_len;
+	if (skb_headroom(skb) < hh_len &&
+	    pskb_expand_head(skb, hh_len - skb_headroom(skb), 0, GFP_ATOMIC))
+		return -ENOMEM;
+	return 0;
+}
+#endif
+
 static unsigned int
 nf_nat_ipv4_local_in(void *priv, struct sk_buff *skb,
 		     const struct nf_hook_state *state)
-- 
2.26.3


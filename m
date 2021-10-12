Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA43C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 17:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E3286109E
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 17:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbhJLRc3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Oct 2021 13:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbhJLRcZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 13:32:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60743C061766;
        Tue, 12 Oct 2021 10:30:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1maLbW-0008TY-TE; Tue, 12 Oct 2021 19:30:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel@vger.kernel.org
Cc:     lvs-devel@vger.kernel.org, ja@ssi.bg, horms@verge.net.au,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 3/4] netfilter: ipvs: remove unneeded input wrappers
Date:   Tue, 12 Oct 2021 19:29:58 +0200
Message-Id: <20211012172959.745-4-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211012172959.745-1-fw@strlen.de>
References: <20211012172959.745-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

After earlier patch ip_vs_hook_in can be used directly.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipvs/ip_vs_core.c | 57 +++------------------------------
 1 file changed, 4 insertions(+), 53 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 2db033455204..ad5f5e50547f 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2093,55 +2093,6 @@ ip_vs_in_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *state
 	return ret;
 }
 
-/*
- *	AF_INET handler in NF_INET_LOCAL_IN chain
- *	Schedule and forward packets from remote clients
- */
-static unsigned int
-ip_vs_remote_request4(void *priv, struct sk_buff *skb,
-		      const struct nf_hook_state *state)
-{
-	return ip_vs_in_hook(priv, skb, state);
-}
-
-/*
- *	AF_INET handler in NF_INET_LOCAL_OUT chain
- *	Schedule and forward packets from local clients
- */
-static unsigned int
-ip_vs_local_request4(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
-{
-	return ip_vs_in_hook(priv, skb, state);
-}
-
-#ifdef CONFIG_IP_VS_IPV6
-
-/*
- *	AF_INET6 handler in NF_INET_LOCAL_IN chain
- *	Schedule and forward packets from remote clients
- */
-static unsigned int
-ip_vs_remote_request6(void *priv, struct sk_buff *skb,
-		      const struct nf_hook_state *state)
-{
-	return ip_vs_in_hook(priv, skb, state);
-}
-
-/*
- *	AF_INET6 handler in NF_INET_LOCAL_OUT chain
- *	Schedule and forward packets from local clients
- */
-static unsigned int
-ip_vs_local_request6(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
-{
-	return ip_vs_in_hook(priv, skb, state);
-}
-
-#endif
-
-
 /*
  *	It is hooked at the NF_INET_FORWARD chain, in order to catch ICMP
  *      related packets destined for 0.0.0.0/0.
@@ -2202,7 +2153,7 @@ static const struct nf_hook_ops ip_vs_ops4[] = {
 	 * or VS/NAT(change destination), so that filtering rules can be
 	 * applied to IPVS. */
 	{
-		.hook		= ip_vs_remote_request4,
+		.hook		= ip_vs_in_hook,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_NAT_SRC - 1,
@@ -2216,7 +2167,7 @@ static const struct nf_hook_ops ip_vs_ops4[] = {
 	},
 	/* After mangle, schedule and forward local requests */
 	{
-		.hook		= ip_vs_local_request4,
+		.hook		= ip_vs_in_hook,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_NAT_DST + 2,
@@ -2251,7 +2202,7 @@ static const struct nf_hook_ops ip_vs_ops6[] = {
 	 * or VS/NAT(change destination), so that filtering rules can be
 	 * applied to IPVS. */
 	{
-		.hook		= ip_vs_remote_request6,
+		.hook		= ip_vs_in_hook,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_NAT_SRC - 1,
@@ -2265,7 +2216,7 @@ static const struct nf_hook_ops ip_vs_ops6[] = {
 	},
 	/* After mangle, schedule and forward local requests */
 	{
-		.hook		= ip_vs_local_request6,
+		.hook		= ip_vs_in_hook,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_NAT_DST + 2,
-- 
2.32.0


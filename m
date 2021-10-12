Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B324C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 17:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A0C860F23
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 17:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhJLRcZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Oct 2021 13:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbhJLRcS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 13:32:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3976EC061570;
        Tue, 12 Oct 2021 10:30:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1maLbS-0008TJ-Ko; Tue, 12 Oct 2021 19:30:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel@vger.kernel.org
Cc:     lvs-devel@vger.kernel.org, ja@ssi.bg, horms@verge.net.au,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 2/4] netfilter: ipvs: remove unneeded output wrappers
Date:   Tue, 12 Oct 2021 19:29:57 +0200
Message-Id: <20211012172959.745-3-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211012172959.745-1-fw@strlen.de>
References: <20211012172959.745-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

After earlier patch we can use ip_vs_out_hook directly.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipvs/ip_vs_core.c | 62 ++++-----------------------------
 1 file changed, 6 insertions(+), 56 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 5a5deee3425c..2db033455204 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1471,56 +1471,6 @@ ip_vs_out_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *stat
 	return NF_ACCEPT;
 }
 
-/*
- *	It is hooked at the NF_INET_FORWARD and NF_INET_LOCAL_IN chain,
- *	used only for VS/NAT.
- *	Check if packet is reply for established ip_vs_conn.
- */
-static unsigned int
-ip_vs_reply4(void *priv, struct sk_buff *skb,
-	     const struct nf_hook_state *state)
-{
-	return ip_vs_out_hook(priv, skb, state);
-}
-
-/*
- *	It is hooked at the NF_INET_LOCAL_OUT chain, used only for VS/NAT.
- *	Check if packet is reply for established ip_vs_conn.
- */
-static unsigned int
-ip_vs_local_reply4(void *priv, struct sk_buff *skb,
-		   const struct nf_hook_state *state)
-{
-	return ip_vs_out_hook(priv, skb, state);
-}
-
-#ifdef CONFIG_IP_VS_IPV6
-
-/*
- *	It is hooked at the NF_INET_FORWARD and NF_INET_LOCAL_IN chain,
- *	used only for VS/NAT.
- *	Check if packet is reply for established ip_vs_conn.
- */
-static unsigned int
-ip_vs_reply6(void *priv, struct sk_buff *skb,
-	     const struct nf_hook_state *state)
-{
-	return ip_vs_out_hook(priv, skb, state);
-}
-
-/*
- *	It is hooked at the NF_INET_LOCAL_OUT chain, used only for VS/NAT.
- *	Check if packet is reply for established ip_vs_conn.
- */
-static unsigned int
-ip_vs_local_reply6(void *priv, struct sk_buff *skb,
-		   const struct nf_hook_state *state)
-{
-	return ip_vs_out_hook(priv, skb, state);
-}
-
-#endif
-
 static unsigned int
 ip_vs_try_to_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 		      struct ip_vs_proto_data *pd,
@@ -2243,7 +2193,7 @@ ip_vs_forward_icmp_v6(void *priv, struct sk_buff *skb,
 static const struct nf_hook_ops ip_vs_ops4[] = {
 	/* After packet filtering, change source only for VS/NAT */
 	{
-		.hook		= ip_vs_reply4,
+		.hook		= ip_vs_out_hook,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_NAT_SRC - 2,
@@ -2259,7 +2209,7 @@ static const struct nf_hook_ops ip_vs_ops4[] = {
 	},
 	/* Before ip_vs_in, change source only for VS/NAT */
 	{
-		.hook		= ip_vs_local_reply4,
+		.hook		= ip_vs_out_hook,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_NAT_DST + 1,
@@ -2281,7 +2231,7 @@ static const struct nf_hook_ops ip_vs_ops4[] = {
 	},
 	/* After packet filtering, change source only for VS/NAT */
 	{
-		.hook		= ip_vs_reply4,
+		.hook		= ip_vs_out_hook,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= 100,
@@ -2292,7 +2242,7 @@ static const struct nf_hook_ops ip_vs_ops4[] = {
 static const struct nf_hook_ops ip_vs_ops6[] = {
 	/* After packet filtering, change source only for VS/NAT */
 	{
-		.hook		= ip_vs_reply6,
+		.hook		= ip_vs_out_hook,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_NAT_SRC - 2,
@@ -2308,7 +2258,7 @@ static const struct nf_hook_ops ip_vs_ops6[] = {
 	},
 	/* Before ip_vs_in, change source only for VS/NAT */
 	{
-		.hook		= ip_vs_local_reply6,
+		.hook		= ip_vs_out_hook,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_NAT_DST + 1,
@@ -2330,7 +2280,7 @@ static const struct nf_hook_ops ip_vs_ops6[] = {
 	},
 	/* After packet filtering, change source only for VS/NAT */
 	{
-		.hook		= ip_vs_reply6,
+		.hook		= ip_vs_out_hook,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= 100,
-- 
2.32.0


Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8A9CD98FA
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Oct 2023 08:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345379AbjJKIAD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Oct 2023 04:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345393AbjJKIAB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2023 04:00:01 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7351CF
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2023 00:59:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qqU8M-0006u8-G4; Wed, 11 Oct 2023 09:59:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/6] netfilter: xt_mangle: only check verdict part of return value
Date:   Wed, 11 Oct 2023 09:59:34 +0200
Message-ID: <20231011075944.2301-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231011075944.2301-1-fw@strlen.de>
References: <20231011075944.2301-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These checks assume that the caller only returns NF_DROP without
any errno embedded in the upper bits.

This is fine right now, but followup patches will start to propagate
such errors to allow kfree_skb_drop_reason() in the called functions,
those would then indicate 'errno << 8 | NF_STOLEN'.

To not break things we have to mask those parts out.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/iptable_mangle.c  | 9 +++++----
 net/ipv6/netfilter/ip6table_mangle.c | 9 +++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 3abb430af9e6..385d945d8ebe 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -36,12 +36,12 @@ static const struct xt_table packet_mangler = {
 static unsigned int
 ipt_mangle_out(void *priv, struct sk_buff *skb, const struct nf_hook_state *state)
 {
-	unsigned int ret;
+	unsigned int ret, verdict;
 	const struct iphdr *iph;
-	u_int8_t tos;
 	__be32 saddr, daddr;
-	u_int32_t mark;
+	u32 mark;
 	int err;
+	u8 tos;
 
 	/* Save things which could affect route */
 	mark = skb->mark;
@@ -51,8 +51,9 @@ ipt_mangle_out(void *priv, struct sk_buff *skb, const struct nf_hook_state *stat
 	tos = iph->tos;
 
 	ret = ipt_do_table(priv, skb, state);
+	verdict = ret & NF_VERDICT_MASK;
 	/* Reroute for ANY change. */
-	if (ret != NF_DROP && ret != NF_STOLEN) {
+	if (verdict != NF_DROP && verdict != NF_STOLEN) {
 		iph = ip_hdr(skb);
 
 		if (iph->saddr != saddr ||
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index a88b2ce4a3cb..8dd4cd0c47bd 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -31,10 +31,10 @@ static const struct xt_table packet_mangler = {
 static unsigned int
 ip6t_mangle_out(void *priv, struct sk_buff *skb, const struct nf_hook_state *state)
 {
-	unsigned int ret;
 	struct in6_addr saddr, daddr;
-	u_int8_t hop_limit;
-	u_int32_t flowlabel, mark;
+	unsigned int ret, verdict;
+	u32 flowlabel, mark;
+	u8 hop_limit;
 	int err;
 
 	/* save source/dest address, mark, hoplimit, flowlabel, priority,  */
@@ -47,8 +47,9 @@ ip6t_mangle_out(void *priv, struct sk_buff *skb, const struct nf_hook_state *sta
 	flowlabel = *((u_int32_t *)ipv6_hdr(skb));
 
 	ret = ip6t_do_table(priv, skb, state);
+	verdict = ret & NF_VERDICT_MASK;
 
-	if (ret != NF_DROP && ret != NF_STOLEN &&
+	if (verdict != NF_DROP && verdict != NF_STOLEN &&
 	    (!ipv6_addr_equal(&ipv6_hdr(skb)->saddr, &saddr) ||
 	     !ipv6_addr_equal(&ipv6_hdr(skb)->daddr, &daddr) ||
 	     skb->mark != mark ||
-- 
2.41.0


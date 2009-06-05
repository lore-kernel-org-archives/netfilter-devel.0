From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/3] netfilter: NFQUEUE use NFPROTO_UNSPEC
Date: Fri,  5 Jun 2009 03:15:40 +0200
Message-ID: <1244164542-10739-2-git-send-email-fw@strlen.de>
References: <1244164542-10739-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48517 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbZFEBKw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 21:10:52 -0400
In-Reply-To: <1244164542-10739-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We can use wildcard matching here, just like
ab4f21e6fb1c09b13c4c3cb8357babe8223471bd ("xtables: use NFPROTO_UNSPEC
in more extensions").

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_NFQUEUE.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index f9977b3..6e0f84d 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -34,21 +34,7 @@ nfqueue_tg(struct sk_buff *skb, const struct xt_target_param *par)
 static struct xt_target nfqueue_tg_reg[] __read_mostly = {
 	{
 		.name		= "NFQUEUE",
-		.family		= NFPROTO_IPV4,
-		.target		= nfqueue_tg,
-		.targetsize	= sizeof(struct xt_NFQ_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "NFQUEUE",
-		.family		= NFPROTO_IPV6,
-		.target		= nfqueue_tg,
-		.targetsize	= sizeof(struct xt_NFQ_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "NFQUEUE",
-		.family		= NFPROTO_ARP,
+		.family		= NFPROTO_UNSPEC,
 		.target		= nfqueue_tg,
 		.targetsize	= sizeof(struct xt_NFQ_info),
 		.me		= THIS_MODULE,
-- 
1.6.0.6


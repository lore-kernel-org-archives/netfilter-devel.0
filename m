From: Elison Niven <elison.niven@cyberoam.com>
Subject: [PATCH 1/1] netfilter : fix hooks for SNAT and DNAT targets
Date: Mon, 15 Oct 2012 16:14:48 +0530
Message-ID: <1350297888-3363-1-git-send-email-elison.niven@cyberoam.com>
Cc: sanket.shah@cyberoam.com, Elison Niven <elison.niven@cyberoam.com>
To: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:55894 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750739Ab2JOKyR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2012 06:54:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Correct hooks for SNAT and DNAT targets in xt_nat.c :
SNAT hooks should be POST_ROUTING and LOCAL_IN.
DNAT hooks should be PRE_ROUTING and LOCAL_OUT.

Signed-off-by: Elison Niven <elison.niven@cyberoam.com>
Signed-off-by: Sanket Shah <sanket.shah@cyberoam.com>
---
 net/netfilter/xt_nat.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index 81aafa8..bea7464 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -111,7 +111,7 @@ static struct xt_target xt_nat_target_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV4,
 		.table		= "nat",
 		.hooks		= (1 << NF_INET_POST_ROUTING) |
-				  (1 << NF_INET_LOCAL_OUT),
+				  (1 << NF_INET_LOCAL_IN),
 		.me		= THIS_MODULE,
 	},
 	{
@@ -123,7 +123,7 @@ static struct xt_target xt_nat_target_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV4,
 		.table		= "nat",
 		.hooks		= (1 << NF_INET_PRE_ROUTING) |
-				  (1 << NF_INET_LOCAL_IN),
+				  (1 << NF_INET_LOCAL_OUT),
 		.me		= THIS_MODULE,
 	},
 	{
@@ -133,7 +133,7 @@ static struct xt_target xt_nat_target_reg[] __read_mostly = {
 		.targetsize	= sizeof(struct nf_nat_range),
 		.table		= "nat",
 		.hooks		= (1 << NF_INET_POST_ROUTING) |
-				  (1 << NF_INET_LOCAL_OUT),
+				  (1 << NF_INET_LOCAL_IN),
 		.me		= THIS_MODULE,
 	},
 	{
@@ -143,7 +143,7 @@ static struct xt_target xt_nat_target_reg[] __read_mostly = {
 		.targetsize	= sizeof(struct nf_nat_range),
 		.table		= "nat",
 		.hooks		= (1 << NF_INET_PRE_ROUTING) |
-				  (1 << NF_INET_LOCAL_IN),
+				  (1 << NF_INET_LOCAL_OUT),
 		.me		= THIS_MODULE,
 	},
 };
-- 
1.7.7


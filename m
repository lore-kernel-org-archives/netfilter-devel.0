From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/5] netfilter: nf_tables_bridge: update hook_mask to allow {pre,post}routing
Date: Tue, 28 Oct 2014 14:38:50 +0100
Message-ID: <1414503534-10324-2-git-send-email-pablo@netfilter.org>
References: <1414503534-10324-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, stephen@networkplumber.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56639 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbaJ1Nhb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:37:31 -0400
In-Reply-To: <1414503534-10324-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes: 36d2af5 ("netfilter: nf_tables: allow to filter from prerouting and postrouting")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nf_tables_bridge.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index da17a5e..074c557 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -75,9 +75,11 @@ static const struct nf_chain_type filter_bridge = {
 	.type		= NFT_CHAIN_T_DEFAULT,
 	.family		= NFPROTO_BRIDGE,
 	.owner		= THIS_MODULE,
-	.hook_mask	= (1 << NF_BR_LOCAL_IN) |
+	.hook_mask	= (1 << NF_BR_PRE_ROUTING) |
+			  (1 << NF_BR_LOCAL_IN) |
 			  (1 << NF_BR_FORWARD) |
-			  (1 << NF_BR_LOCAL_OUT),
+			  (1 << NF_BR_LOCAL_OUT) |
+			  (1 << NF_BR_POST_ROUTING),
 };
 
 static int __init nf_tables_bridge_init(void)
-- 
1.7.10.4


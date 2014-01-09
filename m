From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 12/13] netfilter: nf_tables: unininline nft_trace_packet()
Date: Thu,  9 Jan 2014 18:42:42 +0000
Message-ID: <1389292963-4089-13-git-send-email-kaber@trash.net>
References: <1389292963-4089-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51698 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbaAISn2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:43:28 -0500
In-Reply-To: <1389292963-4089-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It makes no sense to inline a rarely used function meant for debugging
only that is called a total of five times in the main evaluation loop.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 5aae317..43b0e9a 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -103,9 +103,9 @@ static struct nf_loginfo trace_loginfo = {
 	},
 };
 
-static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
-				    const struct nft_chain *chain,
-				    int rulenum, enum nft_trace type)
+static void nft_trace_packet(const struct nft_pktinfo *pkt,
+			     const struct nft_chain *chain,
+			     int rulenum, enum nft_trace type)
 {
 	struct net *net = dev_net(pkt->in ? pkt->in : pkt->out);
 
-- 
1.8.4.2


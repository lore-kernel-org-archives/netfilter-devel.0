From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] netfilter: nf_tables: remove unused struct members
Date: Tue, 24 Nov 2015 00:03:28 +0100
Message-ID: <1448319808-9532-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57584 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbbKWXDh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Nov 2015 18:03:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
thoff and nhoff are not used anywhere,
payload expression uses skb_network_header() and xt.thoff as base offset.

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5131ad4..6c6fd49 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -19,8 +19,6 @@ struct nft_pktinfo {
 	const struct net_device		*out;
 	u8				pf;
 	u8				hook;
-	u8				nhoff;
-	u8				thoff;
 	u8				tprot;
 	/* for x_tables compatibility */
 	struct xt_action_param		xt;
-- 
2.4.10


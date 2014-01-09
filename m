From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 03/13] netfilter: nf_tables: fix check for table overflow
Date: Thu,  9 Jan 2014 18:42:33 +0000
Message-ID: <1389292963-4089-4-git-send-email-kaber@trash.net>
References: <1389292963-4089-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51681 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaAISnQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:43:16 -0500
In-Reply-To: <1389292963-4089-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The table use counter is only increased for new chains, so move the check
to the correct position.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d275d38..290472c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -834,9 +834,6 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	if (table->use == UINT_MAX)
-		return -EOVERFLOW;
-
 	chain = NULL;
 	name = nla[NFTA_CHAIN_NAME];
 
@@ -899,6 +896,9 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		goto notify;
 	}
 
+	if (table->use == UINT_MAX)
+		return -EOVERFLOW;
+
 	if (nla[NFTA_CHAIN_HOOK]) {
 		struct nf_hook_ops *ops;
 		nf_hookfn *hookfn;
-- 
1.8.4.2


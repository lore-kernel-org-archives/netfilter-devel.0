From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/2] netfilter: nf_tables: performance set policy skips size description in selection
Date: Mon,  6 Nov 2017 16:41:06 +0100
Message-ID: <20171106154107.15722-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54154 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932196AbdKFPlS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 10:41:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E69511BFA81
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:41:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D69C3DA848
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:41:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B68F6DA86F
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:41:14 +0100 (CET)
Received: from salvia.here (unknown [27.1.3.195])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6263B403DF98
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:41:12 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use the complexity and space notations if policy is performance, this
results in placing the bitmap set representation over the hashtable for
key <= 16 for better performance as we discussed during the last NFWS in
Faro, Portugal.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 929927171426..3b4a0739ee39 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2549,14 +2549,9 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 		case NFT_SET_POL_PERFORMANCE:
 			if (est.lookup < best.lookup)
 				break;
-			if (est.lookup == best.lookup) {
-				if (!desc->size) {
-					if (est.space < best.space)
-						break;
-				} else if (est.size < best.size) {
-					break;
-				}
-			}
+			if (est.lookup == best.lookup &&
+			    est.space < best.space)
+				break;
 			continue;
 		case NFT_SET_POL_MEMORY:
 			if (!desc->size) {
-- 
2.11.0


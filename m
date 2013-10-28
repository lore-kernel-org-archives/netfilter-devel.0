From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC PATCH 2/2 nf_tables] netfilter: nf_tables: round to 32 bits in payload operations
Date: Mon, 28 Oct 2013 13:59:39 +0100
Message-ID: <1382965180-9400-3-git-send-email-pablo@netfilter.org>
References: <1382965180-9400-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49948 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435Ab3J1M7x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:59:53 -0400
In-Reply-To: <1382965180-9400-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If you need to fetch less than 32 bits, round it up to 32 bits
to make sure that it zeroes the remaining part of the register.

This changes is required by concatenations.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index b814b0c4..5feb409 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -54,11 +54,11 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 		return false;
 
 	if (priv->len == 2)
-		*(u16 *)dest = *(u16 *)ptr;
+		*dest = *(u16 *)ptr;
 	else if (priv->len == 4)
-		*(u32 *)dest = *(u32 *)ptr;
+		*dest = *(u32 *)ptr;
 	else
-		*(u8 *)dest = *(u8 *)ptr;
+		*dest = *(u8 *)ptr;
 	return true;
 }
 
-- 
1.7.10.4


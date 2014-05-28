From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] parser: use symbolic expression for ether too
Date: Wed, 28 May 2014 10:06:16 +0200
Message-ID: <1401264376-4094-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51394 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbaE1IG3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 May 2014 04:06:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Like in 0dbced3 ("parser: use symbolic expressions for parsing
keywords as protocol values"), convert `ether' to use a symbolic
expression.

This fixes:

 # nft add rule ip filter input meta iiftype ether
 # nft list table filter
 table ip filter {
	...
	iiftype 256

which was converted to network byte order.

Reported-by: Ana Rey <anarey@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser.y |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/src/parser.y b/src/parser.y
index 20a836e..38b655d 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -1848,10 +1848,9 @@ eth_hdr_expr		:	ETHER	eth_hdr_field
 			}
 			|	ETHER
 			{
-				uint16_t data = ARPHRD_ETHER;
-				$$ = constant_expr_alloc(&@$, &arphrd_type,
-							 BYTEORDER_BIG_ENDIAN,
-							 sizeof(data) * BITS_PER_BYTE, &data);
+				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
+						       current_scope(state),
+						       "ether");
 			}
 			;
 
-- 
1.7.10.4


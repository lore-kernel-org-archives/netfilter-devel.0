From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] parser_bison: allow to used named limit from dictionaries too
Date: Mon,  9 Oct 2017 13:48:11 +0200
Message-ID: <1507549692-9878-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49292 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751068AbdJILsV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2017 07:48:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BF7B180FF1
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2017 13:48:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B1CF7DA7B9
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2017 13:48:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A2386DA848
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2017 13:48:17 +0200 (CEST)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 694844025FBA
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2017 13:48:17 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allow to use limit objects from dictionaries.

Fixes: c0697eabe832 ("src: add stateful object support for limit")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index f996d9d94880..7016f5b24887 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1426,6 +1426,15 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->flags  |= NFT_SET_OBJECT;
 				$$ = $1;
 			}
+			|	map_block	TYPE
+						data_type_expr	COLON	LIMIT
+						stmt_separator
+			{
+				$1->key = $3;
+				$1->objtype = NFT_OBJECT_LIMIT;
+				$1->flags  |= NFT_SET_OBJECT;
+				$$ = $1;
+			}
 			|	map_block	FLAGS		set_flag_list	stmt_separator
 			{
 				$1->flags |= $3;
-- 
2.1.4


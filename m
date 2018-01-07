From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH v2] parser_bison: extend nft to delete table via table handle
Date: Sun,  7 Jan 2018 10:31:01 +0530
Message-ID: <20180107050101.10432-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:39297 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbeAGFBQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jan 2018 00:01:16 -0500
Received: by mail-pl0-f68.google.com with SMTP id bi12so5626616plb.6
        for <netfilter-devel@vger.kernel.org>; Sat, 06 Jan 2018 21:01:16 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows deletion of table via unique table handles which can
be listed with '-a' option.
For.eg.
nft delete table handle 4

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
Changes in v2:
 -remove tableid_spec

 src/parser_bison.y | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6e85a62..6fdfac9 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -978,6 +978,10 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_TABLE, &$2, &@$, NULL);
 			}
+			|	TABLE 		handle_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_TABLE, &$2, &@$, NULL);
+			}
 			|	CHAIN		chain_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_CHAIN, &$2, &@$, NULL);
-- 
2.11.0


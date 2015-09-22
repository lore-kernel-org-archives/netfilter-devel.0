From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] parser: show all tables via list tables with no family
Date: Wed, 23 Sep 2015 00:20:51 +0200
Message-ID: <1442960451-4704-2-git-send-email-pablo@netfilter.org>
References: <1442960451-4704-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, nvinson234@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35041 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759679AbbIVWSO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Sep 2015 18:18:14 -0400
In-Reply-To: <1442960451-4704-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Default to the same behaviour that we get through `list ruleset', ie.

 # nft list tables
 table ip filter
 table ip6 filter

 # nft list tables ip
 table ip filter

 # nft list tables ip6
 table ip6 filter

Closes: http://bugzilla.netfilter.org/show_bug.cgi?id=1033
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 385e214..36910a7 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -767,7 +767,7 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_TABLE, &$2, &@$, NULL);
 			}
-			|	TABLES		tables_spec
+			|	TABLES		ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_TABLE, &$2, &@$, NULL);
 			}
-- 
1.7.10.4


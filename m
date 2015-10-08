From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 7/7] parser_bison: show all sets via list sets with no family
Date: Thu,  8 Oct 2015 22:49:30 +0200
Message-ID: <1444337370-8269-8-git-send-email-pablo@netfilter.org>
References: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47780 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260AbbJHUmm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2015 16:42:42 -0400
In-Reply-To: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Default to the same behaviour that we get through `list ruleset', ie.

 # nft list sets
 table ip test1 {
        set foo {
                type ipv4_addr
        }
 }
 table ip6 test2 {
        set bar {
                type ipv6_addr
        }
 }

 # nft list sets ip
 table ip test1 {
        set foo {
                type ipv4_addr
        }
 }

 # nft list sets ip6
 table ip6 test2 {
        set bar {
                type ipv6_addr
        }
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 86e2dc9..98480b6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -416,8 +416,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
 %destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
 
-%type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
-%destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
+%type <handle>			table_spec chain_spec chain_identifier ruleid_spec ruleset_spec
+%destructor { handle_free(&$$); } table_spec chain_spec chain_identifier ruleid_spec ruleset_spec
 %type <handle>			set_spec set_identifier
 %destructor { handle_free(&$$); } set_spec set_identifier
 %type <val>			handle_spec family_spec family_spec_explicit position_spec chain_policy
@@ -784,7 +784,7 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CHAINS, &$2, &@$, NULL);
 			}
-			|	SETS		tables_spec
+			|	SETS		ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SETS, &$2, &@$, NULL);
 			}
@@ -1195,14 +1195,6 @@ table_spec		:	family_spec	identifier
 			}
 			;
 
-tables_spec		:	family_spec
-			{
-				memset(&$$, 0, sizeof($$));
-				$$.family	= $1;
-				$$.table	= NULL;
-			}
-			;
-
 chain_spec		:	table_spec	identifier
 			{
 				$$		= $1;
-- 
2.1.4


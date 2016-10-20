From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables: Add anonymous set to named set
Date: Thu, 20 Oct 2016 17:11:44 +0200
Message-ID: <20161020151144.GA1556@salvia>
References: <20161018225231.5db3dac1@doomgiver>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Leon Merten Lohse <leon@green-side.de>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161018225231.5db3dac1@doomgiver>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 18, 2016 at 10:52:31PM +0200, Leon Merten Lohse wrote:
> Hi,
> 
> I am trying to add an anonymous set that is defined as a variable to a
> named set as follows:
> 
> define whitelist_v4 = { 1.1.1.1}
> 
> table inet filter {
>   set whitelist_v4 { type ipv4_addr; }
>  
>   [ ... ]
> }
> 
> add element inet filter whitelist_v4 $whitelist_v4

Attaching a patch to resolve this. Thanks for reporting.

--8t9RHnE3ZwKMSgU+
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-parser_bison-allow-to-use-variable-to-add-create-del.patch"

>From 86ea36cfcb18bf4f1d3128e6b848c4d4ffc5f964 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 20 Oct 2016 17:06:05 +0200
Subject: [PATCH nft] parser_bison: allow to use variable to add/create/delete
 elements

Using variable definitions from element command doesn't work, eg.

-test.nft-
 define whitelist_v4 = { 1.1.1.1 }
 table inet filter {
	set whitelist_v4 { type ipv4_addr; }
 }
 add element inet filter whitelist_v4 $whitelist_v4
-EOF-

 # nft -f test.nft
 test.nft:7:38-38: Error: syntax error, unexpected '$', expecting '{'
 add element inet filter whitelist_v4 $whitelist_v4
                                      ^

Fix this by using set_block_expr rule for every element command.

Reported-by: Leon Merten Lohse <leon@green-side.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 14ad67f61b6b..4108dff7e228 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -750,7 +750,7 @@ add_cmd			:	TABLE		table_spec
 				handle_merge(&$3->handle, &$2);
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SET, &$2, &@$, $5);
 			}
-			|	ELEMENT		set_spec	set_expr
+			|	ELEMENT		set_spec	set_block_expr
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SETELEM, &$2, &@$, $3);
 			}
@@ -799,7 +799,7 @@ create_cmd		:	TABLE		table_spec
 				handle_merge(&$3->handle, &$2);
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SET, &$2, &@$, $5);
 			}
-			|	ELEMENT		set_spec	set_expr
+			|	ELEMENT		set_spec	set_block_expr
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SETELEM, &$2, &@$, $3);
 			}
@@ -831,7 +831,7 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
-			|	ELEMENT		set_spec	set_expr
+			|	ELEMENT		set_spec	set_block_expr
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SETELEM, &$2, &@$, $3);
 			}
-- 
2.1.4


--8t9RHnE3ZwKMSgU+--

From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] parser: fix crash if we add a chain with an error chain type
Date: Sun, 29 May 2016 19:25:37 +0800
Message-ID: <1464521137-26146-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:37611 "EHLO m12-11.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135AbcE2L0S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 May 2016 07:26:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

If we add a chain and specify the nonexistent chain type, chain_type_name_lookup
will return a NULL pointer, and meet the assert condition in xstrdup.
Fix crash like this:

  # nft add chain filter input {type none hook input priority 0\;}
  nft: utils.c:63: xstrdup: Assertion `s != ((void *)0)' failed.
  Aborted (core dumped)

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 src/parser_bison.y | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0452b8f..ef10dee 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1124,12 +1124,14 @@ type_identifier		:	STRING	{ $$ = $1; }
 
 hook_spec		:	TYPE		STRING		HOOK		STRING		dev_spec	PRIORITY	prio_spec
 			{
-				$<chain>0->type		= xstrdup(chain_type_name_lookup($2));
-				if ($<chain>0->type == NULL) {
+				const char *chain_type = chain_type_name_lookup($2);
+
+				if (chain_type == NULL) {
 					erec_queue(error(&@2, "unknown chain type %s", $2),
 						   state->msgs);
 					YYERROR;
 				}
+				$<chain>0->type		= xstrdup(chain_type);
 				xfree($2);
 
 				$<chain>0->hookstr	= chain_hookname_lookup($4);
-- 
2.5.5



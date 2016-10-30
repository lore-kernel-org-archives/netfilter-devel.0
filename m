From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft v2] ct: fix "ct l3proto/protocol" syntax broken
Date: Sun, 30 Oct 2016 20:36:14 +0800
Message-ID: <1477830974-13197-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:52047 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbcJ3MhF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 30 Oct 2016 08:37:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

"l3proto" and "protocol" are still keywords in our grammer, they are not
STRING, so if the user input the following rule, nft will complain that
the syntax is error:
  # nft add t c ct l3proto ipv4
  <cmdline>:1:12-18: Error: syntax error, unexpected l3proto, expecting
  string or mark or packets or bytes
  add t c ct l3proto ipv4
             ^^^^^^^

Fixes: c992153402c7 ("ct: allow resolving ct keys at run time")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
V2: Sorry for this, the first version has some code style issues,
    tab and space are mixed.

 src/parser_bison.y | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 106df27..fa5de0c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2629,7 +2629,9 @@ ct_expr			: 	CT	ct_key
 			}
 			;
 
-ct_key			:	MARK		{ $$ = NFT_CT_MARK; }
+ct_key			:	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
+			|	PROTOCOL	{ $$ = NFT_CT_PROTOCOL; }
+			|	MARK		{ $$ = NFT_CT_MARK; }
 			|	ct_key_counters
 			;
 ct_key_dir		:	SADDR		{ $$ = NFT_CT_SRC; }
-- 
2.5.5



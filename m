From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft 1/3] parser_bison: Allow flushing flow tables
Date: Fri, 17 Mar 2017 12:03:17 -0300
Message-ID: <20170317150316.GA1260@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36363 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdCQPEX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 11:04:23 -0400
Received: by mail-qk0-f193.google.com with SMTP id n141so10105993qke.3
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 08:03:33 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch enables the command flush on flow tables, which removes all
entries in it:

$ nft flush flow table filter ft-https

Command above flushes flow table 'ft-https' in table 'filter'.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 src/parser_bison.y | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5d3d106..e44ff44 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1127,6 +1127,10 @@ flush_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
+			|	FLOW TABLE	set_spec
+			{
+				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_SET, &$3, &@$, NULL);
+			}
 			|	RULESET		ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_RULESET, &$2, &@$, NULL);
-- 
2.7.4


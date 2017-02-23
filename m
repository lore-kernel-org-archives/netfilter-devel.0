From: Alexander Alemayhu <alexander@alemayhu.com>
Subject: [PATCH libnftnl] exthdr: remove unused variable uval8
Date: Thu, 23 Feb 2017 23:33:06 +0100
Message-ID: <20170223223306.24394-1-alexander@alemayhu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Alexander Alemayhu <alexander@alemayhu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33418 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWWdN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2017 17:33:13 -0500
Received: by mail-lf0-f42.google.com with SMTP id l12so2187258lfe.0
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2017 14:33:12 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Was added but not used in d7b451fe1a45 (src: add TCP option matching
requirements, 2017-02-07). Fixes the following warning:

expr/exthdr.c: In function ‘nftnl_expr_exthdr_json_parse’:
expr/exthdr.c:244:10: warning: unused variable ‘uval8’ [-Wunused-variable]
  uint8_t uval8;
          ^~~~~

Signed-off-by: Alexander Alemayhu <alexander@alemayhu.com>
---
 src/expr/exthdr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index c44c1a75a5ea..9ed4ae1725ac 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -241,7 +241,6 @@ nftnl_expr_exthdr_json_parse(struct nftnl_expr *e, json_t *root,
 #ifdef JSON_PARSING
 	const char *exthdr_type;
 	uint32_t uval32;
-	uint8_t uval8;
 	int type;
 
 	if (nftnl_jansson_parse_reg(root, "dreg", NFTNL_TYPE_U32, &uval32,
-- 
2.9.3


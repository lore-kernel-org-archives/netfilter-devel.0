From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] src: fix build with older glibc
Date: Fri,  9 Feb 2018 14:49:50 +0200
Message-ID: <381eaa40735385a1a60e5ab0a7daf4bb847fc2ab.1518180590.git.baruch@tkos.co.il>
Cc: netfilter-devel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:33866 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750945AbeBIMuI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Feb 2018 07:50:08 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

glibc before 2.19 missed the definition of IPPROTO_MH. This leads to
build failure:

parser_bison.y: In function 'nft_parse':
parser_bison.y:3793:21: error: 'IPPROTO_MH' undeclared (first use in this function)
    | MH { $$ = IPPROTO_MH; }
                     ^

Since we have a local definition of IPPROTO_MH in headers.h use that to
fix the build.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 src/parser_bison.y | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 2e79109f4da3..578bfdc10429 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -29,6 +29,7 @@
 #include <rule.h>
 #include <statement.h>
 #include <expression.h>
+#include <headers.h>
 #include <utils.h>
 #include <parser.h>
 #include <erec.h>
-- 
2.15.1


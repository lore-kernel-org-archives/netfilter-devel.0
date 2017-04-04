From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: fix build warning on i686
Date: Tue,  4 Apr 2017 20:46:01 +0200
Message-ID: <20170404184601.15961-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37120 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752166AbdDDSoS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Apr 2017 14:44:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

datatype.c:182:13: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 2 has type ‘uint64_t {aka long long unsigned int}’ [-Wformat=] printf("%lu", val);

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/datatype.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index 06a045b..d2eed76 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -179,7 +179,7 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 		printf("\"");
 
 	if (numeric_output > NUMERIC_ALL)
-		printf("%lu", val);
+		printf("%"PRIu64"", val);
 	else
 		printf("%s", s->identifier);
 
-- 
2.9.3


From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/3] datatype: print datatype name in datatype_print() BUG message
Date: Thu, 11 Dec 2014 22:21:14 +0000
Message-ID: <1418336474-25567-3-git-send-email-kaber@trash.net>
References: <1418336474-25567-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56505 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933823AbaLKWVb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:21:31 -0500
In-Reply-To: <1418336474-25567-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/datatype.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index 5599c59..4519d87 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -87,7 +87,8 @@ void datatype_print(const struct expr *expr)
 			return symbolic_constant_print(dtype->sym_tbl, expr);
 	} while ((dtype = dtype->basetype));
 
-	BUG("datatype has no print method or symbol table\n");
+	BUG("datatype %s has no print method or symbol table\n",
+	    expr->dtype->name);
 }
 
 struct error_record *symbol_parse(const struct expr *sym,
-- 
2.1.0


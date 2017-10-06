From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] src: Merge assignment with return
Date: Sat,  7 Oct 2017 04:00:33 +0530
Message-ID: <20171006223033.664-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:37929 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752981AbdJFWdh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Oct 2017 18:33:37 -0400
Received: by mail-pf0-f196.google.com with SMTP id a7so17776120pfj.5
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Oct 2017 15:33:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Merge assignment with return statement to directly return the value.
Done using following coccinelle semantic patch

@@
local idexpression ret;
expression e;
@@

-ret =
+return
     e;
-return ret;

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 src/mini-gmp.c  | 3 +--
 src/statement.c | 5 +----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/src/mini-gmp.c b/src/mini-gmp.c
index acbe1be..0579c46 100644
--- a/src/mini-gmp.c
+++ b/src/mini-gmp.c
@@ -1297,8 +1297,7 @@ mpn_set_str_bits (mp_ptr rp, const unsigned char *sp, size_t sn,
 	    }
 	}
     }
-  rn = mpn_normalized_size (rp, rn);
-  return rn;
+  return mpn_normalized_size(rp, rn);
 }

 static mp_size_t
diff --git a/src/statement.c b/src/statement.c
index 6166863..168f944 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -208,10 +208,7 @@ static const struct stmt_ops objref_stmt_ops = {

 struct stmt *objref_stmt_alloc(const struct location *loc)
 {
-	struct stmt *stmt;
-
-	stmt = stmt_alloc(loc, &objref_stmt_ops);
-	return stmt;
+	return stmt_alloc(loc, &objref_stmt_ops);
 }

 static const char *syslog_level[LOG_DEBUG + 1] = {
--
2.11.0


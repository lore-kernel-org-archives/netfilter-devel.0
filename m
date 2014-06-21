From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/4] expr: meta: Delete the last comma character in json text.
Date: Sat, 21 Jun 2014 18:29:59 +0200
Message-ID: <1403368200-8860-4-git-send-email-anarey@gmail.com>
References: <1403368200-8860-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:54781 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaFUQaQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jun 2014 12:30:16 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so5050784wes.13
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jun 2014 09:30:15 -0700 (PDT)
In-Reply-To: <1403368200-8860-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to delete correctly the last comma character in json text.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/meta.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/expr/meta.c b/src/expr/meta.c
index 25026a9..95d538c 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -322,9 +322,10 @@ nft_rule_expr_meta_snprintf_json(char *buf, size_t size,
 	}
 
 	/* Remove the last separator characther */
-	buf[offset-1] = '\0';
+	if (offset > 0)
+		offset--;
 
-	return offset-1;
+	return offset;
 }
 
 static int
-- 
2.0.0


From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/4] expr: ct: Delete the last comma character in json text.
Date: Tue, 24 Jun 2014 08:46:39 +0200
Message-ID: <1403592401-5057-4-git-send-email-anarey@gmail.com>
References: <1403592401-5057-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:61045 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaFXGrH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:47:07 -0400
Received: by mail-wi0-f176.google.com with SMTP id n3so5283337wiv.9
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 23:47:05 -0700 (PDT)
In-Reply-To: <1403592401-5057-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to delete correctly the last comma character in json text.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/ct.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/expr/ct.c b/src/expr/ct.c
index 49fe238..f2718f9 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -356,9 +356,10 @@ nft_expr_ct_snprintf_json(char *buf, size_t size, struct nft_rule_expr *e)
 	}
 
 	/* Remove the last separator characther  */
-	buf[offset-1] = '\0';
+	if (offset > 0)
+		offset--;
 
-	return offset-1;
+	return offset;
 }
 
 static int
-- 
2.0.0


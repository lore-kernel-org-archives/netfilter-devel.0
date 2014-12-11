From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/3] dtype: fix memory leak in concat_type_destroy()
Date: Thu, 11 Dec 2014 22:21:13 +0000
Message-ID: <1418336474-25567-2-git-send-email-kaber@trash.net>
References: <1418336474-25567-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56502 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933823AbaLKWV2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:21:28 -0500
In-Reply-To: <1418336474-25567-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Free allocated memory for ->desc.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/datatype.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index db3fb06..5599c59 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -950,6 +950,8 @@ const struct datatype *concat_type_alloc(const struct expr *expr)
 
 void concat_type_destroy(const struct datatype *dtype)
 {
-	if (dtype->flags & DTYPE_F_ALLOC)
+	if (dtype->flags & DTYPE_F_ALLOC) {
+		xfree(dtype->desc);
 		xfree(dtype);
+	}
 }
-- 
2.1.0


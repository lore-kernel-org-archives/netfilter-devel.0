From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH] Fix overquota output result
Date: Wed, 30 Jul 2014 19:25:25 +0400
Message-ID: <1406733925-5344-2-git-send-email-a.perevalov@samsung.com>
References: <1406733925-5344-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13412 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaG3PZe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:25:34 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9J00E496UBFOA0@mailout4.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Wed, 30 Jul 2014 16:25:23 +0100 (BST)
In-reply-to: <1406733925-5344-1-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Current implementation shows "packet" for none byte quota type.
It means "packet" was used for overquota counter as well and it
wasn't so informative.

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 src/libnetfilter_acct.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index 7f539b6..9ed50c9 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -266,15 +266,23 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		SNPRINTF_CHECK(ret, rem, offset, len);
 
 		if (nfacct->flags) {
-			uint32_t mode;
-
-			mode = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_FLAGS);
-
+			const uint32_t mode = nfacct_attr_get_u64(nfacct,
+				NFACCT_ATTR_FLAGS);
+			char *mode_name = NULL, *overquota = NULL;
+			printf("mode %u", mode);
+			if (mode & NFACCT_F_QUOTA_PKTS)
+				mode_name = "packet";
+			else if (mode & NFACCT_F_QUOTA_BYTES)
+				mode_name = "byte";
+
+			if (mode & NFACCT_F_OVERQUOTA)
+				overquota = " overquota";
+			else
+				overquota = "";
 			ret = snprintf(buf + offset, rem,
-				", quota = %.20"PRIu64", mode = %s",
+				", quota = %.20"PRIu64", mode = %s%s",
 				nfacct_attr_get_u64(nfacct, NFACCT_ATTR_QUOTA),
-				mode == NFACCT_F_QUOTA_BYTES ?
-				"byte" : "packet");
+				mode_name, overquota);
 			SNPRINTF_CHECK(ret, rem, offset, len);
 		}
 
-- 
1.7.9.5


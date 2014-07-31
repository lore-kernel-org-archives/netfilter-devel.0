From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH v2] Fix overquota output result
Date: Thu, 31 Jul 2014 17:12:33 +0400
Message-ID: <1406812353-2930-1-git-send-email-a.perevalov@samsung.com>
References: <20140730170115.GA6364@salvia>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52239 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaGaNMk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:12:40 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9K006EYVCWL970@mailout1.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Thu, 31 Jul 2014 14:12:32 +0100 (BST)
In-reply-to: <20140730170115.GA6364@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Current implementation shows "packet" for none byte quota type.
It means "packet" was used for overquota counter as well and it
wasn't so informative.

This commmit adds additional column - overquota with yes/no value.

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 src/libnetfilter_acct.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index 7f539b6..0156c9a 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -266,15 +266,22 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		SNPRINTF_CHECK(ret, rem, offset, len);
 
 		if (nfacct->flags) {
-			uint32_t mode;
-
-			mode = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_FLAGS);
+			const uint32_t mode = nfacct_attr_get_u64(nfacct,
+				NFACCT_ATTR_FLAGS);
+			char *mode_name = NULL;
+			if (mode & NFACCT_F_QUOTA_PKTS)
+				mode_name = "packet";
+			else if (mode & NFACCT_F_QUOTA_BYTES)
+				mode_name = "byte";
+			else
+				mode_name = "unknown";
 
 			ret = snprintf(buf + offset, rem,
-				", quota = %.20"PRIu64", mode = %s",
+				", quota = %.20"PRIu64", mode = %s"\
+				", overquota = %s",
 				nfacct_attr_get_u64(nfacct, NFACCT_ATTR_QUOTA),
-				mode == NFACCT_F_QUOTA_BYTES ?
-				"byte" : "packet");
+				mode_name,
+				mode & NFACCT_F_OVERQUOTA ? "yes" : "no");
 			SNPRINTF_CHECK(ret, rem, offset, len);
 		}
 
-- 
1.7.9.5


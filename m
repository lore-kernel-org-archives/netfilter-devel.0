From: fgao@ikuai8.com
Subject: [PATCH v2 2/2 nf-next] netfilter: ftp: Remove the useless codes
Date: Thu,  1 Sep 2016 18:59:02 +0800
Message-ID: <1472727542-1088-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg327.qq.com ([14.17.43.158]:54541 "EHLO smtpbg327.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751606AbcIALIM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2016 07:08:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

There are some debug codes which are commented out in find_pattern by #if 0.
Now clean them.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v2: Splite the original patch to two commits
 v1: Initial patch

 net/netfilter/nf_conntrack_ftp.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index d49a2d4..77f05ac 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -310,16 +310,6 @@ static int find_pattern(const char *data, size_t dlen,
 	}
 
 	if (strncasecmp(data, pattern, plen) != 0) {
-#if 0
-		size_t i;
-
-		pr_debug("ftp: string mismatch\n");
-		for (i = 0; i < plen; i++) {
-			pr_debug("ftp:char %u `%c'(%u) vs `%c'(%u)\n",
-				 i, data[i], data[i],
-				 pattern[i], pattern[i]);
-		}
-#endif
 		return 0;
 	}
 
-- 
1.9.1



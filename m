From: fgao@ikuai8.com
Subject: [PATCH nf-next 1/1] netfilter: nf_tables: Remove one useless condition check in nf_tables_newobj
Date: Fri,  6 Jan 2017 09:49:48 +0800
Message-ID: <1483667388-30814-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG19.QQ.COM ([183.60.61.236]:41095 "EHLO smtpbg320.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753586AbdAFB6G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2017 20:58:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

The return value of nf_tables_obj_lookup is valid pointer or one error.
There are two cases in nf_tables_newobj totally.
case1: return value is -ENOENT, the obj is NULL, it is unnecessary to
perform the latter check "obj != NULL".
case2: IS_ERR(obj) is false, the obj is one valid pointer. It is also
unnecessary to perform that check.

In summary, we could move the block of condition check "obj != NULL" in
the else block to erase the original condition check.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_tables_api.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a019a87..bc55086 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4154,9 +4154,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 			return err;
 
 		obj = NULL;
-	}
-
-	if (obj != NULL) {
+	} else {
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
 
-- 
1.9.1



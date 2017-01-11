From: fgao@ikuai8.com
Subject: [PATCH nf-next 1/1] netfilter: nf_tables: Refine the codes to eliminate useless condition checks in nf_tables_api.c
Date: Wed, 11 Jan 2017 09:32:15 +0800
Message-ID: <1484098335-13300-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG352.QQ.COM ([183.57.50.167]:53879 "EHLO smtpbg352.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750730AbdAKBch (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Jan 2017 20:32:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

The return value of nf_tables_table_lookup is valid pointer or one
pointer error. There are two cases totally.
case1: IS_ERR(table) is true, it would return the error or reset the
table as NULL, it is unnecessary to perform the latter check
"table != NULL".
case2: IS_ERR(obj) is false, the table is one valid pointer. It is also
unnecessary to perform that check.
The nf_tables_newset and nf_tables_newobj have same logic codes.

In summary, we could move the block of condition check "table != NULL"
in the else block to eliminate the original condition checks.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_tables_api.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a019a87..3d7267f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -697,9 +697,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 		if (PTR_ERR(table) != -ENOENT)
 			return PTR_ERR(table);
 		table = NULL;
-	}
-
-	if (table != NULL) {
+	} else {
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
@@ -2964,9 +2962,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 		if (PTR_ERR(set) != -ENOENT)
 			return PTR_ERR(set);
 		set = NULL;
-	}
-
-	if (set != NULL) {
+	} else {
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
@@ -4154,9 +4150,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
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



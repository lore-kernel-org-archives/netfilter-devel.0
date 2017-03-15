From: fgao@ikuai8.com
Subject: [PATCH nf-next 1/1] netfilter: ctlink: Remove duplicated condition check in nfnl_cthelper_create
Date: Wed, 15 Mar 2017 10:11:08 +0800
Message-ID: <1489543868-66151-1-git-send-email-fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG252.QQ.COM ([183.60.52.105]:40609 "EHLO smtpbg252.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750774AbdCOCMs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 22:12:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

Because its caller nfnl_cthelper_new has already checked the tb[NFCTH_TUPLE],
so it is unnecessary to check it again in nfnl_cthelper_create.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nfnetlink_cthelper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index de87823..6649578 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -205,7 +205,7 @@
 	struct nf_conntrack_helper *helper;
 	int ret;
 
-	if (!tb[NFCTH_TUPLE] || !tb[NFCTH_POLICY] || !tb[NFCTH_PRIV_DATA_LEN])
+	if (!tb[NFCTH_POLICY] || !tb[NFCTH_PRIV_DATA_LEN])
 		return -EINVAL;
 
 	helper = kzalloc(sizeof(struct nf_conntrack_helper), GFP_KERNEL);
-- 
1.9.1



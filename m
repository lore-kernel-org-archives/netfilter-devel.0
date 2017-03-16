From: fgao@ikuai8.com
Subject: [PATCH nf 1/1] netfilter: ctlink: Fix one possible memleak in nfnl_cthelper_create
Date: Thu, 16 Mar 2017 09:27:36 +0800
Message-ID: <1489627656-104238-1-git-send-email-fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg342.qq.com ([14.17.44.37]:57058 "EHLO smtpbg342.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750886AbdCPB2f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 21:28:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

When nf_conntrack_helper_register failed, the error handler just frees
the helper, but it does not free the helper->expect_policy which is
allocated in nfnl_cthelper_parse_expect_policy.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nfnetlink_cthelper.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index de87823..f0241a1 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -214,7 +214,7 @@
 
 	ret = nfnl_cthelper_parse_expect_policy(helper, tb[NFCTH_POLICY]);
 	if (ret < 0)
-		goto err;
+		goto err1;
 
 	strncpy(helper->name, nla_data(tb[NFCTH_NAME]), NF_CT_HELPER_NAME_LEN);
 	helper->data_len = ntohl(nla_get_be32(tb[NFCTH_PRIV_DATA_LEN]));
@@ -245,10 +245,12 @@
 
 	ret = nf_conntrack_helper_register(helper);
 	if (ret < 0)
-		goto err;
+		goto err2;
 
 	return 0;
-err:
+err2:
+	kfree(helper->expect_policy);
+err1:
 	kfree(helper);
 	return ret;
 }
-- 
1.9.1



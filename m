From: gfree.wind@foxmail.com
Subject: [PATCH nf-next 1/1] netfilter: cttimeout: Return -EOPNOTSUPP if l4proto doesn't support
Date: Thu,  6 Apr 2017 19:13:29 +0800
Message-ID: <1491477209-1683-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgau2.qq.com ([54.206.34.216]:56269 "EHLO smtpbgau2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753899AbdDFLNn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 07:13:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

Return -EOPNOTSUPP instead of success when l4proto doesn't support
set the timeout attribute.

It is better to return error when fail to set timeout.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nfnetlink_cttimeout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index baa75f3..0b12e8c6 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -50,7 +50,7 @@
 ctnl_timeout_parse_policy(void *timeouts, struct nf_conntrack_l4proto *l4proto,
 			  struct net *net, const struct nlattr *attr)
 {
-	int ret = 0;
+	int ret = -EOPNOTSUPP;
 
 	if (likely(l4proto->ctnl_timeout.nlattr_to_obj)) {
 		struct nlattr *tb[l4proto->ctnl_timeout.nlattr_max+1];
-- 
1.9.1





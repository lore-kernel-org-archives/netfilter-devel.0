From: gfree.wind@foxmail.com
Subject: [PATCH nf-next 1/1] netfilter: cttimeout: Refine cttimeout_del_timeout
Date: Fri,  7 Apr 2017 19:25:36 +0800
Message-ID: <1491564336-44483-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgau2.qq.com ([54.206.34.216]:44615 "EHLO smtpbgau2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753883AbdDGLZy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2017 07:25:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

1. Return one error when try to delete all timeouts and meet one erorr;
2. Delete the condition block when fail to delete specified timeout.
It is more clear that it would stop the loop when find one matched timeout.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nfnetlink_cttimeout.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index baa75f3..220847a 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -361,11 +361,17 @@ static int cttimeout_del_timeout(struct net *net, struct sock *ctnl,
 	char *name;
 
 	if (!cda[CTA_TIMEOUT_NAME]) {
+		int cur_ret;
+
+		ret = 0;
 		list_for_each_entry_safe(cur, tmp, &net->nfct_timeout_list,
-					 head)
-			ctnl_timeout_try_del(net, cur);
+					 head) {
+			cur_ret = ctnl_timeout_try_del(net, cur);
+			if (cur_ret && !ret)
+				ret = cur_ret;
+		}
 
-		return 0;
+		return ret;
 	}
 	name = nla_data(cda[CTA_TIMEOUT_NAME]);
 
@@ -374,9 +380,6 @@ static int cttimeout_del_timeout(struct net *net, struct sock *ctnl,
 			continue;
 
 		ret = ctnl_timeout_try_del(net, cur);
-		if (ret < 0)
-			return ret;
-
 		break;
 	}
 	return ret;
-- 
1.9.1





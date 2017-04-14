From: gfree.wind@foxmail.com
Subject: [PATCH nf v3] netfilter: xt_CT: fix refcnt leak on error path
Date: Fri, 14 Apr 2017 10:00:08 +0800
Message-ID: <1492135208-52964-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbguseast2.qq.com ([54.204.34.130]:59520 "EHLO
        smtpbguseast2.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbdDNCA2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 22:00:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

There are two cases which causes refcnt leak.

1. When nf_ct_timeout_ext_add failed in xt_ct_set_timeout, it should
free the timeout refcnt.
Now goto the err_put_timeout error handler instead of going ahead.

2. When the time policy is not found, we should call module_put.
Otherwise, the related cthelper module cannot be removed anymore.
It is easy to reproduce by typing the following command:
  # iptables -t raw -A OUTPUT -p tcp -j CT --helper ftp --timeout xxx

Signed-off-by: Gao Feng <fgao@ikuai8.com>
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 v3: Merge the patch of Liping together
 v2: enhance the patch
 v1: initial version

 net/netfilter/xt_CT.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index b008db0..81fdcdc 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -167,8 +167,10 @@ static void __xt_ct_tg_timeout_put(struct ctnl_timeout *timeout)
 		goto err_put_timeout;
 	}
 	timeout_ext = nf_ct_timeout_ext_add(ct, timeout, GFP_ATOMIC);
-	if (timeout_ext == NULL)
+	if (!timeout_ext) {
 		ret = -ENOMEM;
+		goto err_put_timeout;
+	}
 
 	rcu_read_unlock();
 	return ret;
@@ -200,6 +202,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 			  struct xt_ct_target_info_v1 *info)
 {
 	struct nf_conntrack_zone zone;
+	struct nf_conn_help *help;
 	struct nf_conn *ct;
 	int ret = -EOPNOTSUPP;
 
@@ -248,7 +251,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 	if (info->timeout[0]) {
 		ret = xt_ct_set_timeout(ct, par, info->timeout);
 		if (ret < 0)
-			goto err3;
+			goto err4;
 	}
 	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
 	nf_conntrack_get(&ct->ct_general);
@@ -256,6 +259,10 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 	info->ct = ct;
 	return 0;
 
+err4:
+	help = nfct_help(ct);
+	if (help)
+		module_put(help->helper->me);
 err3:
 	nf_ct_tmpl_free(ct);
 err2:
-- 
1.9.1





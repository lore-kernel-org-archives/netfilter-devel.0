From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: xt_CT: fix cthelper module's refcnt leak
Date: Sat,  8 Apr 2017 11:38:48 +0800
Message-ID: <1491622728-55625-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:39514 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751011AbdDHDja (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2017 23:39:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

We should call module_put when the time policy is not found. Otherwise,
the related cthelper module cannot be removed anymore.

It is easy to reproduce by typing the following command:
  # iptables -t raw -A OUTPUT -p tcp -j CT --helper ftp --timeout xxx

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/xt_CT.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index b008db0..841cfba 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -200,6 +200,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 			  struct xt_ct_target_info_v1 *info)
 {
 	struct nf_conntrack_zone zone;
+	struct nf_conn_help *help;
 	struct nf_conn *ct;
 	int ret = -EOPNOTSUPP;
 
@@ -248,7 +249,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 	if (info->timeout[0]) {
 		ret = xt_ct_set_timeout(ct, par, info->timeout);
 		if (ret < 0)
-			goto err3;
+			goto err4;
 	}
 	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
 	nf_conntrack_get(&ct->ct_general);
@@ -256,6 +257,10 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
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
2.5.5



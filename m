From: fgao@ikuai8.com
Subject: [PATCH nf-next 1/1] netfilter: expect: Make return value of nf_ct_expect_insert is void
Date: Thu,  9 Feb 2017 21:40:38 +0800
Message-ID: <1486647638-22781-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg328.qq.com ([14.17.43.160]:42654 "EHLO smtpbg328.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752375AbdBINsV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Feb 2017 08:48:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

Because nf_ct_expect_insert always succeeds now, so make its return
value is void instead of int. And remove codes used to check its
return value.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_conntrack_expect.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index f8dbacf..e19a697 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -353,7 +353,7 @@ void nf_ct_expect_put(struct nf_conntrack_expect *exp)
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_put);
 
-static int nf_ct_expect_insert(struct nf_conntrack_expect *exp)
+static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 {
 	struct nf_conn_help *master_help = nfct_help(exp->master);
 	struct nf_conntrack_helper *helper;
@@ -380,7 +380,6 @@ static int nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 	add_timer(&exp->timeout);
 
 	NF_CT_STAT_INC(net, expect_create);
-	return 0;
 }
 
 /* Race with expectations being used means we could have none to find; OK. */
@@ -464,9 +463,8 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 	if (ret <= 0)
 		goto out;
 
-	ret = nf_ct_expect_insert(expect);
-	if (ret < 0)
-		goto out;
+	nf_ct_expect_insert(expect);
+
 	spin_unlock_bh(&nf_conntrack_expect_lock);
 	nf_ct_expect_event_report(IPEXP_NEW, expect, portid, report);
 	return ret;
-- 
1.9.1



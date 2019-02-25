Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C011C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 03:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03A0220989
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 03:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbfBYDc4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Feb 2019 22:32:56 -0500
Received: from mx132-tc.baidu.com ([61.135.168.132]:29820 "EHLO
        tc-sys-mailedm02.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728166AbfBYDc4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Feb 2019 22:32:56 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm02.tc.baidu.com (Postfix) with ESMTP id E48A611C0049
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Feb 2019 11:32:42 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH][nf-next] netfilter: Use RCU primitives under RCU protected data
Date:   Mon, 25 Feb 2019 11:32:42 +0800
Message-Id: <1551065562-26220-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This pointer is RCU protected, so proper primitives should be used.

Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/netfilter/xt_CT.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 0fa863f57575..26dee8bba326 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -99,7 +99,7 @@ xt_ct_set_helper(struct nf_conn *ct, const char *helper_name,
 		return -ENOMEM;
 	}
 
-	help->helper = helper;
+	RCU_INIT_POINTER(help->helper, helper);
 	return 0;
 }
 
@@ -274,7 +274,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 err4:
 	help = nfct_help(ct);
 	if (help)
-		nf_conntrack_helper_put(help->helper);
+		nf_conntrack_helper_put(rcu_dereference(help->helper));
 err3:
 	nf_ct_tmpl_free(ct);
 err2:
@@ -357,7 +357,7 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
 	if (ct) {
 		help = nfct_help(ct);
 		if (help)
-			nf_conntrack_helper_put(help->helper);
+			nf_conntrack_helper_put(rcu_dereference(help->helper));
 
 		nf_ct_netns_put(par->net, par->family);
 
-- 
2.16.2


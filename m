From: Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH nf-next] netfilter: physdev: add missed blank
Date: Mon, 25 Jul 2016 15:24:43 +0800
Message-ID: <1469431483-28480-1-git-send-email-liuhangbin@gmail.com>
Cc: Hangbin Liu <liuhangbin@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33527 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbcGYHZJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jul 2016 03:25:09 -0400
Received: by mail-pa0-f65.google.com with SMTP id q2so10974407pap.0
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jul 2016 00:25:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/netfilter/xt_physdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index e5f1898..bb33598 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -107,8 +107,8 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
 	    par->hook_mask & ((1 << NF_INET_LOCAL_OUT) |
 	    (1 << NF_INET_FORWARD) | (1 << NF_INET_POST_ROUTING))) {
-		pr_info("using --physdev-out and --physdev-is-out are only"
-			"supported in the FORWARD and POSTROUTING chains with"
+		pr_info("using --physdev-out and --physdev-is-out are only "
+			"supported in the FORWARD and POSTROUTING chains with "
 			"bridged traffic.\n");
 		if (par->hook_mask & (1 << NF_INET_LOCAL_OUT))
 			return -EINVAL;
-- 
2.5.5


From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH] netfilter: IDLETIMER: fix race condition when destroy the target
Date: Thu, 21 Apr 2016 00:47:08 -0700
Message-ID: <1461224828-3274-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m50-138.163.com ([123.125.50.138]:45541 "EHLO m50-138.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbcDUHsQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Apr 2016 03:48:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Workqueue maybe still in running while we destroy the IDLETIMER target,
thus cause a use after free error, add cancel_work_sync() to avoid such
situation.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/xt_IDLETIMER.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 29d2c31..daf45da 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -236,6 +236,7 @@ static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
 
 		list_del(&info->timer->entry);
 		del_timer_sync(&info->timer->timer);
+		cancel_work_sync(&info->timer->work);
 		sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
 		kfree(info->timer->attr.attr.name);
 		kfree(info->timer);
-- 
1.7.9.5



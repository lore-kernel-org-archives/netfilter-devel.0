From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 060/103] netfilter: xt_quota: fix wrong return value (error case)
Date: Tue,  4 Aug 2009 09:25:44 +0200
Message-ID: <1249370787-17583-61-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56942 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584AbZHDH1h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:37 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Success was indicated on a memory allocation failure, thereby causing
a crash due to a later NULL deref.
(Affects v2.6.30-rc1 up to here.)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_quota.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index ad0ed79..0de9fcf 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -52,7 +52,7 @@ static bool quota_mt_check(const struct xt_mtchk_param *par)
 
 	q->master = kmalloc(sizeof(*q->master), GFP_KERNEL);
 	if (q->master == NULL)
-		return -ENOMEM;
+		return false;
 
 	q->master->quota = q->quota;
 	return true;
-- 
1.6.3.3


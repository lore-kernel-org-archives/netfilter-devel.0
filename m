From: gfree.wind@foxmail.com
Subject: [PATCH nf-next 1/1] netfilter: ecache: Refine the nf_ct_deliver_cached_events
Date: Thu, 13 Apr 2017 09:35:49 +0800
Message-ID: <1492047349-99130-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpproxy19.qq.com ([184.105.206.84]:49079 "EHLO
        smtpproxy19.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752134AbdDMBgA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Apr 2017 21:36:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

1. Remove single !events condition check to deliver the missed event
even though there is no new event happened.

Consider this case:
1) nf_ct_deliver_cached_events is invoked at the first time, the
event is failed to deliver, then the missed is set.
2) nf_ct_deliver_cached_events is invoked again, but there is no
any new event happened.
The missed event is lost really.

It would try to send the missed event again after remove this check.
And it is ok if there is no missed event because the latter check
!((events | missed) & e->ctmask) could avoid it.

2. Correct the return value check of notify->fcn.
When send the event successfully, it returns 0, not postive value.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_conntrack_ecache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index da9df2d..1e4e257 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -195,7 +195,7 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct)
 
 	events = xchg(&e->cache, 0);
 
-	if (!nf_ct_is_confirmed(ct) || nf_ct_is_dying(ct) || !events)
+	if (!nf_ct_is_confirmed(ct) || nf_ct_is_dying(ct))
 		goto out_unlock;
 
 	/* We make a copy of the missed event cache without taking
@@ -212,7 +212,7 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct)
 
 	ret = notify->fcn(events | missed, &item);
 
-	if (likely(ret >= 0 && !missed))
+	if (likely(ret == 0 && !missed))
 		goto out_unlock;
 
 	spin_lock_bh(&ct->lock);
-- 
1.9.1





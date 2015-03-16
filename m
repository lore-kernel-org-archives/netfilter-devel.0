From: Sergey Popovich <popovich_sergei@mail.ua>
Subject: netfilter: ipset: Remove expired entries on set resize
Date: Mon, 16 Mar 2015 15:40:16 +0200
Message-ID: <c13847241dde9420eac06157657997b8c2d6a21b.1426509747.git.popovich_sergei@mail.ua>
References: <cover.1426509747.git.popovich_sergei@mail.ua>
To: netfilter-devel@vger.kernel.org, popovich_sergei@mail.ru
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fallback6.mail.ru ([94.100.181.147]:42824 "EHLO
	fallback6.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbbCPOGm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 10:06:42 -0400
Received: from smtp32.i.mail.ru (smtp32.i.mail.ru [94.100.177.92])
	by fallback6.mail.ru (mPOP.Fallback_MX) with ESMTP id 521D41AAB42
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2015 16:40:23 +0300 (MSK)
In-Reply-To: <cover.1426509747.git.popovich_sergei@mail.ua>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If set resize requested try to remove expired entries on
timeout enabled set first and retry adding element.
Try this only once, of adding element fails again perform
actual set resize.

Fix expected behaviour by setting retried variable after
resize routine is called, as setting this to true before
calling resize will always ignore attempt to remove
expired entries from the set.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
---
 net/netfilter/ipset/ip_set_core.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index fb1f2b4..96e4f2f 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1410,10 +1410,16 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 		write_lock_bh(&set->lock);
 		ret = set->variant->uadt(set, tb, adt, &lineno, flags, retried);
 		write_unlock_bh(&set->lock);
+
+		if (ret != -EAGAIN || !set->variant->resize)
+			break;
+
+		ret = set->variant->resize(set, retried);
+		if (ret)
+			break;
+
 		retried = true;
-	} while (ret == -EAGAIN &&
-		 set->variant->resize &&
-		 (ret = set->variant->resize(set, retried)) == 0);
+	} while (1);
 
 	if (!ret || (ret == -IPSET_ERR_EXIST && eexist))
 		return 0;
-- 
1.7.10.4


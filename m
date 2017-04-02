From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: make it safer during the inet6_dev->addr_list traversal
Date: Sun,  2 Apr 2017 17:27:53 +0800
Message-ID: <1491125273-8002-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:33976 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750984AbdDBJ2Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Apr 2017 05:28:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

inet6_dev->addr_list is protected by inet6_dev->lock, so only using
rcu_read_lock is not enough, we should acquire read_lock_bh(&idev->lock)
before the inet6_dev->addr_list traversal.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_nat_redirect.c | 2 ++
 net/netfilter/xt_TPROXY.c       | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_redirect.c b/net/netfilter/nf_nat_redirect.c
index d438698..86067560 100644
--- a/net/netfilter/nf_nat_redirect.c
+++ b/net/netfilter/nf_nat_redirect.c
@@ -101,11 +101,13 @@ nf_nat_redirect_ipv6(struct sk_buff *skb, const struct nf_nat_range *range,
 		rcu_read_lock();
 		idev = __in6_dev_get(skb->dev);
 		if (idev != NULL) {
+			read_lock_bh(&idev->lock);
 			list_for_each_entry(ifa, &idev->addr_list, if_list) {
 				newdst = ifa->addr;
 				addr = true;
 				break;
 			}
+			read_unlock_bh(&idev->lock);
 		}
 		rcu_read_unlock();
 
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 80cb7ba..df7f1df 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -393,7 +393,8 @@ tproxy_laddr6(struct sk_buff *skb, const struct in6_addr *user_laddr,
 
 	rcu_read_lock();
 	indev = __in6_dev_get(skb->dev);
-	if (indev)
+	if (indev) {
+		read_lock_bh(&indev->lock);
 		list_for_each_entry(ifa, &indev->addr_list, if_list) {
 			if (ifa->flags & (IFA_F_TENTATIVE | IFA_F_DEPRECATED))
 				continue;
@@ -401,6 +402,8 @@ tproxy_laddr6(struct sk_buff *skb, const struct in6_addr *user_laddr,
 			laddr = &ifa->addr;
 			break;
 		}
+		read_unlock_bh(&indev->lock);
+	}
 	rcu_read_unlock();
 
 	return laddr ? laddr : daddr;
-- 
2.5.5



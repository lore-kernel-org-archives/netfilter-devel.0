From: pablo@netfilter.org
Subject: netfilter: ctnetlink: remove incorrect spin_[un]lock_bh  on NAT module autoload
Date: Sat,  3 Mar 2012 10:17:18 +0100
Message-ID: <1330766238-2512-1-git-send-email-pablo@netfilter.org>
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39637 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab2CCJRa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Mar 2012 04:17:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Since 7d367e0, ctnetlink_new_conntrack is called without holding
the nf_conntrack_lock spinlock. Thus, ctnetlink_parse_nat_setup
does not require to release that spinlock anymore in the NAT module
autoload case.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 30c9d4c..1068769 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1041,16 +1041,13 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 	if (!parse_nat_setup) {
 #ifdef CONFIG_MODULES
 		rcu_read_unlock();
-		spin_unlock_bh(&nf_conntrack_lock);
 		nfnl_unlock();
 		if (request_module("nf-nat-ipv4") < 0) {
 			nfnl_lock();
-			spin_lock_bh(&nf_conntrack_lock);
 			rcu_read_lock();
 			return -EOPNOTSUPP;
 		}
 		nfnl_lock();
-		spin_lock_bh(&nf_conntrack_lock);
 		rcu_read_lock();
 		if (nfnetlink_parse_nat_setup_hook)
 			return -EAGAIN;
-- 
1.7.7.3


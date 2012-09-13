From: pablo@netfilter.org
Subject: [PATCH 5/5] netfilter: ctnetlink: fix module auto-load in ctnetlink_parse_nat
Date: Thu, 13 Sep 2012 13:01:32 +0200
Message-ID: <1347534092-3579-6-git-send-email-pablo@netfilter.org>
References: <1347534092-3579-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46305 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab2IMLDA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Sep 2012 07:03:00 -0400
In-Reply-To: <1347534092-3579-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

(c7232c9 netfilter: add protocol independent NAT core) added
incorrect locking for the module auto-load case in ctnetlink_parse_nat.

That function is always called from ctnetlink_create_conntrack which
requires no locking.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a205bd6..090d267 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1120,16 +1120,13 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 	if (err == -EAGAIN) {
 #ifdef CONFIG_MODULES
 		rcu_read_unlock();
-		spin_unlock_bh(&nf_conntrack_lock);
 		nfnl_unlock();
 		if (request_module("nf-nat-%u", nf_ct_l3num(ct)) < 0) {
 			nfnl_lock();
-			spin_lock_bh(&nf_conntrack_lock);
 			rcu_read_lock();
 			return -EOPNOTSUPP;
 		}
 		nfnl_lock();
-		spin_lock_bh(&nf_conntrack_lock);
 		rcu_read_lock();
 #else
 		err = -EOPNOTSUPP;
-- 
1.7.10.4


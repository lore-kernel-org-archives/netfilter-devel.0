From: pablo@netfilter.org
Subject: [PATCH] netfilter: ctnetlink: fix module auto-load in ctnetlink_create_conntrack
Date: Tue, 11 Sep 2012 17:52:15 +0200
Message-ID: <1347378735-22625-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47396 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758764Ab2IKTBE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Sep 2012 15:01:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

(c7232c9 netfilter: add protocol independent NAT core) added
incorrect locking for the module auto-load case in ctnetlink_parse_nat.

That function is always called from ctnetlink_create_conntrack which
requires no locking.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a205bd6..257da50 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1120,7 +1120,6 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 	if (err == -EAGAIN) {
 #ifdef CONFIG_MODULES
 		rcu_read_unlock();
-		spin_unlock_bh(&nf_conntrack_lock);
 		nfnl_unlock();
 		if (request_module("nf-nat-%u", nf_ct_l3num(ct)) < 0) {
 			nfnl_lock();
@@ -1129,7 +1128,6 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 			return -EOPNOTSUPP;
 		}
 		nfnl_lock();
-		spin_lock_bh(&nf_conntrack_lock);
 		rcu_read_lock();
 #else
 		err = -EOPNOTSUPP;
-- 
1.7.10.4


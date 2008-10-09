From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] [PATCH] use nf_conntrack_get instead of atomic_inc
Date: Thu, 09 Oct 2008 10:37:56 +0200
Message-ID: <20081009083756.10285.44065.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59418 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752501AbYJIIki (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 04:40:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use nf_conntrack_get instead of the direct call to atomic_inc.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index bce9e5d..3643a70 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1382,7 +1382,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 				goto out_unlock;
 			}
 			master_ct = nf_ct_tuplehash_to_ctrack(master_h);
-			atomic_inc(&master_ct->ct_general.use);
+			nf_conntrack_get(&master_ct->ct_general);
 		}
 
 		spin_unlock_bh(&nf_conntrack_lock);


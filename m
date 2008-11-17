From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/8] [PATCH] use nf_conntrack_get instead of atomic_inc
Date: Mon, 17 Nov 2008 09:39:24 +0100
Message-ID: <20081117083924.11368.38741.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55713 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752554AbYKQIjg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:39:36 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use nf_conntrack_get instead of the direct call to atomic_inc.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a040d46..80a3f13 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1209,7 +1209,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 				goto out_unlock;
 			}
 			master_ct = nf_ct_tuplehash_to_ctrack(master_h);
-			atomic_inc(&master_ct->ct_general.use);
+			nf_conntrack_get(&master_ct->ct_general);
 		}
 
 		spin_unlock_bh(&nf_conntrack_lock);


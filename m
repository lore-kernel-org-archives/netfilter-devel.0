From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 3/4] netfilter: ipset: Validate the set family and not the set type family at swapping
Date: Mon, 16 Sep 2013 20:47:58 +0200
Message-ID: <1379357279-13361-4-git-send-email-kadlec@blackhole.kfki.hu>
References: <1379357279-13361-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:56913 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab3IPSsA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:48:00 -0400
In-Reply-To: <1379357279-13361-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This closes netfilter bugzilla #843, reported by Quentin Armitage.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index c8c303c..f2e30fb 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1052,7 +1052,7 @@ ip_set_swap(struct sock *ctnl, struct sk_buff *skb,
 	 * Not an artificial restriction anymore, as we must prevent
 	 * possible loops created by swapping in setlist type of sets. */
 	if (!(from->type->features == to->type->features &&
-	      from->type->family == to->type->family))
+	      from->family == to->family))
 		return -IPSET_ERR_TYPE_MISMATCH;
 
 	strncpy(from_name, from->name, IPSET_MAXNAMELEN);
-- 
1.7.0.4


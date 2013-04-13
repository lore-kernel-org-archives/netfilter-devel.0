From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/1] netfilter: ipset: bitmap:ip,mac: fix listing with timeout
Date: Sat, 13 Apr 2013 14:51:14 +0200
Message-ID: <1365857474-4943-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1365857474-4943-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Yoann JUET <yoann.juet@univ-nantes.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:36844 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072Ab3DMMvP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Apr 2013 08:51:15 -0400
In-Reply-To: <1365857474-4943-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The type when timeout support was enabled, could not list all elements,
just the first ones which could fit into one netlink message: it just
did not continue listing after the first message.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_bitmap_ipmac.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 0f92dc2..d7df6ac 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -339,7 +339,11 @@ bitmap_ipmac_tlist(const struct ip_set *set,
 nla_put_failure:
 	nla_nest_cancel(skb, nested);
 	ipset_nest_end(skb, atd);
-	return -EMSGSIZE;
+	if (unlikely(id == first)) {
+		cb->args[2] = 0;
+		return -EMSGSIZE;
+	}
+	return 0;
 }
 
 static int
-- 
1.7.0.4


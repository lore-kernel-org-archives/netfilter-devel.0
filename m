From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/6] netfilter: ipset: Sparse warning about shadowed variable fixed
Date: Thu,  2 May 2013 11:37:18 +0200
Message-ID: <1367487442-3571-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1367487442-3571-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:39789 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756939Ab3EBJhY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 May 2013 05:37:24 -0400
In-Reply-To: <1367487442-3571-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

net/netfilter/ipset/ip_set_hash_ipportnet.c:275:20:
warning: symbol 'cidr' shadows an earlier one

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_ipportnet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index c6a5253..fd193d6 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -272,7 +272,7 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (ip > ip_to)
 			swap(ip, ip_to);
 	} else if (tb[IPSET_ATTR_CIDR]) {
-		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+		cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
 		if (!cidr || cidr > 32)
 			return -IPSET_ERR_INVALID_CIDR;
-- 
1.7.0.4


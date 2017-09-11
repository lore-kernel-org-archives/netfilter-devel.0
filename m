From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/4] netfilter: ipset: Fix sparse warnings
Date: Mon, 11 Sep 2017 21:52:38 +0200
Message-ID: <1505159560-13161-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1505159560-13161-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:34436 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751618AbdIKTwn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Sep 2017 15:52:43 -0400
In-Reply-To: <1505159560-13161-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_ipportnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 5ab1b99..24bf558 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -434,7 +434,7 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (unlikely(tb[IPSET_ATTR_IP_TO]))
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
 	if (unlikely(tb[IPSET_ATTR_CIDR])) {
-		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+		cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
 		if (cidr != HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
-- 
2.1.4


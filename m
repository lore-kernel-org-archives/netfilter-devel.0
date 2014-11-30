From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 14/14] netfilter: ipset: Fix sparse warning
Date: Sun, 30 Nov 2014 19:57:05 +0100
Message-ID: <1417373825-3734-15-git-send-email-kadlec@blackhole.kfki.hu>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:57607 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbaK3S4R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Nov 2014 13:56:17 -0500
In-Reply-To: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"warning: cast to restricted __be32" warnings are fixed

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_ipmark.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 7abf978..2ec4ac5 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -128,7 +128,7 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 
-	e.mark = ntohl(nla_get_u32(tb[IPSET_ATTR_MARK]));
+	e.mark = ntohl(nla_get_be32(tb[IPSET_ATTR_MARK]));
 	e.mark &= h->markmask;
 
 	if (adt == IPSET_TEST ||
@@ -263,7 +263,7 @@ hash_ipmark6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 
-	e.mark = ntohl(nla_get_u32(tb[IPSET_ATTR_MARK]));
+	e.mark = ntohl(nla_get_be32(tb[IPSET_ATTR_MARK]));
 	e.mark &= h->markmask;
 
 	if (adt == IPSET_TEST) {
-- 
1.8.5.1


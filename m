From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 8/8] netfilter: ipset: Fix sparse warning
Date: Fri, 12 Dec 2014 22:58:09 +0100
Message-ID: <1418421489-17411-9-git-send-email-kadlec@blackhole.kfki.hu>
References: <1418421489-17411-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:40179 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbaLLV5J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Dec 2014 16:57:09 -0500
In-Reply-To: <1418421489-17411-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"warning: cast to restricted __be32" warnings are fixed

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_ipmark.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 6882a08..71468d5 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -128,7 +128,7 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 
-	e.mark = ntohl(nla_get_u32(tb[IPSET_ATTR_MARK]));
+	e.mark = ntohl(nla_get_be32(tb[IPSET_ATTR_MARK]));
 	e.mark &= h->markmask;
 
 	if (adt == IPSET_TEST ||
@@ -262,7 +262,7 @@ hash_ipmark6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 
-	e.mark = ntohl(nla_get_u32(tb[IPSET_ATTR_MARK]));
+	e.mark = ntohl(nla_get_be32(tb[IPSET_ATTR_MARK]));
 	e.mark &= h->markmask;
 
 	if (adt == IPSET_TEST) {
-- 
1.8.5.1


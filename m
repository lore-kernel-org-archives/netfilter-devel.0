From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 08/22] netfilter: ipset: Regroup ip_set_put_extensions and add extern
Date: Thu, 10 Nov 2016 13:57:42 +0100
Message-ID: <1478782676-9770-9-git-send-email-kadlec@blackhole.kfki.hu>
References: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:48989 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932976AbcKJM6F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2016 07:58:05 -0500
In-Reply-To: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cleanup: group ip_set_put_extensions and ip_set_get_extensions
together and add missing extern.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index b5bd0fb3..7a218eb 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -331,6 +331,8 @@ extern size_t ip_set_elem_len(struct ip_set *set, struct nlattr *tb[],
 			      size_t len, size_t align);
 extern int ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
 				 struct ip_set_ext *ext);
+extern int ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
+				 const void *e, bool active);
 
 static inline int
 ip_set_get_hostipaddr4(struct nlattr *nla, u32 *ipaddr)
@@ -449,10 +451,6 @@ static inline int nla_put_ipaddr6(struct sk_buff *skb, int type,
 #include <linux/netfilter/ipset/ip_set_counter.h>
 #include <linux/netfilter/ipset/ip_set_skbinfo.h>
 
-int
-ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
-		      const void *e, bool active);
-
 #define IP_SET_INIT_KEXT(skb, opt, set)			\
 	{ .bytes = (skb)->len, .packets = 1,		\
 	  .timeout = ip_set_adt_opt_timeout(opt, set) }
-- 
1.8.5.1


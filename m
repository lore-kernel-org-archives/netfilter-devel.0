From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 01/22] netfilter: ipset: Remove extra whitespaces in ip_set.h
Date: Thu, 10 Nov 2016 13:57:35 +0100
Message-ID: <1478782676-9770-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:48958 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932961AbcKJM6B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2016 07:58:01 -0500
In-Reply-To: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove unnecessary whitespaces.

Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.

Suggested-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 83b9a2e..5b1fd09 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -336,14 +336,15 @@ struct ip_set {
 
 static inline void
 ip_set_get_skbinfo(struct ip_set_skbinfo *skbinfo,
-		      const struct ip_set_ext *ext,
-		      struct ip_set_ext *mext, u32 flags)
+		   const struct ip_set_ext *ext,
+		   struct ip_set_ext *mext, u32 flags)
 {
-		mext->skbmark = skbinfo->skbmark;
-		mext->skbmarkmask = skbinfo->skbmarkmask;
-		mext->skbprio = skbinfo->skbprio;
-		mext->skbqueue = skbinfo->skbqueue;
+	mext->skbmark = skbinfo->skbmark;
+	mext->skbmarkmask = skbinfo->skbmarkmask;
+	mext->skbprio = skbinfo->skbprio;
+	mext->skbqueue = skbinfo->skbqueue;
 }
+
 static inline bool
 ip_set_put_skbinfo(struct sk_buff *skb, struct ip_set_skbinfo *skbinfo)
 {
-- 
1.8.5.1


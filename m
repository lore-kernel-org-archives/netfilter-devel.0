From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 02/22] netfilter: ipset: Mark some helper args as const.
Date: Thu, 10 Nov 2016 13:57:36 +0100
Message-ID: <1478782676-9770-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:48960 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932976AbcKJM6C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2016 07:58:02 -0500
In-Reply-To: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Mark some of the helpers arguments as const.

Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.

Suggested-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h         | 4 ++--
 include/linux/netfilter/ipset/ip_set_comment.h | 2 +-
 include/linux/netfilter/ipset/ip_set_timeout.h | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 5b1fd09..524467f 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -346,7 +346,7 @@ struct ip_set {
 }
 
 static inline bool
-ip_set_put_skbinfo(struct sk_buff *skb, struct ip_set_skbinfo *skbinfo)
+ip_set_put_skbinfo(struct sk_buff *skb, const struct ip_set_skbinfo *skbinfo)
 {
 	/* Send nonzero parameters only */
 	return ((skbinfo->skbmark || skbinfo->skbmarkmask) &&
@@ -373,7 +373,7 @@ struct ip_set {
 }
 
 static inline bool
-ip_set_put_counter(struct sk_buff *skb, struct ip_set_counter *counter)
+ip_set_put_counter(struct sk_buff *skb, const struct ip_set_counter *counter)
 {
 	return nla_put_net64(skb, IPSET_ATTR_BYTES,
 			     cpu_to_be64(ip_set_get_bytes(counter)),
diff --git a/include/linux/netfilter/ipset/ip_set_comment.h b/include/linux/netfilter/ipset/ip_set_comment.h
index 8d02485..bae5c76 100644
--- a/include/linux/netfilter/ipset/ip_set_comment.h
+++ b/include/linux/netfilter/ipset/ip_set_comment.h
@@ -43,7 +43,7 @@
 
 /* Used only when dumping a set, protected by rcu_read_lock_bh() */
 static inline int
-ip_set_put_comment(struct sk_buff *skb, struct ip_set_comment *comment)
+ip_set_put_comment(struct sk_buff *skb, const struct ip_set_comment *comment)
 {
 	struct ip_set_comment_rcu *c = rcu_dereference_bh(comment->c);
 
diff --git a/include/linux/netfilter/ipset/ip_set_timeout.h b/include/linux/netfilter/ipset/ip_set_timeout.h
index 1d6a935..bfb3531 100644
--- a/include/linux/netfilter/ipset/ip_set_timeout.h
+++ b/include/linux/netfilter/ipset/ip_set_timeout.h
@@ -40,7 +40,7 @@
 }
 
 static inline bool
-ip_set_timeout_expired(unsigned long *t)
+ip_set_timeout_expired(const unsigned long *t)
 {
 	return *t != IPSET_ELEM_PERMANENT && time_is_before_jiffies(*t);
 }
@@ -63,7 +63,7 @@
 }
 
 static inline u32
-ip_set_timeout_get(unsigned long *timeout)
+ip_set_timeout_get(const unsigned long *timeout)
 {
 	return *timeout == IPSET_ELEM_PERMANENT ? 0 :
 		jiffies_to_msecs(*timeout - jiffies)/MSEC_PER_SEC;
-- 
1.8.5.1


From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 02/22] netfilter: ipset: Headers file cleanup
Date: Sun, 23 Oct 2016 22:37:35 +0200
Message-ID: <1477255075-15255-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:50853 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756734AbcJWUiC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Oct 2016 16:38:02 -0400
In-Reply-To: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove extra whitespace, group counter helper together. Mark some of
the helpers arguments as const.

Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.

Suggested-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h         | 57 +++++++++++++-------------
 include/linux/netfilter/ipset/ip_set_comment.h |  2 +-
 include/linux/netfilter/ipset/ip_set_timeout.h |  4 +-
 3 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 83b9a2e..1ea28e3 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -334,18 +334,40 @@ struct ip_set {
 	}
 }
 
+static inline bool
+ip_set_put_counter(struct sk_buff *skb, const struct ip_set_counter *counter)
+{
+	return nla_put_net64(skb, IPSET_ATTR_BYTES,
+			     cpu_to_be64(ip_set_get_bytes(counter)),
+			     IPSET_ATTR_PAD) ||
+	       nla_put_net64(skb, IPSET_ATTR_PACKETS,
+			     cpu_to_be64(ip_set_get_packets(counter)),
+			     IPSET_ATTR_PAD);
+}
+
+static inline void
+ip_set_init_counter(struct ip_set_counter *counter,
+		    const struct ip_set_ext *ext)
+{
+	if (ext->bytes != ULLONG_MAX)
+		atomic64_set(&(counter)->bytes, (long long)(ext->bytes));
+	if (ext->packets != ULLONG_MAX)
+		atomic64_set(&(counter)->packets, (long long)(ext->packets));
+}
+
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
-ip_set_put_skbinfo(struct sk_buff *skb, struct ip_set_skbinfo *skbinfo)
+ip_set_put_skbinfo(struct sk_buff *skb, const struct ip_set_skbinfo *skbinfo)
 {
 	/* Send nonzero parameters only */
 	return ((skbinfo->skbmark || skbinfo->skbmarkmask) &&
@@ -371,27 +393,6 @@ struct ip_set {
 	skbinfo->skbqueue = ext->skbqueue;
 }
 
-static inline bool
-ip_set_put_counter(struct sk_buff *skb, struct ip_set_counter *counter)
-{
-	return nla_put_net64(skb, IPSET_ATTR_BYTES,
-			     cpu_to_be64(ip_set_get_bytes(counter)),
-			     IPSET_ATTR_PAD) ||
-	       nla_put_net64(skb, IPSET_ATTR_PACKETS,
-			     cpu_to_be64(ip_set_get_packets(counter)),
-			     IPSET_ATTR_PAD);
-}
-
-static inline void
-ip_set_init_counter(struct ip_set_counter *counter,
-		    const struct ip_set_ext *ext)
-{
-	if (ext->bytes != ULLONG_MAX)
-		atomic64_set(&(counter)->bytes, (long long)(ext->bytes));
-	if (ext->packets != ULLONG_MAX)
-		atomic64_set(&(counter)->packets, (long long)(ext->packets));
-}
-
 /* Netlink CB args */
 enum {
 	IPSET_CB_NET = 0,	/* net namespace */
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


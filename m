From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 32/34] netfilter: ipset: RCU safe comment extension handling
Date: Sat,  2 May 2015 19:28:21 +0200
Message-ID: <1430587703-3387-33-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:51408 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbbEBR2L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:11 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Complete the transition to RCU with RCU safe comment extension handling.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h         |  7 ++++-
 include/linux/netfilter/ipset/ip_set_comment.h | 38 ++++++++++++++++++--------
 net/netfilter/ipset/ip_set_bitmap_gen.h        | 19 +++++++++----
 net/netfilter/ipset/ip_set_list_set.c          | 17 ++++++++----
 4 files changed, 57 insertions(+), 24 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index d7215d5..344616d 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -108,8 +108,13 @@ struct ip_set_counter {
 	atomic64_t packets;
 };
 
+struct ip_set_comment_rcu {
+	struct rcu_head rcu;
+	char str[0];
+};
+
 struct ip_set_comment {
-	char *str;
+	struct ip_set_comment_rcu __rcu *c;
 };
 
 struct ip_set_skbinfo {
diff --git a/include/linux/netfilter/ipset/ip_set_comment.h b/include/linux/netfilter/ipset/ip_set_comment.h
index 21217ea..8d02485 100644
--- a/include/linux/netfilter/ipset/ip_set_comment.h
+++ b/include/linux/netfilter/ipset/ip_set_comment.h
@@ -16,41 +16,57 @@ ip_set_comment_uget(struct nlattr *tb)
 	return nla_data(tb);
 }
 
+/* Called from uadd only, protected by the set spinlock.
+ * The kadt functions don't use the comment extensions in any way.
+ */
 static inline void
 ip_set_init_comment(struct ip_set_comment *comment,
 		    const struct ip_set_ext *ext)
 {
+	struct ip_set_comment_rcu *c = rcu_dereference_protected(comment->c, 1);
 	size_t len = ext->comment ? strlen(ext->comment) : 0;
 
-	if (unlikely(comment->str)) {
-		kfree(comment->str);
-		comment->str = NULL;
+	if (unlikely(c)) {
+		kfree_rcu(c, rcu);
+		rcu_assign_pointer(comment->c, NULL);
 	}
 	if (!len)
 		return;
 	if (unlikely(len > IPSET_MAX_COMMENT_SIZE))
 		len = IPSET_MAX_COMMENT_SIZE;
-	comment->str = kzalloc(len + 1, GFP_ATOMIC);
-	if (unlikely(!comment->str))
+	c = kzalloc(sizeof(*c) + len + 1, GFP_ATOMIC);
+	if (unlikely(!c))
 		return;
-	strlcpy(comment->str, ext->comment, len + 1);
+	strlcpy(c->str, ext->comment, len + 1);
+	rcu_assign_pointer(comment->c, c);
 }
 
+/* Used only when dumping a set, protected by rcu_read_lock_bh() */
 static inline int
 ip_set_put_comment(struct sk_buff *skb, struct ip_set_comment *comment)
 {
-	if (!comment->str)
+	struct ip_set_comment_rcu *c = rcu_dereference_bh(comment->c);
+
+	if (!c)
 		return 0;
-	return nla_put_string(skb, IPSET_ATTR_COMMENT, comment->str);
+	return nla_put_string(skb, IPSET_ATTR_COMMENT, c->str);
 }
 
+/* Called from uadd/udel, flush or the garbage collectors protected
+ * by the set spinlock.
+ * Called when the set is destroyed and when there can't be any user
+ * of the set data anymore.
+ */
 static inline void
 ip_set_comment_free(struct ip_set_comment *comment)
 {
-	if (unlikely(!comment->str))
+	struct ip_set_comment_rcu *c;
+
+	c = rcu_dereference_protected(comment->c, 1);
+	if (unlikely(!c))
 		return;
-	kfree(comment->str);
-	comment->str = NULL;
+	kfree_rcu(c, rcu);
+	rcu_assign_pointer(comment->c, NULL);
 }
 
 #endif
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 6660f2a..86429f3 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -209,10 +209,13 @@ mtype_list(const struct ip_set *set,
 	struct nlattr *adt, *nested;
 	void *x;
 	u32 id, first = cb->args[IPSET_CB_ARG0];
+	int ret = 0;
 
 	adt = ipset_nest_start(skb, IPSET_ATTR_ADT);
 	if (!adt)
 		return -EMSGSIZE;
+	/* Extensions may be replaced */
+	rcu_read_lock();
 	for (; cb->args[IPSET_CB_ARG0] < map->elements;
 	     cb->args[IPSET_CB_ARG0]++) {
 		id = cb->args[IPSET_CB_ARG0];
@@ -228,9 +231,11 @@ mtype_list(const struct ip_set *set,
 		if (!nested) {
 			if (id == first) {
 				nla_nest_cancel(skb, adt);
-				return -EMSGSIZE;
-			} else
-				goto nla_put_failure;
+				ret = -EMSGSIZE;
+				goto out;
+			}
+
+			goto nla_put_failure;
 		}
 		if (mtype_do_list(skb, map, id, set->dsize))
 			goto nla_put_failure;
@@ -244,16 +249,18 @@ mtype_list(const struct ip_set *set,
 	/* Set listing finished */
 	cb->args[IPSET_CB_ARG0] = 0;
 
-	return 0;
+	goto out;
 
 nla_put_failure:
 	nla_nest_cancel(skb, nested);
 	if (unlikely(id == first)) {
 		cb->args[IPSET_CB_ARG0] = 0;
-		return -EMSGSIZE;
+		ret = -EMSGSIZE;
 	}
 	ipset_nest_end(skb, adt);
-	return 0;
+out:
+	rcu_read_unlock();
+	return ret;
 }
 
 static void
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 507d1ab..76a1c5f 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -477,6 +477,7 @@ list_set_list(const struct ip_set *set,
 	struct nlattr *atd, *nested;
 	u32 i = 0, first = cb->args[IPSET_CB_ARG0];
 	struct set_elem *e;
+	int ret = 0;
 
 	atd = ipset_nest_start(skb, IPSET_ATTR_ADT);
 	if (!atd)
@@ -487,6 +488,7 @@ list_set_list(const struct ip_set *set,
 		i++;
 	}
 
+	rcu_read_lock();
 	list_for_each_entry_from(e, &map->members, list) {
 		i++;
 		if (SET_WITH_TIMEOUT(set) &&
@@ -496,9 +498,10 @@ list_set_list(const struct ip_set *set,
 		if (!nested) {
 			if (i == first) {
 				nla_nest_cancel(skb, atd);
-				return -EMSGSIZE;
-			} else
-				goto nla_put_failure;
+				ret = -EMSGSIZE;
+				goto out;
+			}
+			goto nla_put_failure;
 		}
 		if (nla_put_string(skb, IPSET_ATTR_NAME,
 				   ip_set_name_byindex(map->net, e->id)))
@@ -511,17 +514,19 @@ list_set_list(const struct ip_set *set,
 	ipset_nest_end(skb, atd);
 	/* Set listing finished */
 	cb->args[IPSET_CB_ARG0] = 0;
-	return 0;
+	goto out;
 
 nla_put_failure:
 	nla_nest_cancel(skb, nested);
 	if (unlikely(i == first)) {
 		cb->args[IPSET_CB_ARG0] = 0;
-		return -EMSGSIZE;
+		ret = -EMSGSIZE;
 	}
 	cb->args[IPSET_CB_ARG0] = i - 1;
 	ipset_nest_end(skb, atd);
-	return 0;
+out:
+	rcu_read_unlock();
+	return ret;
 }
 
 static bool
-- 
1.8.5.1


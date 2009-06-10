From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/4] list_nulls: add hlist_nulls_add_head and hlist_nulls_del
Date: Wed, 10 Jun 2009 15:41:28 +0200
Message-ID: <20090610134128.14805.42190.stgit@Decadence>
References: <20090610133716.14805.95308.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54898 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbZFJNld (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:41:33 -0400
In-Reply-To: <20090610133716.14805.95308.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the hlist_nulls_add_head() function which is
based on hlist_nulls_add_head_rcu() but without the use of
rcu_assign_pointer(). It also adds hlist_nulls_del which is
exactly the same like hlist_nulls_del_rcu().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
---

 include/linux/list_nulls.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/list_nulls.h b/include/linux/list_nulls.h
index 93150ec..5d10ae3 100644
--- a/include/linux/list_nulls.h
+++ b/include/linux/list_nulls.h
@@ -56,6 +56,18 @@ static inline int hlist_nulls_empty(const struct hlist_nulls_head *h)
 	return is_a_nulls(h->first);
 }
 
+static inline void hlist_nulls_add_head(struct hlist_nulls_node *n,
+					struct hlist_nulls_head *h)
+{
+	struct hlist_nulls_node *first = h->first;
+
+	n->next = first;
+	n->pprev = &h->first;
+	h->first = n;
+	if (!is_a_nulls(first))
+		first->pprev = &n->next;
+}
+
 static inline void __hlist_nulls_del(struct hlist_nulls_node *n)
 {
 	struct hlist_nulls_node *next = n->next;
@@ -65,6 +77,12 @@ static inline void __hlist_nulls_del(struct hlist_nulls_node *n)
 		next->pprev = pprev;
 }
 
+static inline void hlist_nulls_del(struct hlist_nulls_node *n)
+{
+	__hlist_nulls_del(n);
+	n->pprev = LIST_POISON2;
+}
+
 /**
  * hlist_nulls_for_each_entry	- iterate over list of given type
  * @tpos:	the type * to use as a loop cursor.


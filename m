From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] simplify list handing in ifname2index infrastructure
Date: Thu, 22 May 2008 14:19:12 +0200
Message-ID: <483564C0.2000100@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010400060000090100070706"
Cc: Eric Leblond <eric@inl.fr>, Anton <anton.vazir@gmail.com>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56082 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757936AbYEVMT0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 08:19:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010400060000090100070706
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The patch attached simplifies the ifname2index list handling by using
linux list and it introduces minor cleanups such as remove iftb_log()
calls. This patch also fixes the leak in the nlif_close path (we forgot
to release the ifindex nodes from the hashes) that Anton has reported.

Slightly tested here. If you are OK with it I'll apply it asap.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------010400060000090100070706
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/configure.in b/configure.in
index 84772b4..d8270f6 100644
--- a/configure.in
+++ b/configure.in
@@ -1,6 +1,6 @@
 dnl Process this file with autoconf to create configure.
 
-AC_INIT(libnfnetlink, 0.0.35)
+AC_INIT(libnfnetlink, 0.0.37)
 
 AC_CANONICAL_SYSTEM
 
diff --git a/include/Makefile.am b/include/Makefile.am
index 16b7c90..288c711 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -1,3 +1,2 @@
-
 SUBDIRS = libnfnetlink
-
+noinst_HEADERS = linux_list.h
diff --git a/include/linux_list.h b/include/linux_list.h
new file mode 100644
index 0000000..de182a4
--- /dev/null
+++ b/include/linux_list.h
@@ -0,0 +1,727 @@
+#ifndef _LINUX_LIST_H
+#define _LINUX_LIST_H
+
+#include <stddef.h>
+
+#undef offsetof
+#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+
+/**
+ * container_of - cast a member of a structure out to the containing structure
+ *
+ * @ptr:	the pointer to the member.
+ * @type:	the type of the container struct this is embedded in.
+ * @member:	the name of the member within the struct.
+ *
+ */
+#define container_of(ptr, type, member) ({			\
+        typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+        (type *)( (char *)__mptr - offsetof(type,member) );})
+
+/*
+ * Check at compile time that something is of a particular type.
+ * Always evaluates to 1 so you may use it easily in comparisons.
+ */
+#define typecheck(type,x) \
+({	type __dummy; \
+	typeof(x) __dummy2; \
+	(void)(&__dummy == &__dummy2); \
+	1; \
+})
+
+#define prefetch(x)		1
+
+/* empty define to make this work in userspace -HW */
+#ifndef smp_wmb
+#define smp_wmb()
+#endif
+
+/*
+ * These are non-NULL pointers that will result in page faults
+ * under normal circumstances, used to verify that nobody uses
+ * non-initialized list entries.
+ */
+#define LIST_POISON1  ((void *) 0x00100100)
+#define LIST_POISON2  ((void *) 0x00200200)
+
+/*
+ * Simple doubly linked list implementation.
+ *
+ * Some of the internal functions ("__xxx") are useful when
+ * manipulating whole lists rather than single entries, as
+ * sometimes we already know the next/prev entries and we can
+ * generate better code by using them directly rather than
+ * using the generic single-entry routines.
+ */
+
+struct list_head {
+	struct list_head *next, *prev;
+};
+
+#define LIST_HEAD_INIT(name) { &(name), &(name) }
+
+#define LIST_HEAD(name) \
+	struct list_head name = LIST_HEAD_INIT(name)
+
+#define INIT_LIST_HEAD(ptr) do { \
+	(ptr)->next = (ptr); (ptr)->prev = (ptr); \
+} while (0)
+
+/*
+ * Insert a new entry between two known consecutive entries.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_add(struct list_head *new,
+			      struct list_head *prev,
+			      struct list_head *next)
+{
+	next->prev = new;
+	new->next = next;
+	new->prev = prev;
+	prev->next = new;
+}
+
+/**
+ * list_add - add a new entry
+ * @new: new entry to be added
+ * @head: list head to add it after
+ *
+ * Insert a new entry after the specified head.
+ * This is good for implementing stacks.
+ */
+static inline void list_add(struct list_head *new, struct list_head *head)
+{
+	__list_add(new, head, head->next);
+}
+
+/**
+ * list_add_tail - add a new entry
+ * @new: new entry to be added
+ * @head: list head to add it before
+ *
+ * Insert a new entry before the specified head.
+ * This is useful for implementing queues.
+ */
+static inline void list_add_tail(struct list_head *new, struct list_head *head)
+{
+	__list_add(new, head->prev, head);
+}
+
+/*
+ * Insert a new entry between two known consecutive entries.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_add_rcu(struct list_head * new,
+		struct list_head * prev, struct list_head * next)
+{
+	new->next = next;
+	new->prev = prev;
+	smp_wmb();
+	next->prev = new;
+	prev->next = new;
+}
+
+/**
+ * list_add_rcu - add a new entry to rcu-protected list
+ * @new: new entry to be added
+ * @head: list head to add it after
+ *
+ * Insert a new entry after the specified head.
+ * This is good for implementing stacks.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as list_add_rcu()
+ * or list_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * list_for_each_entry_rcu().
+ */
+static inline void list_add_rcu(struct list_head *new, struct list_head *head)
+{
+	__list_add_rcu(new, head, head->next);
+}
+
+/**
+ * list_add_tail_rcu - add a new entry to rcu-protected list
+ * @new: new entry to be added
+ * @head: list head to add it before
+ *
+ * Insert a new entry before the specified head.
+ * This is useful for implementing queues.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as list_add_tail_rcu()
+ * or list_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * list_for_each_entry_rcu().
+ */
+static inline void list_add_tail_rcu(struct list_head *new,
+					struct list_head *head)
+{
+	__list_add_rcu(new, head->prev, head);
+}
+
+/*
+ * Delete a list entry by making the prev/next entries
+ * point to each other.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_del(struct list_head * prev, struct list_head * next)
+{
+	next->prev = prev;
+	prev->next = next;
+}
+
+/**
+ * list_del - deletes entry from list.
+ * @entry: the element to delete from the list.
+ * Note: list_empty on entry does not return true after this, the entry is
+ * in an undefined state.
+ */
+static inline void list_del(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	entry->next = LIST_POISON1;
+	entry->prev = LIST_POISON2;
+}
+
+/**
+ * list_del_rcu - deletes entry from list without re-initialization
+ * @entry: the element to delete from the list.
+ *
+ * Note: list_empty on entry does not return true after this,
+ * the entry is in an undefined state. It is useful for RCU based
+ * lockfree traversal.
+ *
+ * In particular, it means that we can not poison the forward
+ * pointers that may still be used for walking the list.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as list_del_rcu()
+ * or list_add_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * list_for_each_entry_rcu().
+ *
+ * Note that the caller is not permitted to immediately free
+ * the newly deleted entry.  Instead, either synchronize_kernel()
+ * or call_rcu() must be used to defer freeing until an RCU
+ * grace period has elapsed.
+ */
+static inline void list_del_rcu(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	entry->prev = LIST_POISON2;
+}
+
+/**
+ * list_del_init - deletes entry from list and reinitialize it.
+ * @entry: the element to delete from the list.
+ */
+static inline void list_del_init(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	INIT_LIST_HEAD(entry);
+}
+
+/**
+ * list_move - delete from one list and add as another's head
+ * @list: the entry to move
+ * @head: the head that will precede our entry
+ */
+static inline void list_move(struct list_head *list, struct list_head *head)
+{
+        __list_del(list->prev, list->next);
+        list_add(list, head);
+}
+
+/**
+ * list_move_tail - delete from one list and add as another's tail
+ * @list: the entry to move
+ * @head: the head that will follow our entry
+ */
+static inline void list_move_tail(struct list_head *list,
+				  struct list_head *head)
+{
+        __list_del(list->prev, list->next);
+        list_add_tail(list, head);
+}
+
+/**
+ * list_empty - tests whether a list is empty
+ * @head: the list to test.
+ */
+static inline int list_empty(const struct list_head *head)
+{
+	return head->next == head;
+}
+
+/**
+ * list_empty_careful - tests whether a list is
+ * empty _and_ checks that no other CPU might be
+ * in the process of still modifying either member
+ *
+ * NOTE: using list_empty_careful() without synchronization
+ * can only be safe if the only activity that can happen
+ * to the list entry is list_del_init(). Eg. it cannot be used
+ * if another CPU could re-list_add() it.
+ *
+ * @head: the list to test.
+ */
+static inline int list_empty_careful(const struct list_head *head)
+{
+	struct list_head *next = head->next;
+	return (next == head) && (next == head->prev);
+}
+
+static inline void __list_splice(struct list_head *list,
+				 struct list_head *head)
+{
+	struct list_head *first = list->next;
+	struct list_head *last = list->prev;
+	struct list_head *at = head->next;
+
+	first->prev = head;
+	head->next = first;
+
+	last->next = at;
+	at->prev = last;
+}
+
+/**
+ * list_splice - join two lists
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ */
+static inline void list_splice(struct list_head *list, struct list_head *head)
+{
+	if (!list_empty(list))
+		__list_splice(list, head);
+}
+
+/**
+ * list_splice_init - join two lists and reinitialise the emptied list.
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ *
+ * The list at @list is reinitialised
+ */
+static inline void list_splice_init(struct list_head *list,
+				    struct list_head *head)
+{
+	if (!list_empty(list)) {
+		__list_splice(list, head);
+		INIT_LIST_HEAD(list);
+	}
+}
+
+/**
+ * list_entry - get the struct for this entry
+ * @ptr:	the &struct list_head pointer.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_entry(ptr, type, member) \
+	container_of(ptr, type, member)
+
+/**
+ * list_for_each	-	iterate over a list
+ * @pos:	the &struct list_head to use as a loop counter.
+ * @head:	the head for your list.
+ */
+#define list_for_each(pos, head) \
+	for (pos = (head)->next, prefetch(pos->next); pos != (head); \
+        	pos = pos->next, prefetch(pos->next))
+
+/**
+ * __list_for_each	-	iterate over a list
+ * @pos:	the &struct list_head to use as a loop counter.
+ * @head:	the head for your list.
+ *
+ * This variant differs from list_for_each() in that it's the
+ * simplest possible list iteration code, no prefetching is done.
+ * Use this for code that knows the list to be very short (empty
+ * or 1 entry) most of the time.
+ */
+#define __list_for_each(pos, head) \
+	for (pos = (head)->next; pos != (head); pos = pos->next)
+
+/**
+ * list_for_each_prev	-	iterate over a list backwards
+ * @pos:	the &struct list_head to use as a loop counter.
+ * @head:	the head for your list.
+ */
+#define list_for_each_prev(pos, head) \
+	for (pos = (head)->prev, prefetch(pos->prev); pos != (head); \
+        	pos = pos->prev, prefetch(pos->prev))
+
+/**
+ * list_for_each_safe	-	iterate over a list safe against removal of list entry
+ * @pos:	the &struct list_head to use as a loop counter.
+ * @n:		another &struct list_head to use as temporary storage
+ * @head:	the head for your list.
+ */
+#define list_for_each_safe(pos, n, head) \
+	for (pos = (head)->next, n = pos->next; pos != (head); \
+		pos = n, n = pos->next)
+
+/**
+ * list_for_each_entry	-	iterate over list of given type
+ * @pos:	the type * to use as a loop counter.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_each_entry(pos, head, member)				\
+	for (pos = list_entry((head)->next, typeof(*pos), member),	\
+		     prefetch(pos->member.next);			\
+	     &pos->member != (head); 					\
+	     pos = list_entry(pos->member.next, typeof(*pos), member),	\
+		     prefetch(pos->member.next))
+
+/**
+ * list_for_each_entry_reverse - iterate backwards over list of given type.
+ * @pos:	the type * to use as a loop counter.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_each_entry_reverse(pos, head, member)			\
+	for (pos = list_entry((head)->prev, typeof(*pos), member),	\
+		     prefetch(pos->member.prev);			\
+	     &pos->member != (head); 					\
+	     pos = list_entry(pos->member.prev, typeof(*pos), member),	\
+		     prefetch(pos->member.prev))
+
+/**
+ * list_prepare_entry - prepare a pos entry for use as a start point in
+ *			list_for_each_entry_continue
+ * @pos:	the type * to use as a start point
+ * @head:	the head of the list
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_prepare_entry(pos, head, member) \
+	((pos) ? : list_entry(head, typeof(*pos), member))
+
+/**
+ * list_for_each_entry_continue -	iterate over list of given type
+ *			continuing after existing point
+ * @pos:	the type * to use as a loop counter.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_each_entry_continue(pos, head, member) 		\
+	for (pos = list_entry(pos->member.next, typeof(*pos), member),	\
+		     prefetch(pos->member.next);			\
+	     &pos->member != (head);					\
+	     pos = list_entry(pos->member.next, typeof(*pos), member),	\
+		     prefetch(pos->member.next))
+
+/**
+ * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
+ * @pos:	the type * to use as a loop counter.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_each_entry_safe(pos, n, head, member)			\
+	for (pos = list_entry((head)->next, typeof(*pos), member),	\
+		n = list_entry(pos->member.next, typeof(*pos), member);	\
+	     &pos->member != (head); 					\
+	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
+
+/**
+ * list_for_each_rcu	-	iterate over an rcu-protected list
+ * @pos:	the &struct list_head to use as a loop counter.
+ * @head:	the head for your list.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_rcu(pos, head) \
+	for (pos = (head)->next, prefetch(pos->next); pos != (head); \
+        	pos = pos->next, ({ smp_read_barrier_depends(); 0;}), prefetch(pos->next))
+
+#define __list_for_each_rcu(pos, head) \
+	for (pos = (head)->next; pos != (head); \
+        	pos = pos->next, ({ smp_read_barrier_depends(); 0;}))
+
+/**
+ * list_for_each_safe_rcu	-	iterate over an rcu-protected list safe
+ *					against removal of list entry
+ * @pos:	the &struct list_head to use as a loop counter.
+ * @n:		another &struct list_head to use as temporary storage
+ * @head:	the head for your list.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_safe_rcu(pos, n, head) \
+	for (pos = (head)->next, n = pos->next; pos != (head); \
+		pos = n, ({ smp_read_barrier_depends(); 0;}), n = pos->next)
+
+/**
+ * list_for_each_entry_rcu	-	iterate over rcu list of given type
+ * @pos:	the type * to use as a loop counter.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_entry_rcu(pos, head, member)			\
+	for (pos = list_entry((head)->next, typeof(*pos), member),	\
+		     prefetch(pos->member.next);			\
+	     &pos->member != (head); 					\
+	     pos = list_entry(pos->member.next, typeof(*pos), member),	\
+		     ({ smp_read_barrier_depends(); 0;}),		\
+		     prefetch(pos->member.next))
+
+
+/**
+ * list_for_each_continue_rcu	-	iterate over an rcu-protected list
+ *			continuing after existing point.
+ * @pos:	the &struct list_head to use as a loop counter.
+ * @head:	the head for your list.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_continue_rcu(pos, head) \
+	for ((pos) = (pos)->next, prefetch((pos)->next); (pos) != (head); \
+        	(pos) = (pos)->next, ({ smp_read_barrier_depends(); 0;}), prefetch((pos)->next))
+
+/*
+ * Double linked lists with a single pointer list head.
+ * Mostly useful for hash tables where the two pointer list head is
+ * too wasteful.
+ * You lose the ability to access the tail in O(1).
+ */
+
+struct hlist_head {
+	struct hlist_node *first;
+};
+
+struct hlist_node {
+	struct hlist_node *next, **pprev;
+};
+
+#define HLIST_HEAD_INIT { .first = NULL }
+#define HLIST_HEAD(name) struct hlist_head name = {  .first = NULL }
+#define INIT_HLIST_HEAD(ptr) ((ptr)->first = NULL)
+#define INIT_HLIST_NODE(ptr) ((ptr)->next = NULL, (ptr)->pprev = NULL)
+
+static inline int hlist_unhashed(const struct hlist_node *h)
+{
+	return !h->pprev;
+}
+
+static inline int hlist_empty(const struct hlist_head *h)
+{
+	return !h->first;
+}
+
+static inline void __hlist_del(struct hlist_node *n)
+{
+	struct hlist_node *next = n->next;
+	struct hlist_node **pprev = n->pprev;
+	*pprev = next;
+	if (next)
+		next->pprev = pprev;
+}
+
+static inline void hlist_del(struct hlist_node *n)
+{
+	__hlist_del(n);
+	n->next = LIST_POISON1;
+	n->pprev = LIST_POISON2;
+}
+
+/**
+ * hlist_del_rcu - deletes entry from hash list without re-initialization
+ * @n: the element to delete from the hash list.
+ *
+ * Note: list_unhashed() on entry does not return true after this,
+ * the entry is in an undefined state. It is useful for RCU based
+ * lockfree traversal.
+ *
+ * In particular, it means that we can not poison the forward
+ * pointers that may still be used for walking the hash list.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_add_head_rcu()
+ * or hlist_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_for_each_entry().
+ */
+static inline void hlist_del_rcu(struct hlist_node *n)
+{
+	__hlist_del(n);
+	n->pprev = LIST_POISON2;
+}
+
+static inline void hlist_del_init(struct hlist_node *n)
+{
+	if (n->pprev)  {
+		__hlist_del(n);
+		INIT_HLIST_NODE(n);
+	}
+}
+
+#define hlist_del_rcu_init hlist_del_init
+
+static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
+{
+	struct hlist_node *first = h->first;
+	n->next = first;
+	if (first)
+		first->pprev = &n->next;
+	h->first = n;
+	n->pprev = &h->first;
+}
+
+
+/**
+ * hlist_add_head_rcu - adds the specified element to the specified hlist,
+ * while permitting racing traversals.
+ * @n: the element to add to the hash list.
+ * @h: the list to add to.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_add_head_rcu()
+ * or hlist_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_for_each_entry(), but only if smp_read_barrier_depends()
+ * is used to prevent memory-consistency problems on Alpha CPUs.
+ * Regardless of the type of CPU, the list-traversal primitive
+ * must be guarded by rcu_read_lock().
+ *
+ * OK, so why don't we have an hlist_for_each_entry_rcu()???
+ */
+static inline void hlist_add_head_rcu(struct hlist_node *n,
+					struct hlist_head *h)
+{
+	struct hlist_node *first = h->first;
+	n->next = first;
+	n->pprev = &h->first;
+	smp_wmb();
+	if (first)
+		first->pprev = &n->next;
+	h->first = n;
+}
+
+/* next must be != NULL */
+static inline void hlist_add_before(struct hlist_node *n,
+					struct hlist_node *next)
+{
+	n->pprev = next->pprev;
+	n->next = next;
+	next->pprev = &n->next;
+	*(n->pprev) = n;
+}
+
+static inline void hlist_add_after(struct hlist_node *n,
+					struct hlist_node *next)
+{
+	next->next = n->next;
+	n->next = next;
+	next->pprev = &n->next;
+
+	if(next->next)
+		next->next->pprev  = &next->next;
+}
+
+#define hlist_entry(ptr, type, member) container_of(ptr,type,member)
+
+#define hlist_for_each(pos, head) \
+	for (pos = (head)->first; pos && ({ prefetch(pos->next); 1; }); \
+	     pos = pos->next)
+
+#define hlist_for_each_safe(pos, n, head) \
+	for (pos = (head)->first; pos && ({ n = pos->next; 1; }); \
+	     pos = n)
+
+/**
+ * hlist_for_each_entry	- iterate over list of given type
+ * @tpos:	the type * to use as a loop counter.
+ * @pos:	the &struct hlist_node to use as a loop counter.
+ * @head:	the head for your list.
+ * @member:	the name of the hlist_node within the struct.
+ */
+#define hlist_for_each_entry(tpos, pos, head, member)			 \
+	for (pos = (head)->first;					 \
+	     pos && ({ prefetch(pos->next); 1;}) &&			 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
+	     pos = pos->next)
+
+/**
+ * hlist_for_each_entry_continue - iterate over a hlist continuing after existing point
+ * @tpos:	the type * to use as a loop counter.
+ * @pos:	the &struct hlist_node to use as a loop counter.
+ * @member:	the name of the hlist_node within the struct.
+ */
+#define hlist_for_each_entry_continue(tpos, pos, member)		 \
+	for (pos = (pos)->next;						 \
+	     pos && ({ prefetch(pos->next); 1;}) &&			 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
+	     pos = pos->next)
+
+/**
+ * hlist_for_each_entry_from - iterate over a hlist continuing from existing point
+ * @tpos:	the type * to use as a loop counter.
+ * @pos:	the &struct hlist_node to use as a loop counter.
+ * @member:	the name of the hlist_node within the struct.
+ */
+#define hlist_for_each_entry_from(tpos, pos, member)			 \
+	for (; pos && ({ prefetch(pos->next); 1;}) &&			 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
+	     pos = pos->next)
+
+/**
+ * hlist_for_each_entry_safe - iterate over list of given type safe against removal of list entry
+ * @tpos:	the type * to use as a loop counter.
+ * @pos:	the &struct hlist_node to use as a loop counter.
+ * @n:		another &struct hlist_node to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the hlist_node within the struct.
+ */
+#define hlist_for_each_entry_safe(tpos, pos, n, head, member) 		 \
+	for (pos = (head)->first;					 \
+	     pos && ({ n = pos->next; 1; }) && 				 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
+	     pos = n)
+
+/**
+ * hlist_for_each_entry_rcu - iterate over rcu list of given type
+ * @pos:	the type * to use as a loop counter.
+ * @pos:	the &struct hlist_node to use as a loop counter.
+ * @head:	the head for your list.
+ * @member:	the name of the hlist_node within the struct.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as hlist_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
+	for (pos = (head)->first;					 \
+	     pos && ({ prefetch(pos->next); 1;}) &&			 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
+	     pos = pos->next, ({ smp_read_barrier_depends(); 0; }) )
+
+#endif
diff --git a/src/iftable.c b/src/iftable.c
index 7e6172b..d8d52b3 100644
--- a/src/iftable.c
+++ b/src/iftable.c
@@ -1,9 +1,9 @@
 /* iftable - table of network interfaces
  *
  * (C) 2004 by Astaro AG, written by Harald Welte <hwelte@astaro.com>
+ * (C) 2008 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * This software is Free Software and licensed under GNU GPLv2. 
- *
  */
 
 /* IFINDEX handling */
@@ -22,11 +22,10 @@
 
 #include <libnfnetlink/libnfnetlink.h>
 #include "rtnl.h"
+#include "linux_list.h"
 
-#define iftb_log(x, ...)
-
-struct ifindex_map {
-	struct ifindex_map *next;
+struct ifindex_node {
+	struct list_head head;
 
 	u_int32_t	index;
 	u_int32_t	type;
@@ -37,7 +36,7 @@ struct ifindex_map {
 };
 
 struct nlif_handle {
-	struct ifindex_map *ifindex_map[16];
+	struct list_head ifindex_hash[16];
 	struct rtnl_handle *rtnl_handle;
 	struct rtnl_handler ifadd_handler;
 	struct rtnl_handler ifdel_handler;
@@ -52,65 +51,55 @@ struct nlif_handle {
  */
 static int iftable_add(struct nlmsghdr *n, void *arg)
 {
-	unsigned int hash;
+	unsigned int hash, found = 0;
 	struct ifinfomsg *ifi_msg = NLMSG_DATA(n);
-	struct ifindex_map *im, **imp;
+	struct ifindex_node *this, *tmp;
 	struct rtattr *cb[IFLA_MAX+1];
-	struct nlif_handle *nlif_handle = (struct nlif_handle *)arg;
+	struct nlif_handle *h = (struct nlif_handle *)arg;
 
 	if (n->nlmsg_type != RTM_NEWLINK)
 		return -1;
 
-	if (n->nlmsg_len < NLMSG_LENGTH(sizeof(ifi_msg))) {
-		iftb_log(LOG_ERROR, "short message (%u < %u)",
-			 n->nlmsg_len, NLMSG_LENGTH(sizeof(ifi_msg)));
+	if (n->nlmsg_len < NLMSG_LENGTH(sizeof(ifi_msg)))
 		return -1;
-	}
 
-	memset(&cb, 0, sizeof(cb));
 	rtnl_parse_rtattr(cb, IFLA_MAX, IFLA_RTA(ifi_msg), IFLA_PAYLOAD(n));
-	if (!cb[IFLA_IFNAME]) {
-		iftb_log(LOG_ERROR, "interface without name?");
+
+	if (!cb[IFLA_IFNAME])
 		return -1;
-	}
 
-	hash = ifi_msg->ifi_index&0xF;
-	for (imp = &((nlif_handle->ifindex_map)[hash]); 
-	     (im=*imp)!=NULL; imp = &im->next) {
-		if (im->index == ifi_msg->ifi_index) {
-			iftb_log(LOG_DEBUG,
-				 "updating iftable (ifindex=%u)", im->index);
+	hash = ifi_msg->ifi_index & 0xF;
+	list_for_each_entry_safe(this, tmp, &h->ifindex_hash[hash], head) {
+		if (this->index == ifi_msg->ifi_index) {
+			found = 1;
 			break;
 		}
 	}
 
-	if (!im) {
-		im = malloc(sizeof(*im));
-		if (!im) {
-			iftb_log(LOG_ERROR,
-				 "ENOMEM while allocating ifindex_map");
-			return 0;
-		}
-		im->next = *imp;
-		im->index = ifi_msg->ifi_index;
-		*imp = im;
-		iftb_log(LOG_DEBUG, "creating new iftable (ifindex=%u)",
-			 im->index);
+	if (!found) {
+		this = malloc(sizeof(*this));
+		if (!this)
+			return -1;
+
+		this->index = ifi_msg->ifi_index;
 	}
-	
-	im->type = ifi_msg->ifi_type;
-	im->flags = ifi_msg->ifi_flags;
+
+	this->type = ifi_msg->ifi_type;
+	this->flags = ifi_msg->ifi_flags;
 	if (cb[IFLA_ADDRESS]) {
 		unsigned int alen;
-		im->alen = alen = RTA_PAYLOAD(cb[IFLA_ADDRESS]);
-		if (alen > sizeof(im->addr))
-			alen = sizeof(im->addr);
-		memcpy(im->addr, RTA_DATA(cb[IFLA_ADDRESS]), alen);
+		this->alen = alen = RTA_PAYLOAD(cb[IFLA_ADDRESS]);
+		if (alen > sizeof(this->addr))
+			alen = sizeof(this->addr);
+		memcpy(this->addr, RTA_DATA(cb[IFLA_ADDRESS]), alen);
 	} else {
-		im->alen = 0;
-		memset(im->addr, 0, sizeof(im->addr));
+		this->alen = 0;
+		memset(this->addr, 0, sizeof(this->addr));
 	}
-	strcpy(im->name, RTA_DATA(cb[IFLA_IFNAME]));
+	strcpy(this->name, RTA_DATA(cb[IFLA_IFNAME]));
+
+	list_add(&this->head, &h->ifindex_hash[hash]);
+
 	return 1;
 }
 
@@ -125,46 +114,28 @@ static int iftable_del(struct nlmsghdr *n, void *arg)
 {
 	struct ifinfomsg *ifi_msg = NLMSG_DATA(n);
 	struct rtattr *cb[IFLA_MAX+1];
-	struct nlif_handle *nlif_handle = (struct nlif_handle *)arg;
-	struct ifindex_map *im, *ima, **imp;
+	struct nlif_handle *h = (struct nlif_handle *)arg;
+	struct ifindex_node *this, *tmp;
 	unsigned int hash;
 
-	if (n->nlmsg_type != RTM_DELLINK) {
-		iftb_log(LOG_ERROR,
-			 "called with wrong nlmsg_type %u", n->nlmsg_type);
+	if (n->nlmsg_type != RTM_DELLINK)
 		return -1;
-	}
 
-	if (n->nlmsg_len < NLMSG_LENGTH(sizeof(ifi_msg))) {
-		iftb_log(LOG_ERROR, "short message (%u < %u)",
-			 n->nlmsg_len, NLMSG_LENGTH(sizeof(ifi_msg)));
+	if (n->nlmsg_len < NLMSG_LENGTH(sizeof(ifi_msg)))
 		return -1;
-	}
 
-	memset(&cb, 0, sizeof(cb));
 	rtnl_parse_rtattr(cb, IFLA_MAX, IFLA_RTA(ifi_msg), IFLA_PAYLOAD(n));
 
-	/* \todo Really suppress entry */
-	hash = ifi_msg->ifi_index&0xF;
-	for (ima = NULL, imp = &((nlif_handle->ifindex_map)[hash]); 
-	     (im=*imp)!=NULL; imp = &im->next, ima=im) {
-		if (im->index == ifi_msg->ifi_index) {
-			iftb_log(LOG_DEBUG,
-				 "deleting iftable (ifindex=%u)", im->index);
-			break;
+	hash = ifi_msg->ifi_index & 0xF;
+	list_for_each_entry_safe(this, tmp, &h->ifindex_hash[hash], head) {
+		if (this->index == ifi_msg->ifi_index) {
+			list_del(&this->head);
+			free(this);
+			return 1;
 		}
 	}
 
-	if (!im)
-		return 0;
-
-	if (ima)
-		ima->next = *imp;
-	else
-		(nlif_handle->ifindex_map)[hash] = *imp;
-	free(im);
-
-	return 1;
+	return 0;
 }
 
 /** Get the name for an ifindex
@@ -174,36 +145,42 @@ static int iftable_del(struct nlmsghdr *n, void *arg)
  * \param name interface name, pass a buffer of IFNAMSIZ size
  * \return -1 on error, 1 on success 
  */
-int nlif_index2name(struct nlif_handle *nlif_handle, 
+int nlif_index2name(struct nlif_handle *h, 
 		    unsigned int index,
 		    char *name)
 {
-	struct ifindex_map *im;
+	unsigned int hash;
+	struct ifindex_node *this, *tmp;
 
-	assert(nlif_handle != NULL);
+	assert(h != NULL);
 	assert(name != NULL);
 
 	if (index == 0) {
 		strcpy(name, "*");
 		return 1;
 	}
-	for (im = (nlif_handle->ifindex_map)[index&0xF]; im; im = im->next)
-		if (im->index == index) {
-			strcpy(name, im->name);
+
+	hash = index & 0xF;
+	list_for_each_entry_safe(this, tmp, &h->ifindex_hash[hash], head) {
+		if (this->index == index) {
+			strcpy(name, this->name);
 			return 1;
 		}
+	}
 
 	errno = ENOENT;
 	return -1;
 }
 
-static int iftable_up(struct nlif_handle *nlif_handle, unsigned int index)
+static int iftable_up(struct nlif_handle *h, unsigned int index)
 {
-	struct ifindex_map *im;
+	unsigned int hash;
+	struct ifindex_node *this, *tmp;
 
-	for (im = nlif_handle->ifindex_map[index&0xF]; im; im = im->next) {
-		if (im->index == index) {
-			if (im->flags & IFF_UP)
+	hash = index & 0xF;
+	list_for_each_entry_safe(this, tmp, &h->ifindex_hash[hash], head) {
+		if (this->index == index) {
+			if (this->flags & IFF_UP)
 				return 1;
 			else
 				return 0;
@@ -221,12 +198,16 @@ static int iftable_up(struct nlif_handle *nlif_handle, unsigned int index)
  */
 struct nlif_handle *nlif_open(void)
 {
+	int i;
 	struct nlif_handle *h;
 
 	h = calloc(1,  sizeof(struct nlif_handle));
 	if (h == NULL)
 		goto err;
 
+	for (i=0; i<16; i++)
+		INIT_LIST_HEAD(&h->ifindex_hash[i]);
+
 	h->ifadd_handler.nlmsg_type = RTM_NEWLINK;
 	h->ifadd_handler.handlefn = iftable_add;
 	h->ifadd_handler.arg = h;
@@ -262,11 +243,22 @@ err:
  */
 void nlif_close(struct nlif_handle *h)
 {
+	int i;
+	struct ifindex_node *this, *tmp;
+
 	assert(h != NULL);
 
 	rtnl_handler_unregister(h->rtnl_handle, &h->ifadd_handler);
 	rtnl_handler_unregister(h->rtnl_handle, &h->ifdel_handler);
 	rtnl_close(h->rtnl_handle);
+
+	for (i=0; i<16; i++) {
+		list_for_each_entry_safe(this, tmp, &h->ifindex_hash[i], head) {
+			list_del(&this->head);
+			free(this);
+		}
+	}
+
 	free(h);
 	h = NULL; /* bugtrap */
 }
@@ -276,12 +268,12 @@ void nlif_close(struct nlif_handle *h)
  * \param nlif_handle A pointer to a ::nlif_handle created
  * \return 0 if OK
  */
-int nlif_catch(struct nlif_handle *nlif_handle)
+int nlif_catch(struct nlif_handle *h)
 {
-	assert(nlif_handle != NULL);
+	assert(h != NULL);
 
-	if (nlif_handle->rtnl_handle)
-		return rtnl_receive(nlif_handle->rtnl_handle);
+	if (h->rtnl_handle)
+		return rtnl_receive(h->rtnl_handle);
 
 	return -1;
 }
@@ -305,12 +297,12 @@ int nlif_query(struct nlif_handle *h)
  * \param nlif_handle A pointer to a ::nlif_handle created
  * \return The fd or -1 if there's an error
  */
-int nlif_fd(struct nlif_handle *nlif_handle)
+int nlif_fd(struct nlif_handle *h)
 {
-	assert(nlif_handle != NULL);
+	assert(h != NULL);
 
-	if (nlif_handle->rtnl_handle)
-		return nlif_handle->rtnl_handle->rtnl_fd;
+	if (h->rtnl_handle)
+		return h->rtnl_handle->rtnl_fd;
 
 	return -1;
 }
diff --git a/src/rtnl.c b/src/rtnl.c
index 0206d30..29fc184 100644
--- a/src/rtnl.c
+++ b/src/rtnl.c
@@ -91,9 +91,10 @@ int rtnl_handler_unregister(struct rtnl_handle *rtnl_handle,
 	return 0;
 }
 
-/* rtnl_arse_rtattr - parse rtattr */
 int rtnl_parse_rtattr(struct rtattr *tb[], int max, struct rtattr *rta, int len)
 {
+	memset(tb, 0, sizeof(struct rtattr *) * max);
+
 	while (RTA_OK(rta, len)) {
 		if (rta->rta_type <= max)
 			tb[rta->rta_type] = rta;

--------------010400060000090100070706--

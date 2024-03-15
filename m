Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E80F14003
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488057; cv=none; b=R3ffOBYMc3gdz8q5b81RxNwhP+V0EBhR8DxKzY8pelUB+PGMn/jWuNo406ki1n41gI8IvWdhVssLuQBsQ2DxS1jw5Odcb7Hh9Os7u71XXMP+T8QSFwMmmP1VyQnWUFyzY5/v7beCQh3nPEZzJ01elAlZPi8O9yfhirnpnzifYcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488057; c=relaxed/simple;
	bh=7Sx+8by7WD/z6doyzULK5AVW5ICs+fSukt3Zsxv6vcs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L/wQKl/dkh5LcTS7x+/3eP15MB/Im7nnaPyTmDz2pDoGoy0KSohe02T5JEaJB4S8B+d7xh7OjcNpHv0+WHaT5xX+pE18KMFIxdsFNn0hqJfkEbXrlflm2FxuTJDoI17mbap71DyStPFGIK4JQ0olPW5idCbAYjoSFkuPDv6tpPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=imsaW3T3; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="imsaW3T3"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dddb160a37so13279455ad.2
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488054; x=1711092854; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ST7YQ+jNFyaPwUkk6LpODfbUNC32KeNIqWZvbE5lu9g=;
        b=imsaW3T3hqJGbBqg7jdwf9NNIWy2ZzcnFXAo74KQa57b0FKSWBFr7iuXw9q534KedV
         0qk6yqnTmVCfIvB9tcrtd5O+jmIDZwqoto+tXllTgkp/4wO5fgU3p7IWbvsniQcBFgBB
         GB5VP2X+UNbI36UQ4LiOjxo1DKZrraTUeFWCHoKjGxYMeEUQpOcy9vQsWEk0ViiPW8JY
         jYYx5ypljZBafyueM9YK70jeWwIYgbYitd5yltMw2W42tznlxjatui5ivfSCLF0rNTms
         ZRYGlpmGbsxNm6jagyCfVduuGHiXhS51gZuvI8KFXpGn+pOZATgGXmk10TK6kSzoHjhx
         sKhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488054; x=1711092854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ST7YQ+jNFyaPwUkk6LpODfbUNC32KeNIqWZvbE5lu9g=;
        b=Kp2dAxtGno5NVImKNRM9rzNT8F750/ET/TdirDRcRkF9hJdPkWnYzV2Ie5PMeIMJtX
         JvteCNQ1tQtG1lp5Kj5wAk6LZLXQQFzDh0n1S1nxKYZJCx5OQVNSE9my4CZRJ4d4zJ2Z
         WXLVWQ/NsxXvp9DeP+PCCIs7DoJdTYOlDJUtSq2upAIhNenCRVIfoaldbCT+NDDDofD+
         Yfrkj/vlzF663RrvTBFUK10ib5m1YUpLZ8bWjfPlPP9+T9ca4UGjBSW5tcqtHlJfqK4T
         /PFxFST5mDrVgeC9/SAaaK51ehn3co8/ym6PzH2rtU7130/7miai0JnhKXl+WWRf3IXl
         H9jQ==
X-Gm-Message-State: AOJu0Yy4VM/fUR9iFMHcWV6DDKJZmScp+ZFeYdxy4LiY2t4TQNzILC4g
	NSph69Im3IccsMJ9uP4q6tktYrhd9NDf0gW9k0zcJMVH2eZctTCrk9RI5Mfx
X-Google-Smtp-Source: AGHT+IGaoEpd5Sef7ECCmlVsskFMupPxQkt+SbmQRqrlHEc7JoBCQ91WcV7fhBj1u9vrKoak6ldbKw==
X-Received: by 2002:a17:902:bb17:b0:1dd:72ea:58cd with SMTP id im23-20020a170902bb1700b001dd72ea58cdmr4435017plb.3.1710488053622;
        Fri, 15 Mar 2024 00:34:13 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:13 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 12/32] src: Copy nlif-related code from libnfnetlink
Date: Fri, 15 Mar 2024 18:33:27 +1100
Message-Id: <20240315073347.22628-13-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <ZcyaQvJ1SvnYgakf@calendula>
References: <ZcyaQvJ1SvnYgakf@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These sources are for reviewer's reference. In particular, the libmnl
updates to rtnl.c are slated to be done in iftable.c so rtnl.c will be
removed after the libmnl updates are done.
linux_list.h raises a number of checkpatch errors.
These will be addresses in a later commit.
This patch doesn't actually do anything with the new files.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/libnetfilter_queue/linux_list.h | 727 ++++++++++++++++++++++++
 src/iftable.c                           | 348 ++++++++++++
 src/rtnl.c                              | 283 +++++++++
 3 files changed, 1358 insertions(+)
 create mode 100644 include/libnetfilter_queue/linux_list.h
 create mode 100644 src/iftable.c
 create mode 100644 src/rtnl.c

diff --git a/include/libnetfilter_queue/linux_list.h b/include/libnetfilter_queue/linux_list.h
new file mode 100644
index 0000000..cf71837
--- /dev/null
+++ b/include/libnetfilter_queue/linux_list.h
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
+#define prefetch(x) ((void)0)
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
new file mode 100644
index 0000000..aab59b3
--- /dev/null
+++ b/src/iftable.c
@@ -0,0 +1,348 @@
+/* iftable - table of network interfaces
+ *
+ * (C) 2004 by Astaro AG, written by Harald Welte <hwelte@astaro.com>
+ * (C) 2008 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This software is Free Software and licensed under GNU GPLv2+.
+ */
+
+/* IFINDEX handling */
+
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/types.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <errno.h>
+#include <assert.h>
+
+#include <linux/netdevice.h>
+
+#include <libnfnetlink/libnfnetlink.h>
+#include "rtnl.h"
+#include "linux_list.h"
+
+/**
+ * \defgroup iftable Functions in iftable.c [DEPRECATED]
+ * This documentation is provided for the benefit of maintainers of legacy code.
+ *
+ * New applications should use
+ * [libmnl](https://netfilter.org/projects/libmnl/doxygen/html/).
+ * @{
+ */
+
+struct ifindex_node {
+	struct list_head head;
+
+	uint32_t	index;
+	uint32_t	type;
+	uint32_t	alen;
+	uint32_t	flags;
+	char		addr[8];
+	char		name[16];
+};
+
+struct nlif_handle {
+	struct list_head ifindex_hash[16];
+	struct rtnl_handle *rtnl_handle;
+	struct rtnl_handler ifadd_handler;
+	struct rtnl_handler ifdel_handler;
+};
+
+/* iftable_add - Add/Update an entry to/in the interface table
+ * @n:		netlink message header of a RTM_NEWLINK message
+ * @arg:	not used
+ *
+ * This function adds/updates an entry in the intrface table.
+ * Returns -1 on error, 1 on success.
+ */
+static int iftable_add(struct nlmsghdr *n, void *arg)
+{
+	unsigned int hash, found = 0;
+	struct ifinfomsg *ifi_msg = NLMSG_DATA(n);
+	struct ifindex_node *this;
+	struct rtattr *cb[IFLA_MAX+1];
+	struct nlif_handle *h = arg;
+
+	if (n->nlmsg_type != RTM_NEWLINK)
+		return -1;
+
+	if (n->nlmsg_len < NLMSG_LENGTH(sizeof(ifi_msg)))
+		return -1;
+
+	rtnl_parse_rtattr(cb, IFLA_MAX, IFLA_RTA(ifi_msg), IFLA_PAYLOAD(n));
+
+	if (!cb[IFLA_IFNAME])
+		return -1;
+
+	hash = ifi_msg->ifi_index & 0xF;
+	list_for_each_entry(this, &h->ifindex_hash[hash], head) {
+		if (this->index == ifi_msg->ifi_index) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found) {
+		this = malloc(sizeof(*this));
+		if (!this)
+			return -1;
+
+		this->index = ifi_msg->ifi_index;
+	}
+
+	this->type = ifi_msg->ifi_type;
+	this->flags = ifi_msg->ifi_flags;
+	if (cb[IFLA_ADDRESS]) {
+		unsigned int alen;
+		this->alen = alen = RTA_PAYLOAD(cb[IFLA_ADDRESS]);
+		if (alen > sizeof(this->addr))
+			alen = sizeof(this->addr);
+		memcpy(this->addr, RTA_DATA(cb[IFLA_ADDRESS]), alen);
+	} else {
+		this->alen = 0;
+		memset(this->addr, 0, sizeof(this->addr));
+	}
+	strcpy(this->name, RTA_DATA(cb[IFLA_IFNAME]));
+
+	if (!found)
+		list_add(&this->head, &h->ifindex_hash[hash]);
+
+	return 1;
+}
+
+/* iftable_del - Delete an entry from the interface table
+ * @n:		netlink message header of a RTM_DELLINK nlmsg
+ * @arg:	not used
+ *
+ * Delete an entry from the interface table.  
+ * Returns -1 on error, 0 if no matching entry was found or 1 on success.
+ */
+static int iftable_del(struct nlmsghdr *n, void *arg)
+{
+	struct ifinfomsg *ifi_msg = NLMSG_DATA(n);
+	struct rtattr *cb[IFLA_MAX+1];
+	struct nlif_handle *h = arg;
+	struct ifindex_node *this, *tmp;
+	unsigned int hash;
+
+	if (n->nlmsg_type != RTM_DELLINK)
+		return -1;
+
+	if (n->nlmsg_len < NLMSG_LENGTH(sizeof(ifi_msg)))
+		return -1;
+
+	rtnl_parse_rtattr(cb, IFLA_MAX, IFLA_RTA(ifi_msg), IFLA_PAYLOAD(n));
+
+	hash = ifi_msg->ifi_index & 0xF;
+	list_for_each_entry_safe(this, tmp, &h->ifindex_hash[hash], head) {
+		if (this->index == ifi_msg->ifi_index) {
+			list_del(&this->head);
+			free(this);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+/** Get the name for an ifindex
+ *
+ * \param nlif_handle A pointer to a ::nlif_handle created
+ * \param index ifindex to be resolved
+ * \param name interface name, pass a buffer of IFNAMSIZ size
+ * \return -1 on error, 1 on success 
+ */
+int nlif_index2name(struct nlif_handle *h, 
+		    unsigned int index,
+		    char *name)
+{
+	unsigned int hash;
+	struct ifindex_node *this;
+
+	assert(h != NULL);
+	assert(name != NULL);
+
+	if (index == 0) {
+		strcpy(name, "*");
+		return 1;
+	}
+
+	hash = index & 0xF;
+	list_for_each_entry(this, &h->ifindex_hash[hash], head) {
+		if (this->index == index) {
+			strcpy(name, this->name);
+			return 1;
+		}
+	}
+
+	errno = ENOENT;
+	return -1;
+}
+
+/** Get the flags for an ifindex
+ *
+ * \param nlif_handle A pointer to a ::nlif_handle created
+ * \param index ifindex to be resolved
+ * \param flags pointer to variable used to store the interface flags
+ * \return -1 on error, 1 on success 
+ */
+int nlif_get_ifflags(const struct nlif_handle *h,
+		     unsigned int index,
+		     unsigned int *flags)
+{
+	unsigned int hash;
+	struct ifindex_node *this;
+
+	assert(h != NULL);
+	assert(flags != NULL);
+
+	if (index == 0) {
+		errno = ENOENT;
+		return -1;
+	}
+
+	hash = index & 0xF;
+	list_for_each_entry(this, &h->ifindex_hash[hash], head) {
+		if (this->index == index) {
+			*flags = this->flags;
+			return 1;
+		}
+	}
+	errno = ENOENT;
+	return -1;
+}
+
+/** Initialize interface table
+ *
+ * Initialize rtnl interface and interface table
+ * Call this before any nlif_* function
+ *
+ * \return file descriptor to netlink socket
+ */
+struct nlif_handle *nlif_open(void)
+{
+	int i;
+	struct nlif_handle *h;
+
+	h = calloc(1,  sizeof(struct nlif_handle));
+	if (h == NULL)
+		goto err;
+
+	for (i=0; i<16; i++)
+		INIT_LIST_HEAD(&h->ifindex_hash[i]);
+
+	h->ifadd_handler.nlmsg_type = RTM_NEWLINK;
+	h->ifadd_handler.handlefn = iftable_add;
+	h->ifadd_handler.arg = h;
+	h->ifdel_handler.nlmsg_type = RTM_DELLINK;
+	h->ifdel_handler.handlefn = iftable_del;
+	h->ifdel_handler.arg = h;
+
+	h->rtnl_handle = rtnl_open();
+	if (h->rtnl_handle == NULL)
+		goto err;
+
+	if (rtnl_handler_register(h->rtnl_handle, &h->ifadd_handler) < 0)
+		goto err_close;
+
+	if (rtnl_handler_register(h->rtnl_handle, &h->ifdel_handler) < 0)
+		goto err_unregister;
+
+	return h;
+
+err_unregister:
+	rtnl_handler_unregister(h->rtnl_handle, &h->ifadd_handler);
+err_close:
+	rtnl_close(h->rtnl_handle);
+	free(h);
+err:
+	return NULL;
+}
+
+/** Destructor of interface table
+ *
+ * \param nlif_handle A pointer to a ::nlif_handle created 
+ * via nlif_open()
+ */
+void nlif_close(struct nlif_handle *h)
+{
+	int i;
+	struct ifindex_node *this, *tmp;
+
+	assert(h != NULL);
+
+	rtnl_handler_unregister(h->rtnl_handle, &h->ifadd_handler);
+	rtnl_handler_unregister(h->rtnl_handle, &h->ifdel_handler);
+	rtnl_close(h->rtnl_handle);
+
+	for (i=0; i<16; i++) {
+		list_for_each_entry_safe(this, tmp, &h->ifindex_hash[i], head) {
+			list_del(&this->head);
+			free(this);
+		}
+	}
+
+	free(h);
+	h = NULL; /* bugtrap */
+}
+
+/** Receive message from netlink and update interface table
+ *
+ * \param nlif_handle A pointer to a ::nlif_handle created
+ * \return 0 if OK
+ */
+int nlif_catch(struct nlif_handle *h)
+{
+	assert(h != NULL);
+
+	if (h->rtnl_handle)
+		return rtnl_receive(h->rtnl_handle);
+
+	return -1;
+}
+
+static int nlif_catch_multi(struct nlif_handle *h)
+{
+	assert(h != NULL);
+
+	if (h->rtnl_handle)
+		return rtnl_receive_multi(h->rtnl_handle);
+
+	return -1;
+}
+
+/** 
+ * nlif_query - request a dump of interfaces available in the system
+ * @h: pointer to a valid nlif_handler
+ */
+int nlif_query(struct nlif_handle *h)
+{
+	assert(h != NULL);
+
+	if (rtnl_dump_type(h->rtnl_handle, RTM_GETLINK) < 0)
+		return -1;
+
+	return nlif_catch_multi(h);
+}
+
+/** Returns socket descriptor for the netlink socket
+ *
+ * \param nlif_handle A pointer to a ::nlif_handle created
+ * \return The fd or -1 if there's an error
+ */
+int nlif_fd(struct nlif_handle *h)
+{
+	assert(h != NULL);
+
+	if (h->rtnl_handle)
+		return h->rtnl_handle->rtnl_fd;
+
+	return -1;
+}
+
+/**
+ * @}
+ */
diff --git a/src/rtnl.c b/src/rtnl.c
new file mode 100644
index 0000000..dff3bef
--- /dev/null
+++ b/src/rtnl.c
@@ -0,0 +1,283 @@
+/* rtnl - rtnetlink utility functions
+ *
+ * (C) 2004 by Astaro AG, written by Harald Welte <hwelte@astaro.com>
+ *
+ * Adapted to nfnetlink by Eric Leblond <eric@inl.fr>
+ *
+ * This software is free software and licensed under GNU GPLv2+.
+ *
+ */
+
+/* rtnetlink - routing table netlink interface */
+
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <time.h>
+#include <sys/types.h>
+#include <sys/uio.h>
+
+#include <netinet/in.h>
+
+#include <linux/types.h>
+#include <sys/socket.h>
+#include <linux/netlink.h>
+#include <linux/rtnetlink.h>
+
+#include "rtnl.h"
+
+#define rtnl_log(x, ...)
+
+static inline struct rtnl_handler *
+find_handler(struct rtnl_handle *rtnl_handle, uint16_t type)
+{
+	struct rtnl_handler *h;
+	for (h = rtnl_handle->handlers; h; h = h->next) {
+		if (h->nlmsg_type == type)
+			return h;
+	}
+	return NULL;
+}
+
+static int call_handler(struct rtnl_handle *rtnl_handle,
+			uint16_t type,
+			struct nlmsghdr *hdr)
+{
+	struct rtnl_handler *h = find_handler(rtnl_handle, type);
+
+	if (!h) {
+		rtnl_log(LOG_DEBUG, "no registered handler for type %u", type);
+		return 0;
+	}
+
+	return (h->handlefn)(hdr, h->arg);
+}
+
+/**
+ * \defgroup rtnetlink Functions in rtnl.c [DEPRECATED]
+ * This documentation is provided for the benefit of maintainers of legacy code.
+ *
+ * New applications should use
+ * [libmnl](https://netfilter.org/projects/libmnl/doxygen/html/).
+ * @{
+ */
+
+/**
+ * rtnl_handler_register - register handler for given nlmsg type
+ * \param: rtnl_handle: Handler ftom rtnl_open()
+ * \param: hdlr: callback handler structure
+ */
+int rtnl_handler_register(struct rtnl_handle *rtnl_handle,
+			  struct rtnl_handler *hdlr)
+{
+	rtnl_log(LOG_DEBUG, "registering handler for type %u",
+		 hdlr->nlmsg_type);
+	hdlr->next = rtnl_handle->handlers;
+	rtnl_handle->handlers = hdlr;
+	return 1;
+}
+
+/**
+ * rtnl_handler_unregister - unregister handler for given nlmst type
+ * \param: hdlr: callback handler structure
+ * \param: hdlr:	handler structure
+ */
+int rtnl_handler_unregister(struct rtnl_handle *rtnl_handle,
+			    struct rtnl_handler *hdlr)
+{
+	struct rtnl_handler *h, *prev = NULL;
+
+	rtnl_log(LOG_DEBUG, "unregistering handler for type %u",
+		 hdlr->nlmsg_type);
+
+	for (h = rtnl_handle->handlers; h; h = h->next) {
+		if (h == hdlr) {
+			if (prev)
+				prev->next = h->next;
+			else
+				rtnl_handle->handlers = h->next;
+			return 1;
+		}
+		prev = h;
+	}
+	return 0;
+}
+
+int rtnl_parse_rtattr(struct rtattr *tb[], int max, struct rtattr *rta, int len)
+{
+	memset(tb, 0, sizeof(struct rtattr *) * max);
+
+	while (RTA_OK(rta, len)) {
+		if (rta->rta_type <= max)
+			tb[rta->rta_type] = rta;
+		rta = RTA_NEXT(rta,len);
+	}
+	if (len)
+		return -1;
+	return 0;
+}
+
+/* rtnl_dump_type - ask rtnetlink to dump a specific table
+ * \param: type:	type of table to be dumped
+ */
+int rtnl_dump_type(struct rtnl_handle *rtnl_handle, unsigned int type)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct rtgenmsg g;
+	} req;
+	struct sockaddr_nl nladdr;
+
+	memset(&nladdr, 0, sizeof(nladdr));
+	memset(&req, 0, sizeof(req));
+	nladdr.nl_family = AF_NETLINK;
+
+	req.nlh.nlmsg_len = sizeof(req);
+	req.nlh.nlmsg_type = type;
+	req.nlh.nlmsg_flags = NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST;
+	req.nlh.nlmsg_pid = 0;
+	req.nlh.nlmsg_seq = rtnl_handle->rtnl_dump = ++(rtnl_handle->rtnl_seq);
+	req.g.rtgen_family = AF_INET;
+
+	return sendto(rtnl_handle->rtnl_fd, &req, sizeof(req), 0,
+		      (struct sockaddr*)&nladdr, sizeof(nladdr));
+}
+
+/* rtnl_receive - receive netlink packets from rtnetlink socket */
+int rtnl_receive(struct rtnl_handle *rtnl_handle)
+{
+	int status;
+	char buf[8192];
+	struct sockaddr_nl nladdr;
+	struct iovec iov = { buf, sizeof(buf) };
+	struct nlmsghdr *h;
+
+	struct msghdr msg = {
+		.msg_name    = &nladdr,
+		.msg_namelen = sizeof(nladdr),
+		.msg_iov     = &iov,
+		.msg_iovlen  = 1,
+	};
+
+	status = recvmsg(rtnl_handle->rtnl_fd, &msg, 0);
+	if (status < 0) {
+		if (errno == EINTR)
+			return 0;
+		rtnl_log(LOG_NOTICE, "OVERRUN on rtnl socket");
+		return -1;
+	}
+	if (status == 0) {
+		rtnl_log(LOG_ERROR, "EOF on rtnl socket");
+		return -1;
+	}
+	if (msg.msg_namelen != sizeof(nladdr)) {
+		rtnl_log(LOG_ERROR, "invalid address size");
+		return -1;
+	}
+
+	h = (struct nlmsghdr *) buf;
+	while (NLMSG_OK(h, status)) {
+#if 0
+		if (h->nlmsg_pid != rtnl_local.nl_pid ||
+		    h->nlmsg_seq != rtnl_dump) {
+			goto skip;
+		}
+#endif
+
+		if (h->nlmsg_type == NLMSG_DONE) {
+			rtnl_log(LOG_NOTICE, "NLMSG_DONE");
+			return 0;
+		}
+		if (h->nlmsg_type == NLMSG_ERROR) {
+			struct nlmsgerr *err = NLMSG_DATA(h);
+			if (h->nlmsg_len>=NLMSG_LENGTH(sizeof(struct nlmsgerr)))
+				errno = -err->error;
+			rtnl_log(LOG_ERROR, "NLMSG_ERROR, errnp=%d",
+				 errno);
+			return -1;
+		}
+
+		if (call_handler(rtnl_handle, h->nlmsg_type, h) == 0)
+			rtnl_log(LOG_NOTICE, "unhandled nlmsg_type %u",
+				 h->nlmsg_type);
+		h = NLMSG_NEXT(h, status);
+	}
+	return 1;
+}
+
+int rtnl_receive_multi(struct rtnl_handle *rtnl_handle)
+{
+	while (1) {
+		if (rtnl_receive(rtnl_handle) <= 0)
+			break;
+	}
+	return 1;
+}
+
+/* rtnl_open - constructor of rtnetlink module */
+struct rtnl_handle *rtnl_open(void)
+{
+	socklen_t addrlen;
+	struct rtnl_handle *h;
+
+	h = calloc(1, sizeof(struct rtnl_handle));
+	if (!h)
+		return NULL;
+
+	addrlen = sizeof(h->rtnl_local);
+
+	h->rtnl_local.nl_pid = getpid();
+	h->rtnl_fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
+	if (h->rtnl_fd < 0) {
+		rtnl_log(LOG_ERROR, "unable to create rtnetlink socket");
+		goto err;
+	}
+
+	memset(&h->rtnl_local, 0, sizeof(h->rtnl_local));
+	h->rtnl_local.nl_family = AF_NETLINK;
+	h->rtnl_local.nl_groups = RTMGRP_LINK;
+	if (bind(h->rtnl_fd, (struct sockaddr *) &h->rtnl_local, addrlen) < 0) {
+		rtnl_log(LOG_ERROR, "unable to bind rtnetlink socket");
+		goto err_close;
+	}
+
+	if (getsockname(h->rtnl_fd,
+			(struct sockaddr *) &h->rtnl_local,
+			&addrlen) < 0) {
+		rtnl_log(LOG_ERROR, "cannot gescockname(rtnl_socket)");
+		goto err_close;
+	}
+
+	if (addrlen != sizeof(h->rtnl_local)) {
+		rtnl_log(LOG_ERROR, "invalid address size %u", addr_len);
+		goto err_close;
+	}
+
+	if (h->rtnl_local.nl_family != AF_NETLINK) {
+		rtnl_log(LOG_ERROR, "invalid AF %u", h->rtnl_local.nl_family);
+		goto err_close;
+	}
+
+	h->rtnl_seq = time(NULL);
+
+	return h;
+
+err_close:
+	close(h->rtnl_fd);
+err:
+	free(h);
+	return NULL;
+}
+
+/* rtnl_close - destructor of rtnetlink module */
+void rtnl_close(struct rtnl_handle *rtnl_handle)
+{
+	close(rtnl_handle->rtnl_fd);
+	free(rtnl_handle);
+	return;
+}
+
+/**
+ * @}
+ */
-- 
2.35.8


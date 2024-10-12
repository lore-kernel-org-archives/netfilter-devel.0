Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9877219CC0C
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774592; cv=none; b=gNHHhA80DodpjTZwIpV+U45LN3sigESKBiH6vOZnKI3RQABij6UDgCEBnn3NsaXocneECUE8/0IEi7rUSF20lGJoJOSGzRAUB3XshRJH96s6/grakyTM4fDlYsIEVCHI6gcnm2Yui2PLDSJs9cESCGo80rckCscy07telKkdFOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774592; c=relaxed/simple;
	bh=8gBJf5d5Xl2o6iiPNnzwLJt5ACvfZILezMmXpAd3BUQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kyu6MPsyEsOkmJi5WorQ0kwjqGbH6Ajvknp0lWQ4D+NvBfYJckzhVHFWNnDQYkmBTo7a5AIThZ8l2jklm8w3Y/+aseSnCwqIchJ08LvLSTNeZvgnjrbNhPcebUP66uUDMqMUCFk0aga734Zeys9yPOf1txl6bliH2ZNDkDtiWys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IVwtw617; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IVwtw617"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-71e49ef3bb9so797742b3a.1
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728774589; x=1729379389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iMdu56MWFl9v1Lv0mwqCsWQTpyZJp69abm4qU9f+U8Y=;
        b=IVwtw617ojYB/04idgtFu3YSJ+4xKwZLQFyWfr0pC8wFMJGjsAAEaUIp20nEtg4R0N
         UGi0S4yMb8xPporU+9eRTQO6uj0iYfXhAc20U6g4LKOr8t/IGqAU204U+0clas54H/dQ
         gxEjlyWsVXTeOfiGoGPZDfsxRJlsIh+Oo5VerNPKpT7kjRLnGrWgD5XqgDdo+U5BOQ44
         ZDVyb12s02zVgGsmapDBtEe8EuEeXQjCnaFqOhVeuOoVatc76Csof+nMyQ7AX2/bYBnn
         /obBEdkPdk8369RMsPzjO/F5sXXXrTGhrHsoqYtmb3gzlAdQCMGUz5YqNJNKYCwqYWtH
         zSyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728774589; x=1729379389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iMdu56MWFl9v1Lv0mwqCsWQTpyZJp69abm4qU9f+U8Y=;
        b=hjvT9iCCWwsiii6rsW3Rpy4HDnMq3yQSjjk1zvNol5dSwUKk9loYZaTRapHGGfVi1k
         l7bimrULtVToTtsckuzys9x4RHMKzcemJQNYO4FVXAXPdyeO7YOZokKZXI1NjHEEpCDu
         VCY6plo4cXBdNDzeHEIkX3XUo80Xu6E9NF+ajhZW/3ubA/TmeOs6lLJobppJ2DuMmI6V
         TtNlYOxKz2KrJCDABPJ3Wy56PhjoDsW0SuTqT5E9EQ7USj/DJYbHk+fkF7GWkDYPEmgR
         62jVZuY63yy5oMiM4mDosLte2vzokKh+2B4ivFeJ7A5MdP2jWQnuFfAvF4+TGlCGj/uE
         myzg==
X-Gm-Message-State: AOJu0Yz5hzBt83SBQYH7A5yoG5Q+SLSXzDpQAZ3+mHSb6S1kqXdxfHWs
	hw9iTkcFC371Q3rRE8s1SF7rhsnbkScZfN3g09qWLbLqUpGy9nKe0wvbTQ==
X-Google-Smtp-Source: AGHT+IFuI9jPy+GDAlKlysGrI9x0D1rKxDIBsoS3brdcFcER49tYnYEQOzAouLRhUIwIPO5j/ioSWQ==
X-Received: by 2002:a05:6a00:a87:b0:717:8b4e:a17f with SMTP id d2e1a72fcca58-71e378d4862mr9250558b3a.4.1728774588546;
        Sat, 12 Oct 2024 16:09:48 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aab5bf9sm4854195b3a.145.2024.10.12.16.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:09:47 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 11/15] src: Copy nlif-related files from libnfnetlink
Date: Sun, 13 Oct 2024 10:09:13 +1100
Message-Id: <20241012230917.11467-12-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20241012230917.11467-1-duncan_roe@optusnet.com.au>
References: <20241012230917.11467-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce include/libnetfilter_queue/linux_list.h and src/iftable.c.
These are not exact copies: all tractable checkpatch errors are fixed.
Also complete iftable.c kerneldoc to doxygen translation.
This commit doesn't actually do anything with the new files.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Changes in v3:
 - Move doxygen.cfg changes to here from patch 12/15
   (otherwise if no more patches are applied then man pages don't build)

 Changes in v2:
 - This was originally patch 12 of 32
 - Update commit message
 - Don't copy src/rtnl.c since it's not kept
 - Fix checkpatch errors on the fly.
 - Finish kerneldoc xlation on the fly (was patch 16 of 32).

 doxygen/doxygen.cfg.in                  |  2 ++
 include/libnetfilter_queue/linux_list.h | 730 ++++++++++++++++++++++++
 src/iftable.c                           | 355 ++++++++++++
 3 files changed, 1087 insertions(+)
 create mode 100644 include/libnetfilter_queue/linux_list.h
 create mode 100644 src/iftable.c

diff --git a/doxygen/doxygen.cfg.in b/doxygen/doxygen.cfg.in
index fcfc045..bf6cba8 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -16,6 +16,8 @@ EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
                          nfnl_handle \
                          nfnl_subsys_handle \
                          mnl_socket \
+                         ifindex_node \
+                         nlif_handle \
                          nfnl_callback2 \
                          tcp_flag_word
 EXAMPLE_PATTERNS       =
diff --git a/include/libnetfilter_queue/linux_list.h b/include/libnetfilter_queue/linux_list.h
new file mode 100644
index 0000000..68637c3
--- /dev/null
+++ b/include/libnetfilter_queue/linux_list.h
@@ -0,0 +1,730 @@
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
+	typeof(((type *)0)->member) *__mptr = (ptr);	\
+	(type *)((char *)__mptr - offsetof(type, member)); })
+
+/*
+ * Check at compile time that something is of a particular type.
+ * Always evaluates to 1 so you may use it easily in comparisons.
+ */
+#define typecheck(type, x) \
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
+#define smp_wmb()  /* Comment to placate checkpatch */
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
+static inline void __list_add_rcu(struct list_head *new,
+		struct list_head *prev, struct list_head *next)
+{
+	new->next = next;
+	new->prev = prev;
+	smp_wmb(); /* Comment to placate checkpatch */
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
+static inline void __list_del(struct list_head *prev, struct list_head *next)
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
+	__list_del(list->prev, list->next);
+	list_add(list, head);
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
+	__list_del(list->prev, list->next);
+	list_add_tail(list, head);
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
+
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
+		pos = pos->next, prefetch(pos->next))
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
+		pos = pos->prev, prefetch(pos->prev))
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
+		     prefetch(pos->member.next);		\
+	     &pos->member != (head);					\
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
+	     &pos->member != (head);					\
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
+#define list_for_each_entry_continue(pos, head, member)		\
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
+	     &pos->member != (head);					\
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
+		pos = pos->next, ({ smp_read_barrier_depends(); 0; }), prefetch(pos->next))
+
+#define __list_for_each_rcu(pos, head) \
+	for (pos = (head)->next; pos != (head); \
+		pos = pos->next, ({ smp_read_barrier_depends(); 0; }))
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
+		pos = n, ({ smp_read_barrier_depends(); 0; }), n = pos->next)
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
+	     &pos->member != (head);					\
+	     pos = list_entry(pos->member.next, typeof(*pos), member),	\
+		     ({ smp_read_barrier_depends(); 0; }),		\
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
+		(pos) = (pos)->next, ({ smp_read_barrier_depends(); 0; }), prefetch((pos)->next))
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
+
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
+
+	n->next = first;
+	n->pprev = &h->first;
+	smp_wmb(); /* Comment to placate checkpatch */
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
+	if (next->next)
+		next->next->pprev  = &next->next;
+}
+
+#define hlist_entry(ptr, type, member) container_of(ptr, type, member)
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
+	     pos && ({ prefetch(pos->next); 1; }) &&			 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
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
+	     pos && ({ prefetch(pos->next); 1; }) &&			 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
+	     pos = pos->next)
+
+/**
+ * hlist_for_each_entry_from - iterate over a hlist continuing from existing point
+ * @tpos:	the type * to use as a loop counter.
+ * @pos:	the &struct hlist_node to use as a loop counter.
+ * @member:	the name of the hlist_node within the struct.
+ */
+#define hlist_for_each_entry_from(tpos, pos, member)			 \
+	for (; pos && ({ prefetch(pos->next); 1; }) &&			 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
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
+#define hlist_for_each_entry_safe(tpos, pos, n, head, member)		 \
+	for (pos = (head)->first;					 \
+	     pos && ({ n = pos->next; 1; }) &&				 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
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
+	     pos && ({ prefetch(pos->next); 1; }) &&			 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
+	     pos = pos->next, ({ smp_read_barrier_depends(); 0; }))
+
+#endif
diff --git a/src/iftable.c b/src/iftable.c
new file mode 100644
index 0000000..4673001
--- /dev/null
+++ b/src/iftable.c
@@ -0,0 +1,355 @@
+/* iftable - table of network interfaces
+ *
+ * (C) 2004 by Astaro AG, written by Harald Welte <hwelte@astaro.com>
+ * (C) 2008 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2024 by Duncan Roe <duncan_roe@optusnet.com.au>
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
+ * \defgroup iftable Functions to manage a table of network interfaces
+ * These functions maintain a database of the name and flags of each
+ * network interface.
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
+ * \param n:	netlink message header of a RTM_NEWLINK message
+ * \param arg:	not used
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
+
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
+ * \param n:	netlink message header of a RTM_DELLINK nlmsg
+ * \param arg:	not used
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
+/**
+ * nlif_index2name - get the name for an ifindex
+ *
+ * \param h pointer to nlif_handle created by nlif_open()
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
+/**
+ * nlif_get_ifflags - get the flags for an ifindex
+ *
+ * \param h pointer to nlif_handle created by nlif_open()
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
+/**
+ * nlif_open - initialize interface table
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
+	for (i = 0; i < 16; i++)
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
+/**
+ * nlif_close - free all resources associated with the interface table
+ *
+ * \param h pointer to nlif_handle created by nlif_open()
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
+	for (i = 0; i < 16; i++) {
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
+/**
+ * nlif_catch - receive message from netlink and update interface table
+ *
+ * FIXME - elaborate a bit
+ *
+ * \param h pointer to nlif_handle created by nlif_open()
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
+ * \param h: pointer to a valid nlif_handler
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
+/**
+ * nlif_fd - get file descriptor for the netlink socket
+ *
+ * \param h pointer to nlif_handle created by nlif_open()
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
-- 
2.35.8


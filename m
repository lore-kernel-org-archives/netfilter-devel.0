Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656741429B
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488058; cv=none; b=ZQss8sHsUxNHzcukAJcfnP1IMpXfL+wWPguvpunwUOKoTbX/OiWZxFQWLgfJ3OZ5aCJBgFIsZfqZhh1ZrDYCFmL+GDhRBflYHiYKF/JRC92GSrlkEZrkkj7KrdTo3Qo6z/F9OWe/3AblTIEYPGSABPJFqD2FzCj7BeFUjg/lHac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488058; c=relaxed/simple;
	bh=l+O8bTAGXtBkC2FR/no0Y3OHs24R5QZeUX/A6BAlp3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qZvs2fHPrOjZOoLTMg4ejuNMwGGp6ok3d5oRGFNiXpj+F7CA0E7X5E3tFc7By/Zu7GsqXqsD88DqlVFEo68A9EqVHltyC5q0P3NSjLkVVWSRkRfysEEF7CGLZ8Qi5SNEGkXQfDImcj2yl5J5qgmKPJukIvcKbcepVbs1W2gHwqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nLzulRpf; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nLzulRpf"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1def2a1aafaso1205315ad.3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488056; x=1711092856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gDNVRnv4nhULSeFVMVhozxtkThF010MskmYuYLkQqpE=;
        b=nLzulRpfIQ3CpcyoBjitSBCXmvlteC0r+OAqt//ZIersoufqtDKx6SNgcqpJxfpA6x
         Q7JE7nCveoAKkqOfWZ0lfRfQU4nYzNMeLMKf9dF8xkVAUjwi/eTe/SmzpBh0XjHYNUO4
         qwOu1Odh/gjqXXBS9fKvGysp0w0Di7DTndzMD/4XIy40w05bVmJfCrVVOJOGA6sqkRcW
         4u+QlGNQIJNz+XMtT5/D4a82mXFpuf/hNiH5FHt8d5F7SOwRlfah7iv7S+Um6WMquJar
         jT+uUc3rSEH/6pACm2FqjSWchBgZwJbJHexSuzYiV2XFHghl7OLiPmCbCn8bRQojbo9X
         uo6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488056; x=1711092856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gDNVRnv4nhULSeFVMVhozxtkThF010MskmYuYLkQqpE=;
        b=iqjJYfQz/ul/xzcS5/oN9yknY+W/KwEU7nqdHKlDRqtIwm8x+myzh7pzy2OzJRLlMB
         gGVeyNqb8ceKNB3XwB/+RSDvM8SjEC6LzwJL/IzRltPyx7PdJIb3loacDq7Pxqsnbqsn
         l0e+cEaP/f3pGVqDNNT5HOuK1vrqletnmpSAgltPzxXZ3ZEqnS7hfI1QKe3BSzeUapj5
         9rGzvV9dbg6z/kkaEtcrJiTqx8Y7a9otvgEtWT+oRs0zkqvKDShTzVGjghRl1WhAnknH
         x6HlEhpi0mIm/pRnSAJJEEWZtqVThwgW8sgERC64FWN0tXVA2zk/PITkN19mIOaa5tGV
         nMuQ==
X-Gm-Message-State: AOJu0YycTkjEgxfVlYpEIgyuHsh5Y4tI+r6gI5+oFPHiprBtqBgdggvo
	QBX2dO3ghnaSlKJ0P94q5MK32+yARHuNer2DHDd13FKcfd0fDbGnzNx+6OEc
X-Google-Smtp-Source: AGHT+IEViC3uMuNtQl9aX0lmB75ely9c/t3WooKifsXQRsFGjGZMqR6Fwqj+Bhea3NycDzXLf5iiEg==
X-Received: by 2002:a17:903:248:b0:1dc:b73b:ec35 with SMTP id j8-20020a170903024800b001dcb73bec35mr2744218plh.4.1710488055392;
        Fri, 15 Mar 2024 00:34:15 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:15 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 13/32] include: Cherry-pick macros and functions that nlif will need
Date: Fri, 15 Mar 2024 18:33:28 +1100
Message-Id: <20240315073347.22628-14-duncan_roe@optusnet.com.au>
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

linux_list.h has macros and functions that mnl-api programs may want to
use. Will have to add linux_list.h to the doxygen system,
so cut out stuff we don't need to document.
Update libnetfilter_queue.h to include linux_list.h.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .../libnetfilter_queue/libnetfilter_queue.h   |   1 +
 include/libnetfilter_queue/linux_list.h       | 586 +-----------------
 2 files changed, 7 insertions(+), 580 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 9327f8c..9bd9c43 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -16,6 +16,7 @@
 #include <sys/time.h>
 #include <libnfnetlink/libnfnetlink.h>
 
+#include <libnetfilter_queue/linux_list.h>
 #include <libnetfilter_queue/linux_nfnetlink_queue.h>
 
 #ifdef __cplusplus
diff --git a/include/libnetfilter_queue/linux_list.h b/include/libnetfilter_queue/linux_list.h
index cf71837..eaa9c07 100644
--- a/include/libnetfilter_queue/linux_list.h
+++ b/include/libnetfilter_queue/linux_list.h
@@ -6,6 +6,12 @@
 #undef offsetof
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
 
+/*
+ * This is a cut-down copy of libnfnetlink/include/linux_list.h which is itself
+ * an old snapshot of linux/include/linux/list.h.
+ * This file only contains what we use.
+ */
+
 /**
  * container_of - cast a member of a structure out to the containing structure
  *
@@ -18,24 +24,8 @@
         typeof( ((type *)0)->member ) *__mptr = (ptr);	\
         (type *)( (char *)__mptr - offsetof(type,member) );})
 
-/*
- * Check at compile time that something is of a particular type.
- * Always evaluates to 1 so you may use it easily in comparisons.
- */
-#define typecheck(type,x) \
-({	type __dummy; \
-	typeof(x) __dummy2; \
-	(void)(&__dummy == &__dummy2); \
-	1; \
-})
-
 #define prefetch(x) ((void)0)
 
-/* empty define to make this work in userspace -HW */
-#ifndef smp_wmb
-#define smp_wmb()
-#endif
-
 /*
  * These are non-NULL pointers that will result in page faults
  * under normal circumstances, used to verify that nobody uses
@@ -58,11 +48,6 @@ struct list_head {
 	struct list_head *next, *prev;
 };
 
-#define LIST_HEAD_INIT(name) { &(name), &(name) }
-
-#define LIST_HEAD(name) \
-	struct list_head name = LIST_HEAD_INIT(name)
-
 #define INIT_LIST_HEAD(ptr) do { \
 	(ptr)->next = (ptr); (ptr)->prev = (ptr); \
 } while (0)
@@ -96,78 +81,6 @@ static inline void list_add(struct list_head *new, struct list_head *head)
 	__list_add(new, head, head->next);
 }
 
-/**
- * list_add_tail - add a new entry
- * @new: new entry to be added
- * @head: list head to add it before
- *
- * Insert a new entry before the specified head.
- * This is useful for implementing queues.
- */
-static inline void list_add_tail(struct list_head *new, struct list_head *head)
-{
-	__list_add(new, head->prev, head);
-}
-
-/*
- * Insert a new entry between two known consecutive entries.
- *
- * This is only for internal list manipulation where we know
- * the prev/next entries already!
- */
-static inline void __list_add_rcu(struct list_head * new,
-		struct list_head * prev, struct list_head * next)
-{
-	new->next = next;
-	new->prev = prev;
-	smp_wmb();
-	next->prev = new;
-	prev->next = new;
-}
-
-/**
- * list_add_rcu - add a new entry to rcu-protected list
- * @new: new entry to be added
- * @head: list head to add it after
- *
- * Insert a new entry after the specified head.
- * This is good for implementing stacks.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as list_add_rcu()
- * or list_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * list_for_each_entry_rcu().
- */
-static inline void list_add_rcu(struct list_head *new, struct list_head *head)
-{
-	__list_add_rcu(new, head, head->next);
-}
-
-/**
- * list_add_tail_rcu - add a new entry to rcu-protected list
- * @new: new entry to be added
- * @head: list head to add it before
- *
- * Insert a new entry before the specified head.
- * This is useful for implementing queues.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as list_add_tail_rcu()
- * or list_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * list_for_each_entry_rcu().
- */
-static inline void list_add_tail_rcu(struct list_head *new,
-					struct list_head *head)
-{
-	__list_add_rcu(new, head->prev, head);
-}
-
 /*
  * Delete a list entry by making the prev/next entries
  * point to each other.
@@ -194,69 +107,6 @@ static inline void list_del(struct list_head *entry)
 	entry->prev = LIST_POISON2;
 }
 
-/**
- * list_del_rcu - deletes entry from list without re-initialization
- * @entry: the element to delete from the list.
- *
- * Note: list_empty on entry does not return true after this,
- * the entry is in an undefined state. It is useful for RCU based
- * lockfree traversal.
- *
- * In particular, it means that we can not poison the forward
- * pointers that may still be used for walking the list.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as list_del_rcu()
- * or list_add_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * list_for_each_entry_rcu().
- *
- * Note that the caller is not permitted to immediately free
- * the newly deleted entry.  Instead, either synchronize_kernel()
- * or call_rcu() must be used to defer freeing until an RCU
- * grace period has elapsed.
- */
-static inline void list_del_rcu(struct list_head *entry)
-{
-	__list_del(entry->prev, entry->next);
-	entry->prev = LIST_POISON2;
-}
-
-/**
- * list_del_init - deletes entry from list and reinitialize it.
- * @entry: the element to delete from the list.
- */
-static inline void list_del_init(struct list_head *entry)
-{
-	__list_del(entry->prev, entry->next);
-	INIT_LIST_HEAD(entry);
-}
-
-/**
- * list_move - delete from one list and add as another's head
- * @list: the entry to move
- * @head: the head that will precede our entry
- */
-static inline void list_move(struct list_head *list, struct list_head *head)
-{
-        __list_del(list->prev, list->next);
-        list_add(list, head);
-}
-
-/**
- * list_move_tail - delete from one list and add as another's tail
- * @list: the entry to move
- * @head: the head that will follow our entry
- */
-static inline void list_move_tail(struct list_head *list,
-				  struct list_head *head)
-{
-        __list_del(list->prev, list->next);
-        list_add_tail(list, head);
-}
-
 /**
  * list_empty - tests whether a list is empty
  * @head: the list to test.
@@ -265,66 +115,6 @@ static inline int list_empty(const struct list_head *head)
 {
 	return head->next == head;
 }
-
-/**
- * list_empty_careful - tests whether a list is
- * empty _and_ checks that no other CPU might be
- * in the process of still modifying either member
- *
- * NOTE: using list_empty_careful() without synchronization
- * can only be safe if the only activity that can happen
- * to the list entry is list_del_init(). Eg. it cannot be used
- * if another CPU could re-list_add() it.
- *
- * @head: the list to test.
- */
-static inline int list_empty_careful(const struct list_head *head)
-{
-	struct list_head *next = head->next;
-	return (next == head) && (next == head->prev);
-}
-
-static inline void __list_splice(struct list_head *list,
-				 struct list_head *head)
-{
-	struct list_head *first = list->next;
-	struct list_head *last = list->prev;
-	struct list_head *at = head->next;
-
-	first->prev = head;
-	head->next = first;
-
-	last->next = at;
-	at->prev = last;
-}
-
-/**
- * list_splice - join two lists
- * @list: the new list to add.
- * @head: the place to add it in the first list.
- */
-static inline void list_splice(struct list_head *list, struct list_head *head)
-{
-	if (!list_empty(list))
-		__list_splice(list, head);
-}
-
-/**
- * list_splice_init - join two lists and reinitialise the emptied list.
- * @list: the new list to add.
- * @head: the place to add it in the first list.
- *
- * The list at @list is reinitialised
- */
-static inline void list_splice_init(struct list_head *list,
-				    struct list_head *head)
-{
-	if (!list_empty(list)) {
-		__list_splice(list, head);
-		INIT_LIST_HEAD(list);
-	}
-}
-
 /**
  * list_entry - get the struct for this entry
  * @ptr:	the &struct list_head pointer.
@@ -334,47 +124,6 @@ static inline void list_splice_init(struct list_head *list,
 #define list_entry(ptr, type, member) \
 	container_of(ptr, type, member)
 
-/**
- * list_for_each	-	iterate over a list
- * @pos:	the &struct list_head to use as a loop counter.
- * @head:	the head for your list.
- */
-#define list_for_each(pos, head) \
-	for (pos = (head)->next, prefetch(pos->next); pos != (head); \
-        	pos = pos->next, prefetch(pos->next))
-
-/**
- * __list_for_each	-	iterate over a list
- * @pos:	the &struct list_head to use as a loop counter.
- * @head:	the head for your list.
- *
- * This variant differs from list_for_each() in that it's the
- * simplest possible list iteration code, no prefetching is done.
- * Use this for code that knows the list to be very short (empty
- * or 1 entry) most of the time.
- */
-#define __list_for_each(pos, head) \
-	for (pos = (head)->next; pos != (head); pos = pos->next)
-
-/**
- * list_for_each_prev	-	iterate over a list backwards
- * @pos:	the &struct list_head to use as a loop counter.
- * @head:	the head for your list.
- */
-#define list_for_each_prev(pos, head) \
-	for (pos = (head)->prev, prefetch(pos->prev); pos != (head); \
-        	pos = pos->prev, prefetch(pos->prev))
-
-/**
- * list_for_each_safe	-	iterate over a list safe against removal of list entry
- * @pos:	the &struct list_head to use as a loop counter.
- * @n:		another &struct list_head to use as temporary storage
- * @head:	the head for your list.
- */
-#define list_for_each_safe(pos, n, head) \
-	for (pos = (head)->next, n = pos->next; pos != (head); \
-		pos = n, n = pos->next)
-
 /**
  * list_for_each_entry	-	iterate over list of given type
  * @pos:	the type * to use as a loop counter.
@@ -388,43 +137,6 @@ static inline void list_splice_init(struct list_head *list,
 	     pos = list_entry(pos->member.next, typeof(*pos), member),	\
 		     prefetch(pos->member.next))
 
-/**
- * list_for_each_entry_reverse - iterate backwards over list of given type.
- * @pos:	the type * to use as a loop counter.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_for_each_entry_reverse(pos, head, member)			\
-	for (pos = list_entry((head)->prev, typeof(*pos), member),	\
-		     prefetch(pos->member.prev);			\
-	     &pos->member != (head); 					\
-	     pos = list_entry(pos->member.prev, typeof(*pos), member),	\
-		     prefetch(pos->member.prev))
-
-/**
- * list_prepare_entry - prepare a pos entry for use as a start point in
- *			list_for_each_entry_continue
- * @pos:	the type * to use as a start point
- * @head:	the head of the list
- * @member:	the name of the list_struct within the struct.
- */
-#define list_prepare_entry(pos, head, member) \
-	((pos) ? : list_entry(head, typeof(*pos), member))
-
-/**
- * list_for_each_entry_continue -	iterate over list of given type
- *			continuing after existing point
- * @pos:	the type * to use as a loop counter.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_for_each_entry_continue(pos, head, member) 		\
-	for (pos = list_entry(pos->member.next, typeof(*pos), member),	\
-		     prefetch(pos->member.next);			\
-	     &pos->member != (head);					\
-	     pos = list_entry(pos->member.next, typeof(*pos), member),	\
-		     prefetch(pos->member.next))
-
 /**
  * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
  * @pos:	the type * to use as a loop counter.
@@ -438,290 +150,4 @@ static inline void list_splice_init(struct list_head *list,
 	     &pos->member != (head); 					\
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
 
-/**
- * list_for_each_rcu	-	iterate over an rcu-protected list
- * @pos:	the &struct list_head to use as a loop counter.
- * @head:	the head for your list.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_rcu(pos, head) \
-	for (pos = (head)->next, prefetch(pos->next); pos != (head); \
-        	pos = pos->next, ({ smp_read_barrier_depends(); 0;}), prefetch(pos->next))
-
-#define __list_for_each_rcu(pos, head) \
-	for (pos = (head)->next; pos != (head); \
-        	pos = pos->next, ({ smp_read_barrier_depends(); 0;}))
-
-/**
- * list_for_each_safe_rcu	-	iterate over an rcu-protected list safe
- *					against removal of list entry
- * @pos:	the &struct list_head to use as a loop counter.
- * @n:		another &struct list_head to use as temporary storage
- * @head:	the head for your list.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_safe_rcu(pos, n, head) \
-	for (pos = (head)->next, n = pos->next; pos != (head); \
-		pos = n, ({ smp_read_barrier_depends(); 0;}), n = pos->next)
-
-/**
- * list_for_each_entry_rcu	-	iterate over rcu list of given type
- * @pos:	the type * to use as a loop counter.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_entry_rcu(pos, head, member)			\
-	for (pos = list_entry((head)->next, typeof(*pos), member),	\
-		     prefetch(pos->member.next);			\
-	     &pos->member != (head); 					\
-	     pos = list_entry(pos->member.next, typeof(*pos), member),	\
-		     ({ smp_read_barrier_depends(); 0;}),		\
-		     prefetch(pos->member.next))
-
-
-/**
- * list_for_each_continue_rcu	-	iterate over an rcu-protected list
- *			continuing after existing point.
- * @pos:	the &struct list_head to use as a loop counter.
- * @head:	the head for your list.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_continue_rcu(pos, head) \
-	for ((pos) = (pos)->next, prefetch((pos)->next); (pos) != (head); \
-        	(pos) = (pos)->next, ({ smp_read_barrier_depends(); 0;}), prefetch((pos)->next))
-
-/*
- * Double linked lists with a single pointer list head.
- * Mostly useful for hash tables where the two pointer list head is
- * too wasteful.
- * You lose the ability to access the tail in O(1).
- */
-
-struct hlist_head {
-	struct hlist_node *first;
-};
-
-struct hlist_node {
-	struct hlist_node *next, **pprev;
-};
-
-#define HLIST_HEAD_INIT { .first = NULL }
-#define HLIST_HEAD(name) struct hlist_head name = {  .first = NULL }
-#define INIT_HLIST_HEAD(ptr) ((ptr)->first = NULL)
-#define INIT_HLIST_NODE(ptr) ((ptr)->next = NULL, (ptr)->pprev = NULL)
-
-static inline int hlist_unhashed(const struct hlist_node *h)
-{
-	return !h->pprev;
-}
-
-static inline int hlist_empty(const struct hlist_head *h)
-{
-	return !h->first;
-}
-
-static inline void __hlist_del(struct hlist_node *n)
-{
-	struct hlist_node *next = n->next;
-	struct hlist_node **pprev = n->pprev;
-	*pprev = next;
-	if (next)
-		next->pprev = pprev;
-}
-
-static inline void hlist_del(struct hlist_node *n)
-{
-	__hlist_del(n);
-	n->next = LIST_POISON1;
-	n->pprev = LIST_POISON2;
-}
-
-/**
- * hlist_del_rcu - deletes entry from hash list without re-initialization
- * @n: the element to delete from the hash list.
- *
- * Note: list_unhashed() on entry does not return true after this,
- * the entry is in an undefined state. It is useful for RCU based
- * lockfree traversal.
- *
- * In particular, it means that we can not poison the forward
- * pointers that may still be used for walking the hash list.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_add_head_rcu()
- * or hlist_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_for_each_entry().
- */
-static inline void hlist_del_rcu(struct hlist_node *n)
-{
-	__hlist_del(n);
-	n->pprev = LIST_POISON2;
-}
-
-static inline void hlist_del_init(struct hlist_node *n)
-{
-	if (n->pprev)  {
-		__hlist_del(n);
-		INIT_HLIST_NODE(n);
-	}
-}
-
-#define hlist_del_rcu_init hlist_del_init
-
-static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
-{
-	struct hlist_node *first = h->first;
-	n->next = first;
-	if (first)
-		first->pprev = &n->next;
-	h->first = n;
-	n->pprev = &h->first;
-}
-
-
-/**
- * hlist_add_head_rcu - adds the specified element to the specified hlist,
- * while permitting racing traversals.
- * @n: the element to add to the hash list.
- * @h: the list to add to.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_add_head_rcu()
- * or hlist_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_for_each_entry(), but only if smp_read_barrier_depends()
- * is used to prevent memory-consistency problems on Alpha CPUs.
- * Regardless of the type of CPU, the list-traversal primitive
- * must be guarded by rcu_read_lock().
- *
- * OK, so why don't we have an hlist_for_each_entry_rcu()???
- */
-static inline void hlist_add_head_rcu(struct hlist_node *n,
-					struct hlist_head *h)
-{
-	struct hlist_node *first = h->first;
-	n->next = first;
-	n->pprev = &h->first;
-	smp_wmb();
-	if (first)
-		first->pprev = &n->next;
-	h->first = n;
-}
-
-/* next must be != NULL */
-static inline void hlist_add_before(struct hlist_node *n,
-					struct hlist_node *next)
-{
-	n->pprev = next->pprev;
-	n->next = next;
-	next->pprev = &n->next;
-	*(n->pprev) = n;
-}
-
-static inline void hlist_add_after(struct hlist_node *n,
-					struct hlist_node *next)
-{
-	next->next = n->next;
-	n->next = next;
-	next->pprev = &n->next;
-
-	if(next->next)
-		next->next->pprev  = &next->next;
-}
-
-#define hlist_entry(ptr, type, member) container_of(ptr,type,member)
-
-#define hlist_for_each(pos, head) \
-	for (pos = (head)->first; pos && ({ prefetch(pos->next); 1; }); \
-	     pos = pos->next)
-
-#define hlist_for_each_safe(pos, n, head) \
-	for (pos = (head)->first; pos && ({ n = pos->next; 1; }); \
-	     pos = n)
-
-/**
- * hlist_for_each_entry	- iterate over list of given type
- * @tpos:	the type * to use as a loop counter.
- * @pos:	the &struct hlist_node to use as a loop counter.
- * @head:	the head for your list.
- * @member:	the name of the hlist_node within the struct.
- */
-#define hlist_for_each_entry(tpos, pos, head, member)			 \
-	for (pos = (head)->first;					 \
-	     pos && ({ prefetch(pos->next); 1;}) &&			 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
-
-/**
- * hlist_for_each_entry_continue - iterate over a hlist continuing after existing point
- * @tpos:	the type * to use as a loop counter.
- * @pos:	the &struct hlist_node to use as a loop counter.
- * @member:	the name of the hlist_node within the struct.
- */
-#define hlist_for_each_entry_continue(tpos, pos, member)		 \
-	for (pos = (pos)->next;						 \
-	     pos && ({ prefetch(pos->next); 1;}) &&			 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
-
-/**
- * hlist_for_each_entry_from - iterate over a hlist continuing from existing point
- * @tpos:	the type * to use as a loop counter.
- * @pos:	the &struct hlist_node to use as a loop counter.
- * @member:	the name of the hlist_node within the struct.
- */
-#define hlist_for_each_entry_from(tpos, pos, member)			 \
-	for (; pos && ({ prefetch(pos->next); 1;}) &&			 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
-
-/**
- * hlist_for_each_entry_safe - iterate over list of given type safe against removal of list entry
- * @tpos:	the type * to use as a loop counter.
- * @pos:	the &struct hlist_node to use as a loop counter.
- * @n:		another &struct hlist_node to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the hlist_node within the struct.
- */
-#define hlist_for_each_entry_safe(tpos, pos, n, head, member) 		 \
-	for (pos = (head)->first;					 \
-	     pos && ({ n = pos->next; 1; }) && 				 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = n)
-
-/**
- * hlist_for_each_entry_rcu - iterate over rcu list of given type
- * @pos:	the type * to use as a loop counter.
- * @pos:	the &struct hlist_node to use as a loop counter.
- * @head:	the head for your list.
- * @member:	the name of the hlist_node within the struct.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as hlist_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
-	for (pos = (head)->first;					 \
-	     pos && ({ prefetch(pos->next); 1;}) &&			 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next, ({ smp_read_barrier_depends(); 0; }) )
-
 #endif
-- 
2.35.8


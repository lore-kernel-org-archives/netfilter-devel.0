Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C6114A85
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488059; cv=none; b=nr6DCgVRp3xzbOFF0426VnjB93cELtJ8THzHtgiZIC5TQdT3a2Jzp3kwO1YszCveHdHcaFb7LoxBCAxRMhPzyyl+HdC4t/g4xpAegUAj5UPzm33MSgrLQ2bF6VjmAUxTvByolUkpYBYiZ3llLKj7682hS0AS86QWhLE1v3QITIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488059; c=relaxed/simple;
	bh=rIMYm9xmAf1FO7ba8I3Tr2uPcLoasnSbbBmmwj+LkHU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MIW1SAGeAqo0tr5N57RE9TwWKt3nrInD507UFuSSjwVupso+QNPE1HGs4KlBNwuMAnTofh5W0+x9SzXTkMOOmG3VieRqtYzEMziQFpiKDLMIoj2HGF6K/GnrQRL1i0SYfziC+2k453d6x5MEIHnVDXmsIQmDSLyXAIOxggrYFm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bsWNgYzo; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bsWNgYzo"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5e4b775e1d6so1404746a12.1
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488057; x=1711092857; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ridKINc0EsoB1KENHztZ2H4kUEGBRS1Z/G3iJtoeFFU=;
        b=bsWNgYzoptitSJmN8KSTuE7VQV/rGFgZkOxXGSKJ8TP9olYQOD9nlAIN17PSyv2uxh
         DAhnq6SnaAHrF3Zkhg3+iuc7kVZnoLEboSQQoIBYhjljQK3xytyXISBsX2pEafLcvS8U
         +KOY2LuoN22Ac7f7eOO7lwW9aZKtbr+/VGTANW6a1T3jikVdXCrIJRBAY7m4Y10P7WCx
         wdFM8d1Ti1bZbjwWmBtf8xv8MPOttbXpEi1sGc5n9OOcKxQ0TkFXnI6DJz039zS70RlM
         nK/qfdXsr/qGbp4O1zKkTjyFhXahhCXmzmGgCRBAbJVc0o8qMmWhnLM77AeJ20NkgwUw
         Zqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488057; x=1711092857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ridKINc0EsoB1KENHztZ2H4kUEGBRS1Z/G3iJtoeFFU=;
        b=Sa8DtozG0i25/2gu4ra7VHpIJpt7CRjhojwUcRldX4z0tHo3L4GD48JYLNQc9h5yPz
         lw6do8vKmZGWUw5ITZgi7JeYI8ITjAPiPd57n0EnAojzwO0PTBChGt6RpzMddLss5cYJ
         pdLCcBbEHxRC57iKOItxHe6s90JDIEZsU5YqEbwcnZg/4KRJXYkQRQtjYW/wCpVSw750
         9WWFqjFDMd/JclOP62VLl7dCmMh1rtmMHvjK9DQRx6gxN40xmX9TQzs4K67TDZYNUJWp
         sbInY8zYkzsaccfOoisrjqMxoxLBnw1eGVkz7Ua2wcrBLGHMEv1iOdyqFb6lDRNMFDII
         xybA==
X-Gm-Message-State: AOJu0Yy0lDpdpFP4HDKQSYJWltSKB53AVHLJDoDjDoNzE28bJJHMWgbb
	qfcF+128SMkVLoaiSZKS4Oy0Aask1ZNxsDhyCdNB5/irhHiCWgM+7OudHEB/
X-Google-Smtp-Source: AGHT+IFynxSvR3Sb/7ekijYuETjNCD5IqZHTrQzAspnzRtA90LRaFzN3ikVbxk1pWz7hYRAb0gq4Bg==
X-Received: by 2002:a17:90b:3108:b0:29b:d747:f7ae with SMTP id gc8-20020a17090b310800b0029bd747f7aemr6164710pjb.14.1710488057111;
        Fri, 15 Mar 2024 00:34:17 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:16 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 14/32] doc: Add linux_list.h to the doxygen system
Date: Fri, 15 Mar 2024 18:33:29 +1100
Message-Id: <20240315073347.22628-15-duncan_roe@optusnet.com.au>
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

Produce web and man pages for list_for_each_entry() and other macros.
Mostly a straight conversion of the kerneldoc but also document
struct list_head and macro INIT_LIST_HEAD.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/Makefile.am                     |  1 +
 doxygen/build_man.sh                    |  7 ++-
 doxygen/doxygen.cfg.in                  |  5 ++-
 include/libnetfilter_queue/linux_list.h | 60 +++++++++++++++++--------
 4 files changed, 52 insertions(+), 21 deletions(-)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 68be963..6135f25 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -8,6 +8,7 @@ doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c\
            $(top_srcdir)/src/extra/ipv6.c\
            $(top_srcdir)/src/extra/tcp.c\
            $(top_srcdir)/src/extra/udp.c\
+           $(top_srcdir)/include/libnetfilter_queue/linux_list.h\
            $(top_srcdir)/src/extra/icmp.c
 
 doxyfile.stamp: $(doc_srcs) Makefile build_man.sh
diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index 7eab8fa..643ad42 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -84,7 +84,12 @@ post_process(){
 
 make_man7(){
   popd >/dev/null
-  target=$(grep -Ew INPUT doxygen.cfg | rev | cut -f1 -d' ' | rev)/$2
+
+  # This grep command works for multiple directories on the INPUT line,
+  # as long as the directory containing the source with the main page
+  # comes first.
+  target=/$(grep -Ew INPUT doxygen.cfg | cut -f2- -d/ | cut -f1 -d' ')/$2
+
   mypath=$(dirname $0)
 
   # Build up temporary source in temp.c
diff --git a/doxygen/doxygen.cfg.in b/doxygen/doxygen.cfg.in
index fcfc045..e69dcd7 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -5,8 +5,9 @@ ABBREVIATE_BRIEF       =
 FULL_PATH_NAMES        = NO
 TAB_SIZE               = 8
 OPTIMIZE_OUTPUT_FOR_C  = YES
-INPUT                  = @abs_top_srcdir@/src
-FILE_PATTERNS          = *.c
+INPUT                  = @abs_top_srcdir@/src \
+                         @abs_top_srcdir@/include/libnetfilter_queue
+FILE_PATTERNS          = *.c linux_list.h
 RECURSIVE              = YES
 EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
                          tcp_word_hdr \
diff --git a/include/libnetfilter_queue/linux_list.h b/include/libnetfilter_queue/linux_list.h
index eaa9c07..88ea386 100644
--- a/include/libnetfilter_queue/linux_list.h
+++ b/include/libnetfilter_queue/linux_list.h
@@ -12,17 +12,23 @@
  * This file only contains what we use.
  */
 
+/**
+ * \defgroup List Simple doubly linked list implementation
+ * @{
+ */
+
+
 /**
  * container_of - cast a member of a structure out to the containing structure
  *
- * @ptr:	the pointer to the member.
- * @type:	the type of the container struct this is embedded in.
- * @member:	the name of the member within the struct.
+ * \param ptr:	the pointer to the member.
+ * \param type:	the type of the container struct this is embedded in.
+ * \param member:	the name of the member within the struct.
  *
  */
 #define container_of(ptr, type, member) ({			\
-        typeof( ((type *)0)->member ) *__mptr = (ptr);	\
-        (type *)( (char *)__mptr - offsetof(type,member) );})
+	typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+	(type *)( (char *)__mptr - offsetof(type,member) );})
 
 #define prefetch(x) ((void)0)
 
@@ -44,10 +50,24 @@
  * using the generic single-entry routines.
  */
 
+/**
+ * \struct list_head
+ * Link to adjacent members of the circular list
+ * \note Each member of a list must start with this structure
+ * (containing structures OK)
+ * \var list_head::next
+ * pointer to the next list member
+ * \var list_head::prev
+ * pointer to the previous list member
+ */
 struct list_head {
 	struct list_head *next, *prev;
 };
 
+/**
+ * INIT_LIST_HEAD - Initialise first member of a new list
+ * \param ptr the &struct list_head pointer.
+ */
 #define INIT_LIST_HEAD(ptr) do { \
 	(ptr)->next = (ptr); (ptr)->prev = (ptr); \
 } while (0)
@@ -70,8 +90,8 @@ static inline void __list_add(struct list_head *new,
 
 /**
  * list_add - add a new entry
- * @new: new entry to be added
- * @head: list head to add it after
+ * \param new: new entry to be added
+ * \param head: list head to add it after
  *
  * Insert a new entry after the specified head.
  * This is good for implementing stacks.
@@ -96,7 +116,7 @@ static inline void __list_del(struct list_head * prev, struct list_head * next)
 
 /**
  * list_del - deletes entry from list.
- * @entry: the element to delete from the list.
+ * \param entry: the element to delete from the list.
  * Note: list_empty on entry does not return true after this, the entry is
  * in an undefined state.
  */
@@ -117,18 +137,18 @@ static inline int list_empty(const struct list_head *head)
 }
 /**
  * list_entry - get the struct for this entry
- * @ptr:	the &struct list_head pointer.
- * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
+ * \param ptr:	the &struct list_head pointer.
+ * \param type:	the type of the struct this is embedded in.
+ * \param member:	the name of the list_struct within the struct.
  */
 #define list_entry(ptr, type, member) \
 	container_of(ptr, type, member)
 
 /**
  * list_for_each_entry	-	iterate over list of given type
- * @pos:	the type * to use as a loop counter.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * \param pos:	the type * to use as a loop counter.
+ * \param head:	the head for your list.
+ * \param member:	the name of the list_struct within the struct.
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos = list_entry((head)->next, typeof(*pos), member),	\
@@ -139,10 +159,10 @@ static inline int list_empty(const struct list_head *head)
 
 /**
  * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
- * @pos:	the type * to use as a loop counter.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * \param pos:	the type * to use as a loop counter.
+ * \param n:		another type * to use as temporary storage
+ * \param head:	the head for your list.
+ * \param member:	the name of the list_struct within the struct.
  */
 #define list_for_each_entry_safe(pos, n, head, member)			\
 	for (pos = list_entry((head)->next, typeof(*pos), member),	\
@@ -150,4 +170,8 @@ static inline int list_empty(const struct list_head *head)
 	     &pos->member != (head); 					\
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
 
+/**
+ * @}
+ */
+
 #endif
-- 
2.35.8


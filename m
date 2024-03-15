Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EC51429B
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488061; cv=none; b=r2Skhzlh5ocr7spOzey7MGo9800kKtLGZ7KSkno8dTzvo7VNnPfafTxaj+w58RO96b/nigWsuTsC0RlkKWeXm6Tw0XSyc6QzGPCZhbhoznVeJC+oGt4pZuuf8R7C8JuGrfeRdeZ9xSPgzqtX/KN9TbqVL6A+H66PtK8JIJ4vAnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488061; c=relaxed/simple;
	bh=TtRECGmP6MHaOZrrVzohAg/8MBVmv2iqw1XSE7Gr+G8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rN8sfJvxiQIUFEBvsar3bWOKk0Ib1MNKv+kQdSPC6VatkG5q/ebdeH5O/8RDJMWp8Yi2BTqO0LM7E7+zpwnCXrEyuVsX+3nj0aLsRG8vf4dhqaVLKgb+VuGdz2qUaZUJxIsKHndBV/kguK8UggBWNCh8bOrovfq6WmRArpMwB8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V1HLXVMl; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1HLXVMl"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1dcab44747bso11889935ad.1
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488059; x=1711092859; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SPSN64yPOxMhvukMW/PYHvbAop8Gd3lPnbcriApkV30=;
        b=V1HLXVMlAwvBbdkg7Zw6GmFIeFJbQ2YFwWY343wLhE4rZV5ocz75qXs+SNSTCpoU7b
         fjdJvcCrgQMeJDgLUL1ZtlTwbGqWFhG6oUbbbWBzqGeqxwyoCSjupQkSgf7NB+1950Z5
         w/gZWsvkl5+sPWLMJwfEeoC/Kb30RZzNjfkqsoGAoC0YnMwoMMr8VfbigwSJue3qUP/a
         TDqWHeIs35chkdQLPjLnpNIbk6zdSFDY86bkaqL2ebB2I6fwenGk55c7Abxpks8gjeij
         LvkeMeKqI0RS45BLcQ9jReaPTMH6U4NYe/nOj+GvcZR8x7c90Nzj93E1WGxOGJiwmkOp
         E8rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488059; x=1711092859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SPSN64yPOxMhvukMW/PYHvbAop8Gd3lPnbcriApkV30=;
        b=VHO/upT6zxHcZvyPvaoecDkXJha7xHsoHXzELEggQ1LqgKP6pYNkLp4VKn0AxR15Zj
         aHE0o3glA4uRULPMFrptVjl1sAMBHOzAKoH6UDzUnJXnY0148IJ/qwi1YTrT+uHvueRX
         VjuwQ5m1MLy4p/4aj4u4giUb9RLSlmmzKTm0IbiNwyHujAcXgRZh650z14b5N6ZhqCQQ
         TJx0SG0iw3JL1Qr6WxGBmcMeiZ+zbllOnaj2cXsK6TdT6eMq7ACXH9IEYFv/w+Vs1Zpk
         yA7j9ltjg3j+UcUTI69WPJo0WjeDHAoaX8rZ5pDZSaLEd7fXXzrQhR6AJ9V+skrvxcy5
         /cPw==
X-Gm-Message-State: AOJu0Yxs1Uq+528Lp79gC2PmjJO/QxAGJ/7DhKYt3zOA0eddLtIyTWWZ
	1Ic2qwg1ok+kAP9Wv19u13NsEgDHchYXNTU84QmqahYbigCgZsVi3im+pfE1
X-Google-Smtp-Source: AGHT+IHs0/RqIuHh1ozEZ+T0Kw+ORlOBlM5VKndplY3qIfPG5Xb/EWn+XGb0HTr9ONcBlqBRcT+fsw==
X-Received: by 2002:a17:903:943:b0:1de:de26:f6b3 with SMTP id ma3-20020a170903094300b001dede26f6b3mr3607351plb.26.1710488058964;
        Fri, 15 Mar 2024 00:34:18 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:18 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 15/32] doc: Eliminate doxygen warnings from linux_list.h
Date: Fri, 15 Mar 2024 18:33:30 +1100
Message-Id: <20240315073347.22628-16-duncan_roe@optusnet.com.au>
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

The warnings concerned prefetch(), LIST_POISON1 & LIST_POISON2.
Remove all 3 macros since they do nothing useful in userspace programs.
Also take a few doxygen comment improvements from 6.6 Linux source.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/libnetfilter_queue/linux_list.h | 44 ++++++++++++-------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/include/libnetfilter_queue/linux_list.h b/include/libnetfilter_queue/linux_list.h
index 88ea386..500481d 100644
--- a/include/libnetfilter_queue/linux_list.h
+++ b/include/libnetfilter_queue/linux_list.h
@@ -10,10 +10,20 @@
  * This is a cut-down copy of libnfnetlink/include/linux_list.h which is itself
  * an old snapshot of linux/include/linux/list.h.
  * This file only contains what we use.
+ *
+ * 2024-01-27 12:45:41 +1100 duncan_roe@optusnet.com.au
+ * LIST_POISONx doesn't really work for user space - just use NULL
+ *
+ * 2024-01-27 18:16:51 +1100 duncan_roe@optusnet.com.au
+ * I can't see how the prefetch() calls do any good so remove them
+ * and #define of prefetch
+ *
+ * 2024-01-27 18:53:46 +1100 duncan_roe@optusnet.com.au
+ * Take a few doxygen comment improvements from 6.6 Linux source
  */
 
 /**
- * \defgroup List Simple doubly linked list implementation
+ * \defgroup List Circular doubly linked list implementation
  * @{
  */
 
@@ -30,18 +40,8 @@
 	typeof( ((type *)0)->member ) *__mptr = (ptr);	\
 	(type *)( (char *)__mptr - offsetof(type,member) );})
 
-#define prefetch(x) ((void)0)
-
 /*
- * These are non-NULL pointers that will result in page faults
- * under normal circumstances, used to verify that nobody uses
- * non-initialized list entries.
- */
-#define LIST_POISON1  ((void *) 0x00100100)
-#define LIST_POISON2  ((void *) 0x00200200)
-
-/*
- * Simple doubly linked list implementation.
+ * Circular doubly linked list implementation.
  *
  * Some of the internal functions ("__xxx") are useful when
  * manipulating whole lists rather than single entries, as
@@ -123,8 +123,8 @@ static inline void __list_del(struct list_head * prev, struct list_head * next)
 static inline void list_del(struct list_head *entry)
 {
 	__list_del(entry->prev, entry->next);
-	entry->next = LIST_POISON1;
-	entry->prev = LIST_POISON2;
+	entry->next = NULL;
+	entry->prev = NULL;
 }
 
 /**
@@ -139,30 +139,28 @@ static inline int list_empty(const struct list_head *head)
  * list_entry - get the struct for this entry
  * \param ptr:	the &struct list_head pointer.
  * \param type:	the type of the struct this is embedded in.
- * \param member:	the name of the list_struct within the struct.
+ * \param member:	the name of the list_head within the struct.
  */
 #define list_entry(ptr, type, member) \
 	container_of(ptr, type, member)
 
 /**
  * list_for_each_entry	-	iterate over list of given type
- * \param pos:	the type * to use as a loop counter.
+ * \param pos:	the type * to use as a loop cursor.
  * \param head:	the head for your list.
- * \param member:	the name of the list_struct within the struct.
+ * \param member:	the name of the list_head within the struct.
  */
 #define list_for_each_entry(pos, head, member)				\
-	for (pos = list_entry((head)->next, typeof(*pos), member),	\
-		     prefetch(pos->member.next);			\
+	for (pos = list_entry((head)->next, typeof(*pos), member);	\
 	     &pos->member != (head); 					\
-	     pos = list_entry(pos->member.next, typeof(*pos), member),	\
-		     prefetch(pos->member.next))
+	     pos = list_entry(pos->member.next, typeof(*pos), member))	\
 
 /**
  * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
- * \param pos:	the type * to use as a loop counter.
+ * \param pos:	the type * to use as a loop cursor.
  * \param n:		another type * to use as temporary storage
  * \param head:	the head for your list.
- * \param member:	the name of the list_struct within the struct.
+ * \param member:	the name of the list_head within the struct.
  */
 #define list_for_each_entry_safe(pos, n, head, member)			\
 	for (pos = list_entry((head)->next, typeof(*pos), member),	\
-- 
2.35.8


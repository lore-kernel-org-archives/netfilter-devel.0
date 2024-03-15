Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD9914A81
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488090; cv=none; b=YJ0TIa8fioe1FrwxEFBNgHwdMKcYQ75d4U8ewiC8z2kMirUyK3GA0SHMtcZVtjAPyC5q+XHMyQFc8jfs9oC3j+WP3tKEKmkXvr0m64DdE0p+GI9yJuvASG/uO0e2hZaZ8LCcmI5WVTrZX/QShlu3gkfOLHsVuFU+ruecOX0MgtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488090; c=relaxed/simple;
	bh=DObN3FsSJ8ynGjhbhUwoQ3ha/4zGIs/SBM6IkDSzi/M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FyPXJmG/YzH0ceDK5Q4mP+aKFXdrq+GQnbBLdefqpXDS0r6BnBOl03LmKnyBvy1iuvAJkhnqJm91FqfaOFXz7kQXT8nUZtbvA9Puhu7CnjvSdjcRySrIKhGJMvkO0HUJKaS99Us5P9oOP1SXljAPhHOOzn9HDNs/Np2svCfk2oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YpVDglhO; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YpVDglhO"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1dc49b00bdbso13455535ad.3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488088; x=1711092888; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DxfPXMcwIrL0QusDqACDPPEf8yzUhw67nqw49M7EU/I=;
        b=YpVDglhOSBT8ZH5wvmCw+iyU90PLBcz0J1BxvmV79RIaI+2ORvT5tYmyofuAPGcQj6
         +OvypqJY7ut9+qjKcSsir5+jd+XAl6wjGwqYwVWKKXdYbPSumo9XqZOQNHkd++gL9GPv
         p9hRjwukT21KL53XtBAh9AJmKGMfATk+89PxjWm34DOSfw3YlfY7gZ1bkm0eijH3PNGk
         KHTpB/LkG4tcRTl1kDBwK1PWUNORDDSWjry4MK5pcdFRc0UjWX1SkSR8K1oi9cXSBsuY
         0DCan3kf2f+4ib+pBtvdqljd0S0X698FF8nYJwFa+ED+idoIz7drnvrWUCaIIvG+437l
         rK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488088; x=1711092888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DxfPXMcwIrL0QusDqACDPPEf8yzUhw67nqw49M7EU/I=;
        b=wWkYM/zz27/DpGih2S2MC0SFu6NEgwTXRCLSwNHhGZPH6oDtfVw9iE4DGnew17K/Vc
         eXp8wqc56tz0PUVle8YvRP5PiNP6eRbFrtNowTzUg9G3V/jTp+GL+W39VpuuEka26PPB
         hNpu6R41vt4nBpNgtHZYOh1DChRTvXr6P4lW92GclZHWaW2Fss1GfsKTPst86ZIl4EBj
         W/9FXNcNp8g1od3y0JMo0ETftlWEaEDZrC0DpSFFgJBOxZLmUAEnFQMfOpjPE7dAu7R+
         8PDfstxqmnPSlfTZtFtQ2l1omjoUAdTBDP2rfuvdpHU+WLSusa7lyZbLMyAl7UuHwznD
         iR3g==
X-Gm-Message-State: AOJu0YzHO+murmEa0qnH22DdzUl2oJiNMRzy3lkAq9Hb8iC6ondYZO9R
	RyUv5OYadB7qU+yXYy5aHxGZj+KFh7BAyMmYLd6cbwxjZ4d+hh0ZkYuK7GnT
X-Google-Smtp-Source: AGHT+IGZ5Z4RBiHuEmZC3OIQ8gJbvAN93Gu2S4gK9vC3UkEVr1jukMeKphdOQ0NHrzfFv84GnZsO/Q==
X-Received: by 2002:a17:902:efce:b0:1de:e4bd:73fc with SMTP id ja14-20020a170902efce00b001dee4bd73fcmr1875362plb.24.1710488088370;
        Fri, 15 Mar 2024 00:34:48 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:48 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 32/32] whitespace: Fix more checkpatch errors & warnings
Date: Fri, 15 Mar 2024 18:33:47 +1100
Message-Id: <20240315073347.22628-33-duncan_roe@optusnet.com.au>
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

Fix errors & warnings in the copies of linux_list.h & iftable.c.
One possible false +ve:
 typeof(((type *)0)->member) *__mptr = (ptr);
gets "need consistent spacing around '*' (ctx:WxV)"

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/libnetfilter_queue/linux_list.h | 10 +++++-----
 src/iftable.c                           | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/libnetfilter_queue/linux_list.h b/include/libnetfilter_queue/linux_list.h
index f687d20..738d834 100644
--- a/include/libnetfilter_queue/linux_list.h
+++ b/include/libnetfilter_queue/linux_list.h
@@ -51,8 +51,8 @@
  *
  */
 #define container_of(ptr, type, member) ({			\
-	typeof( ((type *)0)->member ) *__mptr = (ptr);	\
-	(type *)( (char *)__mptr - offsetof(type,member) );})
+	typeof(((type *)0)->member) *__mptr = (ptr);	\
+	(type *)((char *)__mptr - offsetof(type, member)); })
 
 /*
  * Circular doubly linked list implementation.
@@ -122,7 +122,7 @@ static inline void list_add(struct list_head *new, struct list_head *head)
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
  */
-static inline void __list_del(struct list_head * prev, struct list_head * next)
+static inline void __list_del(struct list_head *prev, struct list_head *next)
 {
 	next->prev = prev;
 	prev->next = next;
@@ -169,7 +169,7 @@ static inline int list_empty(const struct list_head *head)
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos = list_entry((head)->next, typeof(*pos), member);	\
-	     &pos->member != (head); 					\
+	     &pos->member != (head);					\
 	     pos = list_entry(pos->member.next, typeof(*pos), member))	\
 
 /**
@@ -182,7 +182,7 @@ static inline int list_empty(const struct list_head *head)
 #define list_for_each_entry_safe(pos, n, head, member)			\
 	for (pos = list_entry((head)->next, typeof(*pos), member),	\
 		n = list_entry(pos->member.next, typeof(*pos), member);	\
-	     &pos->member != (head); 					\
+	     &pos->member != (head);					\
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
 
 /**
diff --git a/src/iftable.c b/src/iftable.c
index 7eada24..322b18e 100644
--- a/src/iftable.c
+++ b/src/iftable.c
@@ -29,7 +29,7 @@
 
 #define NUM_NLIF_BITS 4
 #define NUM_NLIF_ENTRIES (1 << NUM_NLIF_BITS)
-#define NLIF_ENTRY_MASK (NUM_NLIF_ENTRIES -1)
+#define NLIF_ENTRY_MASK (NUM_NLIF_ENTRIES - 1)
 
 static int data_cb(const struct nlmsghdr *nlh, void *data);
 
@@ -192,7 +192,7 @@ struct nlif_handle *nlif_open(void)
 	if (h == NULL)
 		goto err;
 
-	for (i = NUM_NLIF_ENTRIES - 1; i>= 0; i--)
+	for (i = NUM_NLIF_ENTRIES - 1; i >= 0; i--)
 		INIT_LIST_HEAD(&h->ifindex_hash[i]);
 
 	h->nl = mnl_socket_open(NETLINK_ROUTE);
@@ -226,7 +226,7 @@ void nlif_close(struct nlif_handle *h)
 
 	mnl_socket_close(h->nl);
 
-	for (i = NUM_NLIF_ENTRIES - 1; i>= 0; i--) {
+	for (i = NUM_NLIF_ENTRIES - 1; i >= 0; i--) {
 		list_for_each_entry_safe(this, tmp, &h->ifindex_hash[i], head) {
 			list_del((struct list_head *)this);
 			free(this);
@@ -256,7 +256,7 @@ int nlif_catch(struct nlif_handle *h)
 	if (!h->nl)                /* The old library had this test */
 		return -1;
 
-	ret = mnl_socket_recvfrom(h->nl, buf, sizeof buf);
+	ret = mnl_socket_recvfrom(h->nl, buf, sizeof(buf));
 	if (ret == -1)
 		return -1;
 	return mnl_cb_run(buf, ret, 0, h->portid, data_cb, h) == -1 ? -1 : 0;
@@ -303,7 +303,7 @@ int nlif_query(struct nlif_handle *h)
 EXPORT_SYMBOL
 int nlif_fd(struct nlif_handle *h)
 {
-	return h->nl? mnl_socket_get_fd(h->nl) : -1;
+	return h->nl ? mnl_socket_get_fd(h->nl) : -1;
 }
 
 /**
-- 
2.35.8


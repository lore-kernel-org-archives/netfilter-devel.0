Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DED1401B
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488087; cv=none; b=Z0Jq1+m4fwtOMSCUR1/q5cwJBc+84Ap+r+AqDEmU8I8H2xli9d7WHI8hzH4F4pYpkVCtKCffZbSy0hEQFfujFpLsG4+Tw1GBfpJGjyVOV61eJgkNmJ4mss6mQDc8VT4uLIdru7SeP9OhzYGTiElExsDkU5eluAb17oZWRQqj/74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488087; c=relaxed/simple;
	bh=FsIK3XDLu7IBb2HUuatZ+9oFfp6PHTzDx0Y7Iceggr4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hfV4upLPPdJW/RKf53FbOjfOsoRyxG1cDbOIu9sXn5kFtEX81U642Hk4b6cHRtVTSVahZhuYvB3Yd5rEdTasLxFUwlJmiunxUDRoXt0KkfomffTzIvmHU7sT/SbNrZdwXJrYA/NiHru2pO/NdH79eTPc9fEvsyQBiMXnBMRSvqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kcBbtb+H; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kcBbtb+H"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5ce2aada130so1512316a12.1
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488085; x=1711092885; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p3MIaz01oC6a/5du6YFI8E+XuhuXf1lZ8pIOk6Nlw4Y=;
        b=kcBbtb+HYvuO79ph3AeixZWaW4W6xnIuKiyc6/DrFFIOk3H9qX6GVhNAeAaXARjeS9
         Goc4wImdoeVxwCgoOoi2SiD8RMJ0/CXs9ya/Wo3x2OCD5p6Ajq+xXYQWhUgOUpu3mro9
         WCk8nLLWj1dFFXj4yqsSETYGSSPxq3ix0GTuvDwDlbio9VTJ9Rhwwl6Cj4yt+Yt6CSoY
         +acJuvEZKOq9qhID2Isu5vN9tCHjBcIMaPuqHeuU50RtmQDV8XZgY/Y/yPDBp5p1QLOO
         XpPi0xf2M0BWrxZrMd/cgHa9DNXO22Ea35bX0PFFH9+ZCh6kd9H2ndSKRgp5SE5dVtRz
         Yuhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488085; x=1711092885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p3MIaz01oC6a/5du6YFI8E+XuhuXf1lZ8pIOk6Nlw4Y=;
        b=WWuNw52KZ38/KINTzIaEj+yIwNjb+EHm6reh8QTDqk5ERO8LzctCKa9zzRTGiGW37d
         NqBBIhuj7SQPIDzHzprT8srCBEyrlRpBI4rK5LJfF/YZx62AA8ivdNQ4P1QO8GAXRqOm
         v67nNDpUfs+PtAoH4tVE+zwnsrgokwOQqGdh8W9qASnqeSg42hwyCwkxaeZXP9bod/x3
         ufVUtFJojZ7376vsbDq10QtdeedD3XBdqRP3bgN0XM/+9wrEull7F3bul2OTIcyroTw+
         qyCMSb/eC235tdS0JeDLhGudw2a7tg3hVkzWGCMxwnG2/tAYPonh404fRwFaWSs/h70n
         ntKA==
X-Gm-Message-State: AOJu0YyOdxeArWJidgBofc7RnMJGibNMT06NmMu7owTYKngKmgHepo2O
	OXyYQ916xbqqqgj4XrggJaT+snj1I7FjgY/SzoPL9qZMOOSeSesWA3GYNDKH
X-Google-Smtp-Source: AGHT+IHujiykL2a0QG5fDwtC4M4Kr/t365jiz597o7oQzAjlTsgKCRkoLUQQdoxnY8da0DcH/4Agtw==
X-Received: by 2002:a17:902:8ec8:b0:1de:e8ce:9d8f with SMTP id x8-20020a1709028ec800b001dee8ce9d8fmr2374071plo.18.1710488084949;
        Fri, 15 Mar 2024 00:34:44 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:44 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 30/32] doc: Fix list_empty() doxygen comments
Date: Fri, 15 Mar 2024 18:33:45 +1100
Message-Id: <20240315073347.22628-31-duncan_roe@optusnet.com.au>
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

Need blank line between list_empty and list_entry.
Translate kerneldoc comments to doxygen.
Not all static inline functions are void any more.
Use \note instead of Note:.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/Makefile.am                     | 2 +-
 include/libnetfilter_queue/linux_list.h | 7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 1784afa..4934e8e 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -14,7 +14,7 @@ doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c\
 
 doxyfile.stamp: $(doc_srcs) Makefile build_man.sh
 	rm -rf html man
-	sed '/^static inline void [^_]/s/static //' \
+	sed '/^static inline [^ ]* [^_]/s/static //' \
 	  $(top_srcdir)/include/libnetfilter_queue/linux_list.h > linux_list.h
 	doxygen doxygen.cfg >/dev/null
 	rm linux_list.h
diff --git a/include/libnetfilter_queue/linux_list.h b/include/libnetfilter_queue/linux_list.h
index 76d24ea..f687d20 100644
--- a/include/libnetfilter_queue/linux_list.h
+++ b/include/libnetfilter_queue/linux_list.h
@@ -131,7 +131,8 @@ static inline void __list_del(struct list_head * prev, struct list_head * next)
 /**
  * list_del - deletes entry from list.
  * \param entry: the element to delete from the list.
- * Note: list_empty on entry does not return true after this, the entry is
+ * \note
+ * list_empty() on **entry** does not return true after this, **entry** is
  * in an undefined state.
  */
 static inline void list_del(struct list_head *entry)
@@ -143,12 +144,14 @@ static inline void list_del(struct list_head *entry)
 
 /**
  * list_empty - tests whether a list is empty
- * @head: the list to test.
+ * \param head: the list to test.
+ * \return 1 if list is empty, 0 otherwise
  */
 static inline int list_empty(const struct list_head *head)
 {
 	return head->next == head;
 }
+
 /**
  * list_entry - get the struct for this entry
  * \param ptr:	the &struct list_head pointer.
-- 
2.35.8


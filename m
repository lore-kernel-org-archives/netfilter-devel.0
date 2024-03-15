Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCAF14AA7
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488075; cv=none; b=TldMv8llM19jk/aO+eSB2LV1BijThzlYUyQNdHci3UguH8ujEUWjzHp3qh5aRWJNZjGfNP+dJ30NPffpH46AZ9qbD3pGFmVyZT/bj9FOFZNxsGVttWjneNP+9nC/WvSN6J5lRrUd3xJ52HU58ncGbIeqdWzkSxdBfUA+VtcDbZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488075; c=relaxed/simple;
	bh=iNvFo9f90yvJt6t3ZMjBUQq0Cg/ZNVkoCOUACpH3SNA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lbonYdiXlNEZh7oy5lWPBgcoZ/eNrCcnx34Px3+sBO9bkv176HuA/Jk82yCb+PMwHlYu+gwq/5PZgwzAR/6s9IKlQAyb8fSNDuRJRqGt4PSk9vam0pxQ04xJrFgPwIDR7PfVS1ADIOh46F8FjywgbBSZf/6f54VUdD2rM4YYi2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nMheiBH9; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nMheiBH9"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1ddbad11823so17130505ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488073; x=1711092873; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zo4VSn5LzqKf56uLGgHPtgCZNDUAkrP7gmPf68CRcOo=;
        b=nMheiBH9GojxtbqPeU4Q1OiwcSb0O2KATePp4V3HxbswaH4itkUmQpeQMidlo9XvJb
         E47smZYDdS5Qbab09mH0+jT4WF1Uwe3K+K4uPruEEwb4jNWZDEFY6vDByunFAr2oPJUM
         QWAKnmOQALrt3Wu5fDaU9YrAt/pdMF1GQr/u4KHYsekLsYLZgr6dH4mNyNJbB544eNNO
         23EjwhK3DNRSMtgXN+9fLPdEEABGovmahNMT8//90jIuYzuEOprLDMkreHRLf61YIPGG
         m3kHgp6XTZJINXoETZS8ktiusKevUfpu8BhRjvveoUbslEMOJ5V5GLaYe7sk2pqfIqXf
         mfOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488073; x=1711092873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zo4VSn5LzqKf56uLGgHPtgCZNDUAkrP7gmPf68CRcOo=;
        b=RtOtkWXi0YKWutFyv77NEfwGeY/qfwfZIRaJuqulIS5UYCfpI/qIXJ8PCsxLqXj+kw
         fZDXzBtF7uERoqmlOd3QYdOvwWfommdQJvFqhzjeDc3RqPhrl/d0Xe6oBr6/vbjewSUl
         qyv59lXG0SVNLzWAU5bws1EV6NRaNtiFMRnClHauec/oliK3OeGagMC0wj3CyNgf9wxy
         4JCJ0bnjcRnZhRhAyMSGLOrY4ze91npg2XApNhKSZmU0igWAySpO42zgLz/5ByRxqwu7
         dtuYGHYx6DTwUzUlL+cy70C9NtHd2dPL0g2HW23XTXKgtCKg6X7VnCOub8YzzYtBNRqo
         Bpig==
X-Gm-Message-State: AOJu0Yxr12dyECiy3GmBYnJoi0SiwqnxgGLpYiwDL+kV5Ld+abUjH1b3
	Z/qaguZy+Y92MsVj95aCh17PP5VjgMsdjMB+YzXlQlaEBjm2SNqoIzjbz2C+
X-Google-Smtp-Source: AGHT+IGgY38HDi64ZEP8zc7XNl0G5D+u9pNN2iQvYLH7AFjPj9FNguWQxacxE22CEnxn7GDqrIQg4g==
X-Received: by 2002:a17:903:244d:b0:1de:dfba:789d with SMTP id l13-20020a170903244d00b001dedfba789dmr3878604pls.7.1710488072963;
        Fri, 15 Mar 2024 00:34:32 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:32 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 23/32] doc: Get doxygen to document useful static inline functions
Date: Fri, 15 Mar 2024 18:33:38 +1100
Message-Id: <20240315073347.22628-24-duncan_roe@optusnet.com.au>
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

include/libnetfilter_queue/linux_list.h contains static inline list_add and
list_del which mnl programs may wish to use. Make a temporary copy of
linux_list.h with 'static' removed and get doxygen to process that.

Also add some detailed description and a SYNOPSIS line to linux_list.h.

Some problems remain with the generated man page.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/Makefile.am                     |  3 +++
 doxygen/doxygen.cfg.in                  |  3 +--
 include/libnetfilter_queue/linux_list.h | 14 ++++++++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index aae1ccc..1784afa 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -14,7 +14,10 @@ doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c\
 
 doxyfile.stamp: $(doc_srcs) Makefile build_man.sh
 	rm -rf html man
+	sed '/^static inline void [^_]/s/static //' \
+	  $(top_srcdir)/include/libnetfilter_queue/linux_list.h > linux_list.h
 	doxygen doxygen.cfg >/dev/null
+	rm linux_list.h
 
 if BUILD_MAN
 	$(abs_top_srcdir)/doxygen/build_man.sh libnetfilter_queue libnetfilter_queue.c
diff --git a/doxygen/doxygen.cfg.in b/doxygen/doxygen.cfg.in
index c795df1..601d4ab 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -5,8 +5,7 @@ ABBREVIATE_BRIEF       =
 FULL_PATH_NAMES        = NO
 TAB_SIZE               = 8
 OPTIMIZE_OUTPUT_FOR_C  = YES
-INPUT                  = @abs_top_srcdir@/src \
-                         @abs_top_srcdir@/include/libnetfilter_queue
+INPUT                  = @abs_top_srcdir@/src .
 FILE_PATTERNS          = *.c linux_list.h
 RECURSIVE              = YES
 EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
diff --git a/include/libnetfilter_queue/linux_list.h b/include/libnetfilter_queue/linux_list.h
index 500481d..6e67b9a 100644
--- a/include/libnetfilter_queue/linux_list.h
+++ b/include/libnetfilter_queue/linux_list.h
@@ -24,6 +24,20 @@
 
 /**
  * \defgroup List Circular doubly linked list implementation
+ *
+ * Unlike file units (which are re-used), network interface indicies
+ * increase monotonically as they are brought up and down.
+ *
+ * To keep memory usage predictable as indices increase,
+ * the nlif_* functions keep their data in a circular list
+ * (in fact a number of lists, to minimise search times).
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libnetfilter_queue/linux_list.h>
+\endmanonly
  * @{
  */
 
-- 
2.35.8


Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5426313D29A
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774599; cv=none; b=LAJvnsFh21SFyt1r+gKeBNGTUlyts4r8dEoc+OY3+nuTXcApI4m10lD2+JViyi2ZDPsUG2wCDOeoXnULbJLbtKjYU/VMLdZuAG9Pjxuxxl0r4X5u8qPzsWXv5/7ZS69p3/0dDQ4BJs54JLYosC95Vl04jxuZCWawOttKrdlWPhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774599; c=relaxed/simple;
	bh=Gz8yL3O+Vo03l/rDIikrDVqq4lhCPeRPZ3EXLKj1bZY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pC4MH4APJMPGU6kedVkWUGHZ5LlV/amzTr8jCqXVUaz41BwI7ip/hM35u5T11ibx56iZTwlukVMvL4eA385LX8oZ/3+PerG0MMMn8ICD3+BXpHSDMPBk2TX/pqfSvC4L/y9KKTBbRrsOWRw5/V0DllKh+HvVWm454PjJnYGB4K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JAe3bArH; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JAe3bArH"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-71e580256c2so248048b3a.3
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728774597; x=1729379397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+woaX/kz0i+zZjaFmPWAfc+jsPO0Wn6eUxHNT7FQPYc=;
        b=JAe3bArHI8PiA0kPLAgnNzj5JrCdC7K3SSJcn77Sf8BoIPDrv43EpJBW/Fbtd6OoAh
         X0/ks1m7WypHURwZ/KXXSa52xAtpcFzPBBB5MuHoOYP7t98KV+UuvtG86R7gFOncRzg/
         MPit92xhvnGJPFfYqqEeQHi+ifDy7S3ANdClEnrJXYCFWOUiiBA1vllHzqHXMXbvMFvD
         sRB44ISR/MHn0on+rAEqzNgx1Ub3exMkRxcitm8nlZExuaWHgfm7p6k9m6G11GYo6ygK
         7qAFFz4/En/PgQkHGDZFGo3APVFR71+vT8XET725KB/7iKA02TMQ3N++NcowJAiwPmN6
         8HUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728774597; x=1729379397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+woaX/kz0i+zZjaFmPWAfc+jsPO0Wn6eUxHNT7FQPYc=;
        b=b2Lq0pigA328ajMJcE1mAGmH1EXhMzmEJ1QsofcYoflceMQOHe/FZmxp0q7fWE39bp
         YO6Bi7KDVACPETG0qFRKnwXVxwNmJRHf+nvtIOkvwHbqodwqplYbEY8TYhQcrCdtLDSJ
         01PjFn2iLdT310qb34hGc5K27d7kCT3kw46SrYEUYinCjI169Boda/H+Tal70uSnVkEx
         mZSNTxzrdE5LAWbvAu+FQGQFYtouv0csJkNNZZWAEMO69ojh0LI7pWSfeRxYYivi+xdY
         DPpoFF8fRw0B/TA6iTyKS7dtvH53/0h7dsKlYJrbWzjLm+ImGsp5QuAphg+zvTbk7V/D
         K/1g==
X-Gm-Message-State: AOJu0YwPgRPoLiosKBYD8lJREhYsFzpi+2QljxfVlqP5xBeb5HFgwWgh
	eXHAc9HYg1uq2rhaFqvA370MSvZDrq7Or/aDAarpkoVVkqcNS5L7KozTeA==
X-Google-Smtp-Source: AGHT+IG3+3X7xp7RYkFAKsF/KJFm6Byz3P4szyebg0BBt83Wips26NQiiY18Vkd2/Kb/gr1JiI7Fbw==
X-Received: by 2002:a05:6a21:38c:b0:1d8:aca5:ea86 with SMTP id adf61e73a8af0-1d8bcf42336mr10295779637.23.1728774597558;
        Sat, 12 Oct 2024 16:09:57 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aab5bf9sm4854195b3a.145.2024.10.12.16.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:09:57 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 15/15] build: Remove libnfnetlink from the build
Date: Sun, 13 Oct 2024 10:09:17 +1100
Message-Id: <20241012230917.11467-16-duncan_roe@optusnet.com.au>
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

libnfnetlink was a "private library" - always loaded whether user apps
used it or not. Remove it now it is no longer needed.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 v3: no change

 v2: This was patch 21/32. No changes.

 Make_global.am           | 2 +-
 configure.ac             | 1 -
 libnetfilter_queue.pc.in | 2 --
 src/Makefile.am          | 2 +-
 4 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 91da5da..4d8a58e 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -1,2 +1,2 @@
-AM_CPPFLAGS = -I${top_srcdir}/include ${LIBNFNETLINK_CFLAGS} ${LIBMNL_CFLAGS}
+AM_CPPFLAGS = -I${top_srcdir}/include ${LIBMNL_CFLAGS}
 AM_CFLAGS = -Wall ${GCC_FVISIBILITY_HIDDEN}
diff --git a/configure.ac b/configure.ac
index 7359fba..ba7b15f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -42,7 +42,6 @@ case "$host" in
 esac
 
 dnl Dependencies
-PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
 
 AS_IF([test "$enable_man_pages" = no -a "$enable_html_doc" = no],
diff --git a/libnetfilter_queue.pc.in b/libnetfilter_queue.pc.in
index 9c6c2c4..1927a8a 100644
--- a/libnetfilter_queue.pc.in
+++ b/libnetfilter_queue.pc.in
@@ -9,8 +9,6 @@ Name: libnetfilter_queue
 Description: netfilter userspace packet queueing library
 URL: http://netfilter.org/projects/libnetfilter_queue/
 Version: @VERSION@
-Requires: libnfnetlink
 Conflicts:
 Libs: -L${libdir} -lnetfilter_queue
-Libs.private: @LIBNFNETLINK_LIBS@
 Cflags: -I${includedir}
diff --git a/src/Makefile.am b/src/Makefile.am
index a6813e8..e5e1d66 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -39,4 +39,4 @@ libnetfilter_queue_la_SOURCES = libnetfilter_queue.c	\
 				extra/pktbuff.c		\
 				extra/udp.c
 
-libnetfilter_queue_la_LIBADD  = ${LIBNFNETLINK_LIBS} ${LIBMNL_LIBS}
+libnetfilter_queue_la_LIBADD  = ${LIBMNL_LIBS}
-- 
2.35.8


Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B858885286
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 05:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716529097; cv=none; b=hlNDzyg50OuidTuGvdmiD/SsDDPJFvBwkr3uMr/6t18hhBXtEAjzYgLWWgVgCNWGHuG5U+DAwxWh9y5/9E7VQSSrQjiRXQoyG+o1xm0pk7EfaLukusVALdbY8BuwAjIeozMHebbBHYyvKYZz9KMEtadAXsGPlrSBA3qvuojB4to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716529097; c=relaxed/simple;
	bh=zf7nI8VCA4uVTiUd43rNKgZ+KepDp5+QWawmLjv6yhU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l410zJSYVSch0UNvQwO5FsRpyhDpcI7HDNJxlPfG8jgJEo2aGk24l1T8GFQy8E0H4gKU2nDentYKDfWbBwKJpUgUgz49YG1aJia5Y02tCpBugZhzp5rHb1H13jTEW+3SgIkhez2qJoQDNng75OzvY6cqvbnjT3zyvfEIx+orI7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C/uwrJ4C; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C/uwrJ4C"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6f69422c090so3676185b3a.2
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 22:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716529095; x=1717133895; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cqvHPDbxLtfCnye35rWsySJwaa0HricqSMVkAzCrPjw=;
        b=C/uwrJ4CE8QqFOnx6RTxipdiaILwUGuo9y8aUKfekQg+2QSusRrjA2GFJ9xxP+SgS6
         QSBskiv9VGbhdL0xpKoI7VUrtZ+VWPdEeYi3yOEaM9TJWlFIIH6rGbYDS/Gda2FBG1tg
         IZAJZtO8TZIKco1Zy8J+oZKGGd3T03CNeoNpKSRVbNowSUwPBQHJ8U22Ey2PKbomn5xk
         CbinruX7ZqhF8v4jnt8/6tUfUIkwpRM4zhXkSRvg/34tYu1uO+u+vC+jCaoTZx4y4QAl
         EKefnlK1EJHHCIk7HZvVnNibEAcus1VHh3e4zO7xe19o0dCHLNTATLiO+kmHzpQqHYr6
         UWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716529095; x=1717133895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cqvHPDbxLtfCnye35rWsySJwaa0HricqSMVkAzCrPjw=;
        b=rJbCUPv72sDXXHgouRNwhixCZxHvIXZj3eOJsm2RgVS1ATf0MBnIqnjdjCLnTAPzC5
         n4vXAq7W9cdW/vTD2JeHiZNdy30YawDcxJDwdLdaK5diH4UYct57NAzFQmOZaY9iz4EG
         IswZ1xtczUBG61fQl23kIPJQiK50EthKMVD/Z5b39aAUOxqYC3Jb009RLrMxsK8mgYOS
         N8dgALlGdkm5WNoBOLBfBi4BlZd+XewsMuyNArO0lh0pl24xpr8Lb1aa2PqScGpI3Bbm
         i6xkweusfrghdozc13V+owwpGv6jUDoVFXsbnUIqi4Uvj67lP4/TTwZljmPl3bXtm6rP
         mkmw==
X-Gm-Message-State: AOJu0YzjnsW4kLAaj6AJWIGr7Asj/hI0mK/xKuPjOHfgQXthBvVB3OML
	Eum9IT/BoE4qkz5P6y1xKePd9WAX8zGCQQzo7zEI2FKCX4AmXf/++wfGVw==
X-Google-Smtp-Source: AGHT+IF4Xfi4kqUWQL2hP1kKe4eS62B4UdADKc09LzLSX3UOWiWxmQny0SeKj2aLhXilvr2tG/Gh6A==
X-Received: by 2002:a05:6a21:271b:b0:1b1:d2a5:c7b1 with SMTP id adf61e73a8af0-1b212df0622mr1359777637.49.1716529094893;
        Thu, 23 May 2024 22:38:14 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcbe9f61sm460374b3a.110.2024.05.23.22.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 22:38:14 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Subject: [PATCH libnetfilter_queue v2 15/15] build: Remove libnfnetlink from the build
Date: Fri, 24 May 2024 15:37:42 +1000
Message-Id: <20240524053742.27294-16-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20240524053742.27294-1-duncan_roe@optusnet.com.au>
References: <20240524053742.27294-1-duncan_roe@optusnet.com.au>
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


Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F413216CD30
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Jul 2024 12:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720787945; cv=none; b=jxXXLndVkVomugUae3B9X7YYVpLLYTQHvjpSuIjkd2rGutNluphyo8mscAHxyfeI4DJ+0WJI1J/OgywwW2z4QmniU6CdBgVzOSJam/k4tqdlUR7axn09aljVx70TOFzHRChDojazeJ57xbmZTE26JfSs2Wc4vnxaMI4qI/C3LTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720787945; c=relaxed/simple;
	bh=STosxXf5pyaJNDca33jQkpZIKtA5Efax5jUz5ofsFRU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aixMrmeRph5YNYq929qpe4Ew3MxNaB1Pb9n9/m8Yjq7eUjDW4GGw63DlLAXfez36yS/cM2PmOWZZtnJZ32IuMczZ0/mDpqVdBmqlfnmyJD5WvTCLCt/ExjxSUqdTFu/fomNyde3WnsKtGkhwGohDoaHdQQXINg56MxRmrYlJY58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=RmKCoGZ6; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="RmKCoGZ6"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4266f344091so15035305e9.0
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jul 2024 05:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1720787942; x=1721392742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PfG6vDqW6l4NDiGhE85EiFpXifUp6GuVWIM/fodIMLM=;
        b=RmKCoGZ6uHA0swZRBI+XynS2uV3Sunw4qOvOcsZtKdKLhV7wyGD5qGhpw2d1hc65Xw
         sUxs7EBBK5IZjyb+PI9zro36k5Bvc3+TSBd/QcPyWVuum8i7UqbHN98FTS/zjR/mNckH
         8jSqZ1qNrdK0luwQ8Y9UYZZZayvR6+vs6dcIXX/wIOCyoV6bt4ZO031FCEzchUlZKcQO
         X43JwmVSoMxlbaNzUwnuZMHQAV4jNq6hgt86/yJXvVv507ByX3ItD9IVP24obGS13O2O
         RsumiBVUip7Ftj/7waN5NquXGpZ0uXDW2bZY1VIkoPXJlh4mrr6dvU2lRTfM2sn0lwPy
         vmhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720787942; x=1721392742;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PfG6vDqW6l4NDiGhE85EiFpXifUp6GuVWIM/fodIMLM=;
        b=tERMQcKkQtwIdwvCYHLrDQeFXX3iyT0TKpntrwXUlXH+NWosxEU0sYnkEpCXNDoE5c
         tsNR4iLYkLyEzv/FDFhO1tBV9ojj4kQ61NlH7zVzc//hiydDxyXx/JRpF0+UTfxojBLQ
         z+SKXVAbGBKRWOekd1E689+2t17LiuGckaLYO2+v9GbPQ5I8TkP7m1bLSEhfzN8VfSLh
         ZEiohGoDhxuf2CB0jF/iQSl0PBT+Jgl9cj67YTpuihjYpBV9JijUyPC5et8+ZDf52SVH
         E7x4qu9Z6C5BMEm2A4i3XKeuvoIacQ4M/GInudhLGuS0wVId1UnCXrli56Fi++LJkTNa
         sACw==
X-Gm-Message-State: AOJu0YwxQClIkJ4yCX6Af2lUaE77YrR4XivwiXJN5jcAi0upRKVYeerz
	+oz09vr4PAGZIJDcicbSzB7NXUXaUvIKdAa1om4J4056Hdrhlzk08KKClw==
X-Google-Smtp-Source: AGHT+IERxaqMC7DhHQK+wHDkRlc2EvbSRSRDxqzS6nOARNz/fPvnzxeQYJ7Uvj/S9T/O+SCGc0jHFw==
X-Received: by 2002:a05:600c:3b92:b0:426:6a53:e54f with SMTP id 5b1f17b1804b1-426708f1fdamr68098925e9.33.1720787941752;
        Fri, 12 Jul 2024 05:39:01 -0700 (PDT)
Received: from localhost.localdomain (shef-16-b2-v4wan-169484-cust5160.vm3.cable.virginm.net. [92.236.212.41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4279f2cc499sm21732435e9.29.2024.07.12.05.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 05:39:01 -0700 (PDT)
From: Joshua Lant <joshualant@googlemail.com>
X-Google-Original-From: Joshua Lant <joshualant@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Joshua Lant <joshualant@gmail.com>
Subject: [PATCH] configure: Add option for building with musl
Date: Fri, 12 Jul 2024 12:38:59 +0000
Message-Id: <20240712123859.1108496-1-joshualant@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adding this configure option fixes compilation errors which occur when
building with musl-libc. These are known issues with musl that cause structure
redefinition errors in headers between linux/if_ether.h and
netinet/ether.h.

Signed-off-by: Joshua Lant joshualant@gmail.com
---
 INSTALL      |  7 +++++++
 configure.ac | 10 +++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/INSTALL b/INSTALL
index d62b428c..8095b0bb 100644
--- a/INSTALL
+++ b/INSTALL
@@ -63,6 +63,13 @@ Configuring and compiling
 	optionally specify a search path to include anyway. This is
 	probably only useful for development.
 
+--enable-musl-build
+
+	When compiling against musl-libc, you may encounter issues with
+	redefinitions of structures in headers between musl and the kernel.
+	This is a known issue with musl-libc, and setting this option
+	should fix your build.
+
 If you want to enable debugging, use
 
 	./configure CFLAGS="-ggdb3 -O0"
diff --git a/configure.ac b/configure.ac
index 2293702b..7f54ccd1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -77,6 +77,9 @@ AC_ARG_WITH([xt-lock-name], AS_HELP_STRING([--with-xt-lock-name=PATH],
 AC_ARG_ENABLE([profiling],
 	AS_HELP_STRING([--enable-profiling], [build for use of gcov/gprof]),
 	[enable_profiling="$enableval"], [enable_profiling="no"])
+AC_ARG_ENABLE([musl-build],
+    AS_HELP_STRING([--enable-musl-build], [Set this option if you encounter compilation errors when building with musl-libc]),
+    [enable_musl_build="$enableval"], [enable_musl_build="no"])
 
 AC_MSG_CHECKING([whether $LD knows -Wl,--no-undefined])
 saved_LDFLAGS="$LDFLAGS";
@@ -206,6 +209,10 @@ if test "x$enable_profiling" = "xyes"; then
 	regular_LDFLAGS+=" -lgcov --coverage"
 fi
 
+if test "x$enable_musl_build" = "xyes"; then
+	regular_CFLAGS+=" -D__UAPI_DEF_ETHHDR=0"
+fi
+
 define([EXPAND_VARIABLE],
 [$2=[$]$1
 if test $prefix = 'NONE'; then
@@ -277,7 +284,8 @@ Build parameters:
   Installation prefix (--prefix):	${prefix}
   Xtables extension directory:		${e_xtlibdir}
   Pkg-config directory:			${e_pkgconfigdir}
-  Xtables lock file:			${xt_lock_name}"
+  Xtables lock file:			${xt_lock_name}
+  Build against musl-libc:		${enable_musl_build}"
 
 if [[ -n "$ksourcedir" ]]; then
 	echo "  Kernel source directory:		${ksourcedir}"
-- 
2.25.1


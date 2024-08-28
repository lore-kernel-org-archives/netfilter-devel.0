Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0EE149C7A
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Aug 2024 12:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724849260; cv=none; b=AJjXcjbd9WPNQC3HLhtZPYJ5Am1ktlXBPHrwkuU8e2Du1fEVwAMq3TJ0ZqwXxHQWUnenlhzn9PkpO7dS7oUUyb7igN0bApnvbGllJr/oy1kNfVAYi6W3DOo13ZEllNmIh9Dadg6+eBu2XtKl5xXTs/NyukJ0v8ZdW6mHeT9SSvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724849260; c=relaxed/simple;
	bh=oGX/eCEWKFZOPksVf2hlTyAv7EJeZbMJFfj6ryCvA9U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AB+iyRiYjA/eNG2Br3rxT5fX1qNeF8YaryORUuO0diEYsovBSUajbL0BPGiQ+SPhBE595QsZfNRG0w7mOAvejJLMO8uHw5rq46BDPnTarVA07uc0Ie1+R0WosUenXC+9EMf2JEuyHNbFp9NUR3EpwoqVD3us0pT6BJcvvsJu/Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lBYTPv87; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lBYTPv87"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-427fc97a88cso58819265e9.0
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Aug 2024 05:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1724849256; x=1725454056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N+rlFF1WOmr9CfghIFm6PeDDAS0bMBJO6+BO+r0XMkU=;
        b=lBYTPv8729YqXhz4HC6lKDi+AAg3J0acxoD+RExSe7lq0ra69xDYd924kwdMrm5vTy
         qtzBdj61Z6DkF0TobosTcFThyZiVAJGoRdC0YwM1I7LaODFGUG/N2nOZCu1mfBvANchZ
         uJ/VAAkpbOnlPr48j+v+k5hMtQv9ykhuZUr0fSZujf+SSH9g6nooJ/yMwfjiDSUoDPhn
         lZUH965vzab7NocbuFYVTY7ZJ1VpMeKCQZejHzeva+Cfask2a98opB0UTXrrytOq+DJr
         4hYZeZIXKNoj9I3/aQPg1jSaB4aSvFiK522U61lUO44q+fEfIUCl/Y2rOEwJTiEUDQbC
         SQng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724849256; x=1725454056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N+rlFF1WOmr9CfghIFm6PeDDAS0bMBJO6+BO+r0XMkU=;
        b=bcraVJnr8gRsCi3H8TgI8NOZBudKbinWVh0380cZYTl3hOofo+OBwv45VJM+CFDrPd
         TXJr4kF3bYNBUu5+s4I2mPTGN2I/iYzCBzVIKCOO07kdjovNlCIy2pyv3cgmEZ46o7Zi
         imkqLfP1QYphhZ76uS7WqxvObj+tj83A+dnCBSuBKbMxjUjbF/EQNe+vEXHS5SYoij/s
         gX/NKDSN2GOLcy5g72C02RAj5rxu/Losm8m+ynFMhdizF9YYPmeyPG1BWXkThft4e/JT
         3G7wBiUisPreqrhhRjU/lAivWFFY2Gu1f3ubc279kehHYkMhOSq5F/Yx1IVmLWE9KN1t
         srFg==
X-Gm-Message-State: AOJu0Yw2i+QB3aSELnxoiid3irE0CO1NNzDm8p+IxHmezgUac9vTMGaQ
	dtzKSt86FV1Q6/PsfSsUoqhXUl7YKlV5XRlEnmVqzXahlxhh0vgBCdfEYg==
X-Google-Smtp-Source: AGHT+IEwTZYi8Za51b9ORzCIo4Bqcv2OmblaAt4F2mVTJ/swyvoQmhccB6IqAlFMTmKp5kfFMRE/VQ==
X-Received: by 2002:adf:ea90:0:b0:371:8d08:6309 with SMTP id ffacd0b85a97d-373118e9fc3mr10503272f8f.55.1724849255863;
        Wed, 28 Aug 2024 05:47:35 -0700 (PDT)
Received: from thinkpc.. (shef-16-b2-v4wan-169484-cust5160.vm3.cable.virginm.net. [92.236.212.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a86e5486264sm242777966b.39.2024.08.28.05.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 05:47:35 -0700 (PDT)
From: Joshua Lant <joshualant@googlemail.com>
X-Google-Original-From: Joshua Lant <joshualant@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Joshua Lant <joshualant@gmail.com>
Subject: [PATCH iptables 1/1] configure: Determine if musl is used for build
Date: Wed, 28 Aug 2024 13:47:31 +0100
Message-Id: <20240828124731.553911-2-joshualant@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240828124731.553911-1-joshualant@gmail.com>
References: <20240828124731.553911-1-joshualant@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Error compiling with musl-libc:
The commit hash 810f8568f44f5863c2350a39f4f5c8d60f762958
introduces the netinet/ether.h header into xtables.h, which causes an error due
to the redefinition of the ethhdr struct, defined in linux/if_ether.h and
netinet/ether.h. This is fixed by the inclusion of -D__UAPI_DEF_ETHHDR=0 in
CFLAGS for musl. Automatically check for this macro, since it is defined
in musl but not in glibc.

Signed-off-by: Joshua Lant joshualant@gmail.com
---
 configure.ac | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 2293702b..14106a7e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -206,6 +206,27 @@ if test "x$enable_profiling" = "xyes"; then
 	regular_LDFLAGS+=" -lgcov --coverage"
 fi
 
+AC_MSG_CHECKING([whether the build is using musl-libc])
+enable_musl_build=""
+
+AC_COMPILE_IFELSE(
+	[AC_LANG_PROGRAM([[#include <netinet/if_ether.h>]],
+	[[
+	#if defined(__UAPI_DEF_ETHHDR) && __UAPI_DEF_ETHHDR == 0
+		return 0;
+	#else
+		#error error trying musl...
+	#endif
+	]]
+	)],
+	[enable_musl_build="yes"],[enable_musl_build="no"]
+)
+AC_MSG_RESULT([${enable_musl_build}])
+
+if test "x$enable_musl_build" = "xyes"; then
+	regular_CFLAGS+=" -D__UAPI_DEF_ETHHDR=0"
+fi
+
 define([EXPAND_VARIABLE],
 [$2=[$]$1
 if test $prefix = 'NONE'; then
@@ -277,7 +298,8 @@ Build parameters:
   Installation prefix (--prefix):	${prefix}
   Xtables extension directory:		${e_xtlibdir}
   Pkg-config directory:			${e_pkgconfigdir}
-  Xtables lock file:			${xt_lock_name}"
+  Xtables lock file:			${xt_lock_name}
+  Build against musl-libc:		${enable_musl_build}"
 
 if [[ -n "$ksourcedir" ]]; then
 	echo "  Kernel source directory:		${ksourcedir}"
-- 
2.34.1


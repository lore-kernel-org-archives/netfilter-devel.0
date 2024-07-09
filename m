Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162651662E9
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jul 2024 13:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720530352; cv=none; b=D8+7PMGDL/wQO2paMdyiJug/GHxSl4uNPmfAexqSknsY6Ue8rSF/bFk3Y+fta2ypJcznfcq+Fjxcza/hLoxOU1FWBXrlUClaFbyXdEXmIImf3lUa6503LNg7v9b96nqwLMRzMhxGDEVWJHJlb0spP9n3Tz6drXpXt7MZF0EeXAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720530352; c=relaxed/simple;
	bh=YN1molYpntjijbRQvi564WCcHB7GX1ht1tQbZNlKHHE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=on6AUbY52ivtoGF8PoWir5RG252Vqx5CohtCe2jzF0SNCfNhe6RnmVyJS2I3FeMRKC0a+Ml8JUNpo0F8MxMMB7SVcRRx3CKfgaA1KoC9+P5oPvwYtUkr8uRYfAtpIX1bCElLV1OAsG6o6qXgNjgKdFlAdUNsV6tDx/W+RI2emDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=dUxF3Rm2; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="dUxF3Rm2"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-36799fb93baso3496708f8f.0
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jul 2024 06:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1720530349; x=1721135149; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KK5Uz6+VS2dvRKDvhz+CbXGyXB5LLWExzikLHS1GuwI=;
        b=dUxF3Rm2otiHxWnJz95RhNCf+wPllLLj1lVaqOE4zm7ydUzrHik0RRTQ35WyUUBFUs
         ymhTBsjXbHUQbMwvKSkUR8lGEeN9hLAvgZCzRiVDaxDxOOnjfJrLdKiIlIKccvJx8ibL
         LuhGqtzdwe/ovOATM20Ydt8j/37FvOR/FnYSh18eM0XTGF1Ogg3j82t7hl8uB9nTHbcn
         beJrSISvn8iM+30a4AdD+Xvul+FNM0wRYcoCY9DMB54nyH5tlsxGcxLNeW3MrISExdXX
         TTUZUsSy48WBFKQntwnO0SsMzWkVia28pxTEjcXSQztOnuKakOXLquxeRYOBNaIZ+wOx
         Gwow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720530349; x=1721135149;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KK5Uz6+VS2dvRKDvhz+CbXGyXB5LLWExzikLHS1GuwI=;
        b=Kk5dQb1ZJZJGJP5qa9EDg+2+E6c0PoE9tTmUw1z7huqRI6rq0pjREhDTzonCEqMvUY
         0rY9TpGtovuSSQT8AJPVhXXpVzN4j46olm2wZr6OVEjh0LTd+P3JyxTlXwS8ZO3iT+YJ
         iyQxMhJSLD/h39bVNXo3d8KTwsIyBzYy03to+JcoRAlQATh5F6B+fdS8mSdCOxcrfFPd
         q7bSy+akjT/EH6HbLwhVlx9n0ffdT5Dk20vsLX5zLHUzwYcfI0X+Ko3LSbUapuj2XqxE
         2yIrHqzvkg5CcWoH3WVLY/TzS/Zh6FE67abryPUJlArvL1tNFE381aOo3Pl/ilkn1ORi
         RgMg==
X-Gm-Message-State: AOJu0Yyng+f1RFrOMMBczxTcq4uhGkGwx2PmQ4ObE3Qg5E/U12fISvrA
	fY9A5MDeiTTlcsbYlYdM75NuslNjdpn8G/WwWLDYU5LXWKM+hmpO5CmG3A==
X-Google-Smtp-Source: AGHT+IFyuImMl1VT8vOo8mGFjSPmf+3Dl04FwuOUw3x6yd5lM7a+zfCZ7b9wYaMx7uj6e9nTKWHW3w==
X-Received: by 2002:a5d:408d:0:b0:367:326b:f257 with SMTP id ffacd0b85a97d-367cea9656emr1599297f8f.33.1720530348713;
        Tue, 09 Jul 2024 06:05:48 -0700 (PDT)
Received: from localhost.localdomain (shef-16-b2-v4wan-169484-cust5160.vm3.cable.virginm.net. [92.236.212.41])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-367cde84712sm2532507f8f.33.2024.07.09.06.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 06:05:48 -0700 (PDT)
From: Joshua Lant <joshualant@googlemail.com>
X-Google-Original-From: Joshua Lant <joshualant@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Joshua Lant <joshualant@gmail.com>
Subject: [PATCH] xtables: Fix compilation error with musl-libc
Date: Tue,  9 Jul 2024 13:05:45 +0000
Message-Id: <20240709130545.882519-1-joshualant@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Error compiling with musl-libc:
The commit hash 810f8568f44f5863c2350a39f4f5c8d60f762958 introduces the
netinet/ether.h header into xtables.h, which causes an error due to the
redefinition of the ethhdr struct, defined in linux/if_ether.h and
netinet/ether.h.

This is is a known issue with musl-libc, with kernel headers providing
guards against this happening when glibc is used:
https://wiki.musl-libc.org/faq (Q: Why am I getting “error: redefinition
of struct ethhdr/tcphdr/etc”?)

The only value used from netinet/ether.h is ETH_ALEN, which is already set
manually in libxtables/xtables.c. Move this definition to the header and
eliminate the inclusion of netinet/if_ether.h.

Signed-off-by: Joshua Lant joshualant@gmail.com
---
 include/xtables.h    | 5 ++++-
 libxtables/xtables.c | 4 ----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index ab856ebc..e80d0a8e 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -12,13 +12,16 @@
 #include <stdbool.h>
 #include <stddef.h>
 #include <stdint.h>
-#include <netinet/ether.h>
 #include <netinet/in.h>
 #include <net/if.h>
 #include <linux/types.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
 
+#ifndef ETH_ALEN
+#define ETH_ALEN 6
+#endif
+
 #ifndef IPPROTO_SCTP
 #define IPPROTO_SCTP 132
 #endif
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 7b370d48..b3219751 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -71,10 +71,6 @@
 #define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
 #endif
 
-#ifndef ETH_ALEN
-#define ETH_ALEN 6
-#endif
-
 /* we need this for ip6?tables-restore.  ip6?tables-restore.c sets line to the
  * current line of the input file, in order  to give a more precise error
  * message.  ip6?tables itself doesn't need this, so it is initialized to the
-- 
2.25.1


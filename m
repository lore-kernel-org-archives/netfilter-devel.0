Received: from smtp-out.freemail.hu (fmfe19.freemail.hu [46.107.16.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E544C97;
	Tue,  7 Jan 2025 02:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736217723; cv=none; b=YkERzmFxKOsf44ByKottvohkUFP7cdfwn3Vop6lGtKSd6jPOcxcWA6YxsfomiObYpeIX2My6oxRZ1v4dgrxGBgcQi/dJT1rTtJdZAym+mKQqaMu6nHklRRlErs/fQkT/t24Y7/hQCJIlLPrQqphzrlaUOMS1lDs3p15q/NCwVRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736217723; c=relaxed/simple;
	bh=CoZLwngNk1HI+xyUEzftbV9Cp6J/4wCAg0aIq8aJz64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S44lp8LcdWgykcWasYQleazMutbqUB8J6xO8vdBJW1UymPUtB4bHKvhx1fiHuSFcbpKKiW+nNHlurg4dZ2z9uP3sJTdapRQNRWtNFPOSvn7bY/27IzwICUdqURPWGxlJ2Gvb5fl7TT1pWkA25QpvLrqbsZ4YbnMw9mLH37goS6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=UR63CZRX reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="UR63CZRX"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRwLF2Yp2zVJf;
	Tue, 07 Jan 2025 03:41:57 +0100 (CET)
From: egyszeregy@freemail.hu
To: fw@strlen.de,
	pablo@netfilter.org,
	lorenzo@kernel.org,
	daniel@iogearbox.net,
	leitao@debian.org,
	amiculas@cisco.com,
	kadlec@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: =?UTF-8?q?Benjamin=20Sz=C5=91ke?= <egyszeregy@freemail.hu>
Subject: [PATCH 02/10] netfilter: x_tables: Merge xt_RATEEST.h to xt_rateest.h
Date: Tue,  7 Jan 2025 03:41:12 +0100
Message-ID: <20250107024120.98288-3-egyszeregy@freemail.hu>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250107024120.98288-1-egyszeregy@freemail.hu>
References: <20250107024120.98288-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736217717;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=1879; bh=VHMDPbZs+ZeIAPvV9I4olaEjrmptl5QG2Xf+QZlijjI=;
	b=UR63CZRXQXgk2UUAtyoaYIvVdYyx+TufDLVBRO9ED7Kb+npX9nA73OqKbwCLiLgo
	GXlBvl1hq+5Qi0K7+wCReAqXb63A7hR71ulnfG8rl9tnksUy7/nFJNXatxIR2DIXJ+o
	qs8T22miSxE1RSKB7/c5CUTP3HDK49W4hYYY1if/4HgMV1fm9812V4sqGW7zktPM/lH
	CXvOX9yKC3q4l7U0OqZYuD/00W3b5640iylPPL17Q32gJaH0gw5WIABlZzhMReBIu8h
	8ZnUdmIjP5SQhjs+6HpmGBENojzNy5LPiyQy4GQ70zNtcavz6gcmqBNr96eVYa3njcq
	wWeKMCDeow==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Merge xt_RATEEST.h to xt_rateest.h header file.

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 include/uapi/linux/netfilter/xt_RATEEST.h | 12 +-----------
 include/uapi/linux/netfilter/xt_rateest.h | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_RATEEST.h b/include/uapi/linux/netfilter/xt_RATEEST.h
index 2b87a71e6266..f817b5387164 100644
--- a/include/uapi/linux/netfilter/xt_RATEEST.h
+++ b/include/uapi/linux/netfilter/xt_RATEEST.h
@@ -2,16 +2,6 @@
 #ifndef _XT_RATEEST_TARGET_H
 #define _XT_RATEEST_TARGET_H
 
-#include <linux/types.h>
-#include <linux/if.h>
-
-struct xt_rateest_target_info {
-	char			name[IFNAMSIZ];
-	__s8			interval;
-	__u8		ewma_log;
-
-	/* Used internally by the kernel */
-	struct xt_rateest	*est __attribute__((aligned(8)));
-};
+#include <linux/netfilter/xt_rateest.h>
 
 #endif /* _XT_RATEEST_TARGET_H */
diff --git a/include/uapi/linux/netfilter/xt_rateest.h b/include/uapi/linux/netfilter/xt_rateest.h
index 52a37bdc1837..da9727fa527b 100644
--- a/include/uapi/linux/netfilter/xt_rateest.h
+++ b/include/uapi/linux/netfilter/xt_rateest.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _XT_RATEEST_MATCH_H
-#define _XT_RATEEST_MATCH_H
+#ifndef _UAPI_XT_RATEEST_H
+#define _UAPI_XT_RATEEST_H
 
 #include <linux/types.h>
 #include <linux/if.h>
@@ -36,4 +36,13 @@ struct xt_rateest_match_info {
 	struct xt_rateest	*est2 __attribute__((aligned(8)));
 };
 
-#endif /* _XT_RATEEST_MATCH_H */
+struct xt_rateest_target_info {
+	char		name[IFNAMSIZ];
+	__s8		interval;
+	__u8		ewma_log;
+
+	/* Used internally by the kernel */
+	struct xt_rateest	*est __attribute__((aligned(8)));
+};
+
+#endif /* _UAPI_XT_RATEEST_H */
-- 
2.43.5


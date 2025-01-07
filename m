Received: from smtp-out.freemail.hu (fmfe19.freemail.hu [46.107.16.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B81D158520;
	Tue,  7 Jan 2025 02:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736217760; cv=none; b=Ukrs3brp8hh9UBPJ58JkE5vR2P/bj3XH0LC2SqFAZZlgQ4+yE9ClqkH0Ub69j66D5jZm0AdqDjyu8aR2YMkmO9TKCc4IWmwUPfdQHK0WvuUVQHIooY/O0KpmujZIo12UCDuEO4s1ZDyJRQIstEn3ym9Cn6QOjVaaldrhkwSUGNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736217760; c=relaxed/simple;
	bh=xCcWsG/Q99+lso4CrTjjKzMXu9jpM7dMCvc873YJkM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fQSpQ16TsmzLaVDbl1aREmP3rhO+RgkolVMb0kQFeKJ566kHgF+dFlgx0ks4AG65z4b4V0kiyMHeTdrt/ZFZ7JSVbA9fmRvmhkWNHkImDoKO4ug/jKLLS+7q6o1sKSiM5vhGxSnFTOoq7l/DouCFH2WAh9ACRcc2bwEQXCpxz4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=XkqWBjQm reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="XkqWBjQm"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRwLx5lbrzVWy;
	Tue, 07 Jan 2025 03:42:33 +0100 (CET)
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
Subject: [PATCH 04/10] netfilter: x_tables: Use consistent header guard
Date: Tue,  7 Jan 2025 03:41:14 +0100
Message-ID: <20250107024120.98288-5-egyszeregy@freemail.hu>
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
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736217754;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=2788; bh=U+O+QQrBgE01gkQ3uru8WWKkGH/VzN/ORKkOt4devos=;
	b=XkqWBjQmD1M5dabRUOSMpUe1++Zq7QQvPtpZJrGHvXrGT2S2IxjFUNGHTUHRN1gy
	JJZsUvbjjKwgOsUhzdra1c0mmWf26UA699KEkI3AclM8hCCcMPWeBabYSRhc1Hgf7HS
	X3SOZ5JtKPltRCVd8Q10bV3BwPgj9NO+jC0SPs0nguvOukdm3v0w0E6f7bjE9h1kuZd
	bE1nRs1gDNbAyd+3k+pIxYIzX5++tQ1UgAvMrLA61wsxy5+rrE1uBRzMaCA/xes5k3y
	35RSc1cHEPYVAq8TRDKh2NzgUzbbl9G3GFvlE5jl/vnU6QU5PxbImpUUKfXug0/4TMK
	b5lA4+TS0Q==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Use consistent header guard in xt_connmark.h and xt_mark.h files.

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 include/uapi/linux/netfilter/xt_CONNMARK.h | 6 +++---
 include/uapi/linux/netfilter/xt_MARK.h     | 6 +++---
 include/uapi/linux/netfilter/xt_connmark.h | 7 +++----
 include/uapi/linux/netfilter/xt_mark.h     | 6 +++---
 4 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_CONNMARK.h b/include/uapi/linux/netfilter/xt_CONNMARK.h
index 36cc956ead1a..171af24ef679 100644
--- a/include/uapi/linux/netfilter/xt_CONNMARK.h
+++ b/include/uapi/linux/netfilter/xt_CONNMARK.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _XT_CONNMARK_H_target
-#define _XT_CONNMARK_H_target
+#ifndef _XT_CONNMARK_TARGET_H
+#define _XT_CONNMARK_TARGET_H
 
 #include <linux/netfilter/xt_connmark.h>
 
-#endif /*_XT_CONNMARK_H_target*/
+#endif /* _XT_CONNMARK_TARGET_H */
diff --git a/include/uapi/linux/netfilter/xt_MARK.h b/include/uapi/linux/netfilter/xt_MARK.h
index f1fe2b4be933..cdc12c0954b3 100644
--- a/include/uapi/linux/netfilter/xt_MARK.h
+++ b/include/uapi/linux/netfilter/xt_MARK.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _XT_MARK_H_target
-#define _XT_MARK_H_target
+#ifndef _XT_MARK_H_TARGET_H
+#define _XT_MARK_H_TARGET_H
 
 #include <linux/netfilter/xt_mark.h>
 
-#endif /*_XT_MARK_H_target */
+#endif /* _XT_MARK_H_TARGET_H */
diff --git a/include/uapi/linux/netfilter/xt_connmark.h b/include/uapi/linux/netfilter/xt_connmark.h
index 41b578ccd03b..a3f03729805b 100644
--- a/include/uapi/linux/netfilter/xt_connmark.h
+++ b/include/uapi/linux/netfilter/xt_connmark.h
@@ -2,9 +2,8 @@
 /* Copyright (C) 2002,2004 MARA Systems AB <https://www.marasystems.com>
  * by Henrik Nordstrom <hno@marasystems.com>
  */
-
-#ifndef _XT_CONNMARK_H
-#define _XT_CONNMARK_H
+#ifndef _UAPI_XT_CONNMARK_H
+#define _UAPI_XT_CONNMARK_H
 
 #include <linux/types.h>
 
@@ -34,4 +33,4 @@ struct xt_connmark_mtinfo1 {
 	__u8 invert;
 };
 
-#endif /*_XT_CONNMARK_H*/
+#endif /* _UAPI_XT_CONNMARK_H */
diff --git a/include/uapi/linux/netfilter/xt_mark.h b/include/uapi/linux/netfilter/xt_mark.h
index 9d0526ced8f0..adcd90b00786 100644
--- a/include/uapi/linux/netfilter/xt_mark.h
+++ b/include/uapi/linux/netfilter/xt_mark.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _XT_MARK_H
-#define _XT_MARK_H
+#ifndef _UAPI_XT_MARK_H
+#define _UAPI_XT_MARK_H
 
 #include <linux/types.h>
 
@@ -13,4 +13,4 @@ struct xt_mark_mtinfo1 {
 	__u8 invert;
 };
 
-#endif /*_XT_MARK_H*/
+#endif /* _UAPI_XT_MARK_H */
-- 
2.43.5


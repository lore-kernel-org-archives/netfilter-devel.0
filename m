Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BD013C918
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Aug 2024 09:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724404942; cv=none; b=WfCtrH6HW2yk6F9AMGRbwWvuHauXqyyl7TDqSiI5zc/bCTLNSN2riswh38t5qwXMRVcg+9tqX+vDRipqq1jAzwYztcA8Y0YFWqRcKcLn71NRi+CWOg5xn2lSqVoT19r6wyE/HIJgKCrr//VDWxP1dWs5xwcYCmFZQs5fyVLCbgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724404942; c=relaxed/simple;
	bh=PP6M93O66h+a57xZIN8kARZjc+8zZGib0xWYL94kUJs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=C/vZuVu22QqbuE2jQgq69qL3XRhJC6JCGqRtLDTfEyMKpBPX1AoINO/9iDC5qCFNy1czHgFDRTy95LTIEax0YJO1n8jsa6yZX8h8DmLJs4Cg27cx/pzZyRfpJDDvG60RwPazc8SmcuXy1C8pQJ8oT/Tfma9uQkM9nrm5E04gPdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Fn+Aglsb; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Fn+Aglsb"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a7ab5fc975dso202481666b.1
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Aug 2024 02:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1724404939; x=1725009739; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Wc1kyfrEJtJwx3AClqnJlzkB1+dwSceATO6xA2USX2w=;
        b=Fn+AglsbCV/ESJf7gXUcWbCP+9RyxMrELRUFyg96CNFSSA+erzTd1leVXjkdZkPsWF
         N1m7Lvdm6Cok9k2dsQFT6iTqHQRUfgdywv0REEETvO7R6Bb4cvyiL/05NhfKymP0Dakv
         IQ6R4ofRAcnrJuwqZsT3PXcmN/CJpzsqGHzJKuvlZ5qTiE0+f/l4ZcqEj0Hf7gYhKkq+
         RWQWzI6xDEe/AYo3zF09jgWPRRIW5TCLLJyCBTdkzxuC3Ui+kFwZLSqj+F216OxtM6vz
         DM8xU3EG87c59vlVIBTZCM1pnBDiI8+dqQN+Uq/3meSdSH5xAl/uexgH6jgri8xUKHRE
         yibw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724404939; x=1725009739;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wc1kyfrEJtJwx3AClqnJlzkB1+dwSceATO6xA2USX2w=;
        b=KH2jT+NRgZwVN0178Yqy2NFa/g387F5u6AjB5CDYSnEpVGJB4VJoiBR8OGQtlOMTDV
         gYb4X2s1sn9IAxl+77W6zXg00bCoJ9HFyWM2ahNVNvzo4rMZ7rYaoqiDpiZ+sVK38ji/
         52w0z5Zev0VRXx3mvzYA4x9j98QQVdZhzYHtBI/vOwpQ+QVvULWeEM2Ro0LmYeEI7rPZ
         ktIPe7LKB5YXOPyrzK90F3q8BGzb4twNgYM3GBnM7n/gJ0k+WK1B3+kWe+dcCsMl6Q0Q
         XDoTO60lgw4rvIY8HOqb7lADZn9AQBbN4KDsNOsPlGX8Tw1+0j7zjyzhfrc/eVkqH33e
         GPlw==
X-Gm-Message-State: AOJu0YyornU+JxOwdk56UADa6y59Awk9Y2Imn6mq3Ncqvv7zpvNKonuz
	G63zcNB4P4uENOb40iMdMWMNREb8VxZHNV7P9Tz3OCN+BfQhBrgCASymbA==
X-Google-Smtp-Source: AGHT+IE1t7k+LSsKUSlZujzyR4bhhiCZ5ehcebWzG2O9pa9wMZ1JedIMXG8ZjVhIT3ItWgZV/f09qw==
X-Received: by 2002:a17:907:f151:b0:a7a:aa35:409e with SMTP id a640c23a62f3a-a86a52bb61emr105379466b.25.1724404938641;
        Fri, 23 Aug 2024 02:22:18 -0700 (PDT)
Received: from thinkpc.. (shef-16-b2-v4wan-169484-cust5160.vm3.cable.virginm.net. [92.236.212.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f222b2esm230913766b.24.2024.08.23.02.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 02:22:18 -0700 (PDT)
From: Joshua Lant <joshualant@googlemail.com>
X-Google-Original-From: Joshua Lant <joshualant@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Joshua Lant <joshualant@gmail.com>
Subject: [PATCH] iptables: align xt_CONNMARK with current kernel headers
Date: Fri, 23 Aug 2024 10:22:06 +0100
Message-Id: <20240823092206.396460-1-joshualant@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

libxt_CONNMARK.c declares enum which is declared in the kernel header.
Modify the version of the header in the repo's include dir to match the
current kernel, and remove the enum declaration from xt_CONNMARK.c.

Signed-off-by: Joshua Lant joshualant@gmail.com
---
 extensions/libxt_CONNMARK.c           |  5 -----
 include/linux/netfilter/xt_CONNMARK.h |  1 +
 include/linux/netfilter/xt_connmark.h | 19 ++++++++++---------
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index a6568c99..90a5abc0 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -31,11 +31,6 @@ struct xt_connmark_target_info {
 	uint8_t mode;
 };
 
-enum {
-	D_SHIFT_LEFT = 0,
-	D_SHIFT_RIGHT,
-};
-
 enum {
 	O_SET_MARK = 0,
 	O_SAVE_MARK,
diff --git a/include/linux/netfilter/xt_CONNMARK.h b/include/linux/netfilter/xt_CONNMARK.h
index 2f2e48ec..36cc956e 100644
--- a/include/linux/netfilter/xt_CONNMARK.h
+++ b/include/linux/netfilter/xt_CONNMARK.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef _XT_CONNMARK_H_target
 #define _XT_CONNMARK_H_target
 
diff --git a/include/linux/netfilter/xt_connmark.h b/include/linux/netfilter/xt_connmark.h
index bbf2acc9..41b578cc 100644
--- a/include/linux/netfilter/xt_connmark.h
+++ b/include/linux/netfilter/xt_connmark.h
@@ -1,23 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/* Copyright (C) 2002,2004 MARA Systems AB <https://www.marasystems.com>
+ * by Henrik Nordstrom <hno@marasystems.com>
+ */
+
 #ifndef _XT_CONNMARK_H
 #define _XT_CONNMARK_H
 
 #include <linux/types.h>
 
-/* Copyright (C) 2002,2004 MARA Systems AB <http://www.marasystems.com>
- * by Henrik Nordstrom <hno@marasystems.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
 enum {
 	XT_CONNMARK_SET = 0,
 	XT_CONNMARK_SAVE,
 	XT_CONNMARK_RESTORE
 };
 
+enum {
+	D_SHIFT_LEFT = 0,
+	D_SHIFT_RIGHT,
+};
+
 struct xt_connmark_tginfo1 {
 	__u32 ctmark, ctmask, nfmask;
 	__u8 mode;
-- 
2.34.1


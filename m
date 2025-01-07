Received: from smtp-out.freemail.hu (fmfe19.freemail.hu [46.107.16.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FBC13635B;
	Tue,  7 Jan 2025 02:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736217779; cv=none; b=q29hYCZF92ejhVMFMBc2mxpJ64mGg4S7Wwqcdk9WyiaiGzHuzJTHCon0WW9n74gOz9uMhKSZ2sTBVr2Cs6cclXhtl8ssZickYo1slepTr22eluSvonbbKQ1W6ZJaSW7arB5LQtEWcsPkw3Bfs4CWJ4DLPPiR8st6Cu2fWWFIs10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736217779; c=relaxed/simple;
	bh=6o+fzAHkRfrjDzPuDP3xQU2KnPQomA+aJMk6e9jB75s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dzVJYfKnVlV37neUkQtB2nUFywJGpQzvf5Vf9qZwlriVJLzqTxLTQbF2Pfb9nATRGlT3OjPj/gubLWoMfXJSbmWN8jsKEKRcwC0XO2VKy3jmCa+szi3vjbkLVGJgRrTQXNvPg2WuTK0pfUo27cLz8QDf1OMbzkH6tVq+ilMld5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=HYPrLA3U reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="HYPrLA3U"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRwMJ45gmzWwl;
	Tue, 07 Jan 2025 03:42:52 +0100 (CET)
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
Subject: [PATCH 06/10] netfilter: iptables: Merge ipt_TTL.h to ipt_ttl.h
Date: Tue,  7 Jan 2025 03:41:16 +0100
Message-ID: <20250107024120.98288-7-egyszeregy@freemail.hu>
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
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736217773;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=2105; bh=nUYN7A4x2UMF+ZwW0f7oaG/E4oRt0yQxOAXub0eMVWs=;
	b=HYPrLA3U8Rbyw9o5j+TLz09Ahs922/rJmlZ7YIM/uqyo/673h5rviJIyqLufua6g
	J4TB6ySKuMDBtvghshNIVUrQqtmk8Cwfk4TB5qZGTo2KAdaH5flUIdC2HHEX9dbh7ph
	ErpmGBP7gKrGMKncHuhh2fWpDbbu+XGq5HaOkxzjQYCoH0RAHEZzMpLbB99wHTMappn
	IJsK84nXG/WfDQFlc4xQm2BOfevqzLPH+R18lcENxSN0NQJgZujzy3mNOq0GPD2PySi
	jIji+xoQRsk/r1a1Hq79QNVGA9O+mZyYMMLwrXMTPVjBB7QP94gih59rBmquFdBX/7O
	t/+6qx0c8w==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Merge ipt_TTL.h to ipt_ttl.h header file.

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 include/uapi/linux/netfilter_ipv4/ipt_TTL.h | 25 ++++-----------------
 include/uapi/linux/netfilter_ipv4/ipt_ttl.h | 21 +++++++++++++----
 2 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/include/uapi/linux/netfilter_ipv4/ipt_TTL.h b/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
index 57d2fc67a943..5d989199ed28 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
@@ -1,24 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* TTL modification module for IP tables
- * (C) 2000 by Harald Welte <laforge@netfilter.org> */
+#ifndef _IPT_TTL_TARGET_H
+#define _IPT_TTL_TARGET_H
 
-#ifndef _IPT_TTL_H
-#define _IPT_TTL_H
+#include <linux/netfilter_ipv4/ipt_ttl.h>
 
-#include <linux/types.h>
-
-enum {
-	IPT_TTL_SET = 0,
-	IPT_TTL_INC,
-	IPT_TTL_DEC
-};
-
-#define IPT_TTL_MAXMODE	IPT_TTL_DEC
-
-struct ipt_TTL_info {
-	__u8	mode;
-	__u8	ttl;
-};
-
-
-#endif
+#endif /* _IPT_TTL_TARGET_H */
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ttl.h b/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
index ad0226a8629b..c21eb6651353 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* IP tables module for matching the value of the TTL
- * (C) 2000 by Harald Welte <laforge@gnumonks.org> */
-
+/* iptables module for matching/modifying the TTL value
+ * (C) 2000 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2000 by Harald Welte <laforge@netfilter.org>
+ */
 #ifndef _IPT_TTL_H
 #define _IPT_TTL_H
 
@@ -20,5 +21,17 @@ struct ipt_ttl_info {
 	__u8	ttl;
 };
 
+enum {
+	IPT_TTL_SET = 0,
+	IPT_TTL_INC,
+	IPT_TTL_DEC
+};
+
+#define IPT_TTL_MAXMODE	IPT_TTL_DEC
+
+struct ipt_TTL_info {
+	__u8	mode;
+	__u8	ttl;
+};
 
-#endif
+#endif /* _IPT_TTL_H */
-- 
2.43.5


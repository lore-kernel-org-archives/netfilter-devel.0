Received: from smtp-out.freemail.hu (fmfe19.freemail.hu [46.107.16.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE87D154C15;
	Tue,  7 Jan 2025 02:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736217739; cv=none; b=DYLbslxjo668zJbRBugEp3/oMqH5ndnsPGSCmLCMPYMXipPzkOcK2fqU1VLWLal/hXIxPuPPLRNF1eXZdEu7NpzBifEn8jTbLnSXThEEgapid56m4ryPJsI0SVqI0zkUr3v3A1Z+HdkRhOUIDGFSX+rKJPw78fch4fanzKYdzUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736217739; c=relaxed/simple;
	bh=N1iZ0A+L1cR3LWgBVvunWiijh4ctkDKupu86Nc/k02o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u6s9VfL97OdEjN5SN42KR9V9/lhzg2pAhaTAj6YPXpBWF5zjWkTPPDCR+tStW0xpQxzF6KYWefdfFxaQktmmktZHdx/dMTDDB/96J3VAAfgp6MwtQhpKqYFbNlQsYHh2caxtzxCOSjZuhFkrKKSuFwLt4Fkj4hS97VU0NX8SUQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=T52dVo/L reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="T52dVo/L"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRwLZ3tLwzVvS;
	Tue, 07 Jan 2025 03:42:14 +0100 (CET)
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
Subject: [PATCH 03/10] netfilter: x_tables: Merge xt_TCPMSS.h to xt_tcpmss.h
Date: Tue,  7 Jan 2025 03:41:13 +0100
Message-ID: <20250107024120.98288-4-egyszeregy@freemail.hu>
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
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736217734;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=1696; bh=BuL3xsSP3sRZQ1KBecnIjibmE5uLKwimFqRzdhdAoTg=;
	b=T52dVo/Lqu9Q8rWszvo/BN3BsZqh1fZ087Aibzwe5oT5qiJ+aFS9uyVl3Z6z6oiA
	8u6wGPEMrp2avIV3lM1K5MmU+pkVVhS1CIp32LjqUKBtAuoUr2PYyWQskk9xnLaUsh8
	FX54+De51mnDjA99FCGynV9m8TO10u6jZ/aMAOorH6rjHrOFxq+PSGtx5ElK0tb95k3
	q1oxhvTK4QKdMppxHLwq+mvlqYm7utOS9g0Fzvtw/vb5qMaLCJnVoj3UHFAM4Lhv8B2
	LwbSVdsQl8OgAGDsAiGEvoi2o6GvjDOeKb+hYKODolRLao2piRJwbv/hQZv3SnyBqiY
	N3A5kPzkyw==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Merge xt_TCPMSS.h to xt_tcpmss.h header file.

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 include/uapi/linux/netfilter/xt_TCPMSS.h | 14 ++++----------
 include/uapi/linux/netfilter/xt_tcpmss.h | 12 +++++++++---
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_TCPMSS.h b/include/uapi/linux/netfilter/xt_TCPMSS.h
index 65ea6c9dab4b..154e88c1de02 100644
--- a/include/uapi/linux/netfilter/xt_TCPMSS.h
+++ b/include/uapi/linux/netfilter/xt_TCPMSS.h
@@ -1,13 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _XT_TCPMSS_H
-#define _XT_TCPMSS_H
+#ifndef _XT_TCPMSS_TARGET_H
+#define _XT_TCPMSS_TARGET_H
 
-#include <linux/types.h>
+#include <linux/netfilter/xt_tcpmss.h>
 
-struct xt_tcpmss_info {
-	__u16 mss;
-};
-
-#define XT_TCPMSS_CLAMP_PMTU 0xffff
-
-#endif /* _XT_TCPMSS_H */
+#endif /* _XT_TCPMSS_TARGET_H */
diff --git a/include/uapi/linux/netfilter/xt_tcpmss.h b/include/uapi/linux/netfilter/xt_tcpmss.h
index 2268f58b4dec..3ee4acaa6e03 100644
--- a/include/uapi/linux/netfilter/xt_tcpmss.h
+++ b/include/uapi/linux/netfilter/xt_tcpmss.h
@@ -1,12 +1,18 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _XT_TCPMSS_MATCH_H
-#define _XT_TCPMSS_MATCH_H
+#ifndef _UAPI_XT_TCPMSS_H
+#define _UAPI_XT_TCPMSS_H
 
 #include <linux/types.h>
 
+#define XT_TCPMSS_CLAMP_PMTU	0xffff
+
 struct xt_tcpmss_match_info {
     __u16 mss_min, mss_max;
     __u8 invert;
 };
 
-#endif /*_XT_TCPMSS_MATCH_H*/
+struct xt_tcpmss_info {
+	__u16 mss;
+};
+
+#endif /* _UAPI_XT_TCPMSS_H */
-- 
2.43.5


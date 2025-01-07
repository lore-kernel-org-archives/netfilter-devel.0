Received: from smtp-out.freemail.hu (fmfe19.freemail.hu [46.107.16.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EA0770FE;
	Tue,  7 Jan 2025 02:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736217791; cv=none; b=niAIam2NeCs9eJ7nB28EFE55w5oQdjym7A4QluJ/xiil2axBDb4EckFXEek5oyljev54AGLFOnuNo+adEDr45OwN98TvAwGn3wgVPeyTa9ITOFm9luEjaZiBxYZZ5PMgmObZFtUR2Fuj4d0gPHM9P78wOeCWkljzaSCyf4AhAjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736217791; c=relaxed/simple;
	bh=M2/xHC40pTKnude4Ks5GUQHTqs0SC74rEE9yurtG7Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IDS7thxQLIjd2xpw2zLsftPF2fHZfdAQXhtElRi5fUYhpJ0n8fTSKNEKebwODN6FzflSK8eELDCgVdHLxcNkVWkeAbj5a8E3PUxcETSFRtN1dmm1yIEZnghvVEsuvYrAbO1SGx6edeR72Au1TilBh3fS84PTbm9TfoPwYtcpwCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=L67fwGw+ reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="L67fwGw+"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRwMY4W5fzSw0;
	Tue, 07 Jan 2025 03:43:05 +0100 (CET)
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
Subject: [PATCH 07/10] netfilter: iptables: Merge ip6t_HL.h to ip6t_hl.h
Date: Tue,  7 Jan 2025 03:41:17 +0100
Message-ID: <20250107024120.98288-8-egyszeregy@freemail.hu>
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
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736217786;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=2103; bh=EJnyRYzYs0oWDfQj+jkg/6H1ACv4ppRv9UGiJIQj1/k=;
	b=L67fwGw+I2jA/N07pXFH9IOLJgDw3YiGUeMDAEkQe+eNeGXUtwUD1K6q+ENnNOpy
	frAloApvwzMK6h09tNtZzUFtCbdGqnBssnkN8BOohGVBr8uC/8G9E2ES/UeyW6s/Ko4
	O8TVtNSduXoSnil6WFyrwFExO7ScYFcuxlVGM4QHzMpiqGNZwDkVDuPE4RgX7n7rcjG
	6MYXIYe2B0s48gG1D3QWugatkPYPOL0+TmA9Z39S3ROJc4NCW2fMECl79nONN1JyY99
	V2h+oH9Ozgw9rnjK7fCnABcw4rjZ225aLhEI3C1Fy7IRsX1smaEm0lngeewhZ3L3WBU
	LNuTKWsYRQ==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Merge ip6t_HL.h to ip6t_hl.h header file.

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 include/uapi/linux/netfilter_ipv6/ip6t_HL.h | 26 ++++-----------------
 include/uapi/linux/netfilter_ipv6/ip6t_hl.h | 20 ++++++++++++----
 2 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_HL.h b/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
index eaed56a287b4..bcf22824b393 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
@@ -1,25 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* Hop Limit modification module for ip6tables
- * Maciej Soltysiak <solt@dns.toxicfilms.tv>
- * Based on HW's TTL module */
+#ifndef _IP6T_HL_TARGET_H
+#define _IP6T_HL_TARGET_H
 
-#ifndef _IP6T_HL_H
-#define _IP6T_HL_H
+#include <linux/netfilter_ipv6/ip6t_hl.h>
 
-#include <linux/types.h>
-
-enum {
-	IP6T_HL_SET = 0,
-	IP6T_HL_INC,
-	IP6T_HL_DEC
-};
-
-#define IP6T_HL_MAXMODE	IP6T_HL_DEC
-
-struct ip6t_HL_info {
-	__u8	mode;
-	__u8	hop_limit;
-};
-
-
-#endif
+#endif /* _IP6T_HL_TARGET_H */
diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_hl.h b/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
index 6b62f9418eb2..caef38a63b8f 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* ip6tables module for matching the Hop Limit value
+/* ip6tables module for matching/modifying the Hop Limit value
  * Maciej Soltysiak <solt@dns.toxicfilms.tv>
- * Based on HW's ttl module */
-
+ * Based on HW's ttl module
+ */
 #ifndef _IP6T_HL_H
 #define _IP6T_HL_H
 
@@ -21,5 +21,17 @@ struct ip6t_hl_info {
 	__u8	hop_limit;
 };
 
+enum {
+	IP6T_HL_SET = 0,
+	IP6T_HL_INC,
+	IP6T_HL_DEC
+};
+
+#define IP6T_HL_MAXMODE	IP6T_HL_DEC
+
+struct ip6t_HL_info {
+	__u8	mode;
+	__u8	hop_limit;
+};
 
-#endif
+#endif /* _IP6T_HL_H */
-- 
2.43.5


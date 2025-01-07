Received: from smtp-out.freemail.hu (fmfe19.freemail.hu [46.107.16.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAE8259480;
	Tue,  7 Jan 2025 02:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736218119; cv=none; b=WEK+SB9KtY/rAiwLKEhg63s6Im630mUf9hXBbmQezkCI4gBNFpaa6HkfG71ISt7z99J4AWQeOCzZnJlimFlbeEcPJBMwJFmSzfctYAFEhPgouFWg0Lgjj0PoidIhsL5TkyMMY4dA53VOdEBiRUmEjt7PXLvmP4Ttav/giEqjFyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736218119; c=relaxed/simple;
	bh=rdcPHPNe0hLoadoCS5UYbHgLAyfHdf06iO5jSPeHY6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RFEiYbLAl7NgK/odMqnaNs2iPzS+sxU+XL2Ve2L4bVP+yiSYqWtcY8zToOHNZzGl1Wm/gXcAaQ5+jJBj7jBRC3b/WVOxusIwVBxrOFSlZK3Cs44N5wocDA/wVjtiic1+e6NzFCkEM3AlkNq1PcraXBA9vhFK5VbVu1P5R+Zy42A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=PBWYVN4S reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="PBWYVN4S"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRwKs6YSBzVFC;
	Tue, 07 Jan 2025 03:41:37 +0100 (CET)
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
Subject: [PATCH 01/10] netfilter: x_tables: Merge xt_DSCP.h to xt_dscp.h
Date: Tue,  7 Jan 2025 03:41:11 +0100
Message-ID: <20250107024120.98288-2-egyszeregy@freemail.hu>
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
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736217698;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=2597; bh=EWAJLyrABMXs/j8+j7Qz8fyUpy1qwkK7Tej6Vxp/Cvg=;
	b=PBWYVN4SyeuxvVMF06MaQUnH4+TV+pFr3EqXBSWewBsyPJwhEXi11+1fX28g8smT
	WMZ6z8C8MEQDNWyysSivRg7Sn+JSyIV43uwdzpvCt7RG2NTnwNAeJGa877Zui7rOmZr
	GhjoMjypSVCMrbOvduXBMg17E5sI+Ypgd1xviuryZqjk40fuEFBfRsxCgV57+29WT3z
	UdDsigbzIaK4ndsvM+T7rO18gb0KND8PD14HLwgREOK7ArFlPRSgRzxCqqbu7t+Hnpi
	0/ErrpoQ5ICslME4sZQa2YTpRV5jaQB5c++McoTNuJZGt81XufKyIJEHl/MY3gQAPGq
	i/HkbxkULQ==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Merge xt_DSCP.h to xt_dscp.h header file.

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 include/uapi/linux/netfilter/xt_DSCP.h | 22 +---------------------
 include/uapi/linux/netfilter/xt_dscp.h | 20 ++++++++++++++++----
 2 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_DSCP.h b/include/uapi/linux/netfilter/xt_DSCP.h
index 223d635e8b6f..fcff72347256 100644
--- a/include/uapi/linux/netfilter/xt_DSCP.h
+++ b/include/uapi/linux/netfilter/xt_DSCP.h
@@ -1,27 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* x_tables module for setting the IPv4/IPv6 DSCP field
- *
- * (C) 2002 Harald Welte <laforge@gnumonks.org>
- * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
- * This software is distributed under GNU GPL v2, 1991
- *
- * See RFC2474 for a description of the DSCP field within the IP Header.
- *
- * xt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
-*/
 #ifndef _XT_DSCP_TARGET_H
 #define _XT_DSCP_TARGET_H
-#include <linux/netfilter/xt_dscp.h>
-#include <linux/types.h>
-
-/* target info */
-struct xt_DSCP_info {
-	__u8 dscp;
-};
 
-struct xt_tos_target_info {
-	__u8 tos_value;
-	__u8 tos_mask;
-};
+#include <linux/netfilter/xt_dscp.h>
 
 #endif /* _XT_DSCP_TARGET_H */
diff --git a/include/uapi/linux/netfilter/xt_dscp.h b/include/uapi/linux/netfilter/xt_dscp.h
index 7594e4df8587..bcfe4afa6351 100644
--- a/include/uapi/linux/netfilter/xt_dscp.h
+++ b/include/uapi/linux/netfilter/xt_dscp.h
@@ -1,15 +1,17 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* x_tables module for matching the IPv4/IPv6 DSCP field
+/* x_tables module for matching/modifying the IPv4/IPv6 DSCP field
  *
  * (C) 2002 Harald Welte <laforge@gnumonks.org>
+ * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
  * This software is distributed under GNU GPL v2, 1991
  *
  * See RFC2474 for a description of the DSCP field within the IP Header.
  *
+ * xt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
  * xt_dscp.h,v 1.3 2002/08/05 19:00:21 laforge Exp
 */
-#ifndef _XT_DSCP_H
-#define _XT_DSCP_H
+#ifndef _UAPI_XT_DSCP_H
+#define _UAPI_XT_DSCP_H
 
 #include <linux/types.h>
 
@@ -29,4 +31,14 @@ struct xt_tos_match_info {
 	__u8 invert;
 };
 
-#endif /* _XT_DSCP_H */
+/* target info */
+struct xt_DSCP_info {
+	__u8 dscp;
+};
+
+struct xt_tos_target_info {
+	__u8 tos_value;
+	__u8 tos_mask;
+};
+
+#endif /* _UAPI_XT_DSCP_H */
-- 
2.43.5


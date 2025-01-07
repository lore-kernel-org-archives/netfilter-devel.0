Received: from smtp-out.freemail.hu (fmfe19.freemail.hu [46.107.16.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7829E188583;
	Tue,  7 Jan 2025 02:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736217772; cv=none; b=LQggRtucl0Sj7x787eoREvg/owgj1d62Fv2b50W5wfsUkAnT+xYsx1RT5bLdZdEEPyonZaEt7dHHlnBdVtWDRy2u/de7TnhuptVzETr0+DQ2EU+R6Tw2CJBNAXNiBlAD8CiTVzifcQBps5ZPUrpZRKp9TcNaznoq/JIc62TCpoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736217772; c=relaxed/simple;
	bh=5KbVOLIEhppSl9eTrCGfOcx2MwanYCgoXHn2E4PjB04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=umnx1Z/GgpB5Y6vvobjUpTLckODfuPfvQQrz7DQk5wFFnGMKIGS2nK0CUOWHMHpMT4M3uGnKJejvrrAzW8PKCvoza9KrDhbxG+MOZpS7ouxKqpT1A5RbjhSu/ub/i/dHhyjRW2dt3t/cKL4P+2xzKmVYsC7ELz1mD+0n/A0l44g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=BVJX+AJt reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="BVJX+AJt"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRwM86c04zSyj;
	Tue, 07 Jan 2025 03:42:44 +0100 (CET)
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
Subject: [PATCH 05/10] netfilter: iptables: Merge ipt_ECN.h to ipt_ecn.h
Date: Tue,  7 Jan 2025 03:41:15 +0100
Message-ID: <20250107024120.98288-6-egyszeregy@freemail.hu>
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
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736217765;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=3050; bh=GSA2733TurAqCiFq9AeYa0+zYNzqBVCgCF/412Y5ptk=;
	b=BVJX+AJtUOXfZXT8bkWXZSYr/dJOq0d1l4/hT5v9GHOVBa52aW9q7dPgRVaM9LX7
	PjM+WK66eoMTj4vgqpMn6fEIYpyVcPvXm7auQ4YxrW0hB1wYpqnhwm7hxcq8vzxZ2N2
	pxoAdlY2up9phbh3RF851lsbI4uQxlIv92oKOsiRxZ8IwfGKH2mx+ZtxSDfUrW/AdAC
	CO3iuSmwuk9f3WyGuaLhAauhoDXQbkWjBYk4OsYFhyupaXAbVinE9i+b0nRR5xJOgss
	kvOWcxOvwrJ/rzexDTgvTQe74rnvF6SaIaesCLPKPgklnW+dXKMtQUAK/yJmQwhT1cb
	XeQgNCXYCg==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Merge ipt_ECN.h to ipt_ecn.h header file.

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 include/uapi/linux/netfilter_ipv4/ipt_ECN.h | 29 +--------------------
 include/uapi/linux/netfilter_ipv4/ipt_ecn.h | 26 ++++++++++++++++++
 2 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
index e3630fd045b8..6727f5a44512 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
@@ -1,34 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* Header file for iptables ipt_ECN target
- *
- * (C) 2002 by Harald Welte <laforge@gnumonks.org>
- *
- * This software is distributed under GNU GPL v2, 1991
- * 
- * ipt_ECN.h,v 1.3 2002/05/29 12:17:40 laforge Exp
-*/
 #ifndef _IPT_ECN_TARGET_H
 #define _IPT_ECN_TARGET_H
 
-#include <linux/types.h>
-#include <linux/netfilter/xt_DSCP.h>
-
-#define IPT_ECN_IP_MASK	(~XT_DSCP_MASK)
-
-#define IPT_ECN_OP_SET_IP	0x01	/* set ECN bits of IPv4 header */
-#define IPT_ECN_OP_SET_ECE	0x10	/* set ECE bit of TCP header */
-#define IPT_ECN_OP_SET_CWR	0x20	/* set CWR bit of TCP header */
-
-#define IPT_ECN_OP_MASK		0xce
-
-struct ipt_ECN_info {
-	__u8 operation;	/* bitset of operations */
-	__u8 ip_ect;	/* ECT codepoint of IPv4 header, pre-shifted */
-	union {
-		struct {
-			__u8 ece:1, cwr:1; /* TCP ECT bits */
-		} tcp;
-	} proto;
-};
+#include <linux/netfilter_ipv4/ipt_ecn.h>
 
 #endif /* _IPT_ECN_TARGET_H */
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
index 8121bec47026..a6d479aece21 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
@@ -1,10 +1,26 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* Header file for iptables ipt_ECN target and match
+ *
+ * (C) 2002 by Harald Welte <laforge@gnumonks.org>
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ *
+ * ipt_ECN.h,v 1.3 2002/05/29 12:17:40 laforge Exp
+ */
 #ifndef _IPT_ECN_H
 #define _IPT_ECN_H
 
+#include <linux/types.h>
+#include <linux/netfilter/xt_dscp.h>
 #include <linux/netfilter/xt_ecn.h>
+
 #define ipt_ecn_info xt_ecn_info
 
+#define IPT_ECN_OP_SET_IP	0x01	/* set ECN bits of IPv4 header */
+#define IPT_ECN_OP_SET_ECE	0x10	/* set ECE bit of TCP header */
+#define IPT_ECN_OP_SET_CWR	0x20	/* set CWR bit of TCP header */
+#define IPT_ECN_OP_MASK		0xce
+
 enum {
 	IPT_ECN_IP_MASK       = XT_ECN_IP_MASK,
 	IPT_ECN_OP_MATCH_IP   = XT_ECN_OP_MATCH_IP,
@@ -13,4 +29,14 @@ enum {
 	IPT_ECN_OP_MATCH_MASK = XT_ECN_OP_MATCH_MASK,
 };
 
+struct ipt_ECN_info {
+	__u8 operation;	/* bitset of operations */
+	__u8 ip_ect;	/* ECT codepoint of IPv4 header, pre-shifted */
+	union {
+		struct {
+			__u8 ece:1, cwr:1; /* TCP ECT bits */
+		} tcp;
+	} proto;
+};
+
 #endif /* IPT_ECN_H */
-- 
2.43.5


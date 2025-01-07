Received: from smtp-out.freemail.hu (fmfe19.freemail.hu [46.107.16.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E43E1991CF;
	Tue,  7 Jan 2025 02:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736217813; cv=none; b=UKV5vBXnmNtOweS1PxyCYx7D8AiqyFrARHH4G4kBeLqemf7RvfSy7Wpc4c6RR7C8SaYgLP5jTiszVzKfkwO0ix09d3pz/YmEdJYVKZv6j9p1uFeyxUrrKamM2ngA1ICIOpfX5FXySOyRPf+fNnxOXSl0wyEDzfyGWt/vvCS8LPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736217813; c=relaxed/simple;
	bh=WVhwNPsyYcOQvrsX6lGLzPZuszJkjloBSZPn/KVC+8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WK4eLz6ZZpAN9UXOeDvj8kmgON4D3ZQnlgETKmNyTtJodYu0gO2XdypC2q2CroGFp6zNjDp7kiWGHii+DgMg+b9VdWYdI2fgLa4ijRVJ/0/qSk9spCgA5NNVHvGs3wjE5XH5VkxHhQzGSKmn2xo2lx/qm99ylwVK05gayx/UGqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=AjABy8xJ reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="AjABy8xJ"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRwN10B5QzX5S;
	Tue, 07 Jan 2025 03:43:29 +0100 (CET)
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
Subject: [PATCH 09/10] netfilter: Add message pragma for deprecated xt_*.h, ipt_*.h.
Date: Tue,  7 Jan 2025 03:41:19 +0100
Message-ID: <20250107024120.98288-10-egyszeregy@freemail.hu>
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
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736217809;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=4064; bh=DrSJONT6Tt6pfScddDoZLKvf4GZGoxtEa85E0u0wrX0=;
	b=AjABy8xJnuGNO+LlvpyiDuWQyWKRy6R0XnaLaU0kpaE6grgWVc2gCDJZk7OGoujI
	t8tF0YIafSynDQiGzUpLbxzjKEQ3ceiOK0GxXQ9aBD+Uo3TXAjeC8RGmuKyjtWCbwRe
	V041w6tjh3RQMYAyyRpIhgPmvnl07OAp0bodW/Cjf8Az/R/4490jXwQ27d+5tAbJTVi
	la/pZb0agQWJ1NpPxONrLb2yBBs9A50hEsGuGlDuSKCxaJmxn5n4Y9+inFhq1V//kTX
	WxYqj/w3bGIdVhON5rtP+i7ZEpSSNMgAhb7rKChTI5l16DTbDyYEhsReQEG9OdRS8Fk
	SFH7TYx/CA==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Display information about deprecated xt_*.h, ipt_*.h files
at compile time. Recommended to use header files with
lowercase name format in the future.

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 include/uapi/linux/netfilter/xt_CONNMARK.h  | 2 ++
 include/uapi/linux/netfilter/xt_DSCP.h      | 2 ++
 include/uapi/linux/netfilter/xt_MARK.h      | 2 ++
 include/uapi/linux/netfilter/xt_RATEEST.h   | 2 ++
 include/uapi/linux/netfilter/xt_TCPMSS.h    | 2 ++
 include/uapi/linux/netfilter_ipv4/ipt_ECN.h | 2 ++
 include/uapi/linux/netfilter_ipv4/ipt_TTL.h | 2 ++
 include/uapi/linux/netfilter_ipv6/ip6t_HL.h | 2 ++
 8 files changed, 16 insertions(+)

diff --git a/include/uapi/linux/netfilter/xt_CONNMARK.h b/include/uapi/linux/netfilter/xt_CONNMARK.h
index 171af24ef679..1bc991fd546a 100644
--- a/include/uapi/linux/netfilter/xt_CONNMARK.h
+++ b/include/uapi/linux/netfilter/xt_CONNMARK.h
@@ -4,4 +4,6 @@
 
 #include <linux/netfilter/xt_connmark.h>
 
+#pragma message("xt_CONNMARK.h header is deprecated. Use xt_connmark.h instead.")
+
 #endif /* _XT_CONNMARK_TARGET_H */
diff --git a/include/uapi/linux/netfilter/xt_DSCP.h b/include/uapi/linux/netfilter/xt_DSCP.h
index fcff72347256..bd550292803d 100644
--- a/include/uapi/linux/netfilter/xt_DSCP.h
+++ b/include/uapi/linux/netfilter/xt_DSCP.h
@@ -4,4 +4,6 @@
 
 #include <linux/netfilter/xt_dscp.h>
 
+#pragma message("xt_DSCP.h header is deprecated. Use xt_dscp.h instead.")
+
 #endif /* _XT_DSCP_TARGET_H */
diff --git a/include/uapi/linux/netfilter/xt_MARK.h b/include/uapi/linux/netfilter/xt_MARK.h
index cdc12c0954b3..9f6c03e26c96 100644
--- a/include/uapi/linux/netfilter/xt_MARK.h
+++ b/include/uapi/linux/netfilter/xt_MARK.h
@@ -4,4 +4,6 @@
 
 #include <linux/netfilter/xt_mark.h>
 
+#pragma message("xt_MARK.h header is deprecated. Use xt_mark.h instead.")
+
 #endif /* _XT_MARK_H_TARGET_H */
diff --git a/include/uapi/linux/netfilter/xt_RATEEST.h b/include/uapi/linux/netfilter/xt_RATEEST.h
index f817b5387164..ec3d68f67b2f 100644
--- a/include/uapi/linux/netfilter/xt_RATEEST.h
+++ b/include/uapi/linux/netfilter/xt_RATEEST.h
@@ -4,4 +4,6 @@
 
 #include <linux/netfilter/xt_rateest.h>
 
+#pragma message("xt_RATEEST.h header is deprecated. Use xt_rateest.h instead.")
+
 #endif /* _XT_RATEEST_TARGET_H */
diff --git a/include/uapi/linux/netfilter/xt_TCPMSS.h b/include/uapi/linux/netfilter/xt_TCPMSS.h
index 154e88c1de02..826060264766 100644
--- a/include/uapi/linux/netfilter/xt_TCPMSS.h
+++ b/include/uapi/linux/netfilter/xt_TCPMSS.h
@@ -4,4 +4,6 @@
 
 #include <linux/netfilter/xt_tcpmss.h>
 
+#pragma message("xt_TCPMSS.h header is deprecated. Use xt_tcpmss.h instead.")
+
 #endif /* _XT_TCPMSS_TARGET_H */
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
index 6727f5a44512..42317fb3a4e9 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
@@ -4,4 +4,6 @@
 
 #include <linux/netfilter_ipv4/ipt_ecn.h>
 
+#pragma message("ipt_ECN.h header is deprecated. Use ipt_ecn.h instead.")
+
 #endif /* _IPT_ECN_TARGET_H */
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_TTL.h b/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
index 5d989199ed28..1663493e4951 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
@@ -4,4 +4,6 @@
 
 #include <linux/netfilter_ipv4/ipt_ttl.h>
 
+#pragma message("ipt_TTL.h header is deprecated. Use ipt_ttl.h instead.")
+
 #endif /* _IPT_TTL_TARGET_H */
diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_HL.h b/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
index bcf22824b393..55f08e20acd2 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
@@ -4,4 +4,6 @@
 
 #include <linux/netfilter_ipv6/ip6t_hl.h>
 
+#pragma message("ip6t_HL.h header is deprecated. Use ip6t_hl.h instead.")
+
 #endif /* _IP6T_HL_TARGET_H */
-- 
2.43.5


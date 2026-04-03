Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD04826ED45
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2026 20:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775246607; cv=none; b=Wtx+1q+O/BZrzt8tv0wgoOdOPPh10nMHunAEV8gO+OXqdmQJscVHfwrS/DCLjJNvJnI7T6U2vrIjAMHWG/Y1y73FU6G+2Gzo32VBtA8DpQOuWKZ7S3ejGMm2fMN2m+Uws1DsPyTyneaqi5Q/BIk5y4F6yi8LlZJpmcYLo2J1WeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775246607; c=relaxed/simple;
	bh=wADCUDHqv3AIFQTlK0LzdVUglw2571qUMkTdVWFvIxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cBVpqFDEuaNeJodGM0YWPPt0xkE8tX/JyhfH7+TNOhSY1/3O0abqiKyapD9yD88AMj3o/dz7NkusiNnRc97pJDyOVAwR2HGVSPUQmjoFyVwZ6TLoReNtRUwSiEq4ksjxz2Zhvh1SqB0qSPT5mScN/j3uxFFp9IJcYR2bHqr9VOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aOiluptj; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aOiluptj"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48897fd88ebso9743385e9.2
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Apr 2026 13:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775246604; x=1775851404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xE2VFOzNRG0wByucdsL3FPChPaVcDUKG/JIrmw8PamQ=;
        b=aOiluptjCA/ZuUk28yb+vu+KXgUVQcrEcTmITTmklUfzU7D9DiikISVepgca2lmm0l
         I3JfWMG1Zi+WkI8ZZAy/DXsuGo3s0TtfkgyVSS6390T/ZowHrHXx1CJMtDNwhy0e7sC0
         ccnW1Hu0f7Ej2rzsH3QgiL0zWbVr/KTMgouHx808x9HytlV5KE1hUGzVeZ62k+DFG8a0
         3ar+Krzt3UbkeyavIAhoTKjck4rZkYIHHtL/spA63/9JiKBSAVLv32lzF2NkxgllSF1K
         +D4/gWfyJdV+Rn204SI8X2JW6yiBORGV/r2XIW9UCRubhrYA0ilDag23CPFBmMhYMC6Y
         zAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775246604; x=1775851404;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xE2VFOzNRG0wByucdsL3FPChPaVcDUKG/JIrmw8PamQ=;
        b=JF1ABRovMx7akPEKD2XHswQFnVtB3IMGGG5aNbeBLE41RI4P8giLmHSWB3qdz2JZdy
         IonLnEM1u88EzuuffbIjRQVGdKszl0Hgl/60ns91S+1etQClQGHRgNwjvXDtcC6mOD8k
         EZYorgRw+pC6ZaPFshuQjZrmxv++wOIRif61++oZV5Ff2EZt3QQYdXF0fZ5f4s/VMYve
         h155UDFzcLugp045Taq1k5o8mZiF4yNjkuNk61DmvRf/scUyWVLDVo0UDnmtpfI/gvIo
         XDiYoOg5hu05awzScvx84nelHJz2f6rNEiwHi6GJ0es+uZEbl3Y060i1jtKy2V9thyHi
         8rmg==
X-Gm-Message-State: AOJu0YwYPtRKmKDb03aJEAmi9qmz7x5bnm1Tz39SjbxGr9iZCXrh0f0I
	ALwggZ2z8xD16Lsb8e6m74NAijlz0TH24JgNaw/TRW9qn76Nov/8uHwN
X-Gm-Gg: ATEYQzy9W4RV7Wnr2k4dBRP/aHJzonkFuJiRvvFxujkgaom6jyFb012giHxGN8N2PlI
	wAkQjAg/lIbFHTTg1nUCj+dT8RA48c293tBDioN8tKArB7R6oO+/IWfUSmJx+sT+mnWMV094vNH
	YB4g4mvWTfzsjSGy6o+8f3Z7XUZq6JQ2HbwL3gQykdD6xVWCNKuO9LhZ8GF3Qa0/sAVssSg+0in
	DbyeDhrblCGJ/3wxo1g00DUbudueaCSCA85BABejzUjYHKeV6vWw/yXsVNKtXmGndV2ykQ0NoSv
	CM1vUhZd+Wb2N6il20F5SzsLclbPgFtobScjU2CriKO90nweiLvtfXONHhLc54AiqqrBDQr3zjP
	ZJHSvbFkqn0ISvKg6sE8+hA94OFsaNUdPF5xs2L1VvmHVPeweyPuEeft4iLeW0twmSICynwtaiR
	kPMuJiddCWesHcSsnUre3Qhi5TIvj77CPv0JHN3f9uhoDYwa+KjYDnwvs7INkKS+FH7ART0fcj8
	c++T2RFPY/vwXq1FIndqhOSrXoDnDjzGpBhaSjNcKtWbsYNKDI=
X-Received: by 2002:a05:600c:1d1d:b0:488:7ebd:78 with SMTP id 5b1f17b1804b1-4889977cbb7mr65937275e9.14.1775246604026;
        Fri, 03 Apr 2026 13:03:24 -0700 (PDT)
Received: from localhost.localdomain (cpe-188-129-81-72.dynamic.amis.hr. [188.129.81.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48895e19c10sm95627995e9.8.2026.04.03.13.03.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 03 Apr 2026 13:03:23 -0700 (PDT)
From: Marino Dzalto <marino.dzalto@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Marino Dzalto <marino.dzalto@gmail.com>
Subject: [PATCH v2] netfilter: xt_HL: add pr_fmt, drop NULL checks, add checkentry validation
Date: Fri,  3 Apr 2026 22:03:20 +0200
Message-ID: <20260403200320.90449-1-marino.dzalto@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add pr_fmt for module-prefixed log messages. Remove unnecessary NULL
checks for skb, as netfilter core guarantees skb is non-NULL. Add
checkentry functions to validate match mode at rule registration time.

Signed-off-by: Marino Dzalto <marino.dzalto@gmail.com>
---
 net/netfilter/xt_hl.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/netfilter/xt_hl.c b/net/netfilter/xt_hl.c
index c1a70f8f0..4a12a757e 100644
--- a/net/netfilter/xt_hl.c
+++ b/net/netfilter/xt_hl.c
@@ -6,6 +6,7 @@
  * Hop Limit matching module
  * (C) 2001-2002 Maciej Soltysiak <solt@dns.toxicfilms.tv>
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/ip.h>
 #include <linux/ipv6.h>
@@ -22,6 +23,18 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_ttl");
 MODULE_ALIAS("ip6t_hl");
 
+static int ttl_mt_check(const struct xt_mtchk_param *par)
+{
+	const struct ipt_ttl_info *info = par->matchinfo;
+
+	if (info->mode > IPT_TTL_GT) {
+		pr_err("Unknown TTL match mode: %d\n", info->mode);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static bool ttl_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ipt_ttl_info *info = par->matchinfo;
@@ -41,6 +54,18 @@ static bool ttl_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return false;
 }
 
+static int hl_mt6_check(const struct xt_mtchk_param *par)
+{
+	const struct ip6t_hl_info *info = par->matchinfo;
+
+	if (info->mode > IP6T_HL_GT) {
+		pr_err("Unknown Hop Limit match mode: %d\n", info->mode);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static bool hl_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ip6t_hl_info *info = par->matchinfo;
@@ -65,6 +90,7 @@ static struct xt_match hl_mt_reg[] __read_mostly = {
 		.name       = "ttl",
 		.revision   = 0,
 		.family     = NFPROTO_IPV4,
+		.checkentry = ttl_mt_check,
 		.match      = ttl_mt,
 		.matchsize  = sizeof(struct ipt_ttl_info),
 		.me         = THIS_MODULE,
@@ -73,6 +99,7 @@ static struct xt_match hl_mt_reg[] __read_mostly = {
 		.name       = "hl",
 		.revision   = 0,
 		.family     = NFPROTO_IPV6,
+		.checkentry = hl_mt6_check,
 		.match      = hl_mt6,
 		.matchsize  = sizeof(struct ip6t_hl_info),
 		.me         = THIS_MODULE,
-- 
2.50.1 (Apple Git-155)


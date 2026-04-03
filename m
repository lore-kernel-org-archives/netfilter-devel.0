Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9CB3D6666
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2026 20:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775249954; cv=none; b=uObQ1KuSdu/zQKU0d1dILUaEpOqRmJnxHrLcZtMlvvSMG+B3Tm/TzWYTBhBDw6Gu0bGJ3lTWxeVVlScAsy6MsrmzM8gXk3qDpZMjSOjeusNCtFsYW0i0WmWQsQo+0XtnJLqjek0FAbTvKTP6QrHhAbDH46q9eBkTqUo63RF4A6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775249954; c=relaxed/simple;
	bh=kqYs482WFY46q7KpNwPM4K3CeK+5fOx+6sZ6nE4D9Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ATDQEzS/cA/GCr1IUVcPEe07wTfMxwZLEdPW47ySG4fDeWTXV1rPAdtgKO6Uv4YGvHIEirlGBmqqMBADcVw1+/l9E+msFhooAXp7mVKqnMtPTpspVG858101gVRTjgp98S75PbOKBGz+pF2QlfqDsf0EGtVX24rmMWRwrk6ANVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dBE4CG55; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dBE4CG55"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-482f454be5bso35842285e9.0
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Apr 2026 13:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775249952; x=1775854752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PC6QSIaCKHRw04W5RZeL/4jeRdbgtJ8aXjIrqAGfS2c=;
        b=dBE4CG55oJU4skkB0N1F6ZGedSw9a0i0B5D6KUGu0YFmN3X0zxdmmerqUp8UFMWMpo
         d0kExpCFgbmRzYlYvmbM70tM/HUAhlYHPDHKiLA80bH5/Z18zK1hiAKaZG++E49wtleD
         k63gW05g8SdtedyJYkzuRlkzyaQHvHayeJl9tSeReu3Zk1ezWtV1CdfUq/VnNZsy2xM3
         j0JOhhbvNmwW2YCiCqSGLneD/Fz+JPNpE6tzR395C+pjHfik3ICkH3Up0ypSVck+Qcrt
         eraGrCez0eaFQv4mjTXtWhbBN8L65IXkNY38kQc2GNY92AJQM62V2Dwkp8y8fEoqKxdC
         CkQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775249952; x=1775854752;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PC6QSIaCKHRw04W5RZeL/4jeRdbgtJ8aXjIrqAGfS2c=;
        b=rlGLsse+6gq7sxfBbYPULS6LNlRtgkDzI999oL/pXD7BIEs3MXr4DAlByH5vOC0yAV
         f4hIeiBFBWAHhLSRB1Moh5PZfxUUElzm7KOAXXHq0Esyezbs3LY4e+GVx3DDP2sDV7/x
         /SvH1C/s7L7XdHOyEnuCLUyTen2ISAgxapWHNl+Wundeh82RjuvUK7yfblgHrsGjSZoI
         ZOk4hu1x59GduCkQoa9ptAvbfsvZYN4/iSBcDGu3gCca3QDji9fysATWXE67m/JoZ9fH
         6IRDjRAsmkBOhSNJozTa4U49PYDAKQIGh15Npa5jZtkS7DjV76FDkk2HJyf022BaD/rg
         CXbw==
X-Forwarded-Encrypted: i=1; AJvYcCUBQafsMEvg22qP5H9hSF0bffsiyCTr+ENzhNCMaRi6N8FNjs6luI8yfbkowiscUxBH32xrpZ7z8i366tuf7xM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3XjL6I3LdkX7OvdUvZ8uDXf45H8/9Mc7J7SwrS4UYedAHRuvF
	MqPo7uP/YNn4QzOa12FPzNx5eBg78GNBvVkNgcbYi57CsC1HwBNpoJWC
X-Gm-Gg: ATEYQzw3tuYsCTj3WhKGJA4dFJBlUZGQg5S/i/EzkI47ue/7rW/gIr6RQgYR+4pWKEb
	AEmFu612zeY7rk1tK2vrkak4wyoNzQ5eo9ay+jnXdbHXBEXrh/LvVtWzrCltOATg9dO5+1audW6
	cwbAwcY6KrX00UJBX6DFn5oC7S4vF88hj6jSu06fXjIPkRldMci/IzYGo1IABECZIuVkm8QthFz
	6Uk6HlzCPc1N41lN6A3kLe4bZBf0g+BRPokp1eQ8hU5HU3cTiZW/tNa0EfGiHh1hx9ybkqjIaf5
	6oF0SJnKN+4kb+qy0NQz8vwDZtG3LNib854PfQM0C1QsmB4g1Q7LMAzypMnnhTXBOlAmZQIxwD7
	K356z2D82IJAu0IniK/TLQFObqQGdr87VFayDw4+9E+1y2v+odgkSczDKZgK7UM65EM2t6iCtli
	g7SsCMfN4h3sH65jm5N45t9ozdwTbSzBrIYR18Ao2kbn+4/eifrbArIu8D69ygxgPOw4NVvHOA2
	vjIQWuzZ9gsQOV8y8dsFFC1/jEE+qjXeLFKbLGxysMKgbtwKyw=
X-Received: by 2002:a05:600c:450d:b0:485:3428:774c with SMTP id 5b1f17b1804b1-4889946a42dmr64393995e9.4.1775249951503;
        Fri, 03 Apr 2026 13:59:11 -0700 (PDT)
Received: from localhost.localdomain (cpe-188-129-81-72.dynamic.amis.hr. [188.129.81.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48893f39027sm104356165e9.2.2026.04.03.13.59.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 03 Apr 2026 13:59:11 -0700 (PDT)
From: Marino Dzalto <marino.dzalto@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: jacob.e.keller@intel.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Marino Dzalto <marino.dzalto@gmail.com>
Subject: [PATCH v3] netfilter: xt_HL: add pr_fmt and checkentry validation
Date: Fri,  3 Apr 2026 22:59:07 +0200
Message-ID: <20260403205907.92749-1-marino.dzalto@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add pr_fmt to prefix log messages with the module name for
easier debugging in dmesg.

Add checkentry functions for IPv4 (ttl_mt_check) and IPv6
(hl_mt6_check) to validate the match mode at rule registration
time, rejecting invalid modes with -EINVAL.

Signed-off-by: Marino Dzalto <marino.dzalto@gmail.com>
---
v3: Remove mention of NULL checks from commit message, as they
    were never part of the original code.
v2: Remove NULL checks for skb as suggested by Florian Westphal
    (skb is guaranteed non-NULL by netfilter core). Move mode
    validation to checkentry functions instead of match function,
    also as suggested by Florian Westphal.
---
 net/netfilter/xt_hl.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/netfilter/xt_hl.c b/net/netfilter/xt_hl.c
index c1a70f8f0441..4a12a757ecbf 100644
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


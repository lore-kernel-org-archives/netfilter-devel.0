Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507FF31F99F
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2026 19:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775245179; cv=none; b=pEq0FRP3XMlDDD/eKGiAI/6okrr69SR0iuFwPi8QB9o/2MGarE26s8wZHNXni3ZF4kOx5YwwZiGayTQcUPcR4A8CiG1FQ2Dzcd5SO8KH33sem3C/KeGRFch0ywmEGMX2ymjJaFRrf1F29DRHoSQO5UlKe4DhLl7KMnpgBdISlZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775245179; c=relaxed/simple;
	bh=mEnsa1m82X7Qbw/mh295eQAICuszh3WNwBTYCp116Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=INwnfCC8WlYNQCJOzHltoOXSNHgVlcJWMxEJIy7bkghBamZxKeFj2h5qHXzzVnU/2cT+ppnNk97dLJMZAagDpL/O9Jq2WeCP7P2xL3PS9dubCxZKtvXtZGvE3GJBodrrk2TAhwO6NrgjlH3x+EI9SIKfTbhrk4Bk6+lcCvAi+c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pWHgNov1; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pWHgNov1"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43d01d6b50cso1952097f8f.1
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Apr 2026 12:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775245177; x=1775849977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Y6Qc95GC1vro/oOb+qTX+I6jitOjuvKVTkSWpRWYkOI=;
        b=pWHgNov1gP6Kuti2jYPj1FVYjV004ovjnStARHQGNKJlGqrCCrbsii7QjizcoXWpa6
         TrIsPYc2SX0Luih/Q7tQ/XtboeLwNiF5DQMM7cLbhe7aa8R7dqnEg0thKQd8zQhMXiJh
         Cw6WIaFT9Btulf20dRsCLZgOuz42hCAXhpIh+IGwt3/zHlfJiJQVMC18vAwUETC0OpYm
         5KmhA1RxVbg5dGzv6m17wKKms85foIX7wU+qRaKqSCB/dCdFAB2Fsuh0txo/IDy0xaTF
         KJ/HbjUOqNM9eSkGGKr3FPyN9Zh5B9Tp+br3qY/aQx42jAQa332WTeGGVRKVEyozw2m6
         kWPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775245177; x=1775849977;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y6Qc95GC1vro/oOb+qTX+I6jitOjuvKVTkSWpRWYkOI=;
        b=brjcvBvQPACqrsXx15O3dpbpA48+E76D/EONHBKEFle+8/MxaDIT650unzqmCXRPX6
         HDr8LlqE9CSUOrS16muUATELFs+JV3F7GEZ0gCW/NXLF4QA2lV+vbwUK6ABr48LZr2TJ
         lC0EFGCggSWVg6IldaKSedSQgZKmjgpxsIpFeZpknjPfVimCo9/4n2GiX7Etk9za5PRY
         sU0GM5n3ukkziZ+rL2k+Z7V1196zF3gbFiicEmPhI+B6p+sy4Y0NPVM/0gkKqRNaGf0+
         X9oZp1niCxi2kuhR1XH0zo+fyeTvzqJulrQ1MrDj8hUiqHTsDyMEHgow436NX+/G1FYd
         vqyw==
X-Gm-Message-State: AOJu0YwDi6eemzdnf/bSbVpaOBc/DMe39TvoWS5NDZgHerbE3m7bGbXa
	v1gbD2PgpDVEHN94UuI9XzEYgpdHd+y9EUWO9MmQGSzz2GkBfe3fIMC/
X-Gm-Gg: AeBDietejNMLZ7Rv+HVODRtOScxB41F939rXdz0TjZtEPbpgMiz6Kfyyn92JFGFRADn
	Mz/Umm0zp0YVGa/HjLfkdSBPtBplcXDEFaR5Xqd1GrvjOhxtcd/Ln3nFkd2cokygEQ+r4JLnhAo
	GnPk23KDtTjhmmqB4gfPobj7Tr3WGLutrTjCSQfMgSnu9zTIaE/a6VkPK2xzkgcH+u1qG/Nr2k3
	+XTxlXVsv6PMf56Dbn2b9cqDBAi9vbP6o/fEUu1rXE8RBoCl9KbU6fE9tacUFoTtUiqmjZbQxjP
	HaA88nxbzJ4xiLvcts2kLsTs8Es9YEiV7Lq3pgJSrPD2P3QXzkS7H/Z6zZxoHhEfOF8qCM86eix
	Ya1NBDTbdDl5JjYsw7TAEDpDAPtJTQ7ogSuDfyGn1OxCgGQ94DvJK+lIaVcMtsb1rr6eh9GK0iI
	dnKACZPv/jy0Tv9VENhw8PM6Bl0aOczviEQcz5UxndXDlqN6tgp8EsJDrnochQarbrSqvqFTzI2
	xXbGOkrPlzFlMnfi057lS8cMc/kHIyYQL+ZZkSHCvct/uikP5M=
X-Received: by 2002:a05:6000:40da:b0:439:be67:a038 with SMTP id ffacd0b85a97d-43d292ec691mr7007250f8f.41.1775245176453;
        Fri, 03 Apr 2026 12:39:36 -0700 (PDT)
Received: from localhost.localdomain (cpe-188-129-81-72.dynamic.amis.hr. [188.129.81.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e2a720dsm18429186f8f.4.2026.04.03.12.39.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 03 Apr 2026 12:39:35 -0700 (PDT)
From: Marino Dzalto <marino.dzalto@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Marino Dzalto <marino.dzalto@gmail.com>
Subject: [PATCH] netfilter: xt_HL: add pr_fmt, default case and NULL checks
Date: Fri,  3 Apr 2026 21:39:29 +0200
Message-ID: <20260403193929.89449-1-marino.dzalto@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Marino Dzalto <marino.dzalto@gmail.com>
---
 net/netfilter/xt_hl.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_hl.c b/net/netfilter/xt_hl.c
index c1a70f8f0..9434d5ca8 100644
--- a/net/netfilter/xt_hl.c
+++ b/net/netfilter/xt_hl.c
@@ -6,6 +6,7 @@
  * Hop Limit matching module
  * (C) 2001-2002 Maciej Soltysiak <solt@dns.toxicfilms.tv>
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/ip.h>
 #include <linux/ipv6.h>
@@ -25,7 +26,12 @@ MODULE_ALIAS("ip6t_hl");
 static bool ttl_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ipt_ttl_info *info = par->matchinfo;
-	const u8 ttl = ip_hdr(skb)->ttl;
+	const u8 ttl;
+
+	if (!skb)
+		return false;
+
+	ttl = ip_hdr(skb)->ttl;
 
 	switch (info->mode) {
 	case IPT_TTL_EQ:
@@ -36,15 +42,21 @@ static bool ttl_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		return ttl < info->ttl;
 	case IPT_TTL_GT:
 		return ttl > info->ttl;
+	default:
+		pr_warn("Unknown TTL match mode: %d\n", info->mode);
+		return false;
 	}
-
-	return false;
 }
 
 static bool hl_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ip6t_hl_info *info = par->matchinfo;
-	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	const struct ipv6hdr *ip6h;
+
+	if (!skb)
+		return false;
+
+	ip6h = ipv6_hdr(skb);
 
 	switch (info->mode) {
 	case IP6T_HL_EQ:
@@ -55,9 +67,10 @@ static bool hl_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		return ip6h->hop_limit < info->hop_limit;
 	case IP6T_HL_GT:
 		return ip6h->hop_limit > info->hop_limit;
+	default:
+		pr_warn("Unknown Hop Limit match mode: %d\n", info->mode);
+		return false;
 	}
-
-	return false;
 }
 
 static struct xt_match hl_mt_reg[] __read_mostly = {
-- 
2.50.1 (Apple Git-155)


Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823BC3C343C
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2026 18:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775242429; cv=none; b=OBTJNMq3qxn1/CLtrcZCRdElqHS6MI3N9joHabdm7656CFflW5k8ZIyY0ptM+ocM2jFGIdmjD4GsG1vcD8xT6FtbooyljRPcMKptN7MmhfPqYs0lRdZxOqaWArDGeLub4B0Wb/kFgqkqRK/M5C2CRd6MEQb96dQkoYNY9HcRXUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775242429; c=relaxed/simple;
	bh=/jVVlaYZFAwlin52R+2Ey9DOou+ZLFQYY+l+kE8eSHc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mszJkJyG3pCKma2cj09h4sn8MeGeIacAbaUfXYZuhuA3PlzWRNbiDhce3j7OYzmlEetCU+B9JZyMy95014YtEMO3d8Ly6v2QL5NA0KeFpycEcsueQIj62OrpaoQoVY2YntUc9QUTv0HJ8DhYlMhQFQw7t3kK0/uOHZ5xIEoLbo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KtK5YBSn; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KtK5YBSn"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43ba1f3fa7eso2132326f8f.2
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Apr 2026 11:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775242427; x=1775847227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=maeNfYkM/3PGyOug4UakihZPv8oRILxVm2J09dLBdmo=;
        b=KtK5YBSnLPeC3oqAHwG2IFdDU6RrqXWDmlCpSUYaeo9plyoWLTvCpiB4IpOzZMW8XP
         8DHrhlwvzYkpfb2eZUIkV71iwRK5X4IMSo6LJOoSqCmz2HyjDcheHkaYyBcr0YHnCzap
         zfIUBtw6W8e1+w+lnicYEE6M+Uz3R8DvyZL7XXhpzfxfXnWg79iwr2aNO94/sF8FmIJ8
         oL+HvTWvZIFMxMqp/LKsdf3tm8cs8zTTrNMPukaOEB83JpbPH8qSxwFlvzsZMMuwoQbT
         Uf4KPTLab4Nx1NudHdA0sW7Bi8sEAur4hLgl2t1QiFKvBjcvmxFfpHeP87fL3C594O5T
         dTsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775242427; x=1775847227;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=maeNfYkM/3PGyOug4UakihZPv8oRILxVm2J09dLBdmo=;
        b=oQqDZFM16uFKCKezUwAlqnvSHHa15oJICEUEM/0ViehcuO+7/JMe+kX1gjVPpFIZ+C
         ZssCZ0XMfPs61uh3lF+3H+ZgoULVlKTNobnn8e57+kCrO8XkfZUBWHqHZ0cBV8i2DiW5
         gOjVv7K9xaq9f374oqJZnd4XW8zsqCRpDwz/NxwaOCahXwnp6t/yqVajZZteiyqfRD80
         VsOtwVzOItlNyeLKlfgl0ujNhwZBY3lZfuqIyZsF1chNx0b/QaLd8ZsHm4GyntwQymZQ
         EUQdO4cPXXNYIz5yzSq/snnQjat7YkP0SE4MgZ33iZuyy+Bc8WLxzKO/ZZT5uf0IE32n
         B/OA==
X-Gm-Message-State: AOJu0Ywx1FIux4RZax8qQMLiqibzseyo2oAIGIVeqZET0J2NJTOZmIpW
	PQ2398MzMRpLf2vU8ixCK7EMIYt992tfa3+XHTWEq8DDyKMaAW+RMv19
X-Gm-Gg: AeBDieumd+Wl4vKmtSuBtOKPojjpkqtC8l5uFMrdaROlrERrYglOMKYerHZSxuD27Gy
	piaxwW+7LUIwDE1vSE3cTEtH0RvX4eKdz0n5jnKCpikFusd4Dcub8ThMrwkOYibSIcpDguXZuWb
	o9dgdqIfwfgWTGhx06Xxac9VIoxL6okjiNoS2JdP2hIyOIiiV6bmGTSBuOW3iTIOC28mGxGrB9S
	9DOa9iln4rJjX0HQOFMbIBD+YRimEb3idkYpTHgO02hMrsek0bA4WtLzhE5LVIB47tnyripuJCh
	GlbkMPI09/qc2IkVHXTGCGFH4s7wgja8H19D+l0px9r2SCsQviSyxY8DFpRD/UBHC/ifDbM2KFS
	p1XbAtESF90emQyuPBOl7j657X1qLhHuJyd0BRAJvMKw2LjLYm7MmBMmYgVtXoOCvroOy38Ox7J
	wNxuM7V/tU5BHTSSZGHKDjj33pTb0NCcniGHkYiUnTq4KAZxPrZYSou75P08Bv0r5WoedYTJK6G
	c5YZv4XQy4p6eyEd84rwrVQmCL2sp8o8BvdzTY2aqSXHmrjaPw=
X-Received: by 2002:a05:6000:401f:b0:43d:2be:e4e with SMTP id ffacd0b85a97d-43d292ff520mr6572751f8f.46.1775242426634;
        Fri, 03 Apr 2026 11:53:46 -0700 (PDT)
Received: from localhost.localdomain (cpe-188-129-81-72.dynamic.amis.hr. [188.129.81.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4d289asm17855349f8f.19.2026.04.03.11.53.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 03 Apr 2026 11:53:46 -0700 (PDT)
From: Marino Dzalto <marino.dzalto@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Marino Dzalto <marino.dzalto@icloud.com>
Subject: [PATCH] netfilter: xt_dscp: replace -EDOM with -EINVAL and unify match functions
Date: Fri,  3 Apr 2026 20:53:37 +0200
Message-ID: <20260403185337.87676-1-marino.dzalto@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marino Dzalto <marino.dzalto@icloud.com>

Signed-off-by: Marino Dzalto <marino.dzalto@icloud.com>
---
 net/netfilter/xt_dscp.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index fb0169a8f..00137bff3 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -25,16 +25,12 @@ static bool
 dscp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_dscp_info *info = par->matchinfo;
-	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
+	u8 dscp;
 
-	return (dscp == info->dscp) ^ !!info->invert;
-}
-
-static bool
-dscp_mt6(const struct sk_buff *skb, struct xt_action_param *par)
-{
-	const struct xt_dscp_info *info = par->matchinfo;
-	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
+	if (xt_family(par) == NFPROTO_IPV4)
+		dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
+	else
+		dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	return (dscp == info->dscp) ^ !!info->invert;
 }
@@ -44,7 +40,7 @@ static int dscp_mt_check(const struct xt_mtchk_param *par)
 	const struct xt_dscp_info *info = par->matchinfo;
 
 	if (info->dscp > XT_DSCP_MAX)
-		return -EDOM;
+		return -EINVAL;
 
 	return 0;
 }
@@ -74,7 +70,7 @@ static struct xt_match dscp_mt_reg[] __read_mostly = {
 		.name		= "dscp",
 		.family		= NFPROTO_IPV6,
 		.checkentry	= dscp_mt_check,
-		.match		= dscp_mt6,
+		.match		= dscp_mt,
 		.matchsize	= sizeof(struct xt_dscp_info),
 		.me		= THIS_MODULE,
 	},
-- 
2.50.1 (Apple Git-155)


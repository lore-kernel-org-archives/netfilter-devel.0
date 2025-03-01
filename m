Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80981C5F09
	for <netfilter-devel@vger.kernel.org>; Sat,  1 Mar 2025 21:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740863682; cv=none; b=YNLJspPzHZQJcD0OVDkRGRuDH38zspW46ux4a5KGwpNRjNgnnMMpnqtVFHkUQEF325MhOx54kjGjMYDvB98DRBMlY7+ygKuazcRd7hV1t8D9JMTRWTftWcHUgtBSlhBuX6e/ImbwFJ9LIAv9eFwMcNkxgPyH8/qL8tKUa600m4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740863682; c=relaxed/simple;
	bh=oJ5p5QNS4jew4KO7TmIataiu70/Zb6lcTB4h/tqJ7Oc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=um7TYxVs+ISjjm97vYdfP/f9JKhhX0pomO3aE3hej10rj/cBH+e56PXnO9H0zw8yT72/9z+HwLxKg2tEaHx2jCZVrYn/syLazIesFrf9pPhMua7KWcAYL62kOzm8orehcJk4ONk5mzMNXNqNOXCuOfSjY8FPqTHBlbAO/KtWUEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XzAUDWKj; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XzAUDWKj"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-30ba92c846eso5371051fa.3
        for <netfilter-devel@vger.kernel.org>; Sat, 01 Mar 2025 13:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740863679; x=1741468479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vnbs3xiYiim0CNCB0BgOFmgWWANpZ5m4sFJVTBEgo2M=;
        b=XzAUDWKjIPSzWPsOzFWUiTOwWpl8P94/guahbbdmeJM6giCveN+PdvQCpFpbYe+1qW
         ovdlOQxD6XYl4d8vATEY2VaWcwp/Spq68VeD9SwZIxoC/HTRqaYBERPBaijsd7+tAbOa
         DZRCvt83zfEE81Hbb1BXjiwLbSOkiTTTj0Do7HNkvWtYgy7FLqMSlL6cd0Rx7VioRd6j
         XO6dMLSf9zX4JIl4LFBQ2F4VNx+fOB135l/+LhR2WCvyJLUPrgl8eZGstCUmt8CPxdYU
         UNOl3oLz50JudYWT+AQtIoJk/YCGaZKhsCRQq4lN0nwBnvV19L24uz7q8DotHQl5D5io
         Eb6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740863679; x=1741468479;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vnbs3xiYiim0CNCB0BgOFmgWWANpZ5m4sFJVTBEgo2M=;
        b=MCM262Y3lGQkoDXKeGO1M7oDQ7pIM45Tx8GLCewS10K0tFi0x0rH4iOJLHUAfjNYpx
         HzifyYOWM6A+GN2pjFyAgcBf8a7NWxpK5DiVDximsKaCdRIA6OpnJrIPzW1P2H2Rityc
         Pi54hXPQT55bu4SxGc94u7VXxsLpFDiY8fGc9fTtR5CPcTonI/7vmfbI069xoK+TUInq
         G4H2bsDScKP/AJWYGQy8YF6eA78u4ttIMtFly4kFyg6u7V0CT921zzRJ/XK5tCUCAkbs
         M99e8oANdjfb7gt161iFZsfjVDGo3Z8USCjf/4RnI9CDYK6XlKEot4h+oMPb86Oheujz
         H7pQ==
X-Gm-Message-State: AOJu0Yyybvm00jt6iFWQMAqD5kRRoNSMpfOCaufA3E5yH0Im9HofCVaA
	cBHR3anzMg9cqWtrmbgLK9diiTrxeRPWgxqh7SUYSfY6uXcWV9arDKnJMA2F
X-Gm-Gg: ASbGncsaiVIIThQMJC/UeDEwkllVTIbr8OrB8NC5t8oxVLS4/PIUJ6ISafzZnqhJHPj
	5Jx3uhNCn3tp2aB9bm4Hifv6WycmsKTGGN+if8de3om5HzMVnBDHrCypfX2aX16/Mw3FEs0H3wK
	oxJLf8UWln94++Q4DdijABFc8IOAkbv/F6Vq68IMe0vb4eYmCYcO+W13pXnpk1CpK6Ub+x+W2kU
	tWRom/02aXsAujPGIOAjnMmD6LdIq9vBGoWtEat9dAa0RfE+Jsq2VawGkVQAakKqJ4mr/zKqHgA
	rcNGKKvbpjBC7krLKVIpLWtPH4irHC7dSUmcbdr8kFjTuQYsRn8RMRC1
X-Google-Smtp-Source: AGHT+IErJJ4RMeB9RQx5lt4idpIcQBDcLOrgAwwFQ6XqsHJbcWgeeenZ+yteL5K2xMNuc7aHFTwsOw==
X-Received: by 2002:a2e:bea2:0:b0:308:f75f:440 with SMTP id 38308e7fff4ca-30b932215d2mr34806881fa.9.1740863678279;
        Sat, 01 Mar 2025 13:14:38 -0800 (PST)
Received: from localhost.localdomain ([195.16.41.104])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-30b8f2964cbsm7071291fa.28.2025.03.01.13.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Mar 2025 13:14:37 -0800 (PST)
From: Alexey Kashavkin <akashavkin@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Alexey Kashavkin <akashavkin@gmail.com>
Subject: [PATCH] netfilter: nft_exthdr: fix offset with ipv4_find_option()
Date: Sun,  2 Mar 2025 00:14:36 +0300
Message-Id: <20250301211436.2207-1-akashavkin@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is an incorrect calculation in the offset variable which causes the nft_skb_copy_to_reg() function to always return -EFAULT. Adding the start variable is redundant. In the __ip_options_compile() function the correct offset is specified when finding the function. There is no need to add the size of the iphdr structure to the offset.

Signed-off-by: Alexey Kashavkin <akashavkin@gmail.com>
---
 net/netfilter/nft_exthdr.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index b8d03364566c..c74012c99125 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -85,7 +85,6 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	unsigned char optbuf[sizeof(struct ip_options) + 40];
 	struct ip_options *opt = (struct ip_options *)optbuf;
 	struct iphdr *iph, _iph;
-	unsigned int start;
 	bool found = false;
 	__be32 info;
 	int optlen;
@@ -93,7 +92,6 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	iph = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
 	if (!iph)
 		return -EBADMSG;
-	start = sizeof(struct iphdr);
 
 	optlen = iph->ihl * 4 - (int)sizeof(struct iphdr);
 	if (optlen <= 0)
@@ -103,7 +101,7 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	/* Copy the options since __ip_options_compile() modifies
 	 * the options.
 	 */
-	if (skb_copy_bits(skb, start, opt->__data, optlen))
+	if (skb_copy_bits(skb, sizeof(struct iphdr), opt->__data, optlen))
 		return -EBADMSG;
 	opt->optlen = optlen;
 
@@ -118,18 +116,18 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 		found = target == IPOPT_SSRR ? opt->is_strictroute :
 					       !opt->is_strictroute;
 		if (found)
-			*offset = opt->srr + start;
+			*offset = opt->srr;
 		break;
 	case IPOPT_RR:
 		if (!opt->rr)
 			break;
-		*offset = opt->rr + start;
+		*offset = opt->rr;
 		found = true;
 		break;
 	case IPOPT_RA:
 		if (!opt->router_alert)
 			break;
-		*offset = opt->router_alert + start;
+		*offset = opt->router_alert;
 		found = true;
 		break;
 	default:
-- 
2.39.2


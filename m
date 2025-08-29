Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B976713AC1
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 06:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756450256; cv=none; b=O5aChsXMB8zRke5GsTTw+8GBsdAwyQnGyApIIHSFMmDU+2uZ6RUJhQSBurM1ee/rkv/Kl+YwKLWIKxlsAvJgMmysZZUg2esx+ZHLCfxOiZrKwhafHXCQ+rUirgOh8wsBLXvevedGmr/zgSZCyeOsWMX0JOYrewh5BSmlLOfRURo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756450256; c=relaxed/simple;
	bh=lohsmysJSeD1DzUAZ+GjNFAhL2lFYLR2NrOdCdIGwTM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ll7GxnV0oMmJRYyCqWVt7OAhQvyStUZBPtv6H7chP+uX+gAESqdBvzWoiQUZFjsJiOmq44Ge9KKxx5QIAQxyiyXHzSbkSs+13eXrqTUOnIic/wOiHdxOhxUWy7WAr+WOZ3fTtHKitkQ3tCe9U2Llxr/iJyty95+HPNGmJ/JLl/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gGNGBl7k; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gGNGBl7k"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-33685e3b16aso13261751fa.3
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 23:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756450252; x=1757055052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q4bv9XpJPRyW4PIPg5BanTpAyhiBzzJ4kfKB2EmS6yA=;
        b=gGNGBl7k+V7jVxitG0yZzQ43ps02cuecrqtB02SwHtti3rRkGXbWSYavdMvU9WPEv0
         9uMS4XGrvwlwRoxCv7N/5BdqW0lh8W4uon0BFjujj/8jWY1UaYKETZdA+oZpTDqtjpWw
         rvQ27nDvXhk/zqkzXk7SPVzH1ipfe8BHaLD8dzAtE+yREEQgJVZrDXadnmuyPVsyGZ7M
         89JvQXzIknkZOG9iHPp7gI1jFEaZH5WywA+aCcYo78pMIPU/T8f548yrYV9nDFz2kulB
         za/VCzePmFjCubc9ZphyVDiPTwsy4eyWsE+QDDdbVKJ2CnTd9Bq8sXSjzK+xfLSW5mEC
         6Igg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756450252; x=1757055052;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q4bv9XpJPRyW4PIPg5BanTpAyhiBzzJ4kfKB2EmS6yA=;
        b=gv1REnxg05gts70tCaMZ1OyWJWtoDQHzTZ+O5lbapPt4S/EXroyOteXeeyhndUX6JP
         0rgDeRnllFdRMivf2W87Dy44LMu3Zz5UdWUcf3Dmg4l6cTdnRLF3jrK27dHeS10GjFC0
         AVoPX9QCrq24BNj4Hd+f/2bqoHrHzIwBZ10+EwG2Ucr0k6T+61FfGZLhY6Ndp0BCYNxC
         +dnw6BGUOXLL2Qwnk2lh/VZm+Lvwd/WjHKKxYLi/3rJkO1J26HQWlXtxU+KhZeZU/WR6
         gaAUyDedB3mUwmMO1CFqe8ohg0xOjAr+6GdlbJdd9pIw4sa6xTRomiIpKj58Zo9rhPSZ
         ydhQ==
X-Gm-Message-State: AOJu0YzpYe5dYQjY9dT/wuIhossAg1ZCYnwKfiqRfgNozNRimnA69Ig5
	bMXCURa8AKaOLaU/nV8pbMUtS+5NxslCSCSXUF/AD0MQ8xaS7Z+Ci3UqHzg5zXC/+bc=
X-Gm-Gg: ASbGncvuMy9dyrqoD+CaSadbsLGFTMrRvUT7hFm2NuS9KkkEOppyUCu5Jm5dBdK0YSI
	NbPaa5+1FrKzT67nCaHjcJBBHW+CWF1S/AP2jy/ZXsR80TmdI2SLVGEXWUoaZum74JuLmMc98YQ
	BtA6u+50wxMUWJM5UHDXcU+Sii2mXCYc03U70GymuGPALT4BsoGRng1NgamWv/BpP1lKbgBqva6
	lN1IhTkDtmsWuzfqSIN2eJ6Nf/3Z8gX1HuJe0XRMGsjOnVrdRGL4ZE55tljdFn/XYbA/Lk3EvvZ
	vb1X+ZkGbUZiSIz1Bcoub6bEbXfAcmkqZo7NV9H72rV6rfepgit7YDh69147Y1gNAHn6YZAonh6
	8HoxrVOFfezkv/K4tGzkm73P6yIOBdZJAXK4gmDwc3KNRp2aUZs0ADwWAEq2Y25uLMmPYUVlyM6
	nnraGVKxRoOW5oing/Da910Vo2kmAWc8WtGn8SlDw=
X-Google-Smtp-Source: AGHT+IEitkqBBUlO9gDjRL4vH70BRNxeEkp9jhhWrBW9XMaio50YmhL/AmhtB7Z4ZYw3Ck1PjltuHg==
X-Received: by 2002:a05:651c:20ce:10b0:335:40e6:d066 with SMTP id 38308e7fff4ca-33650feeb2cmr51370131fa.45.1756450252353;
        Thu, 28 Aug 2025 23:50:52 -0700 (PDT)
Received: from localhost.localdomain ([2001:464e:6820:0:4bef:9480:233:512])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55f6770d931sm390085e87.39.2025.08.28.23.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 23:50:51 -0700 (PDT)
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	Nikolaos Gkarlis <nickgarlis@gmail.com>
Subject: [PATCH] netfilter: nft_ct: reject ambiguous conntrack expressions in inet tables
Date: Fri, 29 Aug 2025 08:50:11 +0200
Message-Id: <20250829065011.12936-1-nickgarlis@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel accepts netlink messages using the legacy NFT_CT_SRC,
NFT_CT_DST keys in inet tables, creating ambiguous conntrack expressions
that cannot be properly evaluated during packet processing.

When NFPROTO_INET is used with NFT_CT_SRC, NFT_CT_DST the register size
calculation defaults to IPv6 (16 bytes) regardless of the actual packet
family.

This causes two issues:
1. For IPv4 packets, only 4 bytes contain valid address data while 12
   bytes contain uninitialized memory during comparison.
2. nft userspace cannot properly display these rules ([invalid type]).

The bug is not reproducible through standard nft commands, which
properly use NFT_CT_SRC_IP(6), NFT_CT_DST_IP(6) keys instead.

Fix by rejecting such expressions with EAFNOSUPPORT when used in inet
tables.

Signed-off-by: Nikolaos Gkarlis <nickgarlis@gmail.com>
---
As an example, packets from 192.0.2.1 (0xc0000201) would also match
rules filtering on c000:201:: (0xc0000201000000000000000000000000),
which is likely unintended. To my knowledge, the keys NFT_CT_SRC and
NFT_CT_DST were never officially used by nft userspace, so I assume
rejecting them should be safe. I have tested this change and it appears
to work as expected.

 net/netfilter/nft_ct.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index d526e69a2..23ce90975 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -439,7 +439,6 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 					   src.u3.ip);
 			break;
 		case NFPROTO_IPV6:
-		case NFPROTO_INET:
 			len = sizeof_field(struct nf_conntrack_tuple,
 					   src.u3.ip6);
 			break;
-- 
2.34.1


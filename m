Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCC53E9C18
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 09:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787649136; cv=none; b=kpHITpSRHwL2tUirBsWA2tj0z8OZUGGHHcZw6ZOZ6rYgIiD/msUMb3Sg7jmnEWLEG0lpr4pbbgCsExKTMOFr0GmH4yF9oKDN8coOs3g2NGgz8ezXWnv20eI/hoY1RU8706amGlZ4ZOGgHzThq+WlznfwID48jNpNbtVRxicn7Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787649136; c=relaxed/simple;
	bh=RYTgmNzbCcdgdZixJPJV1jW7mvKJmZX2kwBDmBpozhc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ClJmlt4Ud4aCvpFtpri/buuE9Zfs30XTSQRnJXVhqu/yyw7YMEepiJTynAhoYJpw2eKkHSDIBXP040WVWJYhb6EWixpT21viLDr3fOklDydoUxzpGN8h+UeYQT/WmstEWtQO92qqd4gqW+8kaE1rJvdPrl4aL8k637OOgjVzrTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CJjuxRTm; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CJjuxRTm"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b49fee1ce9so65947e87.0
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 02:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787649133; x=1788253933; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mMBLO7CL+KFPWweenYms5rwiRJoiwPTDdcMzsEXMcSQ=;
        b=CJjuxRTmJa6BACni4cbSGdC4RzjSu/NX/B3UMY6MWL6bdhUtn7pgE3dh85NyAAt7UF
         VMtumdjhwzlQsnKjH8bVdtE813jxM+Me54hM3Z8fI//16BoKfE1SiWmj+LRlkr8cWh48
         UpDuZTT+VxvszPkVhsmf26m1+8c6GgoIFio3GjhoW3JlnuZJLiDDvu6JBmoXKkFaYUou
         r8x2U8X9VKErYeX5WxIR+l32txnhRnODuKaMMrrU3G1ES/0o0YFpV1Y48n0m5+3SBSw4
         CKfvktUwpD7g7IuDr/xcmQSQSG56O3HvRIGYCO+jzqoR9oxWrufPlvEM56ZRN+WT46l5
         CqlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787649133; x=1788253933;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mMBLO7CL+KFPWweenYms5rwiRJoiwPTDdcMzsEXMcSQ=;
        b=sYRT24aScShvGrK1ibqXc4bvSM8GJUS1aTS0aG33unoilV6LztCkrfJ13A/g7j2B36
         +xZP3rBDH312VZX5o58I7CgcYFX7mCl/beIdzNTmEA2kOUiDLa0McD0CNzMNlcabiwKt
         VPTSu0kZI3H0MBaD0xUjgonAHNd0UkkaEMMdvOnhaj1EwXLAPA8Qz1IazZOlO8fEkrg5
         QluLrdqSaot5aScw1Ic9kn5ROBd8E2boEbzQbijZgQDuvFgG53pbG9pMpq26o4pnfj9p
         9ELR4hR0GtVpBsENaRSQKSOU/Ys297z4TMFcLHxl5i5FDz/dGhJPPxjD9FdHdwSNkHjY
         8JqA==
X-Gm-Message-State: AFuF++nIC05ZUF4sB6YSJmq6qmXpjjHcODtuYbH4dio+otIw/9Dnoota
	Ym/kpInuzmzfYcbIcM9MB5klUM8+B915Q/YAFoLv6TZOwlc9jrYq3aJz1R1qVyrwVeQ=
X-Gm-Gg: AR+sD11D4bHgTQRCFgzOs6VG/ZctgZ0BtymggSRSZm8CIuPGmladU0KCkSXGRz77rO6
	DyT6RV1AkIe1qEX2AeT6ZhJCCVbrw2wsHitCsBKjUPmIgScnGoJvOx3856qM/SEZ5pTd7rELJev
	Y8Np75dL7ayaT0yPKf2B/DrQYcDWogk7t/awE2unelwS8gNT60mUPbIRHhRzTFXt+b+Lu4z28kb
	k8Okv73D1kOBhLsFtXXdz4s1mLwzaxEvFgd6dU+7bo3xaIN8yqYBI/UiCN3fkQmhBpMVnTAHlTQ
	Mo3Dqtvv2p/BV7lnjMIUjnahgN9g6j4pV/+SunwvjxZT6KCkK+Fmh2pvw9JXtUupRB7PN4Bja9z
	D2vpxZtW6PA/JQy1sSeqAylC1evTr4GgBHokC1GH5NOJBWx0qZ+6zAv/SybooAgf1jzpzgttK7W
	7vPjOcNAfGgauXhv0sCXWZB4rOUl4jOIY3h1XFet+uFbzRaOkThk9yx3VNHO/uN7vOIQHl85q2+
	w==
X-Received: by 2002:a05:6512:3b90:b0:5b4:5846:d925 with SMTP id 2adb3069b0e04-5b484233905mr9784308e87.21.1787649132506;
        Tue, 25 Aug 2026 02:12:12 -0700 (PDT)
Received: from theodors-laptop.. ([81.95.140.58])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b4995cb5a7sm570794e87.62.2026.08.25.02.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 02:12:12 -0700 (PDT)
From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netdev@vger.kernel.org,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Subject: [PATCH] netfilter: nft_nat: fully initialise new_addr in netmap setup
Date: Tue, 25 Aug 2026 12:10:56 +0300
Message-Id: <20260825091056.253147-1-theodorlarionov@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_nat_setup_netmap() builds the mapped address in an on-stack
union nf_inet_addr. For an IPv4 mapping it writes only the 4-byte .ip
member and the loop runs a single 32-bit iteration, but it then copies
the whole 16-byte union into range->min_addr and range->max_addr, so the
upper 12 bytes reach nf_nat_setup_info() uninitialised.

KMSAN reports an uninit-value in nf_nat_setup_info() reached from
nft_nat_eval(). The IPv6 path fills all 16 bytes and is not affected.

Zero-initialise new_addr.

Fixes: 3ff7ddb1353d ("netfilter: nft_nat: add netmap support")
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
---
 net/netfilter/nft_nat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index e32cd9fbc7c2e..7b026305b5fea 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -65,7 +65,7 @@ static void nft_nat_setup_netmap(struct nf_nat_range2 *range,
 				 const struct nft_nat *priv)
 {
 	struct sk_buff *skb = pkt->skb;
-	union nf_inet_addr new_addr;
+	union nf_inet_addr new_addr = {};
 	__be32 netmask;
 	int i, len = 0;
 

base-commit: 7cbfb180945ce529608e4d4e24a6d483699fab1e
-- 
2.34.1


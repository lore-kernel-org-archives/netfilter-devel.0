Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4103BD657
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 16:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781022937; cv=none; b=Ipde1t9cxBuAJmwSOCajy63EYdYrQd4FrM0kl82mQb0n8718T/lRE+ie5QxfeXW67d5BphLUX2NsxXS3bXIgwYJ5kR4gwZNuRovvxd/abWmLC+3VAjshNz++dElwqzS05iJvC/M5hrATpf7b7aDzMla8Z/pMxKCAfm/SvABvIQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781022937; c=relaxed/simple;
	bh=CqCQP01+LBJiO/yyYtoN/nAx25MrKlaUMoT7KCXPYeI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DmIGupguShcPVNMET0di7KffsWUFJHdQ62TX9X4c5AHvrAmy61121EHqpil+4eW8cGKa9xnL5L9BO8TPxEUVXtWTNW2TwGZFdvYckOzjyit7vH9MBwFujegepySzsxfgmnr77pDh9WhF5gjfGyyGaDL0znruGmnNuYJXFVU55ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rdnd9xpY; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rdnd9xpY"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490aebf33e9so32794195e9.3
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jun 2026 09:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781022935; x=1781627735; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ZISnQw1sq7YMU6WSz9bLO5KxRUTFmuBZ4joqQ9xMgg=;
        b=rdnd9xpYNPimt5a2a3UTCVROnU96CIfowFUXOwynrh03Ezimi8gcHoe/4BC935d74q
         ebh0kCyOjAYWjt+Uge8HAhSS7CyHxVTFQ+EJ5IOcESLn63XJtIfpipiHOa3EAYC+7Dg/
         BOssa36Jw1Xi40xSpDinRlsiDkF8HMvghYwwZtCapSLw1/VCZbzmLs3fDsK17auF8pBZ
         7+WECBjX6rypmtyFZmKLBPeRKByQmrSb4fyRE5JKRu7ZO6Q9vbJRi9RyB+KwHzyIqlcB
         n0FJren6Yf32yTJoHOCcx1tIM9DKyEXJWHDxOFPGPwWKfyBzt6h0sYOthPx3FKmu3tnp
         5vPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781022935; x=1781627735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/ZISnQw1sq7YMU6WSz9bLO5KxRUTFmuBZ4joqQ9xMgg=;
        b=QViiKV8lN7yAGt36AqKqnqet0GZ86svryw0jd96J2xHG9UvXB0H775yCt6yuAbCsK4
         4ltMLNf1MDhHnn1YK8NtO8gAtQJe1Gn+w+k+g0BCl59tipVEMsFo6JG1j1MpkdyhsaqZ
         +NmoQGbqLB+qFWGZEX70a3JJrA/DQsTwtdKxFPqMek6/LI9KvMwNp/Wif5omUJlIHKph
         W92fxeZnH2R3c3TAFZaqL8Ip8/cximuR+O8JVgpTxIJswHAYA61mTO6eFcuUczfvIUzP
         CadSM7SoiOQd1Fc9wDjQVv3cHKhmnLVRUTKLYZaBHpq+fskRcVwY8IJoxZvoL7gcWF18
         xoDA==
X-Gm-Message-State: AOJu0YxOxZ3sKdZAOJ9SVVxp58UPSuJOz/nOXPq68AlOtD4OK85QpFUQ
	6B8kCJxzW5yZN2j29gbL/ys6u1d6VwY4ggzUfz4Z3yvJRWuYy6/SMb3MYy1Jy8hynzc=
X-Gm-Gg: Acq92OGnFS5E7H0pFhlBwJMtdZvhPz/SDK2kuK7AIZqTaSihKldMJBmISanhBguqY4x
	8zk2XKwghAH9dlJueqfvqC0QR/BgE3hVysMOumVICVQbZTAntme2zz68HFT0nJRFWu5Fb+9WVtF
	ncJLagy6HVp2i7PFBNDAGNeFb3cdbOjsDartTmKNso8ACebUCT+VQOWrTqKaxJP1Oug4dFe5Di8
	K5DetoZ/CdhzvsnbWzKjnMMQTR6lWP38AFnyJ+//Z+S9r8H4Ui6gfYXOE4bYDcW/81zStLvHdzi
	05uS8QaMwyi/m8p+i3LflYacjulip6HPpYfN93qwDNA5AyBj5N7JGyZIwnNrHTR/1mdkYQvhUiH
	iWKE7V8n/YkS3NG/3LoXUEMamx0SLCkS8m3Do4tOD7smu8q9yUEAR43bMq9rPZZAJ/Mfh9SQ/9H
	rX8nb+rB9L+2P3PlwOsgZRVF18pnggmvAzByMMGhEmItE+9jES5Z2BvBk3su+zHk0l2P0cq58BB
	F9C9Y37GadWrYaUzWay
X-Received: by 2002:a05:600c:81c9:b0:490:bd66:db49 with SMTP id 5b1f17b1804b1-490c25a1e20mr292774665e9.12.1781022934301;
        Tue, 09 Jun 2026 09:35:34 -0700 (PDT)
Received: from manta01.. (host-85-36-215-182.business.telecomitalia.it. [85.36.215.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3b5b06sm449114015e9.3.2026.06.09.09.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 09:35:33 -0700 (PDT)
From: Davide Ornaghi <d.ornaghi97@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	coreteam@netfilter.org,
	Davide Ornaghi <d.ornaghi97@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] netfilter: nft_fib: fix stale stack leak via the OIFNAME register
Date: Tue,  9 Jun 2026 18:32:14 +0200
Message-Id: <20260609163215.1102215-2-d.ornaghi97@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260609163215.1102215-1-d.ornaghi97@gmail.com>
References: <20260609163215.1102215-1-d.ornaghi97@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For NFT_FIB_RESULT_OIFNAME the destination register is declared with
len = IFNAMSIZ (four 32-bit registers), but on the lookup-fail,
RTN_LOCAL and oif-mismatch paths nft_fib{4,6}_eval() only writes one
register via "*dest = 0". The remaining three registers are left as
whatever was on the stack in nft_do_chain()'s struct nft_regs, and a
downstream expression that loads the register span can leak that
uninitialised kernel stack to userspace.

The NFTA_FIB_F_PRESENT case has the same shape: the register is declared
with the result-type length but the eval stores a single byte via
nft_reg_store8(), leaving the rest of the declared span stale.

Write the full declared span in both cases:

 - replace the bare "*dest = 0" in the eval with nft_fib_store_result(),
   which strscpy_pad()s the whole IFNAMSIZ for OIFNAME (and is already
   used on the other early-return path), and

 - declare the destination as a single u8 when NFTA_FIB_F_PRESENT is set,
   so the marked span matches the one byte the eval writes.

Fixes: f6d0cbcf09c5 ("netfilter: nf_tables: add fib expression")
Suggested-by: Florian Westphal <fw@strlen.de>
Cc: stable@vger.kernel.org
Signed-off-by: Davide Ornaghi <d.ornaghi97@gmail.com>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 2 +-
 net/ipv6/netfilter/nft_fib_ipv6.c | 2 +-
 net/netfilter/nft_fib.c           | 3 +++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 9d0c6d7510..177d738825 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -128,7 +128,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		fl4.saddr = get_saddr(iph->daddr);
 	}
 
-	*dest = 0;
+	nft_fib_store_result(dest, priv, NULL);
 
 	if (fib_lookup(nft_net(pkt), &fl4, &res, FIB_LOOKUP_IGNORE_LINKSTATE))
 		return;
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 2dbe44715d..b9ad7cac14 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -239,7 +239,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 	lookup_flags = nft_fib6_flowi_init(&fl6, priv, pkt, oif, iph);
 
-	*dest = 0;
+	nft_fib_store_result(dest, priv, NULL);
 	ret = nft_fib6_lookup(nft_net(pkt), &fl6, &res, lookup_flags);
 	if (ret || res.fib6_flags & (RTF_REJECT | RTF_ANYCAST | RTF_LOCAL))
 		return;
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 327a5f3365..6df811b8d5 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -107,6 +107,9 @@ int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return -EINVAL;
 	}
 
+	if (priv->flags & NFTA_FIB_F_PRESENT)
+		len = sizeof(u8);
+
 	err = nft_parse_register_store(ctx, tb[NFTA_FIB_DREG], &priv->dreg,
 				       NULL, NFT_DATA_VALUE, len);
 	if (err < 0)
-- 
2.34.1


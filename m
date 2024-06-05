Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB441373
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2024 11:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717585443; cv=none; b=HjJhn/c8MDLFUVyjiUtjo5NXzhaXgtHmaV/5kavdPwe2MDK2/o6FqpLcQ6vJpR44scB0+rKNuF/Lia3EFr8tSGPaVRD51mWPI7zToMEWFoNKwVjF5j3iNKS092EcXb1/56Q0gnUcr/X2iN5x3pB6bkLCuQTo+KFhBDCg4Upn5DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717585443; c=relaxed/simple;
	bh=YRuTq8icvLt43Xz+g1U1s6coHMoaDqx5UcPioIlfQII=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ddYQhy40teGtf/021QDAeqXccONb5NWQuevvwyLEUeZx+B4cqmuE/kLMggq7GW66rDym3PMHN4E5QX461AbhoiWTQby4qw4QFy0yjg1dlWq0jwveHGYQlnu8seO2KV2sbnXmGoC3FNIeDPgoPJOG39o80nNVEDL2vd+C8J2+G1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MCbsjcFT; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MCbsjcFT"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52b7e693b8aso733224e87.1
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Jun 2024 04:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717585440; x=1718190240; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YelDKh653St8Uk3tIl8zzDR/OIzJiBFQgK+ie3d/Mz0=;
        b=MCbsjcFTrWR4uOyPl7bK7m0ZOyYDlTbsjQJ3ND5hFz870EqBFAOffihURbgFuMV/cA
         cf0WVpPyzKrv1j6FngXAHnj9zQwpJakTzF0aEacPeD3FnwSMjLJf05Q6nKpUe9zq/XD7
         AyMIhkHUXXrQ+QiYBXmYJaynhlQf4p3IguGN2mttalq8EnKObjzU8RC/QyU8KyuaCPyK
         IXJ4g96r/bEXRZYL9KjaTFP8ieR99QjD8way95DcdSlRld2G/fB0ya8whugm1mRz3Yfw
         myPJcVxbuo3UfKMPjC9EleoYHmAvZ5PWObwUeIJn7oJEe9DJn6KKdLbsg0GdnXUzrjAQ
         aM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717585440; x=1718190240;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YelDKh653St8Uk3tIl8zzDR/OIzJiBFQgK+ie3d/Mz0=;
        b=TjBF7G0OANvFkkEGvJndPxrUDegUuB2fvr4YZ3CKBowmvlAAqUAsZDX3TR6D6chygo
         UytEcRr5o6RR8QtbBjzLoLUYvUthrM1GQ7mNWaHlWdj1reZwPZv/qmJcEc/97mlRJM7x
         QLTygqiFfmFKVu4C022DsaKVBCRyWAb5+kAlrai4ICgguE1mDV7iWOrvIHyxt8DbhIVH
         XL/ROrF4Wglxozm2I8NMRu2LsvKTWD0m021rz9D4a72VSg7Ny5gxYGn7yDtfE1tOWItC
         t6PSfXDuXHCOwrNp5oTueRhjcqazQGAz53R5xveyz/dD+YelPIyy9fcYCV8IQt5M3fhi
         eDHg==
X-Gm-Message-State: AOJu0Yw9El0NcRil+suYI67aSiVyHu8T1XzJFWKPVA35vV+U2Kr/kcpg
	iJNrrvNNMJvQrlmT6NTdU0x1JZ28thbJF4P5Meel9GCc/wH7vAA/NRdFVrl9M2sUK3/uXUkGkv4
	mdXC03+Y9+eaTJVBzGUns1zSzEScXWhERThw=
X-Google-Smtp-Source: AGHT+IFQhaaQMEvn8UyR3QSzCcwSKhxvPmfzX7Hbudr3BUxIX3XI/sNC6ue8Ok/jqxfTks3Sn7KxeGma75rSMTFIcag=
X-Received: by 2002:ac2:4343:0:b0:523:2e60:64c6 with SMTP id
 2adb3069b0e04-52ba226953fmr1318337e87.11.1717585440094; Wed, 05 Jun 2024
 04:04:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Davide Ornaghi <d.ornaghi97@gmail.com>
Date: Wed, 5 Jun 2024 13:03:45 +0200
Message-ID: <CAHH-0Ud0OvWYzBpXqg1noeDWHg7ZpDWPue4-Pr_Nt9-HjoUXNQ@mail.gmail.com>
Subject: [PATCH nft] nf_tables: nft_inner: validate mandatory meta and payload
 netlink attributes
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@netfilter.org, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"

Check for mandatory netlink attributes in payload and meta expression
when used embedded from the inner expression, otherwise NULL pointer
dereference is possible if userspace.

Fixes: a150d122b6bd ("netfilter: nft_meta: add inner match support")
Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel
header matching")
Signed-off-by: Davide Ornaghi <d.ornaghi97@gmail.com>
---
 net/netfilter/nft_meta.c    | 2 ++
 net/netfilter/nft_payload.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index ba0d3683a..e2893077b 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -839,6 +839,8 @@ static int nft_meta_inner_init(const struct nft_ctx *ctx,
        struct nft_meta *priv = nft_expr_priv(expr);
        unsigned int len;

+       if (!tb[NFTA_META_KEY] || !tb[NFTA_META_DREG])
+               return -EINVAL;
        priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
        switch (priv->key) {
        case NFT_META_PROTOCOL:
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 0c43d748e..4c6f15ad0 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -650,6 +650,9 @@ static int nft_payload_inner_init(const struct nft_ctx *ctx,
        struct nft_payload *priv = nft_expr_priv(expr);
        u32 base;

+       if (!tb[NFTA_PAYLOAD_BASE] || !tb[NFTA_PAYLOAD_OFFSET] ||
+           !tb[NFTA_PAYLOAD_LEN] || !tb[NFTA_PAYLOAD_DREG])
+               return -EINVAL;
        base   = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
        switch (base) {
        case NFT_PAYLOAD_TUN_HEADER:
--
2.34.1

Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDFC3DCD8D
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2026 12:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782390523; cv=none; b=j/vYVnA929tcR9fQRdBGx5gKtPZoclteepotNeAa5NV7XdQqwelIzN25HvKeZrTnkBVyMfBZHLHdk5fQ3iqGkwqVCLAaLqwkG32toxiFG0ijg++BaxgXwKs/SoY8yAmgdZIpk0xXfrQch4Cv7SeZn6lbQI2pKK0dFOeXQ3thUlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782390523; c=relaxed/simple;
	bh=UTO7Jm1T6NTWo3k1gPdLKtSamKd3h/kyCBCmwq4liPw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kk/DvACHL5nfjZ7AcCBb0DnUAqNpfLyYavWrcGPpzLGdeTnWxTeevImp6Mh9ziosjPr30RAgNTsvjRW0Fj9kTaVTS0S2EvIN2PuXHhE8hvr9GMQnAGUHq4kVR9yCeD6DUu2odY8VPC1LUKYVjouxJm6S12zWzJxBZJQ45tgV8sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I6MWFi9a; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I6MWFi9a"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c0e12cb1d90so352365466b.2
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2026 05:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782390520; x=1782995320; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h/vLuZxKBQ7pr2bafrnQB5q/6jjB2x09vCJ4tjD3aJA=;
        b=I6MWFi9agwz83G8V/PxpjkABO+QYu7i+EeytNnhgetVNaHfFFf7+mNFYRE+UnJLs89
         RGnYWO941Gt4SOPSy3lGX3p10oa0TD5pWjZdLxmoexl9+9Er2J8c2sT+bv17yLqAYXeX
         OY2c+G+lVR2+0lWh005yjz7WRHGSvfrH0Hti90dEy4Zdo+AM/A7LmqMxPePJ9Fccyfeg
         nrTylxRyfNDiVNwq102j4mJTUXcy6Q95B28EOQsiIW6YLiAZF4XoBP2C0JNA7mhfTjqy
         yw3ojYhTIP+VlpoyAdc7z4rhswI6w3p8P29/cabGJdBUcuTgMkcBtm4VF8GWPMuPDZG3
         qm8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782390520; x=1782995320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h/vLuZxKBQ7pr2bafrnQB5q/6jjB2x09vCJ4tjD3aJA=;
        b=DGDUh1MKiJc7/16xwvqiX49G1/V7TycdLPPPyru8NdACFLOAXfkuO8CPvuw45+YJWc
         EmgV0JHTOSrXI7LXXkHFWHz21mQ+q//z89EF8pBrjaZV0n2XZGheoK7yifbbGv6daToh
         pl2o5lyss0vp85UY8bpEwOi9shbfd5MTNcj9+AK2FZlIyajaqD2b03o+/eFSD0kcQE8m
         J7Qc3B0h/q5o8xNuj8d3AycacnPTuhQB6bqWD68OtK+0yGR/P/8/nDCV/dZ8Jt7Oyc8P
         JugxZpGVfzQg9mkNoqWv/eHv5bzoFUDWNRSJlaNacG1XG+ZRl3s0Nmupvjnu2vnRjIW2
         mg7A==
X-Forwarded-Encrypted: i=1; AHgh+Rqzzc1sUqNg0RGdjrTRk97LRN9sa00ALdEzPwVvD6SaFO2sHQJnF2qGR4879SHCF3JrKSpczgyrRtKX9j9akFE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcwlXglN9vBBj/Llq3LR/B2S3+V2cRdRgC/kbGdQwLsZTtnC8B
	zZGn9bw7IY3Y990godwKvykzgpIJ6I2YCuEHNYRuRYdiW5eaqqDLMSWy
X-Gm-Gg: AfdE7cmEmV8Hd6N5gJOBZo3tEreEJ62RRUxvCbrVs9iqPKCzReAL7tZtlr/SinWbm9o
	8rXfydFjR5Mp3Qc+rzp0mbA2+kU/EeUbeFNq9eXKaf9sUF8BnyzyE8Ss/9hiqxW6Oun44+gmHiK
	vKyl62k/jwtbT9eckNXCxrH2pIGg5EmwizOhtDoT0Ikua7HnxcaIGkHgTVSITYjkx9Z5tOce9i1
	gdBYArYvaZ4oXaDApf68FG9JvKsnyCM1JFLNZDUgrNeCOQKZKJO3V02TyrKHPQagy2GT8/UWLgu
	bkqdQI1NGmHsOouTFkTXTc4Uqhq2Voja16n1ishMSQE7vPYTT1QDoYxw8wHdvnCObZesjB3r0dj
	vFX15eUIpRcdhuVSkjRI/uAzRa8yE5R+F4ZESJ7eUrUXN1JN9X3D0BdH48f7ftZPzC+mjS/rov/
	wY26MyCmVxKjgEEspeeBayTIli/9QHsap7zMrEVBInSXSN0A==
X-Received: by 2002:a17:907:728d:b0:c12:16b9:578d with SMTP id a640c23a62f3a-c1216b98110mr18693566b.38.1782390519695;
        Thu, 25 Jun 2026 05:28:39 -0700 (PDT)
Received: from theodors-laptop.win.dtu.dk ([192.38.81.6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c120dcc55besm57143266b.44.2026.06.25.05.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 05:28:39 -0700 (PDT)
From: Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>
Subject: [PATCH nf] netfilter: nft_fib: reject fib expression on the netdev egress hook
Date: Thu, 25 Jun 2026 15:28:34 +0300
Message-Id: <20260625122834.204088-1-theodorlarionov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ajxsjcDOnwllMfoR@strlen.de>
References: <ajxsjcDOnwllMfoR@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A fib expression in a netdev egress base chain dereferences the input
device nft_in(pkt), which is NULL on the transmit path, causing a
NULL-ptr-deref at eval. nft_fib_validate() gates the chain hook with
NF_INET_* masks, but a netdev chain's hook numbers come from a separate
enum that aliases them (NF_NETDEV_EGRESS == NF_INET_LOCAL_IN == 1), so a
netdev egress chain passes validation and then faults. Add a dedicated
nft_fib_netdev_validate() restricting the netdev fib expression to
NF_NETDEV_INGRESS, the only netdev hook with an input device, and
restrict nft_fib_validate() to NFPROTO_IPV4/IPV6/INET so its NF_INET_*
hook masks are never applied to another family's hook numbering.

Fixes: 42df6e1d221d ("netfilter: Introduce egress hook")
Link: https://lore.kernel.org/netfilter-devel/ajxsjcDOnwllMfoR@strlen.de/
Signed-off-by: Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>
---
 net/netfilter/nft_fib.c        | 9 +++++++++
 net/netfilter/nft_fib_netdev.c | 8 +++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index e048f05694cd..89555380f1c5 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -31,6 +31,15 @@ int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr)
 	const struct nft_fib *priv = nft_expr_priv(expr);
 	unsigned int hooks;
 
+	switch (ctx->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
 	switch (priv->result) {
 	case NFT_FIB_RESULT_OIF:
 	case NFT_FIB_RESULT_OIFNAME:
diff --git a/net/netfilter/nft_fib_netdev.c b/net/netfilter/nft_fib_netdev.c
index 3f3478abd845..c855c5dccd41 100644
--- a/net/netfilter/nft_fib_netdev.c
+++ b/net/netfilter/nft_fib_netdev.c
@@ -50,6 +50,12 @@ static void nft_fib_netdev_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
+static int nft_fib_netdev_validate(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr)
+{
+	return nft_chain_validate_hooks(ctx->chain, 1 << NF_NETDEV_INGRESS);
+}
+
 static struct nft_expr_type nft_fib_netdev_type;
 static const struct nft_expr_ops nft_fib_netdev_ops = {
 	.type		= &nft_fib_netdev_type,
@@ -57,7 +63,7 @@ static const struct nft_expr_ops nft_fib_netdev_ops = {
 	.eval		= nft_fib_netdev_eval,
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
-	.validate	= nft_fib_validate,
+	.validate	= nft_fib_netdev_validate,
 };
 
 static struct nft_expr_type nft_fib_netdev_type __read_mostly = {
-- 
2.34.1


Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA945367B61
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 10:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782730495; cv=none; b=nRbLOuZNwqoqC4K5KtGN4a1C3HP1gOG6Dm3BfoCn3uNVfXvX44o/kRUdmbK7jI037/0Uw+qqzxb63b7ZepaerMO+dnfAg5Y7sE0S3R5jOpRa2+eAvkc/1Omy7oqsVivMdF3dpOEfkfuVl0rXz/ySo5wEN5bI++LMmN9YF1Ps8cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782730495; c=relaxed/simple;
	bh=suTxv2lGlb0vuEZ4qUiIc8hmOhKLVAdheXe73U99V14=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KDfMX5LvyT4N1vlxV9FHRPSn8VUMLvw6Y8dB60w3tkDfOzzsFw+jxdWwZ//zBLa2beuPYiPRyIxwMiQBEwjZkW3A7nkMMvl9o+wrGNfiPrt/3e1A0B5KA8MfHkoXAzU+2GUxRhecqfrAs68C4sj6JEviVNw1sWb55j8QomeKpr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j2xGVV2R; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j2xGVV2R"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c12620ed112so114838666b.3
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 03:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782730492; x=1783335292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1W69xAmU3FH7FS2gj8YG8V7yiLYBih38HJEx68YRubk=;
        b=j2xGVV2R1WGpv3vFLVJ1pT5HykR8Qdj3Ns90FJtzvHjChg93yp5fAD/qRQQxUVN80E
         mkLwiw9B5Rnk8YaMtR/h3/wmhfOu4a6EQNM/ieKAlrnbrv/JGHB2dOwmdTLqO3cnPd+c
         KttOsf52i4R3A+wRYn3cANB8CjMRwgyezh+rC2jn13PPgNcjBQuLh60DNh0xwvrqrdJN
         YdDwlaJRjJ34n7ez4n8/HDPSMzticrScF2Z4TBN8uyotW+9gwLnHtSjwwmH0c1KVEMvi
         Aj8YbFxElcak7BC/xB/tHdBcobPfKv1PNSLltAQoRuqQ5/Jsf00PXR8HJGKwyTuoONqq
         o3Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782730492; x=1783335292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1W69xAmU3FH7FS2gj8YG8V7yiLYBih38HJEx68YRubk=;
        b=nzf6/xlbe0CScn5ZLbpzxWHuhDvjD9ISJJ4WJ+5Kn002dGaOy09/+j654ldrTL1yUx
         NcLolaDM/BaGUCVrfc3gDnzCtQxUGsYzWq5wtViYaI/MQBw+61llf5QV8BjXJ2SH0f4X
         gWegbFqXDgBvEgH64sYyw2Loky+UHrduRtoXDshbdXbRWmVKZBheCGQwImvjRMVBAj3T
         CHBY7YAIjEAsIFmFe/p8m+YG0Tn4Wp5G+y5w31C8Hg0jIrUMTlIlzdVwlobVQahzvABN
         fh6yXlKexwCUcD4Lx/z9hTjzqs5+7juohk8UT4tRYTnYEfFCQdU65bzKDPzhXnQAr5op
         pFMQ==
X-Forwarded-Encrypted: i=1; AHgh+RrrK4omqmiwk3KaeTeNe8WJdsf0uNhMp+BKBACaGb6J38p22/BFan6jwitT3ua0W2eseOx/hZ934rqTpesQ32A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+UNAIjUB/cY6ceN9PR4QpSGX+xO/RQ8/nFY6ElTIkbPNAyxMH
	fyWVyLdVZYj3Um1J0rejiIwJg5uoN2l9kNs1QI600BzbZdX81wxONL/m
X-Gm-Gg: AfdE7ckqRJmFS4lsywjx1F2e6KHjW2jIvZiOIqp673EsB+/RpGXPOHVlJN+BjIV/mhj
	nn65+j89mE2hSZBaSO970ooi3bQYr4y2NTKJPyUBhy44qQubqEPM1r5mo4O4MNJaq6ENLCPuLAh
	8CS0LSkc3+xbtySzWR2RPUZ9bbyvWRrHWAs7jCsdhybkW4Y689ewSrR/Gmf0fvoL48rSRnpyfj4
	FoFU6iPg8bwsm8k08Hdhr3RPxRnEgnPRr5sjUtq9RGyuammjO9uq7K1hz3ll4nmdp2uAvUrl0sP
	e/Rz4gwRljTk1nyw/4ZJTX3pH0rm4F6pPdR2bl+pvrLNJ4w1L7p7jrwci/mF2E8X40On/8Wqu1w
	oFXNn1E9skLF3WPCjEVR/oYWC2gdqw28hAApRv9Y4bYVeFe/K0cgG794FZJm3hoLiZozzfhfj0Q
	6hhC5e5fwU8MTC4io6D17iyKJcIhEs4jr+dzuXsi+8PTFuABfLe739rqJjtbVthA0KyT89Kd3Pw
	5XIb07m
X-Received: by 2002:a17:907:98a:b0:c12:3059:4063 with SMTP id a640c23a62f3a-c123348c719mr444414466b.14.1782730491950;
        Mon, 29 Jun 2026 03:54:51 -0700 (PDT)
Received: from theodors-laptop.. (carrier-grade-nat-ip-009.boaar1.cgn.fiberby.net. [89.23.224.104])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1279b6c0d8sm52102366b.32.2026.06.29.03.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 03:54:51 -0700 (PDT)
From: Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	theodorlarionov@gmail.com
Subject: [PATCH nf v2] netfilter: nft_fib: reject fib expression on the netdev egress hook
Date: Mon, 29 Jun 2026 12:53:11 +0200
Message-Id: <20260629105311.155142-1-theodorlarionov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <aj2LVX4rz4C_Z9DJ@chamomile>
References: <aj2LVX4rz4C_Z9DJ@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A fib expression in a netdev egress base chain dereferences nft_in(pkt),
NULL on the transmit path, causing a NULL pointer dereference at eval.
nft_fib_validate() masks the hook with NF_INET_* values, but netdev hook
numbers are a separate enum that aliases them (NF_NETDEV_EGRESS ==
NF_INET_LOCAL_IN), so an egress chain passes validation and then faults.

Add nft_fib_netdev_validate() that limits each result/flag to the netdev
hook where the device it reads exists: the input-device cases (OIF,
OIFNAME, ADDRTYPE with F_IIF) to ingress, the output-device case (ADDRTYPE
with F_OIF) to egress, ADDRTYPE with no device flag to both. Also restrict
nft_fib_validate() to NFPROTO_IPV4/IPV6/INET so its NF_INET_* masks are
not applied to another family's hooks.

Fixes: 42df6e1d221d ("netfilter: Introduce egress hook")
Link: https://lore.kernel.org/netfilter-devel/ajxsjcDOnwllMfoR@strlen.de/
Signed-off-by: Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>
---
 net/netfilter/nft_fib.c        |  9 +++++++++
 net/netfilter/nft_fib_netdev.c | 29 ++++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

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
index 3f3478abd845..5774a7544027 100644
--- a/net/netfilter/nft_fib_netdev.c
+++ b/net/netfilter/nft_fib_netdev.c
@@ -50,6 +50,33 @@ static void nft_fib_netdev_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
+static int nft_fib_netdev_validate(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr)
+{
+	const struct nft_fib *priv = nft_expr_priv(expr);
+	unsigned int hooks;
+
+	switch (priv->result) {
+	case NFT_FIB_RESULT_OIF:
+	case NFT_FIB_RESULT_OIFNAME:
+		hooks = (1 << NF_NETDEV_INGRESS);
+		break;
+	case NFT_FIB_RESULT_ADDRTYPE:
+		if (priv->flags & NFTA_FIB_F_IIF)
+			hooks = (1 << NF_NETDEV_INGRESS);
+		else if (priv->flags & NFTA_FIB_F_OIF)
+			hooks = (1 << NF_NETDEV_EGRESS);
+		else
+			hooks = (1 << NF_NETDEV_INGRESS) |
+				(1 << NF_NETDEV_EGRESS);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return nft_chain_validate_hooks(ctx->chain, hooks);
+}
+
 static struct nft_expr_type nft_fib_netdev_type;
 static const struct nft_expr_ops nft_fib_netdev_ops = {
 	.type		= &nft_fib_netdev_type,
@@ -57,7 +84,7 @@ static const struct nft_expr_ops nft_fib_netdev_ops = {
 	.eval		= nft_fib_netdev_eval,
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
-	.validate	= nft_fib_validate,
+	.validate	= nft_fib_netdev_validate,
 };
 
 static struct nft_expr_type nft_fib_netdev_type __read_mostly = {
-- 
2.34.1


Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC46E3ED5C9
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 10:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781088047; cv=none; b=jOHuseNb6+f3oVQ7IotxhuU2QF3iNaB5GkX4NasrdTadPMqwc5SSOZ3rnNW33y3QVRKM9Gb+m6TG9eC7gupsas3nbeVxUSjXAE8SxYBK23mT+Pn39SCJq7CRBTwLsWZ6OjYXe4JDZZfr4GyTdb4j3rBrgu4+C8agjxQxx63XrwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781088047; c=relaxed/simple;
	bh=BgIWThzfJbN929F7TMVAmhJQXdFhIwYy0gF4vFRNzFg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i4h3u+C9pAnhviQkJup+3vL5qxftlifklXnVkRjf0YcIkL37qKl0zjRJIZ4uWkTxtsvF/+FEjmlxRz/KTx+Ikn6b+cc0l30Q78LCisexujN+nDmlUFvFPm1LAM+mFfKRCAEs1srSfX7H3MiZt9lAO5caDmWjWDl7f+NfkjoeIqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WxeF4v5s; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WxeF4v5s"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-45ef1198766so3806641f8f.0
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 03:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781088044; x=1781692844; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QQESznGGkGRPzFP+Yzi0QaSyHIzGH7L9pn4wzNTvfPc=;
        b=WxeF4v5sHV2jONGuPFvSbnV1/gDYU2iH7M2bHHt31ttU23ARfIHfA8/sgn4zi0FD9M
         hlibbHwL+e+fjf1g4IIGBuL2D95NJ4Z0ABCXVF5MBbEEEU+8ny1BlSPdKmSNuFEkRxOq
         9f7tyqSPD+lTey2LRAVWI/p6Tvv8P8rU6woGWWPjidZH46mPeKeGHLdlnU+ebavNx8+d
         vfExYWVdSUQleF4BQkGzNY2pEaHGM73Rc2ejXU5rZNcr6nNUIhyHMzp4bld4jCyC+Ya2
         BhW4JKsdBeVfWQzWGatH0tHGnr5CZoZW87qWi+eAFa8Za3cgruEJAv33v/3Xa5rrt4m9
         GNJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781088044; x=1781692844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QQESznGGkGRPzFP+Yzi0QaSyHIzGH7L9pn4wzNTvfPc=;
        b=Dle2330JNXRTFjbe35OEwWEL9UJwAENzZlubir/JJKH0Np6Xqn/k5xMjA0i2YjzzHy
         SeZSs1iouFeFnmNsCCiSdv9olEjgj7Ty14WbuWRbldbb3HB18YIgWF1a3RXkopYYlqU1
         tUw01OLsiXEXvTmfLWkilDydMpVTPelzgYLES2NJAGHbiro50Ia6EAbbtStDO5+h1gYK
         fcRfN18lQc9xXYRIPtEnlWCzCbAc58LGF/oP+NrF0uf5osROemptOHLOzVmEjS3tM/WN
         DwIN++JBCwnpYUT2u/ryEbqgObyOy2BU2v22slJatM5tUEUn/ZUdt5tA0wdRAqxTnx0R
         OdSw==
X-Gm-Message-State: AOJu0YxKeUccVYV8rhuslpBIt5jt2AWmHyRBXQ4ueFRjKw9WIaqOJUeb
	dbvf82iiuNGhEZ5J4Q1Z5B3xhuvp2+KGakvMXKv8NF4I5avi4i774t/sSMw2v8kX404=
X-Gm-Gg: Acq92OHBJzcxKPYAJnbU7zGowSoB5CnStGpBTpmLSjccuJEB/zftknIx6A/yzjH86iG
	t2/vLfWoWg9dES7HRKp+SQmxcrLmTch8SBsV2mHs7t3SS02Gu6cvhzGiendZojAEMLVJaKByK9y
	SEwItL9JajO2NoCA/RLjvESlAqiIsSfNBWrGvq7ZFmzZNkD26KkRRxLwvByjM9bMqic5mKZlTQh
	CxKltasWId58qGdw5fjus5RP9qdKbAxiqRljgWTXWppp4dpwz9zsQjhE/Nla7qWVtzzL+F3fplv
	5Nv7I7SxgcP3MHx11B18VmoSOvPRSE7YMr3JhJ1DxIwQg97esEh6OWQM09lT05wiKAFfvW9aU12
	kScEphTwT2rQhW2pCJQ7gXfwAO/W3ii5VGlXhN0kVIak7x0olI7ntSRVDTsVviTvxpcrNM3T3dd
	/wysLBoTJaMM8swBdI4KQOSnIO0RsEQV2+ok5FCWAWwp9SchRjCvGyLDkZr0t5zFLU6MOWsA8xQ
	MBejg9B+g==
X-Received: by 2002:a05:6000:400d:b0:45e:dd32:92fa with SMTP id ffacd0b85a97d-46032b81e04mr36180470f8f.12.1781088044150;
        Wed, 10 Jun 2026 03:40:44 -0700 (PDT)
Received: from manta01.. (host-85-36-215-182.business.telecomitalia.it. [85.36.215.182])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f345209sm75828687f8f.17.2026.06.10.03.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 03:40:43 -0700 (PDT)
From: Davide Ornaghi <d.ornaghi97@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	coreteam@netfilter.org,
	Davide Ornaghi <d.ornaghi97@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] netfilter: nft_fib: fix stale stack leak via the OIFNAME register
Date: Wed, 10 Jun 2026 12:39:12 +0200
Message-Id: <20260610103913.1949008-2-d.ornaghi97@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260610103913.1949008-1-d.ornaghi97@gmail.com>
References: <20260610103913.1949008-1-d.ornaghi97@gmail.com>
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

The NFTA_FIB_F_PRESENT existence check has the same shape: it is only
meaningful for NFT_FIB_RESULT_OIF, yet it was accepted for any result type
while the eval stores a single byte via nft_reg_store8(), leaving the rest
of the declared span stale.

Fix both:

 - replace the bare "*dest = 0" in the eval with nft_fib_store_result(),
   which strscpy_pad()s the whole IFNAMSIZ for OIFNAME (and is already
   used on the other early-return path), and

 - restrict NFTA_FIB_F_PRESENT to NFT_FIB_RESULT_OIF and declare its
   destination as a single u8, so the marked span matches the one byte
   the eval writes.

Fixes: f6d0cbcf09c5 ("netfilter: nf_tables: add fib expression")
Suggested-by: Florian Westphal <fw@strlen.de>
Cc: stable@vger.kernel.org
Signed-off-by: Davide Ornaghi <d.ornaghi97@gmail.com>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 2 +-
 net/ipv6/netfilter/nft_fib_ipv6.c | 2 +-
 net/netfilter/nft_fib.c           | 6 ++++++
 3 files changed, 8 insertions(+), 2 deletions(-)

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
index 327a5f3365..a1632e308f 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -107,6 +107,12 @@ int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return -EINVAL;
 	}
 
+	if (priv->flags & NFTA_FIB_F_PRESENT) {
+		if (priv->result != NFT_FIB_RESULT_OIF)
+			return -EINVAL;
+		len = sizeof(u8);
+	}
+
 	err = nft_parse_register_store(ctx, tb[NFTA_FIB_DREG], &priv->dreg,
 				       NULL, NFT_DATA_VALUE, len);
 	if (err < 0)
-- 
2.34.1


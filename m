Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C29720CCCA;
	Wed,  5 Mar 2025 10:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741170619; cv=none; b=OPT8WINE0wExvyO5PJmrjPfxdscYfT2ZUeESkiKYbL2xLexeHLlgPMxewhghFO2iXpZeNEvM/pKxbDyYSWVR8a3x+B+6lubNmoEMHPdyMNCZramJwvau+XBVHSt9QUpIluAQi7pnUSQEifOnxOQlUymNahkmZhw97M6y3WOmAP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741170619; c=relaxed/simple;
	bh=Vja1w1A/Wnz062ttT6Bt+MXuQBy3cdFVFTFu9bvZ8Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EB9Q/Z3OdZkkuhHsoWKpd8IvGX7wTvJlXcGMEOkWoXk3qagiu2G5RDc9Z7jB1t1Hq7kApLOPvxtqOq2v3rd8lJ3PJQHt9DiF+75qgiTP2yxVLyhTxkXc8RmyugRmvUzxfEZMadmc3oRPPfXL+YCE3ECZXcsBNX1LQEj6Nug3jVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fMMvThXK; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fMMvThXK"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac21c5d0ea0so34037266b.2;
        Wed, 05 Mar 2025 02:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741170616; x=1741775416; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gr1wMzwLJ3r114jkr+fSh/N13xzOYrfc9OnXbfM4Z7I=;
        b=fMMvThXKnKY2Clv/iR+X5I1glP3mzuMART4wGq7oKZgc7kiLS0uUK2AztnDf7ilLmI
         L62WGXeKl+Qy2GZfypVNOoZPsGjdpcbrgnLRxyl7msqMSlXQ4pqEzJ3cBINxmA+NIjU1
         MRurK67wRDWZ0Q2YD1P3jBM1TyxW+pFAetKiIRUyEQ7jPEVtv1RPti5r8myKU3APTgyC
         Bnrlfv+iAbm9dEDbQPjn0O/MWdDKejaUACfzOxHG9QxkFhvp9LM5uhQ/Y1/ZCUCtSaKf
         s65bKM4xAFRJxJc1a9eXa5Vy9yQFAB1sll7fdXPmtiit9k9VY6bOjn9IkHjXClXWAq8Q
         RUZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741170616; x=1741775416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gr1wMzwLJ3r114jkr+fSh/N13xzOYrfc9OnXbfM4Z7I=;
        b=GtuohwS6GwPxQd/JhyBxxnBfRVa5ehBzGU0lVHRxVmnycD0M6TSuoEjJeoIrin2B5K
         jFjdtIa6gRSy2aj0MFp+TjJhPZXv15530iRQVJZdm3xBSMCLZVPGAEFokjVUdGl0X5Oz
         gplOcCpqYUYkqW2ak6fnvuPAKsEECZ+qmDAXKEKmmPE4BTOr7o9++XMKEfa6xatZr6xZ
         3f9m7g9IkWIiI/R+17lRu/m5OryB0LkTaUZ0FuB7hIpSgEBRQuDK7mkbaJswTWfX9VS3
         EVRUDU3NgM/0nHUUID/Af3qqcLTg/c/qJ+EYjqNsFCowsKlS/XHzrH4MkQ19PRanmd7f
         lWxg==
X-Forwarded-Encrypted: i=1; AJvYcCXCtBzQwS6frq3JQ9myOIM1k3Ok57tpI12RiXS52LH5k7w3RSWy45Codh4xnWpzq4gt4s7XldOjLZfeHs1WN83l@vger.kernel.org, AJvYcCXOtKr20AQEpvGJQj87qvUMWaZBPNjUTanzA4admyLEeTdq6mDt0GrDXGRydY2O6uukgMrSfxA7cl6dmRPUq48=@vger.kernel.org, AJvYcCXUCMK4fGSxnrKQkIdOIB1skwrePN9z/ikcPUKeu084XIkovFxXz9SMeT8MVhUJUFaBsDaP/0030Sw3AAEV@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+gx+P/pAFPaXuvgwLPyck5f0Z4Oaf600PtjVXsyurFz3M2RYh
	KUR/iZOVIb1jVvaj/PNyhMsIFGUNg5N2Aw7qJPmFXfMVFdcx8cRr
X-Gm-Gg: ASbGnctNIQy126LWDY2SRMJ6osDZUJj4/dDbVLVQKo29v21WGkykOkO87banPwr3zaa
	J80SN3ZLLiYWpwVPj0QS6zQFTon0z9LkrzH3P7qUY9ql6B9Aq3vcBrKQUa2kRmG0dTox/lBWDoW
	tQl/Bbt4FCVl7tsac1VNR/muzR2/oispKVRuAafNY+LwgTdjrZWbqnM/XqkfRsR5FW97XYUQVxI
	01gqHvOccdalMQHDGJCtC0n7fN0BLbN3uR9IXL0LDDGsaW4xQEj6D1xA4HGGjw8WRpGFc1baRV+
	kM7Xt4ozxc+K8ce+fmHefzKyfoVjyA5yc+m8Dy4R4NSuVL7+sRLzuK7YgJRdYEIElfNUzY2ihAf
	A8+HmVqnSwepRPrqStxK1JcTg4LQ/pY8iJztquKFybJ7erdEXV0tLNHnNZfwBTQ==
X-Google-Smtp-Source: AGHT+IEs4xR9pD9LIK2nl03zhbpQIh0Gipd81ijJP6mFjuSVofHY5Sl1xp/UlJ1W/hq6f/T3nlJWzg==
X-Received: by 2002:a05:6402:2688:b0:5e4:9348:72e3 with SMTP id 4fb4d7f45d1cf-5e59f47f008mr5076173a12.21.1741170615734;
        Wed, 05 Mar 2025 02:30:15 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1f7161a4esm247154266b.161.2025.03.05.02.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 02:30:15 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v9 nf 10/15] netfilter: nft_flow_offload: Add NFPROTO_BRIDGE to validate
Date: Wed,  5 Mar 2025 11:29:44 +0100
Message-ID: <20250305102949.16370-11-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250305102949.16370-1-ericwouds@gmail.com>
References: <20250305102949.16370-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Need to add NFPROTO_BRIDGE to nft_flow_offload_validate() to support
the bridge-fastpath.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 5ef2f4ba7ab8..323c531c7046 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -421,7 +421,8 @@ static int nft_flow_offload_validate(const struct nft_ctx *ctx,
 
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
-	    ctx->family != NFPROTO_INET)
+	    ctx->family != NFPROTO_INET &&
+	    ctx->family != NFPROTO_BRIDGE)
 		return -EOPNOTSUPP;
 
 	return nft_chain_validate_hooks(ctx->chain, hook_mask);
-- 
2.47.1


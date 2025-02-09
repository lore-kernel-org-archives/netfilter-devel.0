Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5012D1BD9E6;
	Sun,  9 Feb 2025 11:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739099461; cv=none; b=H+k2B+batIOZRlWI33AQcGCwABolh9Kp+5n3rhJqm6xHsZy6X7QTMp0dpQC9VATAMTZti2Luu/TCVQxsEXuND2AjhlyMTRznU3ywyErJ4I+W5S3yGozSitSC7GQUkoFxMrN/Hb6A62jaxU/jIydJKQF1R8sW/7FkwAQGkFiKvVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739099461; c=relaxed/simple;
	bh=Vja1w1A/Wnz062ttT6Bt+MXuQBy3cdFVFTFu9bvZ8Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkBvWYibCbv6bIpNXR+KZNIvYLrh5eLPRaO8qIciPTXCItCi+kxjP5ckdATPji7EKG3X1yKj9i3SkMi0DMm6D8w6NcEQdk1gtLoGT09ND7h8WNytDhF3qxEfr8wnOgWqRnCHEY6HI46jUaTFQWsPUKn1PGX60i7qDnxnCzd5mNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UL2AgNgi; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UL2AgNgi"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ab7800d3939so516119366b.2;
        Sun, 09 Feb 2025 03:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739099458; x=1739704258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gr1wMzwLJ3r114jkr+fSh/N13xzOYrfc9OnXbfM4Z7I=;
        b=UL2AgNgiZ+DZIb4wnWOXQ9HuCAbNfYHcXdSdcMWOtjlpGYRLn+HVK/jbBTG8xjj6j4
         QDu+r4WLI3FH53FahnKQ78zf8b84zXC6AN5b/5f1ZS3T+Vg0vN2ADVZjvWibDRvcXiKv
         VdVYWMrB3iPSPbR5HJJS4+ZidB14vezaNyLOvAphoTwJK4ySrEhjBhC9cxDw9ZbA1Fbq
         BPT0peJl4HLxKYqEURZYuVSgGnpr71FGNj3wyBEqamSoFIFYX1uYl8yWUNB/wQs2LsNx
         y7I53G+M59t/VDiYetmNOc/c+F+KGwATr0Bu25QuZIJhyvm+h+5SUws7Txd8QfIslFUu
         41rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739099458; x=1739704258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gr1wMzwLJ3r114jkr+fSh/N13xzOYrfc9OnXbfM4Z7I=;
        b=ORSCgQwI6o4k80ZKHuBq60/0APsPSUbEPirg13h4mOf9mQ54j9jW039azNLFnC+zgE
         5xrgk3YxMtaQeQxD7LgzR4SG34ZTU2EutXP91Oijn+queq1KhwxTecHMomqQTZpM0tcQ
         VpLsZv8QtJ78X+UIKB9tyhoVtr+OL5mvqPCuSLLz1XYuMKMf5TxALwSdjXp9kjpZlLAB
         S03bsoSyRSs7fNw+/mfGLJWpK6P/YWDEkfTJnfKN2Os80JQOWSfWTenfJiBSzCFSXsiu
         rpf4qPGPh201iLHj+m8gYhpujZZzCTMGlFlwEDyxXMD/AkxhZLkVbpk3qUo+WOaKg4Tf
         e+yA==
X-Forwarded-Encrypted: i=1; AJvYcCWpKRWemBKpKaK/TNBPytcvwjs1X0C21EzX1AVULyIOY3GGL79UJZXVVWWU3SHtdsxsbLyRQDcfUaQycxI=@vger.kernel.org, AJvYcCXw7K3hsyoYdyBWNWG9S3zpSU7FW0C82N5/T3plTpE3hu3cKGRRn6eHPCj4K2GPh9/JRsuwV+k9GB+OPPZOU99D@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/97rxJ9CFWilbgZ9QcMffeTk+J7cH2vtjmL01drWJeYDuRnUq
	Q3LrXqxG0NDDsuudyTG8pNtMVec/E54ImTf35edfViUtlg1ErfnK
X-Gm-Gg: ASbGncshcRMi0UybfdC3FV7QRnaJghFC8fZqYDCb3KUtzM8kpFUjKvI/USLEB3iSBUV
	w1idhHiC7aun7EnwR3aISyGx0zaHutJ39M2tuOaIAA65pLQ0WoMNLtSGvgC78dTPhxJdLGAfeLQ
	S6rHUCrH/AWuxAkWsB+GQ2Rg3ndLfD15uBO0iwCCVG8eWZa/qMSQAQkukpmg/Yw0hFci5Mu9PPb
	kG1Qu05KISZfAOtGeC89gOMRYa5irnC2zv72KhKpug1/RpwN6XO4QtFM3imvMjC1ex5R9L+moMF
	C+qbykG7io7nA7YnJMlx3JSnjxwQK5sVJVep8306S0+2OsPOyGglP5YZxn+1p/+1Qtg/Ll9AJiw
	BKcHdtwVC+QDVCeWOeDGNpeVbT7UWniM1
X-Google-Smtp-Source: AGHT+IFLIZqtdyB586XGL7BZF3ltsD3dhHx63zKrEdsvwLszqHVFUdLBJLGnB6J6lNIv2VbhyBQi/A==
X-Received: by 2002:a17:907:2d91:b0:ab2:b863:b7fa with SMTP id a640c23a62f3a-ab789c1ce64mr946683266b.44.1739099457511;
        Sun, 09 Feb 2025 03:10:57 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab79afc7452sm357516366b.163.2025.02.09.03.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2025 03:10:57 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
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
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
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
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v6 net-next 09/14] netfilter: nft_flow_offload: Add NFPROTO_BRIDGE to validate
Date: Sun,  9 Feb 2025 12:10:29 +0100
Message-ID: <20250209111034.241571-10-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250209111034.241571-1-ericwouds@gmail.com>
References: <20250209111034.241571-1-ericwouds@gmail.com>
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


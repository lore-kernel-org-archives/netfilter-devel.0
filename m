Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1F4215179;
	Tue, 25 Feb 2025 20:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740514599; cv=none; b=hEDu2te2iAVRMP0OfYE7v97xwrHaKw86T9QrR2dczVbhwlBzfv4cLXO1mto6MseMShRrGVDyfssRjKzex8O3lpZMEFGBCVCi34jNbkyXiAZRR1C6hhRdr+37V4XRYtEi60b+eh5lhR6yZP98cZH33d9DpJkdfrrYbFVsTp/uN5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740514599; c=relaxed/simple;
	bh=Vja1w1A/Wnz062ttT6Bt+MXuQBy3cdFVFTFu9bvZ8Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqiePzd1Nal21RwIY9wk59YlHJTb6S4FmJ6sydy/ur24VlkUsflZuKlm4SG1fkXA0KUvuG27/DRHcLnNSNzk13zUoSFO3gRyEnR3fWOhGaTQTZbJWLpSkDHaoooxITk08rUHWgWqIU02pcGWuSTah1DOv4lmGigsjf2iTsLdPUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q+bWoZfW; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q+bWoZfW"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-abb75200275so962807266b.3;
        Tue, 25 Feb 2025 12:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740514596; x=1741119396; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gr1wMzwLJ3r114jkr+fSh/N13xzOYrfc9OnXbfM4Z7I=;
        b=Q+bWoZfWr2sPJocVwfZ4R8UPvc44ySZOu8qRnf750Pn7prhYko/krV5Whumt/GYvjU
         CIo2OjWNgYedtC+YyR0qagKFrymOxHjfXeDBIaiaFXvGkkwG2jiYuGwbOQZV0sw3clhK
         Ki0dJgMGHK7Fw2ZURHn+jbjtb3wTwultzHKekax46qUF+nf2IquyGPWtb+5OgyF3UTVC
         MFeTYV7StGYt7DSu4wesnSFeYXDlRfoNzqhRuyqpSPu3GUEa+eoG8mHh/lr/ofgPU5fb
         GLxsUq3ARZdIqiAeSIaE0EQrbnB3p/+2CTl/xzlA5EGZ6e05Obw1csrvDLRjeDWsKldT
         K71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740514596; x=1741119396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gr1wMzwLJ3r114jkr+fSh/N13xzOYrfc9OnXbfM4Z7I=;
        b=R6UhEW3MeOLULzG2xDpubLUUlK+Z5gJikjWQdD5E8Kr7yJdnU+xpwkgVyGHbJN4nqJ
         Fv5F5xjmA5taaXWLyhjrKLpa2CZsQpYDo2/psiwTzJwZy0YzFWVGvqAmmItyzBiAlbzf
         qGPJ5z//caxNRCwGDQuV4xAkx3YHmK2dx1aO0iTbExDeUqdxg8SJybQXKXQZKmkzzZ+t
         bdKXU/hZprD1JKmdmUNKDoB9T8tb3bFN6EKQmUKISulZtRkK8l94PlU4ijFlfhkwtu0m
         s4gXF1Uh3UvGvA3u3hfvhUffLpOpJRuTfKwhcH+IWLtmSpogxIvIZmigZLe1GTY7+E9q
         ztWA==
X-Forwarded-Encrypted: i=1; AJvYcCUHzWiECqG0XXeKVXh1kA4L4w7Dbm8J6ILd43q/LqbfMxFAxCo3mTwmnQoIQxv+lD/ktPsYIRMO8+F53ms=@vger.kernel.org, AJvYcCW2eNhhh/JpYrOrjJ2JvQSV8CVJ3+nek54mvl27wtp9AFlMjfuei+F4uP0SoWH4A1kd8dxK62tr27UYwVX90J36@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1JdJCjB7mkI4nS3NJPkWaVSTeTVEdbaNEK2pqy7AxVGzDZQyD
	EzHqnWMeD2opp9a9AlFglZ6EAmgMRTniJaZyWmJmI+MvPVhsjd4m
X-Gm-Gg: ASbGncuIejMD0FNcJ1LIM1n/B2ZWCXdxN3WOfMQ3hrRNg7eKqVrYYpx4LLpN5cBd44F
	R7DywkuBTCgINQ3If7tNsLXG6YV/Z+KkrQstWdhpgwp8SxCTI/ukmGYmFnWBVIbjG7aw23nnaq3
	T6TlEypA4D4RNaWdXJiJb1KfOwpBnuF4rYQlmqTKmO+2hU48m52PBsv87iOQd89SmkEbpwJiTMz
	7uQ7tSsiSFBokduTizS4yB9q/iBBeR49SH29Q5j025AIIwV+q/ERNIXYkTU8O5soxFb489AY20q
	GpvEmA4pu3b5nArCFCaGFXdKKSvF0GuedGx0P7XwfIrF4vEgy6YnrTufULr82MUsuOdpTkzsYj7
	ZU1YNuOVMkJfZGKHqSGS6lb/h0j4CloWTPwYIoOb2Wvs=
X-Google-Smtp-Source: AGHT+IFQrPMr/zga3A1PXJqgdsJBXZ3US5klRSnZht6r010E2CvDfRMDZ8BFvHY6Z6/b4s4s1eKUxw==
X-Received: by 2002:a17:906:30c4:b0:abe:ea7e:d1af with SMTP id a640c23a62f3a-abeea7ed9e3mr122695566b.50.1740514595791;
        Tue, 25 Feb 2025 12:16:35 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed201218fsm194319666b.104.2025.02.25.12.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 12:16:35 -0800 (PST)
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
Subject: [PATCH v7 net-next 09/14] netfilter: nft_flow_offload: Add NFPROTO_BRIDGE to validate
Date: Tue, 25 Feb 2025 21:16:11 +0100
Message-ID: <20250225201616.21114-10-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250225201616.21114-1-ericwouds@gmail.com>
References: <20250225201616.21114-1-ericwouds@gmail.com>
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


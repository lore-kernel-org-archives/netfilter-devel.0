Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6072343BD;
	Tue, 10 Dec 2024 09:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733823989; cv=none; b=NOUbrDnJDzWakxm+7bY4hi2FSvj1CbA4WrRxOE0xQfAjiIm27bZVoYbH6uytHnjrSLX3AM97BBcUFUEBN8Sud/g7ZJT8uPqxtcBvvXztCdeyGKlQ5Ic/DMFZE4wAhnfIzA4qzR7tNx3kWy/o38uVpNtQ9fHq4rk6TERC/NUNSGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733823989; c=relaxed/simple;
	bh=dxwgF+fYRk3V5G96b0Vv6EygsfQSyTWaswg0nQK3KaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHZticgRsJZK2pZh0jly2dIEsZ6Z6I5smk8peoJTv3Cla67iYPwz1aRkMmZ2ii860MV865ig0B/OmNWmtr02KW5gOhxcVHSetgizUIp9mnXTNzLFKdCTrwLpxtdjriYgMNRF6Fg7JpBg8iCXNpfWW4HyiCmd6wP9Gq3WVNxLOpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hU/VO5An; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hU/VO5An"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d41848901bso2136224a12.0;
        Tue, 10 Dec 2024 01:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733823986; x=1734428786; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dC3jhTj5HQrnKJfxc0SY/ZIZuFArZD9eLZZ+JbLbIJI=;
        b=hU/VO5AnDVGZElUuymSpcwJvtBKnPXzZV6y4lIZM8ExJu1NWkM8aXclBtZJyOAyAhA
         wkc/akMWhsVgSdozgG+AQctUYWm2OndQ/Jt04Cf+OvasaVs89CFviR3YR0C1IYfEWOBv
         gPTxMx/G8y/kFw6jE+Nw+VR2r7QegUEimMPQM33BjCJH/X2HYb5oweyisSjUTCrXm6uZ
         t0Vt8cnkzn7UBJI8uwCnAurJtZa2CcbZUJggu2z0PnEjhTNfCTo7SaCwSCWazI/f3fHV
         m482WH+OnYG2pHULW1dbbCp3o6zpmlxyZkodCQIroh3ozZV17m/ZFQN//wfgYRBUCZ7z
         MkTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733823986; x=1734428786;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dC3jhTj5HQrnKJfxc0SY/ZIZuFArZD9eLZZ+JbLbIJI=;
        b=j2rppKLW5fo6SasYNk/BMG973pRG5gEeAUB5cgupIIZRsEuPmisSdDR9Qyh1WbSXNQ
         niw3wF3WqJWBq0Z9bzk1IGsQn4PASufMDsZqAZ53SshNUEkN0am5oXZngkxozsAAk7TL
         hMUShOBGq+d+pW9FE6vYMtWpkppwXEcXz6GSV+O4JCPL8w2doWj+h/ChX6SJNsFx9ggK
         0zGT7IV1liaDuFRW4kxoNHRVoHDEAdCn1RqhZEHjyJw/4aEsZk1ZlPyBg6wo+Hv+jLqv
         zwwjlZ6Z7Vuz3ttAjWD0Y37DIqHDdJKDbPhIKwGc1dKdLlhIWETEnzlFjeh3q79zs6WN
         PKTQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3zUU/qCa9khUYjLJCdKhWUqORVFiW8CbwJf79dRNSmLtuSpIHkUpl1z3/DzhypmEtyQtn6Po0XkjMBTkWHCc8@vger.kernel.org, AJvYcCXcfHEjAHAvT0IzussNrlo/jOiTWxXLTFQbUDmXtYravQg9iU7MwJ/gWyz5Re5YhIeAedcAd1Qy3m8MBJo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo2H8sr5GyXDvWsvEoS5bWazzeqSqTrxfh2X+e5CnpjudfX8nx
	DduP19+oc1oYneYyTADiCTRjAsUeAOGItMRPD68qwt7DimNrJk5k
X-Gm-Gg: ASbGncszWrRNfZ+sLIbfeuCggp635BMysnRWa1Ew1cOqwQfd8BPkUHdkB8aXK7zBpR8
	RAjU42I8oh6JwxViOpu87p6qEBcKFXvlrGaky4lAj0gdkMQSZiq6RONpfD5ovYDWxDyCyPJISDc
	G+/xWjBHHHGh6siVFKsF8R3nEkoCXKYE89ig1pqVxf1M4Vr45mzyGyYjeqSovATJ2+5Pxo+Jks1
	ECLLpef5NcbNEf7KOWT6+epOjNFVSuZdiMNdRyZe/oroR+02ag/gr6lQclkzF86Q4tLAm5TiCoH
	dHDWCfxh3PGjt9wirzj/pdrd1Xj0Taxjb7LepNpV8G3VeiAoAnh42nAlTG7lR1UKm1EbJhM=
X-Google-Smtp-Source: AGHT+IHlX9+SooPSE590CjcBy1PCTK3BSd2T3uvELFXCE//zwA+1O6qm8MPbAI3EXqA1jn0vY/Q71w==
X-Received: by 2002:a05:6402:1f8c:b0:5d4:1c66:d783 with SMTP id 4fb4d7f45d1cf-5d41d3dd1c0mr2691977a12.0.1733823986474;
        Tue, 10 Dec 2024 01:46:26 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d14b609e56sm7313936a12.40.2024.12.10.01.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 01:46:25 -0800 (PST)
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
	David Ahern <dsahern@kernel.org>,
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
Subject: [PATCH RFC v3 net-next 08/13] netfilter: nft_flow_offload: Add NFPROTO_BRIDGE to validate
Date: Tue, 10 Dec 2024 10:44:56 +0100
Message-ID: <20241210094501.3069-9-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241210094501.3069-1-ericwouds@gmail.com>
References: <20241210094501.3069-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Need to add NFPROTO_BRIDGE to nft_flow_offload_validate() to support
the bridge-fastpath.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index cdf1771906b8..cce4c5980ed5 100644
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


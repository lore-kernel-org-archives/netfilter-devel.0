Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FE71E9B31;
	Tue,  7 Jan 2025 09:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736240777; cv=none; b=SLx2SlIfj9VSnHSxq33IJ8NPuL3X3g8TFLgmLLuenBb/WuPXhIUtzTsD+QSktvj9wgRvU/gSC7sivQM7H3D+Jq+/DH96GBze38afvQkeZpfzoAuY/P5gJyjKGRCFhu05ZkWp4zgX7JW/AndhgcoZRMcxnvtg8lJAYt+Gw/1SPXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736240777; c=relaxed/simple;
	bh=dxwgF+fYRk3V5G96b0Vv6EygsfQSyTWaswg0nQK3KaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnjtH3UH8XW6zS7mcACLXhXHaM2tUO2VanyPyqBvp9qEPajS2jxWhoPPRzy6zz3ozH3m8j0sVwVCgqaP2h1gEtlY6YW05TuX8x/JqE1VToTt24kDl40KqycUe+a691DQAkAfkZoL6Nx673ptITzoSVH7eYG34jbJR+fE/8KBdo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CX1ePOdk; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CX1ePOdk"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d41848901bso29788239a12.0;
        Tue, 07 Jan 2025 01:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736240773; x=1736845573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dC3jhTj5HQrnKJfxc0SY/ZIZuFArZD9eLZZ+JbLbIJI=;
        b=CX1ePOdkYpSYghZl33edVOGANIZ3BCpJ1XqkLWCNK0/mA+jfwNsDT59CjKo7N5MP17
         47XCGY2RryNtu+Kwqa+zfuKxhY3rkmlmCD7fykIEGMiVXe5k09pOYOVTud0Hy94vorJo
         Etl4RZdPX6QFNwZsGA+Db/sLNRBcRm9spScRThfgr21GXFTnuvXcb56Q5mIlN/Fu9v+A
         nK30kUQ6iVJ5cIjlX8FDlUFr5fgApiCDwdee12Y+pkHFQkJdTN09R3/3PU4zw1zPawYq
         +fW5C+LGN14EzQIkfzUmUFz198T73dwo8bz9cQIm8pqkNJMLbDwOt/R4yXvcilPjbnYg
         A9Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736240773; x=1736845573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dC3jhTj5HQrnKJfxc0SY/ZIZuFArZD9eLZZ+JbLbIJI=;
        b=Stf1FYMT8PYjZOcZZu4H1ee3+Zdcp8CnOJ2IDfqlb6UrxoGds7biRXyv5zfUUCUBd9
         RcugHmi09no9GxdJHLrnjmZ1mq5Hl5IJm5cjA95Wvu8UlmWMDttJlzETGyaLEj+HQF3I
         LzT3q3S/xCEMEU3/HI4gUhf5Gf1Q6BHA6QHJkCoJ5s+kyuvt8oGAWq13tt6598ap4ah4
         Zl7T0sskwrl2TKlUy4l2jPMFuSg/Vq5MlTauiow1tTGtINtO67qR3yQltF3yww04opWC
         SO0UClbsHckIQq4Saq1rF/DSQEN8uzPPb+ctr5GlbAHhgzg0HN7FGAoWwzmMv+eAPU+t
         jI6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUNIDtzZMFE2OTYOmi9LMg4fh2SDzOMHvAVuZKiYma9DRC18loNI6iBiuP9SG8Kk7UrICIF/Mta7c4gHfoZVizO@vger.kernel.org, AJvYcCW0ogQtfmZXui+t6fQDgV8Iu4d2LLGquqhYBXUgCSipZyRSux0jtHkXgkCHBB1Txt63NJBm8UJvMUCKqjQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6rOE1Vlkdbs30cs5B5wFX7K1m0loa2Z/DNSH7rLtYsEhth9Zn
	tF0UqSBdzcPShjTEEu3+qLlHovwTZZjjCZyKA9fEnUzDfmIPwlhw
X-Gm-Gg: ASbGncvYizIdiBwhjNe6adTaes4MiGzDl3KEVbm1vvwiNNw3SzKDsZdyZ16eG4pdR/2
	NsCTIrtLm3Myzygx/NzCJQGjeFd6yc0UgMO6bGl1kwAc5hQvxZi9/vTirLsZ3Yfu9dlqME5ciyZ
	/Q/X+a2hJULjNzFlrqUkjTWmrBZDRaRCtBMOyNWY9TU2LtVDsMxg4cm8ko0BN5qR4Xq9nVdhR4l
	kcFjtOW2ANlkwhv9vLL3FP3lGPX0vBzvJ/xGlWhlYq0Rg7BOopmKWTDE3jWylOCN5NTeOTpRm+1
	LhfiJPfryouKmiZZa/i0w7TCOb4Olu1Elz9meue+I7rG5l8L6LeSvbEIv/e1rWt0EK+F9H7H+Q=
	=
X-Google-Smtp-Source: AGHT+IGPm33fBqlSag/h/JxGM9QbnBBO/F6XspmD/3+zFhonYQ/Vf8Fd540DJY6vH70es8P0d2HC8A==
X-Received: by 2002:a05:6402:1f4f:b0:5d8:8292:5674 with SMTP id 4fb4d7f45d1cf-5d95e8d541dmr2197749a12.7.1736240773221;
        Tue, 07 Jan 2025 01:06:13 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80676f3f9sm24005333a12.23.2025.01.07.01.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 01:06:12 -0800 (PST)
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
Subject: [PATCH v4 net-next 08/13] netfilter: nft_flow_offload: Add NFPROTO_BRIDGE to validate
Date: Tue,  7 Jan 2025 10:05:25 +0100
Message-ID: <20250107090530.5035-9-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250107090530.5035-1-ericwouds@gmail.com>
References: <20250107090530.5035-1-ericwouds@gmail.com>
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


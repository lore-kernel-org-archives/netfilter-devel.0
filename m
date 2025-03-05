Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD9820E022;
	Wed,  5 Mar 2025 10:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741170624; cv=none; b=iDkReC1Io8DHovojaRfFnYVfWX1Is7OgUf3XUx9+h/aOHgfJh5qKndrGKKpSAwHSvQNJt0INZT7sSEuvzR0Br4EySCltvzbLl2+p0kLlNcaPIf95K6feYQqAKGw7Mega9ph+l4lBPtWbq++Qz3L6U7C34wtnSaYbBktj+XjbAa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741170624; c=relaxed/simple;
	bh=8dcYAV0MonhKL6O5x+ptHAAw+fbiOOhKssEKku03mBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxgybxU2x4ypZ2rO8bodqQoF3Ik+RZMUy7Ob8/L0dzqSZLKzdTk3Kbesl6i21OVwH2CQjBF2Xxblu6tsmHhzvoKOkpwI3sMIn7XgUQ0N4CqrcEBCacKDvQ62KlxRoO73ohsx/wMM/wFnTa2UhHz8XS+kJ6CJ5ODiZysc09bl6lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MEYOemkm; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MEYOemkm"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5e5b572e45cso305207a12.0;
        Wed, 05 Mar 2025 02:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741170618; x=1741775418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVAkTZii1Gy4XRugZsnKaWDIV+1UdUIxS1E1wVQkwnU=;
        b=MEYOemkm1ju+5EgUW4aopcsBTecQI1DNdLhwz8vift6V+g0R8180S9iCUEpeEzqYhx
         GNM2oeSmpZCNYsWQaa2KtzpxDMuhsJUE+98NWiNYyst0vOhKv7JvJ0tAuSqW/r4ObpKt
         muDBiYYY3ry86DI0e68RCrDzVePyWaoAxZONUW4bUm4hD1hIpCuacqbG89XVhC68++na
         pnc39o9EzDosmXnRrzcR+9D97PM/qwgIwat6jAw9bM7sTfB8VPyvIh5BwbTrXaCMnDUS
         puaiqgHDKET4cqjx5bHOG0jD974gA3qPKtNs3vfwQbo0to3cQKTgnJStIY8ic7QNk3xp
         HrtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741170618; x=1741775418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BVAkTZii1Gy4XRugZsnKaWDIV+1UdUIxS1E1wVQkwnU=;
        b=peWeB/9UYpQPu3LVSFYiyI702rESVTld8rkE7phuQAF2hyutG4uUZgUZnsIpm5ExXh
         T+XzHWS4OGzMvhpf1cQ9uYWkjBHO2rnTpBq5NLS8Z4b/8nzrzyiApnu42K1jYZtB/azc
         jFUx1sH+Nvo0tzKkuPxL0B2hRZSVvcrcdNrjjP4PMHrQl+YTUjHNG5KLbHOhr5NJ+S7d
         le58XIyZf/YRgHTgigU2Sp0XZVQI6BsSkrGs5XZeBuAgZmjdAajo4fI4RCcXmtWw0Q2U
         usrpZGRSOgM2VMEGLtUg65iq4NFgMcECW9K8eBFT0iFvzT6RkhS0xq+UBC3sJWntqZUF
         1tSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtTv3PF9+CW6iqh9xtp9napNDGbNvG6XS7BSXVOyIMyWmaTDlyLRwIJk1efRX27NH3NRHRJbGuROLxbi5p@vger.kernel.org, AJvYcCWkkgB9kpnfaCDu1tJKiS8KAVsfkZNvQkmjBbC5hRJWMleavLyU8Pw8+S8MxxR8L6nZJymBOu6WGL7taFIPli8=@vger.kernel.org, AJvYcCXsv07V/83ymdhWLng/KK8fdPb/JXw3hM7UhexMIZx0cjgz+SDTwhu3s1LcRiry53vBLNQWv0WR4N5Q21REBcdO@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo16O8u+UzUwp0jZdriZFGyj02haDIuNaMMBLEiOtbBFruC0Mi
	38sw0ZQuhVCkUifgEGvMrlg6ms4anytN4fsy9DNvI/CxXOYyviWk
X-Gm-Gg: ASbGnctytxjPRbuvr2udiWPxHf2X63GJFnUY99iWHVUo01OXUnGTmYmG2GuMBCTLjqX
	WBPUVdZWAtL/+iUKySYJjzrT9Fn8N2oBlhsiER4mV9jyOYQoESDoKYmQrD8ZwsVZuvQpmfmJZx/
	fxW/vDQ1T3qJa6MkYMpMIrmWCJKKxGgu/XKiPhWuIichmUpP+fMvhzo/4i/4PLH2d5F0dM6Jwu9
	fdOMTCBomTZvxaMfN/B5XIEsYYpemXGTdUyHDXhNWniNLgOTcclr2gK2kvRuVxivsSI41OlcGZM
	Bvhm69m7OxFL3Q6JU/1Oi65oLZ8rJpAlfMECtR9Lav8U5H8OTCkwfw5ECTAPfDri2ga0FC07DaU
	gAUT3gokHATsVP0dQQHHvjwueWy0yLkHIS2fTyjjDJdrWkJhmCq/lNraCceRYdQ==
X-Google-Smtp-Source: AGHT+IH76j7PuSAp246zNAO/9bTEHz/TOOLWKA15shLvAnk2YElCcj8yD7y6QikO3QGYtioJiV2+DA==
X-Received: by 2002:a17:907:6e8f:b0:abf:663b:22c2 with SMTP id a640c23a62f3a-ac20db005edmr280954166b.51.1741170618037;
        Wed, 05 Mar 2025 02:30:18 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1f7161a4esm247154266b.161.2025.03.05.02.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 02:30:17 -0800 (PST)
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
Subject: [PATCH v9 nf 12/15] netfilter: nft_flow_offload: No ingress_vlan forward info for dsa user port
Date: Wed,  5 Mar 2025 11:29:46 +0100
Message-ID: <20250305102949.16370-13-ericwouds@gmail.com>
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

The bitfield info->ingress_vlans and corresponding vlan encap are used for
a switchdev user port. However, they should not be set for a dsa user port.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index b9e6d9e6df66..c95fad495460 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -116,6 +116,11 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				break;
 			if (path->type == DEV_PATH_DSA) {
 				i = stack->num_paths;
+				if (!info->num_encaps ||
+				    !(info->ingress_vlans & BIT(info->num_encaps - 1)))
+					break;
+				info->num_encaps--;
+				info->ingress_vlans &= ~BIT(info->num_encaps - 1);
 				break;
 			}
 			if (path->type == DEV_PATH_MTK_WDMA) {
-- 
2.47.1


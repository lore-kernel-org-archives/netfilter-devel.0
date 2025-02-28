Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470C027EC83;
	Fri, 28 Feb 2025 20:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740773797; cv=none; b=qU32iIdvGJGW9fje4TFk4gvKD/fSpih6WdbQpXl6dFRA3JEtp0PzUAZEbnBRkfBoeDZV3x9w6fIt8VywSKlbFZSEGENpjkakySQWQKbA3S6gl4CVuWjm2bmB7TSvwEjXETdAoTfb4+TRyKtL05RViskJZv0zayWqL3Z4RCRTz34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740773797; c=relaxed/simple;
	bh=8dcYAV0MonhKL6O5x+ptHAAw+fbiOOhKssEKku03mBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giuSs9Mlg85F7aRZOIZKFuKhBW3Dls8bwGnp2OrZ39Vzrovn/Mhmi7HMhiaCbcOQwGyLMwBpUa3BD+njzRWMQNAup8ol6tsTMlvQUKP1QXSamZqwjfWmI6XWEM+NgUGuGDBMr/kzFhb82yoLGjHFUqzbaaL2AfuocK+DdAvyxUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=grRfNmvh; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="grRfNmvh"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-abf4b376f2fso37979766b.3;
        Fri, 28 Feb 2025 12:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740773793; x=1741378593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVAkTZii1Gy4XRugZsnKaWDIV+1UdUIxS1E1wVQkwnU=;
        b=grRfNmvhKZ2HxcKyGVo5hwlInREQ5IFu803p4LVSrCan3zMPJMyvVvWIVSMcbvTS7O
         5jCVNA0lwm6N2Tm6humEJo14Rh+W5MerS6TTOMPihw8cDT0xXcLJOCfhd+raKkwiS73s
         plG8o+6i3VC0H08rAEQMC5+2NoIx2WmfnwKvKT7HEI3EO/THLey+CFv8KuOz7LFxsk1s
         K7EheSPL6MiuXvuffp8pDL3Zca6ucu2t3qnj8ctbspwgJeip3gr6nhGK1rUYEai6k98e
         GJ7on9X3CGQintPpeG6WsTbhBiHbsMcQtK4AThJhJfV7raOhQQn13laIW7CzP6mmgoYF
         26xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740773793; x=1741378593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BVAkTZii1Gy4XRugZsnKaWDIV+1UdUIxS1E1wVQkwnU=;
        b=NlyWIWB6mvDyHNT35SraHS0uOdg+JBeChHetUpkKxM1Rhz9Nd30BXoONNpAk8trFfZ
         MRWqpR23HRF7Z8nUApBszPh6JNa/nEkloto+ZjqGNq2oszAXWsvixy6KuyMvxjhyilBw
         w562KnDy2RAcjOmCxFQF3FnPXvJs3E8HkK4uwAF4tIlIPLJgLTvXFlJqxTMBHDzL6lSy
         PcxRycvcGIKdIftoKlCpvsdj19SzpHk8/aAy/IxiiK48chjvWD+8A7fvxYpVTHbe/qO/
         SC96JxX29bFqi4cfg00JnfUGbfe8xLFrIBTWY856LZLBZxa48/vM52YtGKieEO430aSZ
         MAhg==
X-Forwarded-Encrypted: i=1; AJvYcCUCXALCKgweMHtdcIpTPhVqRTxHsJS8it0INqO0G+Yh4XeXTqOVq0R+iFJa9nkb1LbWK13njSD2YJzubxF7Tzs=@vger.kernel.org, AJvYcCWi+i3x2yVeBrVmscsaO6SsCjL7eA9Efa4wjH3db1CwNOaBK5OLVX8gd4aqqmP736CwdmLZlGyTOtyUUfbc@vger.kernel.org, AJvYcCXBlK51BwTLNnDebEr566Zk6D2hueRwdVb2iaSz5o1Z0G32l4MvBVDFZMK7T/ivx9WJfvt6myZtwGg1j0eUvaP/@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+7dGBhijksDmptrGBSXUesddxajePyE4oWMIs4fZhuPFsjGCU
	mwo4Zm6pjBrmJl7i9xUm1s6GfaH+oEMpMTlhwyjW0WCb6IHDqlgh
X-Gm-Gg: ASbGncs71wSwaE3JjJii/jTVXa4J8bQQGhoIj2bJ5iAFcakv3+ciWZAzN+B+C3a3xEw
	BPEKeq4teX1emugjg6BI36UjfdvUjDegjjDOTyvwP4iaspK/5ZYiPrwVOi+8/5xwCQtJqzOar0a
	7cqEPOoVlPhXbf+Via5q1OFBWna8A1rIArMr0N0Hw1OzavCm8eR8cVCnAnh7nsfKmWDjiWXEJ3x
	Pxt8srxb3KcuuKXSGBa7tSC52/OvtIkBK4xnSGhqy46akpdu/ZsacaDr3eO3rb6Bu4RDuADu3Kh
	t3lGmFQuuLoRCbssh4rklEZtomdlu27e0IL/ON9tZnFv9dIy7gyfPDSMxOBrUxBGoM66r09kc2r
	uezHIIxYtKnCZss+EGr2vvw/1hNO+f0ZxwMszp8tbBWmtWELOj+Nt8beGUEnhHQ==
X-Google-Smtp-Source: AGHT+IHTNHcim7XN7hH9c7Sh5FIEX168d0fQlddgi57248KaGuR3JKO3W8QVJ0D+qGDqKD6MfYoZMQ==
X-Received: by 2002:a17:907:6d04:b0:abc:29e3:f453 with SMTP id a640c23a62f3a-abf261f2fd0mr480274566b.33.1740773793400;
        Fri, 28 Feb 2025 12:16:33 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c755c66sm340812666b.136.2025.02.28.12.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 12:16:32 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
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
Subject: [PATCH v8 net-next 12/15] netfilter: nft_flow_offload: No ingress_vlan forward info for dsa user port
Date: Fri, 28 Feb 2025 21:15:30 +0100
Message-ID: <20250228201533.23836-13-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250228201533.23836-1-ericwouds@gmail.com>
References: <20250228201533.23836-1-ericwouds@gmail.com>
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


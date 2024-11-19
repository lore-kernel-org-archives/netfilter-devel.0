Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4470C1C57AD;
	Tue, 19 Nov 2024 10:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732011568; cv=none; b=QEnuydzonCrbWreFAhOEXvp03Y0fz8aPmBIQ3KosXatlOtgryFZBiaYPUoE+xqyZz4I7GB/gMcfF+487BqDq9RUhGZiSdN18JKRS574DRvWoBL+Hjz7A1Xl30TyCUyPQ4u/hki58pFBtNJPIObrRoe4jmz6INVHjje1p7BCjbNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732011568; c=relaxed/simple;
	bh=KS/BSXKwODiNlM345SD1MVSJzHQruZ4MhHPY3AhQs7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvylM0Urp/b1003nPAB5I7OkuTdERsGMyHVJ6O0nsezd2IdeVmHv0ZppUOLBav24TUe+qwM2HZILosr7bOG20/tA6tJUPVFudQgd7KQhmNJGaLGkW+V0X2mxcSo6aRBiyh8M0EzlEklmWktdaduknEzqm3KPiUO6LF6xBzwawys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bwSdhvbA; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bwSdhvbA"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2fb4af0b6beso42481771fa.3;
        Tue, 19 Nov 2024 02:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732011565; x=1732616365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3IFIJoTYk6YKRTRNHwxftMTYmZfYo4cB7iVfLaoFmHE=;
        b=bwSdhvbAOBVz1Z4od4PC1RHthKX0VofA2W3HVQoSTn6R+yfreHNuyUbE0g3FvGVyRV
         MWMaFVLTdpXKplCqldy9muVoEBSFNW5FeSuA1pjncTGKlKXh6NIXpo03yjAp8JDInhcy
         XdOUApEGnW1c0ik7MKH2aE43MTkW5cZjq2xC1mbAPZ98CXqT2Md9Ckr/NF/bl89zZyyo
         HlXtsN1JoL1WJAkZ/1lFxoT/42gmnEIywThzF+NPLNgt/UK0yjimO3eUU8XN2SBEenR3
         BFZoLoJNRqGrEhKkMnzuVAsRdJ8wcXwICVH6kOYGUWafKHrZbLN9ZMjvZ/eeyXLd8WG1
         4VnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732011565; x=1732616365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3IFIJoTYk6YKRTRNHwxftMTYmZfYo4cB7iVfLaoFmHE=;
        b=QPHRmxmIhOHI2OXXtL6xAnaiAFicaiczF4Ux1TyrYco+5BPoSdd+su7E+Lc/RIMvI2
         WSFtlgFd56GWCHILCqdX8DSXHAgA7A69tcDD4dRAQe1Bz26kSHFK+g/vdqWkuZuiUA00
         P8wrRHxKodAjvwNdLoOJZhp/CkFuYHvps1UTh9Cgn3U9OyLpd5OWJHTiSpAAjKXBz9WH
         9YBKMpdNLCgWaa7QKHJ3JrSz5baUqOHydPpcJWlBD0A5qyTIr2jPrTh53sglLMmS071S
         RniNY9F2UmdxckJs4cAUDOy3DDZ0YWv5h04be0Mva3KUDP0GAsxkRlArLa0X6/1drJHj
         Qi0w==
X-Forwarded-Encrypted: i=1; AJvYcCUaPJpnEqKIMMmgWH6jOBVVHmBFn/iobJo2i5yb4zfgpW93oCyz9hCg61ibwXymqld/8cHlJTR+nj8k49M=@vger.kernel.org, AJvYcCX+McHztXOM3W2DFhfesnAwQEvW5XTXdHU9fhQq+lWqh2/4du1hQ9igVNtqOH0Rg91x8V0+AMWXjsYhonPsh4Ga@vger.kernel.org
X-Gm-Message-State: AOJu0YxLhz5rRZMQCA1yRlQClSEtPR4FH2QgF+VmtDZKv2k70VY0jke8
	IoAFeO2/uE9DnvBu+Dv4MRUSZieaovW3MaZf6gI96Q6ymiaYuCmg
X-Google-Smtp-Source: AGHT+IHnkAmZBG6E9wO/q7BJvCC5UomYmpRer3uAt1HmEjIcUorcDjARLDEPuztshHFwg7HC5D+dGA==
X-Received: by 2002:a05:6512:32c9:b0:52e:fa5f:b6a7 with SMTP id 2adb3069b0e04-53dab29e907mr9290473e87.13.1732011565255;
        Tue, 19 Nov 2024 02:19:25 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e081574sm634875566b.179.2024.11.19.02.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 02:19:24 -0800 (PST)
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
Subject: [PATCH RFC v2 net-next 05/14] bridge: br_fill_forward_path add port to port
Date: Tue, 19 Nov 2024 11:18:57 +0100
Message-ID: <20241119101906.862680-6-ericwouds@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241119101906.862680-1-ericwouds@gmail.com>
References: <20241119101906.862680-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If handed a bridge port, use the bridge master to fill the forward path.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/bridge/br_device.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 0ab4613aa07a..c7646afc8b96 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -383,16 +383,25 @@ static int br_del_slave(struct net_device *dev, struct net_device *slave_dev)
 static int br_fill_forward_path(struct net_device_path_ctx *ctx,
 				struct net_device_path *path)
 {
+	struct net_bridge_port *src, *dst;
 	struct net_bridge_fdb_entry *f;
-	struct net_bridge_port *dst;
 	struct net_bridge *br;
 
-	if (netif_is_bridge_port(ctx->dev))
-		return -1;
+	if (netif_is_bridge_port(ctx->dev)) {
+		struct net_device *br_dev;
+
+		br_dev = netdev_master_upper_dev_get_rcu((struct net_device *)ctx->dev);
+		if (!br_dev)
+			return -1;
 
-	br = netdev_priv(ctx->dev);
+		src = br_port_get_rcu(ctx->dev);
+		br = netdev_priv(br_dev);
+	} else {
+		src = NULL;
+		br = netdev_priv(ctx->dev);
+	}
 
-	br_vlan_fill_forward_path_pvid(br, ctx, path);
+	br_vlan_fill_forward_path_pvid(br, src, ctx, path);
 
 	f = br_fdb_find_rcu(br, ctx->daddr, path->bridge.vlan_id);
 	if (!f)
-- 
2.45.2


Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DEB1C8788;
	Tue, 19 Nov 2024 10:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732011571; cv=none; b=kbp40kMGaCq1QmL3bvl8teNSsJb/pVsaSEJZwxd+2WJjt5KlhB6XZk+3QZr4yJt+qmmJ9y4bcRX+ILaOASE5YCcZ4/uLsJUiB1FFPlPXeU/Mp1jqPvknR5H1z86e8f2rVK4qf1QwTqdfZVfa2Cf8z72vyiSjQntaSj8Gn8LtRV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732011571; c=relaxed/simple;
	bh=hGsEEgBwVWVwF5UUBIOEi5WjCie3Q/gi9JKsnhC1X8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpJ+BSFNcJFyyBHsoskF1l+IrP9+eMXu6wJfV7BxaT33SN+ARmBXX1AUuJkJI1bHWBbu5qlupyhPJPa5PAwvphnD5TyStP1iuAlFoVYWEhUMbani07fWuoMsPermMj0fp0qIpMdG2v03c7D13Ft3Dz8OGQnskp2KxetVtqPj9/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k26TVJxM; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k26TVJxM"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a9ed0ec0e92so428322166b.0;
        Tue, 19 Nov 2024 02:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732011568; x=1732616368; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pdMZzUqlItAKYCipC8R7CKRW4bj0To7qOhyuRvVgeD0=;
        b=k26TVJxMPo9ZClnhJPAOrtPZ+FxuVwFiERkyuo9dFjoYWEHVU36MqI52iQ52dJ5Vg6
         1arS03Yt7KJXFq2/9q3fLmn8ZqD3RZ0lkSMHgsokm+SyuEvGKHH8r2Djq1ddASr+zRTy
         YCz4l/yWAUbgunpE99o2upVRASHILyquGWYU+Ln3hykBSR0uqFUwrhF1/OOagUiknnyf
         DhrD/HVWEh8N9c/h7qrzIBKueXqi9VNDFqGcrRvpgol3HeEth+CyCCJ2PxoldeCNekxj
         WPALGD58GYGQ0bjA2jZrpgZLJczrkPeNe1MWleOmMfq1QEB98ZwAZ7QQaT9uvcf0dHCw
         nkyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732011568; x=1732616368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pdMZzUqlItAKYCipC8R7CKRW4bj0To7qOhyuRvVgeD0=;
        b=r1didY5WTsYF/nWKwlk7h8mxniIkVTsT8SWPbWy5dImmyIFSmLozUxV7gXAx6xnFXp
         /S2Rka32mLvNQX3OAOfDQyTxPY0Pgzf5SQkL/BEFtNdSLN0NGYo+4JhAJJaPy65r6fFf
         pbvPqC6V9G9rYxOpO1w1gExMF4SOL1cpjeuOxzll6BVBLSUYjFNcW/+jCYtJyDvTzk73
         gnzXVdtjd29ORmiiujUMVMokUOnxERHeNaKrHErlTzdDOY2FeDX76Z8E4/hB34ttxiwf
         WnYDQWnw6ofvdNiEQ02+tk9tH5ynm+oFW9MFrSCGviQ0x99vKN2oz/4CGqYgwRyWmix0
         WVqA==
X-Forwarded-Encrypted: i=1; AJvYcCV5VuYySnED1Vq3J1YRO6FmPHANJzewrzxwQiaq2tEuacFcGpUJiKnbR8dNdSF6M5sCt/Fa0x0JwRq1Abt9aX+I@vger.kernel.org, AJvYcCW7oJD8TELvcJnfmMlfEDT6do5YCX/9iP4t91dnHK7Ty8qEV71meKCQH+qOO6yVglRU12uvRPfXw7X2MJ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVkThk3hFTh3IjoJjtkxrPFU2MhWINMZVMctsZtBQtDgQcTdwJ
	ftdYFyxnD/CBUVLgQHFXQ94z/Ir/PJDaKEpX61RXRJK7qHkDTkz+
X-Google-Smtp-Source: AGHT+IE5L4vgeqmlwvDR/7799c7w2L3XGWClbNm8n2h6VzOovB3/FqcYwFKbh7Ag4naigGnLrOKLJg==
X-Received: by 2002:a17:907:7f88:b0:a9a:7f84:93e3 with SMTP id a640c23a62f3a-aa48341a1c8mr1497903766b.14.1732011567950;
        Tue, 19 Nov 2024 02:19:27 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e081574sm634875566b.179.2024.11.19.02.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 02:19:27 -0800 (PST)
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
Subject: [PATCH RFC v2 net-next 07/14] netfilter :nf_flow_table_offload: Add nf_flow_rule_bridge()
Date: Tue, 19 Nov 2024 11:18:59 +0100
Message-ID: <20241119101906.862680-8-ericwouds@gmail.com>
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

Add nf_flow_rule_bridge().

It only calls the common rule and adds the redirect.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/net/netfilter/nf_flow_table.h |  3 +++
 net/netfilter/nf_flow_table_offload.c | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index b63d53bb9dd6..568019a3898a 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -341,6 +341,9 @@ void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
 				enum flow_block_command cmd);
+int nf_flow_rule_bridge(struct net *net, struct flow_offload *flow,
+			enum flow_offload_tuple_dir dir,
+			struct nf_flow_rule *flow_rule);
 int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index e06bc36f49fe..5543ce03a196 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -679,6 +679,19 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 	return 0;
 }
 
+int nf_flow_rule_bridge(struct net *net, struct flow_offload *flow,
+			enum flow_offload_tuple_dir dir,
+			struct nf_flow_rule *flow_rule)
+{
+	if (nf_flow_rule_route_common(net, flow, dir, flow_rule) < 0)
+		return -1;
+
+	flow_offload_redirect(net, flow, dir, flow_rule);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_flow_rule_bridge);
+
 int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule)
-- 
2.45.2


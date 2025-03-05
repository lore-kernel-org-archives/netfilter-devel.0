Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68ECE20B202;
	Wed,  5 Mar 2025 10:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741170618; cv=none; b=ajiVZ8nMaDJsBjm7UIlRaMvon7bo5xhImn3ZGC7FFrRImwNJ9yrlVQOM7iDPgfjRns7AU3MgNwHBA24Thlpa8BcE3rxV79FSbBYmYyt7dYaCRQSyIRRYUBCVKh0+UJvR1xH20GxQmYi2A1wAbIqkCECWqfxl4kVp1CJHw9TkEtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741170618; c=relaxed/simple;
	bh=p1IsKiAxwq12F2MM7ABxyO6mLj6RlYFe8Yg33MCLfXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cF8vJtIwdYtgvqv1eiFR2Kyg/OEuHBvUYIS3CmP4z2tmq78fQKs2fBgClImGDwvN+tbLcht2e32ttnJAmWucXVV3xZJXUbfCqHnKuCWHFgr62qOUwtaEwbpL5teKLj05VUhwVCT88FXQQ9sT+mnd6p6oooE8/bUgGRWzmWSyjHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VLsL4snA; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VLsL4snA"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5e058ca6806so10953166a12.3;
        Wed, 05 Mar 2025 02:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741170613; x=1741775413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAJ1+kbz8lZ4YwPg+OV3VOfAm0Jd01XhEIX1QeYwh3U=;
        b=VLsL4snANM+SFravaItV2e9WEjP7wxKChRvyYTZ48DWCM2crmWxTiUej6pD2ys7BaY
         6evDDLkt+OFhRoBR5zJVm1NhtJwRetV78N+Af3IecWHYv8yGLDgLJMb8aImtSUsygB8S
         S/LJVNlQBP5wXMzWZndtjUnm9N1L3YsLfXa1zjqD3lisEU4vYHfNMYY/2zynnl+2TyIc
         Uj9s2XnhtIFhg8FhlpkahhGiYmObH6KskzjrcYP5VnBcXl/x9ypeA2HkPxMCG9yVhb/U
         OGh1H06ILAaECs5JQRu3pTkMaQ2qOc9acw+WZtuIZFZPBRSJ8IQtbsLPfXo8PL5XYykh
         wDgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741170613; x=1741775413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MAJ1+kbz8lZ4YwPg+OV3VOfAm0Jd01XhEIX1QeYwh3U=;
        b=N6p7emeDOf1mFxUNkiFvwRYxrh1/vU+zKnfth0eFX3WMGuEGFZYJyIK5Iiil666ohO
         1JM2ln+qgNRxRi8sZnpChZmsCmn/tRU+bDw6MItziNAWRsBxA34eKHWlXorzYvA2+BDL
         Sc0rXR1oRppblib5jYbuQ10xFEQNfnBENmgjftjuCOjrnqSGUwO5jdcRgwqgIpPB4CyN
         I26z+uyuV7cyoJ7muIiIowY9g1luD28tM3W/K+0eJHGSxHIAG8oD6gp6nbc4k60wWSor
         ZUJ5LvUNU3E9EGrEblIu2SZlZPizIgs6kT7+w5WgExJDswMS48WR4GOwXkqIfzrvA9hd
         HBUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMLzSAcLc7FW8ZG/8+8YEKKFfJSzrufrCvIbg7sDb5reP+3evJZf0ah/fYl0fT5wiaemT+7ENiaoVNifT/VZ10@vger.kernel.org, AJvYcCWStb6dVXCcIbfl0wHs+DiT0SUM7HNqSM69ohiUFWyeMazT5dTvaHGNChfqJyXDFD7m7GPmkWHHjm9ca6tc@vger.kernel.org, AJvYcCWVPzb81S0RlG0MgmprBm1qvx6HBmcCnbzdctyopc6sSWmIo93gapY04/J4/pfVV3J1BN/cg9hdHnYHbQy250c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiNUxM4LOEKQod2WTRw4tvW3xJIPj9YKLAhGsAlOXJV7kBP88N
	bO2yImJJeDpeNoYshcG4iSnCj6bBY5xgUeIQxN/crv8RQdA6y6BY
X-Gm-Gg: ASbGnct/xhQ1R4hqiAuZfMy9RpEniHG9O00uCitxCBiLTcyTlopliP6sM0sOQ4O8/Cr
	cxlje9xsxsu3Kfqp/JAg1TLhk+BM0gKl/IEeU/c4A7oIBXFpdrNQ+fXWgAuc1l4+8hww9k6GfBy
	KR6bg7HlnmN5RTEJ6Hb4BBD3sKDCgRtsspMPYtrcJl7vwT1fXUvbVMjMUO0enHBelR39oR2BpqA
	GEHl3DgH3ZBLSJcIsuS4JrYFOo5tKYKK0rqHsT67aVkuoitFyj2MQaUzly504F3Xeqg9liXekN9
	v9xCe3jv1kPet28QtyswxcKrsJZ4LODzc8psyGKJhXSs5gW5VgiFrLqizbZWozsJmSiXPUW+fJl
	5XdU5+6tomDCVDqx9IAVrT5noqejJIHT3A9NVp0t7w6eBde0RVG/Kt3/atpRCZg==
X-Google-Smtp-Source: AGHT+IHkGwcjTfVbXx6eVRlSW1bPJWg7ABfB6LE3pcI1ePV03v0+a0Kiykk4HhykJH2czK6vrMyHQg==
X-Received: by 2002:a17:907:8b9a:b0:ac2:c1e:dff0 with SMTP id a640c23a62f3a-ac20dac2643mr219805866b.19.1741170613297;
        Wed, 05 Mar 2025 02:30:13 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1f7161a4esm247154266b.161.2025.03.05.02.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 02:30:12 -0800 (PST)
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
Subject: [PATCH v9 nf 08/15] netfilter :nf_flow_table_offload: Add nf_flow_rule_bridge()
Date: Wed,  5 Mar 2025 11:29:42 +0100
Message-ID: <20250305102949.16370-9-ericwouds@gmail.com>
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

Add nf_flow_rule_bridge().

It only calls the common rule and adds the redirect.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/net/netfilter/nf_flow_table.h |  3 +++
 net/netfilter/nf_flow_table_offload.c | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 4ab32fb61865..a7f5d6166088 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -340,6 +340,9 @@ void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
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
index d8f7bfd60ac6..3cc30ebfa6ff 100644
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
2.47.1


Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB75A27E1CE;
	Fri, 28 Feb 2025 20:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740773795; cv=none; b=Pa3MqoQzL2LnyzxGJRNRA0Ozgkxj74qgCgNW4IHkZ1gwhkFN1ys30d40WXICbB2qSA4JEDwadnzpzRqyYo0qZzvvxtW1gax3YEtiZat33VX5w30a6vG5BLL5d+OMW8S18jkzwOu58RIlutPW3aoe7KCV8KXyHgvewFDF1Z99rgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740773795; c=relaxed/simple;
	bh=Xf5mlATXYp8EYoXU9a3w+XGI157o2p4WZAmB5ikh7tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRzRmWR/k3azNAgq+O8UjTSoXgz09p8g7xoh1stBAKqAwJp18RiuXm249LzUZGOtta0yNAb+wBUcJ4HjpZ71CUkaileN3z4HMiUW7mK59kLEXFjfjVNeRMsoV6vLoukjETYs2iJQ8tDZtPSdzR37fNhKj/ipgsHDFWOZYGm/XtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kLXUD86v; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kLXUD86v"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5e0573a84fcso3627556a12.2;
        Fri, 28 Feb 2025 12:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740773792; x=1741378592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mNvAyhAv6GepxNEYkCskllQBVi38mrCeZ4SsbbR7WSY=;
        b=kLXUD86v2yHsrYgUq36gFRlzTev9NbfexU5LtdR72qFpA8vpQBql7vql+nPt7PZm7T
         A2ltBJMw2m4DcFw1j5JjHA0oA4h4iKvtfYhgPV2FCO3K+y7bFba7wZIScT4dMtwoJWB+
         2i34Q5gJmZqE8mTNe338kITHOUw59gru3vj7CGvFXuBpKPjdKPN8Z3wXeJxivYc1ZHRs
         zT+69cgbCsEORPW0I4Lh39mrYzNq+bxQcZjCR2qkmZ3QEjV4poNsWSTgScy4wJ+sFx4g
         159r36nr2GBOS5YTAFIjzA8imGO5NeXDEOzO5VPLXOSZWoQFHakpMcCQVBSjlREHfzAg
         S6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740773792; x=1741378592;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mNvAyhAv6GepxNEYkCskllQBVi38mrCeZ4SsbbR7WSY=;
        b=dnY25SihqG9W4FgJwFY/OpIAFUvn7y7GHVoR5OqXNh6EHgjPEh6wHhupumPY6Keu88
         cex5BSCIae8sed4VxRWreqHQIzVOmItMZXgg3aqa8v+738i1KWMuGrQ3EkItv/7RbX+U
         eXs4//S3ggdMZ61d+OeAzRcyrkRcNJOgkxHZUGPIFk33olZ/shhE7BA1aQ5c3LSXWjOQ
         tfD1l+v+nIkugfklcUXDhaYKFfshMQNGWPP+5ItqEJtWGoNtugZo64SetIAjWtva1D//
         uQpX528mWzj5VrVXAuXF5CdO5ERGlmmnc9AZjI5BH76KtoM8emWDvBQN40scsIK8T2nr
         LeSA==
X-Forwarded-Encrypted: i=1; AJvYcCVKtv6l9tKkTti3MtmltzMzFQ9+u/ZHJZ9/ZcgvwGYzWVtdIBESNpe+mwjIZZh2mtzFljZCAN8VJfrNkmLdd8I=@vger.kernel.org, AJvYcCX+ECcc5hhv4d8hnJsWlWQfw5KF96Jvbd3a5cyJeAp6G6YekfRA71ffFyqfkEpugdGReL71LltDPci72BA0@vger.kernel.org, AJvYcCXmqSKSkNDg+C0qQfAepHyXn3EQ5glmQYilnl41dnXv2UjAgT6RUy0+nQgGxJT60eweKldgvgnnl4lD+giFJdPY@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9uL9xwbtlN2s+/jHyqYkI8mugVVWr5oEfbVcKLRcxo/tqgD+S
	ENNH4ysBnXIt2rqSgEJr2IMaM12y66jbej8iOHmfOlkiSG4WMlOG
X-Gm-Gg: ASbGncsDCs2x9NkYuskNmaHeB3taOSMySxt3yotRVJPaAPccqC6QygMPt6z5Y5VUNC8
	FHfYLvn8M1qR/Vf8uWJpoSuKboGaDRUicNJy7liVyU0L8aBMSHHAW4G9O6IS9PXgPRcFslDHBZs
	LCghV6Pjb0WhWuE+mYhULtJULe7NVEYWZ3zB3E1DcAT09+mlR9geyUU0h7ZArqRcyF8xe5QFl9Z
	7SXblNIs4I3RlTIxvKjmFwu7da1CZWd3XQDpSo6+vH46bcq5fHPiojbItw/Jgv2AocP9FNL0UP1
	Jwe6vfDkzSt++NkRQVJArwqg/rfogEgVBYMpHKDAc3CvM+k34cVIDx79Q0i0iK2NPTby1u6RcT5
	RFj3++yC6gBu1NoejZKxbbklW5QYYGNN5/cKd5kVFryk=
X-Google-Smtp-Source: AGHT+IGNTRuqBcd8nLuNsVuXSGF1sIcXELw3HlP5Nzemzcrdv1EtIzMkCBIzwqYM1NbqtT6g+Vprpw==
X-Received: by 2002:a17:907:9484:b0:abb:b136:a402 with SMTP id a640c23a62f3a-abf26424829mr486626566b.18.1740773792060;
        Fri, 28 Feb 2025 12:16:32 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c755c66sm340812666b.136.2025.02.28.12.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 12:16:31 -0800 (PST)
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
Subject: [PATCH v8 net-next 11/15] netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to nft_dev_path_info()
Date: Fri, 28 Feb 2025 21:15:29 +0100
Message-ID: <20250228201533.23836-12-ericwouds@gmail.com>
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

In case of using mediatek wireless, in nft_dev_fill_forward_path(), the
forward path is filled, ending with mediatek wlan1.

Because DEV_PATH_MTK_WDMA is unknown inside nft_dev_path_info() it returns
with info.indev = NULL. Then nft_dev_forward_path() returns without
setting the direct transmit parameters.

This results in a neighbor transmit, and direct transmit not possible.
But we want to use it for flow between bridged interfaces.

So this patch adds DEV_PATH_MTK_WDMA to nft_dev_path_info() and makes
direct transmission possible.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 323c531c7046..b9e6d9e6df66 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -105,6 +105,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 		switch (path->type) {
 		case DEV_PATH_ETHERNET:
 		case DEV_PATH_DSA:
+		case DEV_PATH_MTK_WDMA:
 		case DEV_PATH_VLAN:
 		case DEV_PATH_PPPOE:
 			info->indev = path->dev;
@@ -117,6 +118,10 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				i = stack->num_paths;
 				break;
 			}
+			if (path->type == DEV_PATH_MTK_WDMA) {
+				i = stack->num_paths;
+				break;
+			}
 
 			/* DEV_PATH_VLAN and DEV_PATH_PPPOE */
 			if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
-- 
2.47.1


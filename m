Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A232343DA;
	Tue, 10 Dec 2024 09:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733823991; cv=none; b=Mtjv0/YB10H6qSKUn0r51URicmBTYHsgvIgicGRADtH2O4tq0hTsEVAHQlvwqofyncfbQsm6AFtDrS/AtdxpTK49lNrI+ziGELOK4sL891JVdydFCI37LSOCPlxyUzTReP1AKwKHrsXhoqbUldyjqg8ir4Ek0fe/OZ61xx3l4rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733823991; c=relaxed/simple;
	bh=maNLh6FFLEFZWq9gMrHdXn5flUbXY1gxWqNWlBJHOOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HptuXMzFduelGUdPv3Wh/B7Ux/e6cijdYYWHitGwJE3veXvQSmFBiht+SO37kJ46ApHyY36q9HoT3kDe+upKjH23YDn6R7WEThCWHT6RhbuZpDXxYWonMq+oXEwZ51iDIMe+G1HrAC6HwikXYLG1k4TYrBUZwLXeOJ+Q1kskpQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rb8tybR/; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rb8tybR/"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5cf6f804233so6690607a12.2;
        Tue, 10 Dec 2024 01:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733823988; x=1734428788; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XtgyJTf0nGEQy8dIgfNuKn9dKl89pMTFI5gYmniF26o=;
        b=Rb8tybR/sKrRVEAClgniHmsATeW8Sa3/KkljDsFsBzz4+9a7Gd3X/Odf7H9XI3buQ2
         2hnHBIqe+tvqFVKnpQdT2BdGHcLvsQ7UDiS1qYQ5H20QNqLuoqaGFLWq0twaTJoPSjJc
         /SoITM86p6gedqEGn5VTGlDwW1CyhuLB6uxpU03+q8+z3QYlcAZgB30cG93FGRbEe1m+
         FAyJlo64rUpe7MqAP4urkUzcCH4wwKK8S90jnw/04q2a64yG2Kd3DSlnZMwg1QDguHpL
         omz2XDSEtX/P9fHSmLNGeZ9RY4HWindJMyGyvrBxfjxQ8/DIGYCV/CjZhPXfSLnQNigQ
         ffbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733823988; x=1734428788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XtgyJTf0nGEQy8dIgfNuKn9dKl89pMTFI5gYmniF26o=;
        b=KLwSUusQZ7gamUus7DVCq3vO2TB5gPc5VMQeNVVtdfz08u6xb/Mr9UW0k0uAb0qtMN
         t/TKk2NTpQ8jNnhu7U1ZL7esXxgqUi65nMv50XQnj49MAJccO67tuvFd2qTd0CeIysWT
         7160dp9v7iclzFUH6sd7Q+TdhqNC1Jea8CmpiKYh17ltESF2Et4uj317FBZzdfz/VmRA
         i1hY7YVKzwMcZE7paKI3fPlrc7hybfGaZf6AaNTjyXiVaLr/5Z4T7fl41vgK46UnMv6y
         1ZGznCcVscK/KhCrSkDGAiipBPWiuneOQpD+4e8KWLH2PSE0nOaHtVEddOKSO7U6M0Cc
         f54g==
X-Forwarded-Encrypted: i=1; AJvYcCVfyH2mXUObkbzIQe4TpRFPcFfEIYrzUHHGYPgHATDzw9yUBKFzkQxJJidX4v4kpHAn3sgqYG9Pof2+1VSL6E1I@vger.kernel.org, AJvYcCXwGprZDgl9U089qThMPmxRqUgAWAsFDHaaLU4cTfu306vJiwbAP0ljTVDorTdz6xhIVJR8kHghONQwW8k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlN13U7XjhvZ2KfIRQ4ObXTS6LQKhsJlff8bZNHdNz/vvZpkto
	6yv13PnXIEhKCZvirxK9maU3FZEbjevRZKCkRrJ3y4qYpsFjd69o
X-Gm-Gg: ASbGncuKTP67vx7Z3KW8ZTyAzRBk4k2IRNLWWRiph1ljTTYAsb0Cvm0B5ptHOQgx1Du
	1oShRx61y0PilI5hqx5CTBRAD4HeOSSyjv5g7LifOE46A3hg9vw38JamEGMAaORWpMQaD5MmI8n
	DA1xr57AsqxTfDZQ1GiEvs+197lqBt1U6nXFCwGtFfjH2X0DS0d1rqhFVtAWVYU8Tnh0vRxQA3g
	XdoB12VKvgOORT9ZItJ/eI9Wj9C7QOvqtyyGGdelIGUBoGea4pU6cXE993+h4BPDO3cfzdKcVtn
	YlJFHESMtRkqsqPbHnxYJYCPnHyUP7QIAWayOedXTQJOOWe1zmQoXF7J6gnVOpQAVYOx/lM=
X-Google-Smtp-Source: AGHT+IHMIuAkwd6n+zMlbqGssJrA/sOKUAdIFcZ0GUQzc6T7cPFdzuPhW1u/ZoZsTEDW+OJzrhPxJg==
X-Received: by 2002:a05:6402:4403:b0:5d2:7270:6135 with SMTP id 4fb4d7f45d1cf-5d41863c5c4mr4611870a12.33.1733823987762;
        Tue, 10 Dec 2024 01:46:27 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d14b609e56sm7313936a12.40.2024.12.10.01.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 01:46:27 -0800 (PST)
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
Subject: [PATCH RFC v3 net-next 09/13] netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to nft_dev_path_info()
Date: Tue, 10 Dec 2024 10:44:57 +0100
Message-ID: <20241210094501.3069-10-ericwouds@gmail.com>
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
index cce4c5980ed5..f7c2692ff3f2 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -106,6 +106,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 		switch (path->type) {
 		case DEV_PATH_ETHERNET:
 		case DEV_PATH_DSA:
+		case DEV_PATH_MTK_WDMA:
 		case DEV_PATH_VLAN:
 		case DEV_PATH_PPPOE:
 			info->indev = path->dev;
@@ -118,6 +119,10 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
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


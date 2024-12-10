Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8995922FDE1;
	Tue, 10 Dec 2024 09:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733823996; cv=none; b=Mz2UKwVbZ81QgV5yHTeN9WpapfxIdXQbRTac6otbsbY9ePwzqtFjygr9FGkr5z5n58kyWA1R01gGvGdOa8kviMDoXCnQmmUEY4HSr785oOy1dX3TXLKpq/BtO3swGLKLNSxJ+csABRsJUfvvkw0+7MZVjGvhw6aHB6tqV42Elpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733823996; c=relaxed/simple;
	bh=EaIKx/03ovm33+b5A1CjjkA5NFKzVRl39Rov2VA2iBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYSKGTFUwaUQR8JJTNZHdiyCc4IgYU7tB/32vbMqaer+3Fds8EYLwXOAbG6PT9Bb3dZgH86m/9v/Ur3MSWH0oaKsOVanCwGjO4Y2Chxoec0slRj+jXYykIj6FBIcYLyuslAo7lnR8x7NAVU+xd5FsRcTgv3eb2/z4/Xe9G2dL8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IBj5GZDJ; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IBj5GZDJ"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5cecbddb574so6903345a12.1;
        Tue, 10 Dec 2024 01:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733823992; x=1734428792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CFsTTuW6zvJV2/j0dvEGRR2IPJ0CE10zFwh/NOpRTtg=;
        b=IBj5GZDJXFbX/2btzNcSbfjCIXy+ALKGIR+7MP3uLo7gJDJgNXLyp/JxY7j3O1fAX7
         agbrzg0FcC9M8p0BDQ0/73KX637sv7dM/IWkU96ZStgQVSlggaH4nRFsgqKETGQk3/oB
         8R5E0WokMX993BfSjnPP5v/unrHdPw32wN76HtVNtukFfLCRGIULd/YwqwlTkEs9rQr0
         7PgcQAT8k48fuSTwfRBTM3N0J4xGUSabzEZYt9mXZnLOWeRh0lz5rIzauiT0KA7BwWe9
         j41sseMbQYA4AYPoH1R4JYkjfhyCRm6FGFUnyA+9LylSptn119nsQbG7EQDXNuQKey1x
         JZoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733823992; x=1734428792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CFsTTuW6zvJV2/j0dvEGRR2IPJ0CE10zFwh/NOpRTtg=;
        b=hPUn7bMVKDGVg03qscIOokY/SvZdMl1k/42JOhknioPQrAMa6ubj00C6PREwK7jnlb
         +YeOwWfE6QBvJ8X92UEdOtLy80I4JQTScaOHtJRGSuPDKaiO+eYquB8DMaeHj4Tt0Nq9
         ZiTw5Izw6H4h/E4H0SoF+Vi4GSNYYi377Yd/uk+inBEzzzPlSdgvTwHYQEmqMNMa1WIU
         zZEprQshRWPRA2G2GCYiUTWxkGXXSZenJIndK4wvsH5FiRnLVIqXhL/Rwh92kcPOh1aV
         /R/zgSjij/E0bUgPQasPvIwl1cstkhfMYH6tk9qwqMvUJKxDwtg7r93qoBD8ctaNx2eM
         yobg==
X-Forwarded-Encrypted: i=1; AJvYcCUmrfcYbE4Dr6CQh0gSFVhLlKb34anUd1XnM8Sa4j5LOI45sPtxKS08Bke39DYaLVKyHJaEHCc/S9HSL4M=@vger.kernel.org, AJvYcCVzOw+x+IxisEJQ3+1IZy96+8gOtp7GPwXElb7OwCn8gjaqLtTgK7a9k1mhDHQDX7tjc909UGxa4qvrxfuztHTt@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9cKbc2Ww77RAbRXlG6LdaFmvhtzHNuUeU5txogqBazNaNSLBJ
	5311++QW38BNeqMGcZC5JyFsvk0d3DvK4gXnk2fxPYcS3YxjhBVu
X-Gm-Gg: ASbGncuqKwzbGqbmam2oU+wWfoa3gvb+cUx4VGKE/dY95CjXB81APZYBkg6n0c80Hs8
	LJOg50o3EztJ9uiId2WX/Sc/rJdLwSnkvi1G57qCik/lz/DPMPXgdpnmAwI2ryQMln5WwndGNYI
	a1/igq3oMhUQ5O0g02B+rK+6knx1TZh+UkloIgJwCsuN5wWw4SWI92xVvjI54rEzOiNIhlNyQro
	3nkBM6krNdrC1GRtIiSUZy3WM1oF4ulhu/jbNqQKRguu3pNxSRa4KZF8SRQf9lfl/21/0a8e/H6
	8oAP45sJb68vkkUSzm8pPnOwRJa8woC5XcCKV81IpsROUGK354/VkA5Bdv5ryMY4ilPNwH8=
X-Google-Smtp-Source: AGHT+IGoxFgsuKE4ejuRzVCEJrbEw9zjzZMSxooOe80MGRVJD8eFS/tnxR2FJpuGaoBio2IEBDhCgA==
X-Received: by 2002:a50:9fae:0:b0:5d3:cff5:634f with SMTP id 4fb4d7f45d1cf-5d3cff563a7mr12659584a12.24.1733823991675;
        Tue, 10 Dec 2024 01:46:31 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d14b609e56sm7313936a12.40.2024.12.10.01.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 01:46:31 -0800 (PST)
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
Subject: [PATCH RFC v3 net-next 12/13] bridge: Introduce DEV_PATH_BR_VLAN_KEEP_HW for bridge-fastpath
Date: Tue, 10 Dec 2024 10:45:00 +0100
Message-ID: <20241210094501.3069-13-ericwouds@gmail.com>
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

This patch introduces DEV_PATH_BR_VLAN_KEEP_HW. It is needed in the
bridge fastpath for switchdevs supporting SWITCHDEV_OBJ_ID_PORT_VLAN.

It is similar to DEV_PATH_BR_VLAN_TAG, with the correcponding bit in
ingress_vlans set.

In the forward fastpath it is not needed.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/linux/netdevice.h        |  1 +
 net/bridge/br_device.c           |  4 ++++
 net/bridge/br_vlan.c             | 18 +++++++++++-------
 net/netfilter/nft_flow_offload.c |  3 +++
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6dbc442f9706..8be40145c1d9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -870,6 +870,7 @@ struct net_device_path {
 				DEV_PATH_BR_VLAN_TAG,
 				DEV_PATH_BR_VLAN_UNTAG,
 				DEV_PATH_BR_VLAN_UNTAG_HW,
+				DEV_PATH_BR_VLAN_KEEP_HW,
 			}		vlan_mode;
 			u16		vlan_id;
 			__be16		vlan_proto;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index c7646afc8b96..112fd8556217 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -430,6 +430,10 @@ static int br_fill_forward_path(struct net_device_path_ctx *ctx,
 	case DEV_PATH_BR_VLAN_UNTAG:
 		ctx->num_vlans--;
 		break;
+	case DEV_PATH_BR_VLAN_KEEP_HW:
+		if (!src)
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
+		break;
 	case DEV_PATH_BR_VLAN_KEEP:
 		break;
 	}
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 0decce5d586a..6a2ca7a5854d 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1494,13 +1494,17 @@ int br_vlan_fill_forward_path_mode(struct net_bridge *br,
 	if (!(v->flags & BRIDGE_VLAN_INFO_UNTAGGED))
 		return 0;
 
-	if (path->bridge.vlan_mode == DEV_PATH_BR_VLAN_TAG)
-		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
-	else if (v->priv_flags & BR_VLFLAG_TAGGING_BY_SWITCHDEV)
-		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG_HW;
-	else
-		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG;
-
+	if (path->bridge.vlan_mode == DEV_PATH_BR_VLAN_TAG) {
+		if (v->priv_flags & BR_VLFLAG_TAGGING_BY_SWITCHDEV)
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP_HW;
+		else
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
+	} else {
+		if (v->priv_flags & BR_VLFLAG_TAGGING_BY_SWITCHDEV)
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG_HW;
+		else
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG;
+	}
 	return 0;
 }
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 387e5574c31f..ed0e9b499971 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -149,6 +149,9 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			case DEV_PATH_BR_VLAN_UNTAG_HW:
 				info->ingress_vlans |= BIT(info->num_encaps - 1);
 				break;
+			case DEV_PATH_BR_VLAN_KEEP_HW:
+				info->ingress_vlans |= BIT(info->num_encaps);
+				fallthrough;
 			case DEV_PATH_BR_VLAN_TAG:
 				info->encap[info->num_encaps].id = path->bridge.vlan_id;
 				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
-- 
2.47.1


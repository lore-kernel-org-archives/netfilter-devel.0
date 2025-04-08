Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE59A2222B9;
	Tue,  8 Apr 2025 14:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122456; cv=none; b=M/w5N+dOAY0pAFd+/Aar9R7sewFilm9rlUD6IBhiKLxEiIGk//XUgQTYHXB7e+vGICuT81IjTW27Fpkh1+4LL9u5LZc5hT4x24QwDjF7hCbARf7HmeKTIQXYACT7WuqZC9w7xRPUnSri+tdbNNz1K9gbp6+L8uPlpbT6HVi8K/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122456; c=relaxed/simple;
	bh=gaG/8CllEsuEYVXuPZk1cX0GaP1RIWirH2m+Ef/oQJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daU0boN5RoVXxfz2/zcHiAdH/oaiKOhBa0WwdIUw7r029R6jr0bX59v1WiwaGvJgxW9ME8+dI+6U+Ic71FW4IxbWyDzIyFhInWwKHku2aLxK9omEt9+o3gq37PngdscADsaL+9hX09IEEwke2GT30Iy+oJx8TsYHLnx9KUg4VZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ELIugcKy; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ELIugcKy"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ac3b12e8518so1038910666b.0;
        Tue, 08 Apr 2025 07:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122453; x=1744727253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pSHGxvoqIBIbqZcTKF/gVVMx0ajorY2bbUPhZUg2YJ0=;
        b=ELIugcKygubmCdQF330xaBOSEOBoCtTXiiwCEvubLIwJHoOwTSxvJ1ZvGhePJuoAa3
         +jly5VTHzvAjSVxFj7iAyutvZAsPoVmo+OskPLywO8mMJtKMxv/a4IYIf0EiBGBV7al6
         5LZF0YWuYrqIzbnuh+WrwJ7VBJ6WtG9xlu1eP3J7kQLuU0Oex888Bi37Kda1srLp9cSX
         9mraM7OQd0PNJ9UQKQ6xlP2bP8gT5UZnxFw8eIaX8HEyUyrSQvjNzMM4/svykwlYdipI
         te/XMg2i/Koy+s0Vyo8jaOuLWDXpPEIgRupsGPF+ZL+K3Rdf+4nEAxhJKRWDom8B1Sb6
         FMHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122453; x=1744727253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pSHGxvoqIBIbqZcTKF/gVVMx0ajorY2bbUPhZUg2YJ0=;
        b=Vb3cyaBWb9mLT6DSnWEd0MCIyKPW2rFTy7Ng960sFxvtjVxm2OZ2hQrRKIfGWLpfT2
         +ynkhdxx4dEfsffUO4vcUEz8/49KeUeVbjYdB9ezi/07PkwjzZokYvldXLCHVinxhudD
         Aq36V0mMLw+pArAV3rn1zalEv5wo2809m9erNbq5vi/Wmdqo/I/ucualjwEMeRQnECzj
         IMbciEa1KDcqI8wFyfX+P3YYiE2VEg/JYUJZhshFkGuA5i2xHpqDkBTfZrkN89A21d3p
         OFbkoQ5YWr3BzGJmu8+lO5X0OphO3cvqoJNTO4nYDd8QH6D7odMWqJvgVEKHrs4xzmvr
         du2A==
X-Forwarded-Encrypted: i=1; AJvYcCU9DayKqi+xjv6rUfVFdgzb0zsD17OM6sbFYxZDIXqojpsBrOKdIjL9EE/0OmSPHZ1L4QfbkMD4vWLYVvl4x0Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3EYGmmWVIEW+GFm8MfbQvtrgGrL1BqpUnrPuizQ5AkjK10iyU
	n+YrP6WDOfREXfjwN7PobTlQmPCmX5RU2LqxLCCfZF42jEpyj+Jz
X-Gm-Gg: ASbGnctrCvrlviAMKe8Bb2EGwLcYXMascNCifvyhOH+A8BG8mAOUVG7IMRtfbpCkgfM
	6/EY918QWFUtnSnjSJl4ZxejTN8E4GpSc95qs75H/ClK8OCYWeYo0jUpgH2M4qwBkUENbl9vbpS
	GA9UHEtWcdQjnZDEsFFGv9RmaDkcw+dGRbeedXKZh/NNBBzU2kEe1MxU4hFCgYSswN6tCVnb8Vq
	K1HQEByfdITmLvb02FX687QNT3Vzu5g2ziTutlt22sJeAwMx//tIzFHvivuvyOfF6qxnbNVsPpi
	i+3RsPEwXDy7u3dn3qXQa1JpDMNI8Amt6D7RxkbiQAANCzoPDPjJ+k1KmnPGKvgOApEfuomiSJh
	UxvOT7RhdzEguqqFA/XomcCEgvK4sow6L7w7SCyDuCAEF0qjXPHCn3+x8R57QbqY=
X-Google-Smtp-Source: AGHT+IH3URBmXzvm7rmuiifGg0nI6GTLC2yk/NwC/7RSNf7U9qMp8Uua9d/HOCEY/8nWokG6ODloBA==
X-Received: by 2002:a17:907:7291:b0:ac2:a4ec:46c2 with SMTP id a640c23a62f3a-ac7d1b9c1demr1497465466b.49.1744122452769;
        Tue, 08 Apr 2025 07:27:32 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfe9be67sm910393266b.46.2025.04.08.07.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:27:32 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v11 nf-next 3/3] bridge: Introduce DEV_PATH_BR_VLAN_KEEP_HW
Date: Tue,  8 Apr 2025 16:27:16 +0200
Message-ID: <20250408142716.95855-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250408142716.95855-1-ericwouds@gmail.com>
References: <20250408142716.95855-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following the path through a bridge, there are 2 situations where the
action is to keep:

1. Packets have the encap, and keep the tag at ingress and keep it at
   egress. It is typical in the forward path, when a vlan-device and
   bridge are combined.

2. Packets do not have the encap, are tagged at ingress and untagged
   at egress. Can be found when only a bridge is in the forward path.
   It is also possible in the bridged path.

For switchdev userports that support SWITCHDEV_OBJ_ID_PORT_VLAN in
sitaution 2, it is necessary to introduce DEV_PATH_BR_VLAN_KEEP_HW.
The typical situation 1 is unchanged: DEV_PATH_BR_VLAN_KEEP.

DEV_PATH_BR_VLAN_KEEP_HW is similar to DEV_PATH_BR_VLAN_TAG, with the
correcponding bit in ingress_vlans set.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/linux/netdevice.h        |  1 +
 net/bridge/br_device.c           |  1 +
 net/bridge/br_vlan.c             | 18 +++++++++++-------
 net/netfilter/nft_flow_offload.c |  3 +++
 4 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index cf3b6445817b..4e8eaae8c441 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -887,6 +887,7 @@ struct net_device_path {
 				DEV_PATH_BR_VLAN_TAG,
 				DEV_PATH_BR_VLAN_UNTAG,
 				DEV_PATH_BR_VLAN_UNTAG_HW,
+				DEV_PATH_BR_VLAN_KEEP_HW,
 			}		vlan_mode;
 			u16		vlan_id;
 			__be16		vlan_proto;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index a818fdc22da9..80b75c2e229b 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -423,6 +423,7 @@ static int br_fill_forward_path(struct net_device_path_ctx *ctx,
 	case DEV_PATH_BR_VLAN_UNTAG:
 		ctx->num_vlans--;
 		break;
+	case DEV_PATH_BR_VLAN_KEEP_HW:
 	case DEV_PATH_BR_VLAN_KEEP:
 		break;
 	}
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 6bfc7da10865..0f714df92118 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1490,13 +1490,17 @@ int br_vlan_fill_forward_path_mode(struct net_bridge *br,
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
index d84e677384da..fdf927a8252d 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -145,6 +145,9 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
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


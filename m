Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3611D1CB9EC;
	Tue, 19 Nov 2024 10:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732011578; cv=none; b=t9eZH4Q6YmG/c81WincLlWPByYKs7ZCCekZDgjpPzQLjNjXvDZ70XBY9VJ321Lzjdw/KqAnhDG8CfC5T5VLELwt3cUig6lmESyxsuCHfuZY0UjArSjF+YhLX3LYexFxQXZ2/CTzX4JV7pmBrBU5w6Vo+nnLCDysRFF/UbZuG0JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732011578; c=relaxed/simple;
	bh=kQluY0HS8gO4d1CbWsgjmFEIcn/3ew4ST0okyTuF1QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPTU5d83Epa0/wRK5R5jqEtJ/030zgMStmxrTQCpHs9xdb5UQZoYgg7EFYE30X5gHdapk8bejqjRqyY1EkKXRwYAa0QFUwHBeLiKu1qaGSgv1jQ8Xkf+qHZxEXjHzU4WQbWPQ5doQBT+N33GNnDd5UrHroybLlBvbvBLCPg7frA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OuqUdPL9; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OuqUdPL9"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a9f1c590ecdso722510866b.1;
        Tue, 19 Nov 2024 02:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732011575; x=1732616375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v/vUWoqxNIyzC+NeQY2banTy2Lb/YnflO4/5JFbURlo=;
        b=OuqUdPL9zgxZH/UfkdMEnMU2hVfueUwmDSJYV6gD9atYR7RNWr+edmSPnSLL9AVNMf
         /AIRC5mXYzfTuNPxd1J7+kbvPtrbIV5YBeM+1DWY2hwAB2MFmxOufcIAGd/NDy5lZRy+
         PWe5Xun0cCQhvi4N42xxBCxqZy42l9jUgCOYWiCf0+Bstn5xIcwbghGc/8SPWKbvy4Hs
         fXCYoDCaJqE5E80lOu1Mh11y51+CqnmJ47WOhABXX64KrouOV971LgxeZ3B1cu8R00B5
         7gfyQ3oywIv5GY1mjCP58am+6B4UsjmbaCp2sqRiSyiUiF3NT4Ljw3BxNnfQREhB2eNl
         ZrHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732011575; x=1732616375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v/vUWoqxNIyzC+NeQY2banTy2Lb/YnflO4/5JFbURlo=;
        b=Fokbpy7u8/VxJfuOOhEopo3qWKvZ7zErL8yqIsGehgyVCCs6CXkIo0wrl+aIuCbYJ4
         62p/sqhMQLDfGpvWVnF5J+aUf2/XW1gbKpiTIREVmQY38nsnuY0bjMY/UINhDfVL0OIj
         f5VoSgyxq7F7A5kGKWkJJbrCZtmiXrVkvE5V3D8qxXYRR2yuaek8CYWoB5l2UxJlQ/Gf
         7ge1gD0GJHKQEs4En5AEsHikJME1Fri2uB/y3kwSVlRcLmNDnJ4sOvGmccI/Vt1aN+JL
         ocrGq8v6Hsdrh2n3D6o2VSdkuO0Lp2bm4OazyQsKhXv+rAYRYiTAUO3nJjjQozF/k5OL
         7kFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLvR6RyAPe937GkJ656joFsVVONqjjqY95Y5JAI1adjc7KnQI2JqX+7ZWPtuaG4tbgc98guHYDq9z5JCoQHFbx@vger.kernel.org, AJvYcCXiCLgtBeS+0hLbJtQgwnVvPmmqgN00rrmwlPgTxVPXYp/TPpkWqxwCPhXKOZKnhHl5sU6gGT79cuNWHBw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaGe4gJ9xeA2bhoF+eH8M/lz2b0WX9p0KuaPOG7AdnP8r22IGh
	nc+SG6CI2Pb34R+dYGf12z1q2xwWsLuv4TKgR7cSzdISEdB6f8lF
X-Google-Smtp-Source: AGHT+IGpNp2EcDD7KUg0ypC4A+lKeGJDHv/zRaEDzsK/LGdNlutzMURqa+xe7vSUguB7L7JU3yrxXg==
X-Received: by 2002:a17:907:70e:b0:a9a:533b:56e3 with SMTP id a640c23a62f3a-aa483454466mr1479164366b.26.1732011575326;
        Tue, 19 Nov 2024 02:19:35 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e081574sm634875566b.179.2024.11.19.02.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 02:19:35 -0800 (PST)
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
Subject: [PATCH RFC v2 net-next 13/14] bridge: Introduce DEV_PATH_BR_VLAN_KEEP_HW for bridge-fastpath
Date: Tue, 19 Nov 2024 11:19:05 +0100
Message-ID: <20241119101906.862680-14-ericwouds@gmail.com>
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
index 15923d177f9e..3bd5c7b45460 100644
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
2.45.2


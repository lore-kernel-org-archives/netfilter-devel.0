Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9E11CAA70;
	Sun,  9 Feb 2025 11:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739099468; cv=none; b=KalW6AN4ftf4lqzuIf2ywWTH1w1N/s6cqu9oYfOT7o3tKgGBM//UHFi/bAz09MQtaiiYMbpfPOTbyMS4OsGbXtfOeWiCl4KZEiN3RUFw60xg5Zmppg+fMb5AViUWwonLmDnh6t+6fQx/ODpQLx/t0/eFP/8tZPLQCiNjcev4PBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739099468; c=relaxed/simple;
	bh=XZoyPUjQN/+20T26Lym986aR6M2k2HvcTymZcYiPB2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUZTcOL5UyzK7XYe8OEUMuBl/Uzm/hhtz4FKqOWfidbLEWE8OCY77qnV9uqL63UeVfEpoGeC9DKL6zURZxGOLn5tV2CSPIyyChz6MZSo2yWPcpGnfGkC8N2ZsGqKINvT3u/kDxXYgjqrVzdR5uubt/QXTr94l6ODoC7siH3gZm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XKJg2BrM; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XKJg2BrM"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ab7a862c937so133537366b.3;
        Sun, 09 Feb 2025 03:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739099465; x=1739704265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=21wGozzdg/kg90PQGRE5o7in49y5R5W2VgpxxyORYJo=;
        b=XKJg2BrMAERt4/YK2CkPsmxuYhd5hSVVN0b9tGUIt4pBlaW6tnCkKv5SZgumeM7cme
         Gola0/9XjKqyZzNsyAse892wEntZzp4z7vbREsD001w14F56iYFC7rX3cB7Vd8BGCEKt
         uEwkOVOhFgB0fQJjR9B7EhVMG/01/2bbFap22r+yTgRQqv2KMZMxqq36liOueWbyk8Kd
         1nN3Z+hTWbK5hGw1woxOJbdsxm8hRy6qlmNBqfXBK1CRmHl00y7dvh5nWObi2ugss2Ms
         tgnAW0yAe1et3cSIgFDSee8GkLlUrpuVEYoolrrtL0i2GX87mzZgOVfJLV3OoFb7snB3
         dSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739099465; x=1739704265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=21wGozzdg/kg90PQGRE5o7in49y5R5W2VgpxxyORYJo=;
        b=l/o1lr7OIQ5fKrY4bnXKO7YRVoP45gJiKMXMTsHi88VmCa9XBGxeItLZ6OMcLLybA7
         kZCB9c9yplXsTL4vsWrJvFXZe2yFpaBLNoMj6CQvhBiijdYt+nXUZVG9jBYl7T3uwV51
         KzXSCWnIykNBO5uBCXsDswfKWmVOuaBUDD4joGAHwlPrV74sfb2tc8gUo5RMeFwtEAVB
         7hTA53MgPIy5k1EmFokAgKQ/tLpeq9wuIbg2HAMOuQYAsojwAxHibn4DPStmHy908JTq
         4c/aOFkbUmZq191OSRATncyMDo+7zQ2mT8ikwut6uV9m6xg8ALBF2fIpgTnWMdskv7uL
         I/wQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQJg7V+1lcxf5WdGPQywupN/hiAcFdJUB/l5J+UPaS4By+jNWKvaZerk5c5VViYj5KcAJLCudeii/y/U/Gdvry@vger.kernel.org, AJvYcCXZ3nu1uVBymQGWvrA4XtzAOLjXL+FhallGeEIfzNYdKMCRZ39CU1rmEdEXTtfmkhEliv9MdWJenZEWvnA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2eF1mQs8a+SXIv/DNKNx0IeeC8Dz/QnUpJwpmNiS6KVPc/aA6
	Tq0WmUAAOAbBFQeSb//bREsNVn519DpLjS6gYdZFL6+PG16q+DGL
X-Gm-Gg: ASbGncsNkoYioRvxP+aijCu9Vd/f4Bg+9vEjtPPqk55a36OrUxzq1RDxboMV+SF7euT
	DSeNOgz1PvbdjEDZzHqykRm+6f4pEITFuC6RjARxWe5MI2wGHYxLLSUmYAIKurLBfpTen5f9xcY
	F6rCCPZi4PdiS9mcikMZ+uyOv8QSlSEdFlKQdffuE8jO7bVI4vFWlleGZwBUrnJxgJ12Jhu0MCk
	bqmGzKu/pYtQ4AYywD//rhJRdQjceNobaOBZ0f61FNgZb93JyuZujkpEgvmjmY7CXFoJcqrctc2
	ktxnKixAeLvgQu3JyCwllMxe3I5LyqWuTfFAH9Zo6EAvbEODdJiiVKtxAa13xaFrYr8dAJBELe9
	b57g7dUfepbaQmo+Zel/3PgEwgWwVd8xE
X-Google-Smtp-Source: AGHT+IFCN56S7YNhxymBxkzw1XBWVzH4BKvgunr9+9DooHHAtJHeUPUaPpWkQeeGjmJ70qNtwfqBzw==
X-Received: by 2002:a17:907:60c9:b0:ab7:bf2f:422e with SMTP id a640c23a62f3a-ab7bf2f54cemr32650866b.27.1739099465160;
        Sun, 09 Feb 2025 03:11:05 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab79afc7452sm357516366b.163.2025.02.09.03.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2025 03:11:04 -0800 (PST)
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
	Kuniyuki Iwashima <kuniyu@amazon.com>,
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
Subject: [PATCH v6 net-next 13/14] bridge: Introduce DEV_PATH_BR_VLAN_KEEP_HW for bridge-fastpath
Date: Sun,  9 Feb 2025 12:10:33 +0100
Message-ID: <20250209111034.241571-14-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250209111034.241571-1-ericwouds@gmail.com>
References: <20250209111034.241571-1-ericwouds@gmail.com>
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

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/linux/netdevice.h        |  1 +
 net/bridge/br_device.c           |  4 ++++
 net/bridge/br_vlan.c             | 18 +++++++++++-------
 net/netfilter/nft_flow_offload.c |  3 +++
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9f925dc3d1d1..923dbfc589ba 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -869,6 +869,7 @@ struct net_device_path {
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
index 3e50adaf8e1b..8ac1a7a22b2e 100644
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
index c95fad495460..c0c310c569cd 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -148,6 +148,9 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
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


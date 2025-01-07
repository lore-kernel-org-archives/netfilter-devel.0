Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B111E377A;
	Tue,  7 Jan 2025 09:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736240783; cv=none; b=uv4LL7uIHrie3HNpH873w9EmMMyMaPzjCPzc3WKGlx6SOrZlSYwvF/iu0ya+zri2wF6+x/9OZaujwXCptqbzymKcQWfRtHInZB+7Zsfn5VvjA2aOOeBmS/iAHIhzkrXoExRp1reVJi0vDMvW7PI2rmvVQXFpjsiyLgabhOrXN70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736240783; c=relaxed/simple;
	bh=fNXC6p1bCW+M/ZEhva8GTHTSh+ddIIBQnzEoEEizoog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ch+Jyk0gF5wQPTEXMn39QN4l26AZ4V2BPpPnLTWvayaP3w01bn1T9RSQbO2JQ4CovrbX8OvTpq6I6TLdTlxxvVptLh1uS0kp2YiYwFl8HL4DwVunMrkpn40ejdp5+9sOG/nR2c1pHZ06xnoOipseMaYuDhL0Z3rApMb8mXnpNYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AFDFLODX; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AFDFLODX"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d7e527becaso25989170a12.3;
        Tue, 07 Jan 2025 01:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736240779; x=1736845579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ElntuwObyWWTXWyk0nhZUVrAyxwm6+3uBHbEuscDHA0=;
        b=AFDFLODXFhN4fjLVwVCb6VKvvdxMY/jC/iqkKb8O+7f1pAWYxWOaME8hXseJ0U5SOA
         1uCC6SJmvvjlUWbdzWbZq1c9vg28cI5bHtzYwQaf7RmGVOC+nrRq9XlfJUnn3r72k/S5
         j1/P80MzFs4E/q9nqsbxZkbfx/Wa72L1S5uSwjZ2OGMXfZns/pKGmheyzZxLbncor3T5
         5ds3kvxt4uCdxpUnoFLb4hg5RQT0P8BPFEMdgBM5HReK+uwe3xC+MA/AdHbrkr1Ptkny
         tswh7dwXalZjgAIgXYB2D0Uu9npW9RwaD9MnvcsAv5k6CCo4yKlwWdnsyG+19/SBvqGl
         wucw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736240779; x=1736845579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ElntuwObyWWTXWyk0nhZUVrAyxwm6+3uBHbEuscDHA0=;
        b=QJHXv44JXecCNjIUeqPikUfwG76hlJ1WwUiD0Gq/OZdx4Q35VwqiOKpFu1RwADc6jp
         lhsCri9QIW8+LpTapZJQyJy36iesRR3R+x4okRgtdnLcSc8DtpO3j5UBpl3wXPpEkipY
         9mi9Rws+4jJBlB7bHof+w6+0ApHT9h6EcrKMJckBj8pa0B/gVw+NolGgccGFbAJsaoOW
         YHvVGeRTsVNPikdwuzviAy8LoIvHAEP0nZ+2KguhSjd/ekJUiVWijtEIe1o5ervZ8GKD
         vvMEVJhZiEPzzdNlV39GHeoWLBvFp0WTTFKm3gTBsJ5SV5A74Cp4d1QX64y7RZRqkeg+
         CBoA==
X-Forwarded-Encrypted: i=1; AJvYcCUzTGQPuZdxBsJjgL2VPeJfJo0ZMy0n8JHYrM/5xXIz/4/+6irWON2EbEVnl+GY7POltzbe75fp2vV4EDg=@vger.kernel.org, AJvYcCXk6TjxhdBXl3dUaK2h+w5BvrpJpIkJ17uscRj53bQ1V0rduW+DCNuoVd1dCBcyxG+tISVQcDYKLnGAAi//fK52@vger.kernel.org
X-Gm-Message-State: AOJu0YxQAb+pKeL2CGgV34iB7/XE5sWF0GF+rL72rex8o7ZzOG5aYPHE
	YnwcvNXyDD//dIDiNlLF8WkihuO4HG2K3FXpbl4dr6H1AqmSbqPK
X-Gm-Gg: ASbGncsH1mdT95BaWIj1TZVePogzpo/QuP10DwOmZdxVXXSnNm+Rt85CQt93m1MGWjr
	ncOjThORRrThUFcolHdfYtVgVQ+sRb9nTj0fQ8o64nRkIEAfr6ITa0C/zIpjsZzSHUXG9sDBrEU
	+uOcIkMg1KZu7nLdlD9mG5YzPHYO8mlZ7WY1FskNMeUTQFa7agMSbaBe/reuE3hrtD/kc5ZJ1Zr
	bBa0qB73pJlusWx6oFFztLxF78DwQvvKXz+DStCfKL/IKHqvKgBAkPn7WsMGR3ADuXH82SElat6
	9cRoen1+b5cWihvGIsG3P/XzjFSKHK25Xrna08leo5fa9sE0/3ZUy0QROEE385NJ/r9732qhgg=
	=
X-Google-Smtp-Source: AGHT+IGt7vXeWi8jtx2prBY+YfADkXQQ34zgfUpIHrQ42iesCfqHcrSyvvrAit9+d72yO+NjyUOXkA==
X-Received: by 2002:a05:6402:210f:b0:5d0:cfad:f71 with SMTP id 4fb4d7f45d1cf-5d81de1c921mr140645365a12.32.1736240779167;
        Tue, 07 Jan 2025 01:06:19 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80676f3f9sm24005333a12.23.2025.01.07.01.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 01:06:18 -0800 (PST)
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
Subject: [PATCH v4 net-next 12/13] bridge: Introduce DEV_PATH_BR_VLAN_KEEP_HW for bridge-fastpath
Date: Tue,  7 Jan 2025 10:05:29 +0100
Message-ID: <20250107090530.5035-13-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250107090530.5035-1-ericwouds@gmail.com>
References: <20250107090530.5035-1-ericwouds@gmail.com>
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
index 7d66a73b880c..cf754ebb19df 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -871,6 +871,7 @@ struct net_device_path {
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


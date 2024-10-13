Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05D416C69F;
	Sun, 13 Oct 2024 18:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728845750; cv=none; b=Qs+eEBqjhly5gPjg18ch1rxZdpQWEDfyWWpUGwS8QW8w3UzNCa2PNwdsdVQ75BVfRsvOtRGC64DC2MjrmOXqNRkgkb8mzNeSRhJTROYY0gscVhGWp3wG0IL3nqm0qF/ElgPsjl8ZmY5EbzO0SfX8R17v0InihwOlw4Fo4YeAum4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728845750; c=relaxed/simple;
	bh=2MrR29L0apTeymIhO5SD5LS844z7+xt7fA+cUFkaNlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gz//gw2WQMHsKqbdsdiXsc9IZEnaYjwYNFTG9DX509HzKvL3vtc0iIJic0pM4RBWRue85pRZ8NKMrwhNLpVDMPbw/yTpIUXZ5pjZWzHImGatTtNs6UVF4TR2bm/4QIEL8bFSTAFaCEsmHnnHCVg3UAw4isDFVURRL02/QZ2dD+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ggxGFXvP; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ggxGFXvP"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a994cd82a3bso529018566b.2;
        Sun, 13 Oct 2024 11:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728845747; x=1729450547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/wvQCHOWWIW7US3Y24oFxpAEUoI5Ll0qD/qvu+rx8QE=;
        b=ggxGFXvPopeiAWp+nnKcOv2dj4AsiQLbcaIT/dryhNw+zgHBkE95C50QVx6MR7ygQz
         cDHPpI3uifGj/RWNaYTLJK2o2vNGJQjT1TS5qYybczFVaBFXMg4YH1uBj0qYdZn+oSux
         cSBoo+EjIHC6JyY7Jm6B3ysX6Ch3R0EYjkGihHr9i2+rxYeNK4J+HQ92HgP+2e6PAgC8
         SSm8YWxbGNNQ1kycxvL8m7Ly5arTMfS66odVcjEBys7jQ7ms4qbRP0Yl0CpPGT0ogz70
         DffHGPMjTq5eil7tTJ96yajVoIOmqdlxmDk+xVw6s12XuQDjxkj5tEcX+/RJ3r1/LkSE
         W18Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728845747; x=1729450547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/wvQCHOWWIW7US3Y24oFxpAEUoI5Ll0qD/qvu+rx8QE=;
        b=SgokHDQLPGnCblbeYTlZxlrdG/NzE8BtAiaUgyKvOOPwxqldYTOu88oox3WipQOLkT
         QBTdsgAtBu9zP4vdZtvbTP1GUghY3ApYM1Kw6ypYsXGMZmwENjsbTNxnZKbyMdLaALiC
         STGE2sXpa4mzKuS+MrwwAGTMVqMk1/dCRzvsKIcqW8PRHtb1xj6yxVQeMjt/PZ31Eed+
         v21r2wVYY2uEh/UBR4M0UJm33id9qcMddpP4sFT6Tkto+J/SWmFfZnSXCsjLAs5ZCG+8
         GgM8cDzVhBKmuoBTn7btabsH0+z/NMKJsXeHRrJ/87Mdj7lqbtdf/X+efuG8+1ru4uLt
         Qh4w==
X-Forwarded-Encrypted: i=1; AJvYcCVQ6UbASEVY2nYk7ErYTLwLEh8u7b3nsUOGBcotVW4w0BPaMIb0kg3COTUHD3J4jZb6uREl3ffESzWjdsk=@vger.kernel.org, AJvYcCWGKUtASGnUJRAC/8jQRoVQ6qbPy9Innd5tFrmJ7jm1kz+eXfTVGfOCXZuEgp0lXsZiP/olbA7PvFONmvYp8bV/@vger.kernel.org
X-Gm-Message-State: AOJu0YzUn0ctWLKPFqDcuz40eM6RkkzL9XMs4RU7q+4p1E2bnwuDN1az
	c9LOchZvJD2uhFkU4VklnyKy3SNnFKUYIe17oUinNoAviQUENiK6
X-Google-Smtp-Source: AGHT+IFcMh7X7AR/VKEwvdjIeYhwzK2WvA/EYBgn+NK/HakHY1UTKH1K6wSO2SOJbW3fWApGJV4UEA==
X-Received: by 2002:a17:907:6d27:b0:a99:b592:edba with SMTP id a640c23a62f3a-a99b93a7d8amr743812866b.1.1728845746819;
        Sun, 13 Oct 2024 11:55:46 -0700 (PDT)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a12d384b9sm13500866b.172.2024.10.13.11.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 11:55:46 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>,
	Eric Woudstra <ericwouds@gmail.com>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH RFC v1 net-next 11/12] bridge: br_vlan_fill_forward_path_mode no _UNTAG_HW for dsa
Date: Sun, 13 Oct 2024 20:55:07 +0200
Message-ID: <20241013185509.4430-12-ericwouds@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241013185509.4430-1-ericwouds@gmail.com>
References: <20241013185509.4430-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In network setup as below:

             fastpath bypass
 .----------------------------------------.
/                                          \
|                        IP - forwarding    |
|                       /                \  v
|                      /                  wan ...
|                     /
|                     |
|                     |
|                   brlan.1
|                     |
|    +-------------------------------+
|    |           vlan 1              |
|    |                               |
|    |     brlan (vlan-filtering)    |
|    |               +---------------+
|    |               |  DSA-SWITCH   |
|    |    vlan 1     |               |
|    |      to       |               |
|    |   untagged    1     vlan 1    |
|    +---------------+---------------+
.         /                   \
 ----->wlan1                 lan0
       .                       .
       .                       ^
       ^                     vlan 1 tagged packets
     untagged packets

Now that DEV_PATH_MTK_WDMA is added to nft_dev_path_info() the forward
path is filled also when ending with the mediatek wlan1, info.indev not
NULL now in nft_dev_forward_path(). This results in a direct transmit
instead of a neighbor transmit. This is how it should be, But this fails.

br_vlan_fill_forward_path_mode() sets DEV_PATH_BR_VLAN_UNTAG_HW when
filling in from brlan.1 towards wlan1. But it should be set to
DEV_PATH_BR_VLAN_UNTAG in this case. Using BR_VLFLAG_ADDED_BY_SWITCHDEV
is not correct. The dsa switchdev adds it as a foreign port.

Use BR_VLFLAG_TAGGING_BY_SWITCHDEV to make sure DEV_PATH_BR_VLAN_UNTAG is
set when there is a dsa-switch inside the bridge.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/bridge/br_private.h |  1 +
 net/bridge/br_vlan.c    | 18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 8da7798f9368..7d427214cc7c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -180,6 +180,7 @@ enum {
 	BR_VLFLAG_MCAST_ENABLED = BIT(2),
 	BR_VLFLAG_GLOBAL_MCAST_ENABLED = BIT(3),
 	BR_VLFLAG_NEIGH_SUPPRESS_ENABLED = BIT(4),
+	BR_VLFLAG_TAGGING_BY_SWITCHDEV = BIT(5),
 };
 
 /**
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 1830d7d617cd..b7877724b969 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -3,6 +3,7 @@
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
+#include <net/dsa.h>
 #include <net/switchdev.h>
 
 #include "br_private.h"
@@ -100,6 +101,19 @@ static void __vlan_flags_commit(struct net_bridge_vlan *v, u16 flags)
 	__vlan_flags_update(v, flags, true);
 }
 
+static inline bool br_vlan_tagging_by_switchdev(struct net_bridge *br)
+{
+#if IS_ENABLED(CONFIG_NET_DSA)
+	struct net_bridge_port *p;
+
+	list_for_each_entry(p, &br->port_list, list) {
+		if (dsa_user_dev_check(p->dev))
+			return false;
+	}
+#endif
+	return true;
+}
+
 static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
 			  struct net_bridge_vlan *v, u16 flags,
 			  struct netlink_ext_ack *extack)
@@ -113,6 +127,8 @@ static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
 	if (err == -EOPNOTSUPP)
 		return vlan_vid_add(dev, br->vlan_proto, v->vid);
 	v->priv_flags |= BR_VLFLAG_ADDED_BY_SWITCHDEV;
+	if (br_vlan_tagging_by_switchdev(br))
+		v->priv_flags |= BR_VLFLAG_TAGGING_BY_SWITCHDEV;
 	return err;
 }
 
@@ -1491,7 +1507,7 @@ int br_vlan_fill_forward_path_mode(struct net_bridge *br,
 
 	if (path->bridge.vlan_mode == DEV_PATH_BR_VLAN_TAG)
 		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
-	else if (v->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+	else if (v->priv_flags & BR_VLFLAG_TAGGING_BY_SWITCHDEV)
 		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG_HW;
 	else
 		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG;
-- 
2.45.2


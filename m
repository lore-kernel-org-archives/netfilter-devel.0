Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E7519E966;
	Sat, 15 Mar 2025 20:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742068930; cv=none; b=jG+d/t2plWA+/DkEXWL2wg+Uzrvi31a0R4LRPAhxO8L3uOPsrOAw+ny3Y5p8MQVVEfYSZm9E+cW7AbT+6mkVBr/gGDZ82/JTYjE7HIFXA+nJhqN5U+PsQ4wodeAxxXcFr/QTsyVens4GqRn25JNV2qDWeJ284sdQ1AC++HKgULM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742068930; c=relaxed/simple;
	bh=GybLpAybbUmOfhk9Lf/pKIo5aScLdrW9YfE6FqksJxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9odo1h4d45ZOC7Dr12zar+dxd+QXUlUYN7yg9QUAhD6oMipE4ISLHWstgRco3MWZweLH38GJfpQfLbiuZk9hvP12bGRYGI6FnLRNFhevagA9jy9HRowJl6NaEvXerlCvVuCSfmY5WSHvc3e9dtKuleLjksW3KVGSuIG17ehGuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BPvk58Cj; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BPvk58Cj"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac2ab99e16eso66866366b.0;
        Sat, 15 Mar 2025 13:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742068927; x=1742673727; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkA4UZVIpwTz+MfKCQjyLNbONPOyz+LdYLZQ/1FoX0k=;
        b=BPvk58CjqaBqtS5SniHEKZfuR4hXqgcTyoB+e0WAB5898soLIJiy2kO56rdGBmXQY4
         aeIH7j+t1bAr9KfPRDqThM4t5uBfMrU3H1CFSuzJt6Kbz35Ov2bZcFyqwhxWs81rzB2L
         GbNH5KC7tXAqMJ/3YN442ot4kaa02z2s/r+FQ8yC0UkZo+tqfwC3Pgy2FO6egx4wd9VR
         IINw+UbpSlsqmDU8eYTLi3t/YmmGnSWaQGec/LPc56SLuInY7wJ7vVc47VX5SKF8mVaX
         NH8P7F2eoP1WaZbizmFruIR7px7mqTjx+XGr8xBtDU5idiu51t1/yPXeU71lh4lif86Q
         fVYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742068927; x=1742673727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pkA4UZVIpwTz+MfKCQjyLNbONPOyz+LdYLZQ/1FoX0k=;
        b=CzdP04Xjsx23y7H0R0UBc9KOZBMgxbl39KtwnHRmm7MjyOh8nqzI6uQne3B6VxoLAg
         aqrSeYrTn5S9tiFBSB3S98mBINDwVyu5l6MKmoCUNjsnm/agHWIl/6jSrb0loehnfVKi
         2FkSnWwKe7Es91s4Tx18DWpQlle64zZzirOMGjtyqMrMamRFCEISo4SJkte4UixC20WO
         jkr5ksn4fDcJ/q8XcPPp+SLAZRRYcFrREODa4RpT+uZRUVqMXvCVz1xQIww+GfyAn7YE
         oJ+4ioe9dvTP9XcWPC1JGc+wFwaF3DM+LkAfXrTY8wiNfmBlfPRxzjV/Hp1xZZaCXs6q
         iAuw==
X-Forwarded-Encrypted: i=1; AJvYcCUvtXLjOjgKSYiE8OWzqhC7Q0PpJ5YSW/q6ME/0hszsjEBQOTFsNEnCdrc2N/cHzV440qLyEBkk7/usCog0IWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIpLzezZwf8/4P6kr/dPXK/GkteHq2VHpKA1+vhXCtXo3NgKCL
	t7YuR+/qyEUqzFI2Y1AVGcGVydD5VwBshnJhV3c2nnbOI7HeAZH1
X-Gm-Gg: ASbGncuN31RsD4aTTs6kzXLXFTe829+FHpYdKsWU8kutwvABcPVyHgBFAOUM5bmyOrO
	Lf0Ex6+qOY1R69LhXfp08vCuNx7vs1iwYqOHB75K5MYM8ILjn41Uz3+T3cPs0hsaSPYVuJM+8y2
	mkASZu4WU5XQGw8MvbU5aLRRQHiz66EzL3f6dnA8kpz1LXmTxFzWTA1h7E7Gs9rs9xH7I0FTaxe
	5O1Er2L3PIcZG9jZ3BIuCV6IZrsUzlCM248+4g2IJ3UfIPPtAegav3AFz2ZP4xjxtxYOw4Z4fNo
	a/tAXOIZzH0icx+rY/W24lCt4dc7IItArhZVbstE/fihTn4y9X8EvKg7iQR38sDeTLXXUWzZP9K
	Rw7qMYNroEr1Jxfvs0nilh3TofeLKJtKA3KSiX0Kin9pVvBHvnyPdVGNDuLDj8S8=
X-Google-Smtp-Source: AGHT+IGZrLPyzUFrsmUJ6bjiHKaOKcN6z3XUtUDmp1EbfQa4TkA4lIxe1N3KZXeS7nHJqoz8wrbu6w==
X-Received: by 2002:a17:906:4795:b0:ac1:fa6f:4941 with SMTP id a640c23a62f3a-ac330253720mr766195566b.13.1742068927072;
        Sat, 15 Mar 2025 13:02:07 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac314a489c9sm411456766b.152.2025.03.15.13.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Mar 2025 13:02:06 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v10 nf-next 3/3] bridge: No DEV_PATH_BR_VLAN_UNTAG_HW for dsa foreign
Date: Sat, 15 Mar 2025 21:01:47 +0100
Message-ID: <20250315200147.18016-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250315200147.18016-1-ericwouds@gmail.com>
References: <20250315200147.18016-1-ericwouds@gmail.com>
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

br_vlan_fill_forward_path_mode() sets DEV_PATH_BR_VLAN_UNTAG_HW when
filling in from brlan.1 towards wlan1. But it should be set to
DEV_PATH_BR_VLAN_UNTAG in this case. Using BR_VLFLAG_ADDED_BY_SWITCHDEV
is not correct. The dsa switchdev adds it as a foreign port.

The same problem for all foreignly added dsa vlans on the bridge.

First add the vlan, trying only native devices.
If this fails, we know this may be a vlan from a foreign device.

Use BR_VLFLAG_TAGGING_BY_SWITCHDEV to make sure DEV_PATH_BR_VLAN_UNTAG_HW
is set only when there if no foreign device involved.

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/net/switchdev.h   |  1 +
 net/bridge/br_private.h   | 10 ++++++++++
 net/bridge/br_switchdev.c | 15 +++++++++++++++
 net/bridge/br_vlan.c      |  7 ++++++-
 net/switchdev/switchdev.c |  2 +-
 5 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 8346b0d29542..ee500706496b 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -15,6 +15,7 @@
 #define SWITCHDEV_F_NO_RECURSE		BIT(0)
 #define SWITCHDEV_F_SKIP_EOPNOTSUPP	BIT(1)
 #define SWITCHDEV_F_DEFER		BIT(2)
+#define SWITCHDEV_F_NO_FOREIGN		BIT(3)
 
 enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_UNDEFINED,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 1054b8a88edc..43f04bd69d73 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -180,6 +180,7 @@ enum {
 	BR_VLFLAG_MCAST_ENABLED = BIT(2),
 	BR_VLFLAG_GLOBAL_MCAST_ENABLED = BIT(3),
 	BR_VLFLAG_NEIGH_SUPPRESS_ENABLED = BIT(4),
+	BR_VLFLAG_TAGGING_BY_SWITCHDEV = BIT(5),
 };
 
 /**
@@ -2182,6 +2183,8 @@ void br_switchdev_mdb_notify(struct net_device *dev,
 			     int type);
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 			       bool changed, struct netlink_ext_ack *extack);
+int br_switchdev_port_vlan_no_foreign_add(struct net_device *dev, u16 vid, u16 flags,
+					  bool changed, struct netlink_ext_ack *extack);
 int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
 void br_switchdev_init(struct net_bridge *br);
 
@@ -2265,6 +2268,13 @@ static inline int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid,
 	return -EOPNOTSUPP;
 }
 
+static inline int br_switchdev_port_vlan_no_foreign_add(struct net_device *dev, u16 vid,
+							u16 flags, bool changed,
+							struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
 {
 	return -EOPNOTSUPP;
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 7b41ee8740cb..efa7a055b8f9 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -187,6 +187,21 @@ int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 	return switchdev_port_obj_add(dev, &v.obj, extack);
 }
 
+int br_switchdev_port_vlan_no_foreign_add(struct net_device *dev, u16 vid, u16 flags,
+					  bool changed, struct netlink_ext_ack *extack)
+{
+	struct switchdev_obj_port_vlan v = {
+		.obj.orig_dev = dev,
+		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
+		.obj.flags = SWITCHDEV_F_NO_FOREIGN,
+		.flags = flags,
+		.vid = vid,
+		.changed = changed,
+	};
+
+	return switchdev_port_obj_add(dev, &v.obj, extack);
+}
+
 int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
 {
 	struct switchdev_obj_port_vlan v = {
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index d9a69ec9affe..6bfc7da10865 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -109,6 +109,11 @@ static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
 	/* Try switchdev op first. In case it is not supported, fallback to
 	 * 8021q add.
 	 */
+	err = br_switchdev_port_vlan_no_foreign_add(dev, v->vid, flags, false, extack);
+	if (err != -EOPNOTSUPP) {
+		v->priv_flags |= BR_VLFLAG_ADDED_BY_SWITCHDEV | BR_VLFLAG_TAGGING_BY_SWITCHDEV;
+		return err;
+	}
 	err = br_switchdev_port_vlan_add(dev, v->vid, flags, false, extack);
 	if (err == -EOPNOTSUPP)
 		return vlan_vid_add(dev, br->vlan_proto, v->vid);
@@ -1487,7 +1492,7 @@ int br_vlan_fill_forward_path_mode(struct net_bridge *br,
 
 	if (path->bridge.vlan_mode == DEV_PATH_BR_VLAN_TAG)
 		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
-	else if (v->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+	else if (v->priv_flags & BR_VLFLAG_TAGGING_BY_SWITCHDEV)
 		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG_HW;
 	else
 		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG;
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 6488ead9e464..c48f66643e99 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -749,7 +749,7 @@ static int __switchdev_handle_port_obj_add(struct net_device *dev,
 	/* Event is neither on a bridge nor a LAG. Check whether it is on an
 	 * interface that is in a bridge with us.
 	 */
-	if (!foreign_dev_check_cb)
+	if (!foreign_dev_check_cb || port_obj_info->obj->flags & SWITCHDEV_F_NO_FOREIGN)
 		return err;
 
 	br = netdev_master_upper_dev_get(dev);
-- 
2.47.1


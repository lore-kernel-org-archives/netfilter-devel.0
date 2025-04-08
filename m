Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F9E221D98;
	Tue,  8 Apr 2025 14:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122455; cv=none; b=Z0AKQEcFWe2NJ+RXxB/ZAVvzH27Xt1KBXxmFgE0XJauFuLZvWLzMNwi3g6f4wLUnD0vkv5Lu0WV9hK6mFm07FbvolSKdyK3/ClmT9d/zZ/ap1FLeCUtIHAr/cIRJcC1gcuHEpjsUmhr1xEfnfih3hAQaiJ0ZjN2Lu6o2kEoXxo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122455; c=relaxed/simple;
	bh=Lvry95GQJwlP8/5RPhkqWiou9zm2bdrbI3AcRKPQU5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdQOxWN8mBczPy4nfz/M37Nu5GZkuhFtupAULBJdfi5wP6+NoIsHGYlXgN0kW/wKfDBBvhtV9bpF79AcTth7NzfXJqWhww4gKiRUO8owxVJjzJnDO1jxdO10GgACWUjOeaUDDn1MGEKsMtZFBmcfOge8Z1/On9VxoljmI7c4J24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=doXUVLQh; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="doXUVLQh"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5e5c9662131so8856085a12.3;
        Tue, 08 Apr 2025 07:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122452; x=1744727252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f5hVfTf2arO5GWUz5oTiT6uflST5kWqrKsLVRY0e9e4=;
        b=doXUVLQhFEg58gregAllO6BFcXKQuDVKjKAhJ6DwB2jPaWHd4mDHyYPfvkuR9PIHbN
         CxYHBYnLRd8d9fvnxD81pXbatiQ/qUWbuaY9PQHiXfWUAtKsrUV2FGA2G63shCVKBz9R
         BqQ2OvsXZ2JXOJ9BsJ0J8N5BX3pt8IAlVJwUs2InszJi1I7c/dLOCtMDturXaG2ZlJIh
         kuNRcTsYTkvAGDB1t7Qtt0KhTFKDHdkhhlFhU1aX1/JHZKuVQUeV+5YgMLLGgUftT1hH
         UfE6pK9S6NFNJjJPoV+cv5qoNEI/eZB4rbqhjng3PSDVPxW7bV1rmMSzcb4p9PaMCgoM
         y+Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122452; x=1744727252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f5hVfTf2arO5GWUz5oTiT6uflST5kWqrKsLVRY0e9e4=;
        b=j5XHBs9TJbmt/FaLMdGBrxQ2yykDt8onPCrSwXjVWW3+cy+N24qeML9L6z/JMIfQpc
         oJ+2KtKL7sABF6h/q33KMFpMvQudTDFOEVhDvCJUHxjYoZtgDZSNSfiDXgcvmMwl9GIz
         pp8WfbofQEXa+aFrD4LL7x7kF0oEaus16jrB2vUK2RDYHnF9JMMlFyLLAZknk3DNN+Sr
         EaR5ykX4Jxk/+Se79LZyZK4WR/DxftKRAYHTEJTaKWe0l+9+Rqwy2aYDhsIQxllGAGOQ
         uFTRxu20D9ZwU8so+y4Zy7omOkDyC0js/vOq+Zq62B1WpAmgGl+0s7Exb+5bxMKJwfsd
         Qmhw==
X-Forwarded-Encrypted: i=1; AJvYcCUtdUZwOFGSEtkb0xtUMoa/ydqwCH3hm66faUOFkgO1rauQr+02Pud80xxgbo3GDH3n9GC6h3OORpyED3D6OPE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxsPVL5Ebe7Z01B93Si2nl0wmGXC3TEb2OvKVWKEFUJaIP73Vh
	ocVCQOHH9c9V7JcSZcJSVLqKnqVkIFo/YkF9V021j6jUwVLOSZsT
X-Gm-Gg: ASbGncujJq3XmZzX6HHXLMOpAkmSRa5kg/oYW3uV9ad6Ps/gcAynRVqM8OhwlnHPlcq
	HubTlDkoVLSnkaN+ooqTfps09ODfQQbvzMNNMZvHTSUgk6uR61Se6Tz8pSq+m2BhRKoLLO7sp0W
	zCZQtj8uZGoFiwlWuZEY/jtPEegDt/fEtHs+jeq+Em4gxvlCtsJRmRpiSV0BhWcGfjmKZydWdzw
	7NVDpANgRmdO5r8VR456ZLhDS4QEr4f0G4IGpi6EmTRcrfs2gk+Wc64uUXb73g8noljuhRNH+lu
	k0+bGImp4K4tNekaQkyNXlWoDAGNOh0WskSTOklpr9GH31N2ecV3AKYQP215ShZXlGyXFiDVl2S
	GLHdJyYdBlbOYePjpEtWfoSIQbhdzjhg4wFJTKYDEFWoW2oq/bBJJHxqQe7xEl6Na1iqHHJbtiQ
	==
X-Google-Smtp-Source: AGHT+IEuLjCy67M9CtlT3nZ04pM5kJoHgL/3yFPQcYopdUGXz0qAyUXNTcpg5/Cz/ryz6ZkZMTOq8Q==
X-Received: by 2002:a17:907:3e90:b0:ac4:169:3670 with SMTP id a640c23a62f3a-ac7d6ebb899mr1330218866b.48.1744122451413;
        Tue, 08 Apr 2025 07:27:31 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfe9be67sm910393266b.46.2025.04.08.07.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:27:30 -0700 (PDT)
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
Subject: [PATCH v11 nf-next 2/3] bridge: No DEV_PATH_BR_VLAN_UNTAG_HW for dsa foreign
Date: Tue,  8 Apr 2025 16:27:15 +0200
Message-ID: <20250408142716.95855-3-ericwouds@gmail.com>
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
index d5b3c5936a79..c3395320a4f3 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -180,6 +180,7 @@ enum {
 	BR_VLFLAG_MCAST_ENABLED = BIT(2),
 	BR_VLFLAG_GLOBAL_MCAST_ENABLED = BIT(3),
 	BR_VLFLAG_NEIGH_SUPPRESS_ENABLED = BIT(4),
+	BR_VLFLAG_TAGGING_BY_SWITCHDEV = BIT(5),
 };
 
 /**
@@ -2181,6 +2182,8 @@ void br_switchdev_mdb_notify(struct net_device *dev,
 			     int type);
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 			       bool changed, struct netlink_ext_ack *extack);
+int br_switchdev_port_vlan_no_foreign_add(struct net_device *dev, u16 vid, u16 flags,
+					  bool changed, struct netlink_ext_ack *extack);
 int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
 void br_switchdev_init(struct net_bridge *br);
 
@@ -2264,6 +2267,13 @@ static inline int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid,
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
index 4d5fbacef496..bf252d116ed3 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -760,7 +760,7 @@ static int __switchdev_handle_port_obj_add(struct net_device *dev,
 	/* Event is neither on a bridge nor a LAG. Check whether it is on an
 	 * interface that is in a bridge with us.
 	 */
-	if (!foreign_dev_check_cb)
+	if (!foreign_dev_check_cb || port_obj_info->obj->flags & SWITCHDEV_F_NO_FOREIGN)
 		return err;
 
 	br = netdev_master_upper_dev_get(dev);
-- 
2.47.1


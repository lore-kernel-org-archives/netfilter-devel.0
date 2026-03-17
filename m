Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1E539DBDF
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 11:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773745443; cv=none; b=CiZVbtBM2IAAzCMfa4mz/V8rWwWUUsRpkwZgLgaqtlEgEgTO11La01Rs70h2UuErcu2y3nfJIqB+a243Os950XbUJAemqLsqCxAMSpj+DH0Ezp+ckZkSJNY71sc5jXWUFSSZVQ+pv1eIECYWH9VDaUAYD48H+202XWElnZ3aC8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773745443; c=relaxed/simple;
	bh=KNMdTz0dMtsZ0/bH1FzXk+0DNsqD2IF/dA5rxowQT18=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rx3tGjTQ8EcNcvgOr86gBhMabuB07YZiP+IlzXbHElP6sHQfOLMocLsZxHWKefpViNQeFmbrM5LYWZmBx7ccFdmYNk/xccDOeQ3uAE+KEhVhciI01IJksex45cqj5ENiyHp+MI+8PcJ8gXW+kArs0d5sYLoaihbncSEYKU0iCTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OgO5Ns7W; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OgO5Ns7W"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b97a604e098so394860566b.3
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 04:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773745440; x=1774350240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N+sB1F9ylcq5EEMpOQgUFXx9/JMgB+sZnio0KZ13MVg=;
        b=OgO5Ns7WLfKdW2/u+iUMNWrD3g+Gp8awfDhS9vA4/291hZClk594QsheW0UQu4HelG
         J73i7x5kMI9vJ3w1b9ADmZltai2BmOUyvxyl6wzYtBaQAeobpMAa4+n31mhhz19Vlhiu
         yA4OBhCVmiLtwCvkD6YpEI6odDLuHmqb4Gjje4NzCQjjdHLmaF1VHCVl5QxUKZBTF7qV
         EZPHF9SqIeqRy1czO4nIxfK1nKYeUMAQGgsAoTi8JZHpiK7waTZ+6VQAgktogIc7MQk0
         2xpTin/OtUPmr7stXO8Hj7iK/cMNgnLf9xlEDEDhc7lgxPPDjEgNyM6eGDfZhJhjJ0Po
         HKXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773745440; x=1774350240;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N+sB1F9ylcq5EEMpOQgUFXx9/JMgB+sZnio0KZ13MVg=;
        b=jgOQtfuNFE6X+2M+voate9Syu/9YIWZR1EGm3xUo91Xo0LU119mSR7PEYNugXVPJ8s
         3P0Eq2Me9+kKbygK33TCRK+qta+rBSeUE267WcbTVmt5xD3Yo6oVuQxYP0lHCyvgLA/A
         c0w4NG8qzSTpjK1RWkGItev9kSLZStZ5IrcRnas8sJx9HHAgoICtyNj1fbxBFOVL6jJs
         0xEnUYokeZwMI53zKQ1LzDT4Ih6BfWCfk/1+zoxElfLYTnR0Y0zRucyXneWli0zJCfgf
         Vy2SE34B8A+pHemrJ41245br3SzAg9+DR0cdpwCyEI/5ALPYFPmZGXfMxX9gWc5ps29H
         uocg==
X-Forwarded-Encrypted: i=1; AJvYcCVvOu4e6znSzCGX7uqxj9LWyjUY+S4GQEqXRoT6caY7a/ojLFwT95cQtk8GPuVvivdRZRp6wGbS2OF+PEQQH20=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4nTG6JxKZbF9JmeJM1Z0LSkX9rYcCcJ379nejM54eLN2MtbJK
	wHxWOTcYcF4Upy8//mtxh/dRgpxRImrE9OKwlk3U5dpCpQkfnS1Vyzf7
X-Gm-Gg: ATEYQzxRPbrmfVTMVlLylHPAZy9aveQLGICztMmHLJfci+Zbk7MYP47z5NQpw7QcFQQ
	GgowEngXYYFM8+BPqnlyzWv4twbAIlb3FnmXvTAHxJ5+c61qK/jae7+V7NYVpsEucn/bwwruqt4
	ugUFrYXs/wDpHBErGYXC00UVn8QWh4cqHS9o2KYO2cTZ3AdEbKvv4Win/aTaLWeynlPsOX9memz
	veG4HpkBGvlq/DTbWxlFmTCtEj15SMvMvL5KYutuq0n6DJ/4hzKyQ9jtdhybWV9qe0sw7FbZjK3
	KYU0XiqsWknSs9PyNOJHGpw6ZMAK4xF1Ffpoi+QKN4UibnabFFqSpasL/OA6AT+wq4aX4MHLUZQ
	RLdujISNwDA8NkBhOlfmmL89FYjjlkvaHJXhLNer1f+ulwZurbFeOFr3wenQ6PqGhNHA3k/mBYU
	orxV91AguPoRQ88VkdlL4jY6xk4Ez9fpOqCxOdkdpyE3gPVlq3q8Ar9FaZRSB5wpy3eO9d8ey1a
	IN1Hrp+3JljG/6raud3FeVqHl62iiZm2KdgDZIDTEmRlqwcynRuS/4=
X-Received: by 2002:a17:907:94d6:b0:b97:9076:f84f with SMTP id a640c23a62f3a-b979077179cmr655488666b.45.1773745439719;
        Tue, 17 Mar 2026 04:03:59 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9791c30cf3sm594116866b.2.2026.03.17.04.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 04:03:59 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v12 net-next] bridge: No DEV_PATH_BR_VLAN_UNTAG_HW for dsa foreign
Date: Tue, 17 Mar 2026 12:03:47 +0100
Message-ID: <20260317110347.363875-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
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

This patch has started in v2 of my original patch-set. It remains
unchanged from v4, always moving along in a patch-set. The Acked-by
from Nikolay Aleksandrov was added in v5.

Changes in v12:
 - Moved to net-next.git
 - Split from [PATCH v11 nf-next] netfilter: fastpath fixes

Changes in v10:
- Moved to nf-next.git
- Split from patch-set: bridge-fastpath and related improvements v9

Changes in v9:
- Moved from net-next.git to nf.git

Changes in v4:
- Added !CONFIG_NET_SWITCHDEV version of
   br_switchdev_port_vlan_no_foreign_add().

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
index b9b2981c4841..5a6f7d8fca1f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -182,6 +182,7 @@ enum {
 	BR_VLFLAG_MCAST_ENABLED = BIT(2),
 	BR_VLFLAG_GLOBAL_MCAST_ENABLED = BIT(3),
 	BR_VLFLAG_NEIGH_SUPPRESS_ENABLED = BIT(4),
+	BR_VLFLAG_TAGGING_BY_SWITCHDEV = BIT(5),
 };
 
 /**
@@ -2224,6 +2225,8 @@ void br_switchdev_mdb_notify(struct net_device *dev,
 			     int type);
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 			       bool changed, struct netlink_ext_ack *extack);
+int br_switchdev_port_vlan_no_foreign_add(struct net_device *dev, u16 vid, u16 flags,
+					  bool changed, struct netlink_ext_ack *extack);
 int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
 void br_switchdev_init(struct net_bridge *br);
 
@@ -2307,6 +2310,13 @@ static inline int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid,
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
index fe3f7bbe86ee..556ed24700db 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -190,6 +190,21 @@ int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
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
index ce72b837ff8e..636c86fa1183 100644
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
@@ -1491,7 +1496,7 @@ int br_vlan_fill_forward_path_mode(struct net_bridge *br,
 
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
2.53.0


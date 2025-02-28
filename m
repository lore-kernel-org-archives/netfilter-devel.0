Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7646727F4D0;
	Fri, 28 Feb 2025 20:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740773798; cv=none; b=Oh7v7g+wwPK7h+xbSozj4z/yz7h4Kz4/9qLTe7FNy4YpyJDS/iVle3wDwokVKSD8phOBgUpSB087m4yb729pOUV6oVf7DZB/V2Xe92aJF4kgoEsJxWkJzhEjL8brcYTsEiJ2RugyXnWAoRpktz7joCQ+M++mz9SJASnmQErXFB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740773798; c=relaxed/simple;
	bh=7mcwChSKiCve0A+5TUtOf0dA+ljFl2navKj3ueTAL1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVmx0MOLRrM9W/Zda3004BezgCmhpI96fNIugL+vYBie5pj26SNKSg3AMAtaL0T2ORr3SQFtAGBjprevxISSfh4T0ADPltJx8My6qVautw0pR9Rbrjw1jr4tY55thk/KvMP6e7rnzlPbn9dk/4+/wvvzJNxyNc8YJuqJTT+2V1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=au5RnxOJ; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="au5RnxOJ"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-abf42913e95so108840566b.2;
        Fri, 28 Feb 2025 12:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740773795; x=1741378595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KGHKkM4qxKd9EB0pt79Yst8lznP4qD+tbsrDkGhaAL8=;
        b=au5RnxOJendRdzWYFJ4KRZuSm0VG/InfJ5d48OuU2i6Jb9lhuvKBSUjxOuA7vWgyrC
         mou9lQM/St4WmqnrDIHqPELh53N0muMt3wupK3U2cuk325UkjabEb3zfXLMb3VQtIwCV
         93iS7Me/L+/xtWo++ZsV9mLZu1n95NNi2wkNXgH9igAqRy+CVdTyhy1UqS/pS1+4Wg1v
         P84tOUHmVHPKBdyvJHMaS63ti9XoJNMV8iA5FTyCzmf4ZfMEXoVO0pNoCkgGCWNLg2sW
         WFia8DlAw1UDNwiwXmIVh5e05NEntsilT1GM4ytclFyFW5+fpcpV6eD3Vp1+9VFTNEav
         EvqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740773795; x=1741378595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KGHKkM4qxKd9EB0pt79Yst8lznP4qD+tbsrDkGhaAL8=;
        b=MR8S7YWin6Sa6Azr1KvmBQvDtz59TTo6y8dAcHDbNjZRa34KIoUkm3TXA5h9ycvaFx
         6z+ypvIUAYHZxfB2LVuk0iwxmLE/JKUR7YXZKXF3kuWtZlj213BQ+fssrThUf6tYZNyI
         nQkZalNkJp7V+IYA6YaL5D/zuzn+XCjfkX2ifiUd6sJcsNQE8kJ6PJu5sR9qX7C1hghg
         Pgv/C4SbIGX39KlIJBozJAlcR5ecNbHbOiCP3bhP7kpWNfLvPPEyrgFkt/jubrHPs+JT
         MHVodtNO3J7ENlJ1vQjqCaxGhAx8UvZOjZmj2HG2k4L6k71XmB3CecrG7nfUOpe7f4K9
         32Jw==
X-Forwarded-Encrypted: i=1; AJvYcCUQ8PMNJRE4QSEdsctC/uf8ESTuXlFuaSKd2UaDOLva7gs2zOEkrpXtuZYQ7b2HH9bkfbMHccV5xx8IYYee@vger.kernel.org, AJvYcCV+hwjejqjMBYLELB6qJMMvNw0vhke9WEGOfBEQvIXzK6Sk12yikoqjEHOYQUX7BdMJ10qdLMPSdLZOBDej2wli@vger.kernel.org, AJvYcCVQkWFozdA6Ps7NLjfwLuSo2tIwJV6GDg1rgN9j140RDdoKlVEZDUI0m8oOS9oSmpPqMGuRyru0xARvP27ZtdU=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe148+LKUsnXD79PJGYtLd6ULn4mWTdXvScQhxvuGxaXNXf2SM
	RyJVhdi1xpMaTvrRBPv7gbDU50BN3FFAjMsy8l4qC7Sr2bxz9tky
X-Gm-Gg: ASbGncuSUqukPxM1/bwsHZpLb336iAAPeKlDeyMLbB5mbRK/0wms66nWGUN3TpIC5Rt
	/3fd94Z7X/G4cogWZqzYwKM4rOhAUk7XfZOKws7RyZ+VkFyYbCPDK15ubKqODP3DmRuIjPpabGJ
	Frb4H+rtoPZaPu/20eGo5EClpvnVkHdklcjB0hGFYlDsmcd0cDW8fakvheFc0ZMqOFhqCG2MQzi
	qc2YqSLhrEM1KhLj71gSf1PDmtM3NPlTRgg1xpRDbsCKn54PMf2faqJ4fB1VDenoLCPVLvG0vmx
	UEsyAKJDJGgnqgNrRi+m1TtUuPWWdiieV6rcMLMQmXrPt8WLQ+g+keWWRt876tXHRC1iyEDP778
	CXWnwGGKALl+goBpZGoShh16e8dNngORuinw//TeTw5s=
X-Google-Smtp-Source: AGHT+IEkQhpenLsv9Nobf0wiiAys0Z5V5MCyZxZmQpmyL4y9KNHC8I8jD08d28fmF8UGgHnRX7Un0w==
X-Received: by 2002:a17:907:9408:b0:abf:19ac:76d with SMTP id a640c23a62f3a-abf269b9a91mr542028566b.51.1740773794665;
        Fri, 28 Feb 2025 12:16:34 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c755c66sm340812666b.136.2025.02.28.12.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 12:16:34 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
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
	Ahmed Zaki <ahmed.zaki@intel.com>,
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
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v8 net-next 13/15] bridge: No DEV_PATH_BR_VLAN_UNTAG_HW for dsa foreign
Date: Fri, 28 Feb 2025 21:15:31 +0100
Message-ID: <20250228201533.23836-14-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250228201533.23836-1-ericwouds@gmail.com>
References: <20250228201533.23836-1-ericwouds@gmail.com>
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
index a0b950390a16..b950db453d8d 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -180,6 +180,7 @@ enum {
 	BR_VLFLAG_MCAST_ENABLED = BIT(2),
 	BR_VLFLAG_GLOBAL_MCAST_ENABLED = BIT(3),
 	BR_VLFLAG_NEIGH_SUPPRESS_ENABLED = BIT(4),
+	BR_VLFLAG_TAGGING_BY_SWITCHDEV = BIT(5),
 };
 
 /**
@@ -2184,6 +2185,8 @@ void br_switchdev_mdb_notify(struct net_device *dev,
 			     int type);
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 			       bool changed, struct netlink_ext_ack *extack);
+int br_switchdev_port_vlan_no_foreign_add(struct net_device *dev, u16 vid, u16 flags,
+					  bool changed, struct netlink_ext_ack *extack);
 int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
 void br_switchdev_init(struct net_bridge *br);
 
@@ -2267,6 +2270,13 @@ static inline int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid,
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
index a18c7da12ebd..aea94d401a30 100644
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


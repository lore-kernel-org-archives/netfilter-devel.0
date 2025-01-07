Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9A41EE7DF;
	Tue,  7 Jan 2025 09:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736240784; cv=none; b=WXtxj5Mt7Mw6RZWmXWTDwMF9zYxC9UDLwYCiCgNBFY8Ea1NB+uWL+jK1aQ0FTY4RZSEcTKhBER3N6hHJN80PPUUeYjE7E3fC/TwNuURF6L3BBkxB2ZKMFLmJCoqcP2tZYVjnY9ZAoO/T2N5omWCAZuGBtVnP0AzvyQIvUX/UtSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736240784; c=relaxed/simple;
	bh=HatO8o2t8hOjMXOG7SdN9eW8i9smGPaf05kEwn4y+GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IO90bMYBVnzfz4Zg9uS5NiUHZsj755LjwVCSF/ibTmuNIufnn/LLMQqgWgM2NoOEFw06tCDIohIvUssrMvmQfIWhe37Udk6gbJPhW37w2xkWGiOz+LcrTVJC41qgL536Bj5OEfrrroiKSoqyPsDWkKSUjPU6jG8hlWLyGShC1UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BE2IwmdC; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BE2IwmdC"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a9e44654ae3so2550110066b.1;
        Tue, 07 Jan 2025 01:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736240778; x=1736845578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c9/TvKRPWpgFkI5Z6u1yRjdyakFY+K8HugvLg1dhslU=;
        b=BE2IwmdCGyheThGvgzfI8jCmkteQRdvW1xfOImS1i3ROCR+oy1lQB44wn3bkGk/z6V
         AtwTqbS/uxX5RqQezKkae/L/CA9bLDfSiYoy9IjM3II88HSpWyZQbQK+9W2kb7Bm91nS
         pxM4ViXsSx+6gt32404aszTm82U4+eroHUHHiWlvER54ZBRRBGyr34QkZnZU5AokMlx9
         WLWQ29KGnYOxJJ2bklEeFQ3DQBVc7h6w+3Js86cfjygrH/AokxQluRxKYhFEp3XXTAsQ
         yt3rIMvelTpLIfd0vFKt3C8HcoGadhG7kqJA2T6l198Wp3UA8+t8XYVjOp5U6QCz2UL/
         VqCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736240778; x=1736845578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c9/TvKRPWpgFkI5Z6u1yRjdyakFY+K8HugvLg1dhslU=;
        b=n6h2DrZIzWZx524x0bzMl/axwyms6AqO0J9yawGyXpGwnD+fL95509p1on3m4Zqxfq
         FwOkBavEkF1U/AY7j3CDv7Rjw/HPXDOOI5JrF/rENNQHVM5eibvQ+Sj0z+TJy/nL+FLF
         v0wJ4Dv5r47oWvIHEk7MmHZMtb28TdCe2exttULnqQXEyKC6ofc1XQc2mA4atKKNM98x
         EkXG3ZHVkVv7AIMKSZyghi9DTQAnNBFx6mC2IrKnRNuTaGtQk846CAPlP1BBzVp6KzaL
         vDT2c1sJhA5SooBaZYmpcmHs3sjBGWE6ZIpF2vTAkns9RheBsDXY2Z+iZU+8qBhPV9yJ
         2d/A==
X-Forwarded-Encrypted: i=1; AJvYcCUPutNioYaeJ3hxnC52EZ36N2Gy7WkFGyXhPDu/P2fJ2vB8FLC23p5jVmkaZB43hx9l4QrBU0XhcXikR34=@vger.kernel.org, AJvYcCWD/p+Ry/hBOTEAFUx3BSDul3Wd5TaMV810MRTu/Bab71lvP+VYqYv83b1KT3vFZpXK6vSN+IQFMqucpU+UJNsN@vger.kernel.org
X-Gm-Message-State: AOJu0YwgA51JJ8wjGpgMbdXNglS2TVlPKiSNzk+s3jSkQUA4/u4RzSG6
	WqQjTQq3bt0/6iruRfmjuNFN5M3TTQ4Vz2+cjEp6WorYCXAjCBnp
X-Gm-Gg: ASbGnctCBRSYfNwaKQgkEsyANfkSy7zU2y1yWaDdLCzoiERJ8KwTZYnbfB9hp2SSIJr
	KPM+XmlJ5ck+/LVYWRH2lgvF3y+VLkvG5LSdFPX8NTZA4YE7zxiThVZy2hOWaUFQZLedOjgtlsW
	B8WHdZfdC6WR0aqryTu4/w7PZEqMY38IUo8Gm1tUMtahwoS6JVl4D1RFiHw1tumVN1xDFhzeWQj
	2Bn/xlK9u08NeF16ru83yZCoHmBFAe/Ksmw2o5Kxp/cArn7KYHiChUFT3VMjisRg87fRPPbxwOL
	rZYHv9Ne03RIGmPDtMtWn2nIzYZNEyBMK7CX3j8RaSoRDawAMurk+AhbGdLpAb7E3vot4w+jpQ=
	=
X-Google-Smtp-Source: AGHT+IHdVy6Qh1qZGtVgd8n+OJxf5iK/E+S3j6UfqiQPaQRG6QNZMxXigkGNUkGK3KdZcEdkCWqhIg==
X-Received: by 2002:a17:907:9304:b0:aaf:c27e:12e9 with SMTP id a640c23a62f3a-aafc27e141emr1105602266b.14.1736240777946;
        Tue, 07 Jan 2025 01:06:17 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80676f3f9sm24005333a12.23.2025.01.07.01.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 01:06:17 -0800 (PST)
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
Subject: [PATCH v4 net-next 11/13] bridge: No DEV_PATH_BR_VLAN_UNTAG_HW for dsa foreign
Date: Tue,  7 Jan 2025 10:05:28 +0100
Message-ID: <20250107090530.5035-12-ericwouds@gmail.com>
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
index 94603c64fb63..f60a7bb7af26 100644
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
index 07dae3655c26..3e50adaf8e1b 100644
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


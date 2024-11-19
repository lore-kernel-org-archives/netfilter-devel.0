Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CF41CB50D;
	Tue, 19 Nov 2024 10:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732011577; cv=none; b=ibzbki5lS8/gAlkNlugdacHu5rFgipzAVkS7g31/vy+vYQuVZ4mTHFbH+J+c67a0Xpj6GDrZgdbuFXCCf9AS3OKU8O9gTkiHTrcm8+/mdXUO/7HT73Q9l/DdPT+RD6Bx90BxxJNEzh3xbSM9S1SZYMiSgta+xiSjOX4fNc8Amwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732011577; c=relaxed/simple;
	bh=E2mPktW4wL0uSe0js7TIX+fvCn8bpYhpCdTSnyhA70M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHfcFvAwykjQnlYPkPfzymJUSMIzUwrqXi5muHcVs50k8WuF/x/kni47JDFkEZgU9voI6fuwxoL9W5vrEg+GQIWBU6cFJx+dMcpY2ILSNJsrzaTE1pfVf3SNSdPTWkco8WnysxR7ict//Bu9koGHVGcv1nFFAitwvumcx39sQ5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JuowTcX0; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JuowTcX0"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aa4b439c5e8so346469866b.2;
        Tue, 19 Nov 2024 02:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732011574; x=1732616374; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iRAtb8ene+/sz4LQnXwEVfer/8Rq7ZF+bD6/DZ4QZnU=;
        b=JuowTcX0i1zWzPvHa+bHuoZFxNcI19Hti2Lts/Rqm49kg2ihgLBLOrD2WZUJEcII9z
         9RY2efT+kNwVU59bPBrni5V7Mi5IHS9QPYqu7Z+5x77bYLD54n+lYNjTgelyOO692pBa
         mR3sulP+xTOMbsxnjBSNYcHggNmYRAZWbnue8c3xl0NrbaAky1NQ4bclTRNrLQvm0Puw
         RUTrXEWWJYNsB1WbnxDxacQzpmuom6iH/+KzKv6hSFEUcFhIGAY0ECUc7a6uHON39Zml
         votCTdCW9QZJ1GQUwq5rHQc9MPm0AT7mGCbfwKb/HO5WfdqajTJzilIqenBMcStN7Js6
         /qTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732011574; x=1732616374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iRAtb8ene+/sz4LQnXwEVfer/8Rq7ZF+bD6/DZ4QZnU=;
        b=FfiKUjj1Sh22L+2QaOOzkY1Vv2GoKHTGkslkSaKJfamHB26Qa1lHtI5XWrsJ0llvrj
         0nS/mrQFGAl1ICbZlJCYH/DY4Ay9cPw1sIVz5NMTjV5X4D0eF/qzM7Fx76Sra5enqQZb
         oD9agyGyvFQUZ8TQcp1Q3LDwit9AGpdwkN5z7l6Y3eq41STePzLUD9+LCnhLx7qjoMi2
         z2e++EfUmpu46tncQFe6R7Htm/KfH79Ysyv5Q2gX5fMoKDt3TeLShC2AGymQbDhfrGgN
         CU1Oq2WMnAPLHZpXAPnjtkZXXYAzLJxxQW0qc6sLkb9U/Ua0rYItGM0jLmZ4igzjb7vP
         DugQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWF8SEOIlLcMGRslMJjkfrCTzDoD+BRkiuF9b1/xCabe67RV9zoKIGqBTbHWnYt50W0pLf3c1g0/VXDq4=@vger.kernel.org, AJvYcCW6tD2+MINe1k0UB//EIVq2im3NOehAKjtbuJupCjBpDHStrkW6CuYLSMfK11klNs2QyKTbOYF7u5tPA+thuWUD@vger.kernel.org
X-Gm-Message-State: AOJu0YwhD0KUVGAHt+/q+ijgRXA8fPFpWXl9hgLQTReKZsoqLVhhDMIH
	qRMfHyryr+c/fRgau8quxH0HbpclwWMOywjE884aZzbKtKIJ7+Yc
X-Google-Smtp-Source: AGHT+IGSdzD5FB5lSzDOWRwk05h9KQwL4lMjDIm3lR195Fp/caQ3LhVr0XgClAvYQhvSqXEJ92m6RA==
X-Received: by 2002:a17:907:9344:b0:a9e:8612:f201 with SMTP id a640c23a62f3a-aa483555dd8mr1451247266b.59.1732011574083;
        Tue, 19 Nov 2024 02:19:34 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e081574sm634875566b.179.2024.11.19.02.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 02:19:33 -0800 (PST)
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
Subject: [PATCH RFC v2 net-next 12/14] bridge: No DEV_PATH_BR_VLAN_UNTAG_HW for dsa foreign
Date: Tue, 19 Nov 2024 11:19:04 +0100
Message-ID: <20241119101906.862680-13-ericwouds@gmail.com>
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
 net/bridge/br_private.h   |  3 +++
 net/bridge/br_switchdev.c | 15 +++++++++++++++
 net/bridge/br_vlan.c      |  7 ++++++-
 net/switchdev/switchdev.c |  2 +-
 5 files changed, 26 insertions(+), 2 deletions(-)

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
index 046d7b04771f..977285925422 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -180,6 +180,7 @@ enum {
 	BR_VLFLAG_MCAST_ENABLED = BIT(2),
 	BR_VLFLAG_GLOBAL_MCAST_ENABLED = BIT(3),
 	BR_VLFLAG_NEIGH_SUPPRESS_ENABLED = BIT(4),
+	BR_VLFLAG_TAGGING_BY_SWITCHDEV = BIT(5),
 };
 
 /**
@@ -2175,6 +2176,8 @@ void br_switchdev_mdb_notify(struct net_device *dev,
 			     int type);
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 			       bool changed, struct netlink_ext_ack *extack);
+int br_switchdev_port_vlan_no_foreign_add(struct net_device *dev, u16 vid, u16 flags,
+					  bool changed, struct netlink_ext_ack *extack);
 int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
 void br_switchdev_init(struct net_bridge *br);
 
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
index 2ea1e2ff4676..0decce5d586a 100644
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
2.45.2


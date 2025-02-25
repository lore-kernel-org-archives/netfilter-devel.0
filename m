Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED1D19ABAB;
	Tue, 25 Feb 2025 20:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740514590; cv=none; b=JF6/04TMBSIlUGXchZ8sJLTqBeZb5wIbaGwVNcLCg/8FjbnBFHjyiuUly6Bl9sguFvieeGky5WxplWF3DCvhIzItgwWaQ2sD5wseivrIvrJNKWOqpzIpVIejVJO69y8/eOudqYUIYAIycsejBAQi6Q0YqzTTRPcXBSmtkadfQ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740514590; c=relaxed/simple;
	bh=+jkAnTlIlNo9uQVfUenjBgIZ0qFFSL616IljBftWiZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=APUeIBrQZ6iOAIBE7k8I32vdwQvSeT2S+JAhUIWSC6ucGzU3aWwhznAH5gbjtNWHYl+S81HR31E5YYCM3Dj0Nsym4VqRnn7sSDeFMjtFeVfx9EIodjnnf+XmwOWj2CbiJGVBA7LoiyXDdJuPtKVMozHTA5UEMTuvVp/APdIWZjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mZt4ln5f; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mZt4ln5f"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ab744d5e567so32120666b.1;
        Tue, 25 Feb 2025 12:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740514585; x=1741119385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dgOJudjo2uOucFYhoM4hQWtoWfshdP4oya60L27AXlM=;
        b=mZt4ln5fRzWc4Fp78/yLnl0cwziDeEpmWBoslbBH8hZnjZydB1mdtasqKSoZrRhcFo
         qWsWJPMyfwhsCIsUHZ3yfPe491gF64bh54nFK4KBxlg7O2A477EyKtohiN2QUYcAKsGS
         LC/YNt2staJ+Z+YRZmTagvxhDhic8YKWCkBIavWWXDNcwZJYjSa8RK+nZawvmHf2XXKS
         Plni/ZmgkjthOtHufXtCFDVQqdRXkvimy+hZlNG7Zzvwb5+OCQ7fkwy2On4LM8PPOR0e
         qAx5ZzR3yO/leWruAn0mzioVegCtABcSdARdS01D64WCScaL8HOuaViTgVh7csz5h9da
         Ayyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740514585; x=1741119385;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dgOJudjo2uOucFYhoM4hQWtoWfshdP4oya60L27AXlM=;
        b=d+rL7LOABsk+97paBLqWUs9xRShAS3+Fqk3urlNIC4zzr3oN34HOTq4k5Sg1D4cS51
         pJpd+gWLEoTxmDH5mID5RqhFDpVNp/uHdHxFVCFLznaWb8mXVnTUsTp5/uWlcKWVANNp
         hEoFYSjFHhVlpGVg3CD+kZjRmYk++GJ+XSa51qX+VXOW+j6NnGPM9Omm0aaBaXjl2uCZ
         Ykq39KCduR9vZa6kdgiu4EDUXDrAtEt0iSgFxMN0XZ6L+8UzR4ioOFnf/81imjZPuuGd
         L4FwWHi72bhlEzUKhN5mdpqrh+29spbHyLQvfxJuCFmoe63alommpiLpnXrFlazH+L2E
         SegA==
X-Forwarded-Encrypted: i=1; AJvYcCUgRmLXZO+PpzXs4iI7UiVKhb3ednTIs2GCcCXIoLhEVPXEftNH/M0bk3eYZJP1sYPgJ5Ki2XuxfdfwVaqZ2HFF@vger.kernel.org, AJvYcCXqXYDKTiatXg+BHirBFVY4Y9gE+N/rheEJJvaZhAl0W9CzCe0pGrsud4chprjoprQGUilBiTyyryCkd7E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3QXQRfcHx0ryOol7mAChjRZHyxbs2IZH5QuFzR7d+oVjH88mB
	Iz1jOGmhfSu7mjyvFELQgw+M5FcF8RsoeTHt9cd0mYNMSsj5/Uvn
X-Gm-Gg: ASbGncv6XqJyV187FsIlFFRBH1hX4t7LwqWlFwIxT6nBT4BkrPpgtXjU3/I9bw2YJCQ
	AR2m/s6adxsMVeUvIZ7VCQs53mcBduxWZI5aKPfnKoykq75WUhGGkbIKichUbbtYuHk7ACHPp73
	gzN04yDfrwEwvJ1GPeIqxB6UDmWi7F9aBm5QtgmGwAGiCx+kHdNWGlMO1tcpxCPWhnOm7YNQ80z
	c8zQSBhggciyGmtgzXm3N0Mf3g//pO2VWTHujmHymu77GUmTtOPDjnHAF/6Q1KqaO5jMbng/f4C
	YKh77NpP060nOOcFb0OBp+DZxAU5Zs5boMPQV/KuQuRbs1Qi/b8j6saeW1EgkBgsef6ERkOiSCy
	vujI4c2t9IVY1ZglS4UoOtYmZW+8n+V43dY17TtRmlJw=
X-Google-Smtp-Source: AGHT+IFLN9wJGg7Kz7VIeM5ANhYWZnPmhPngWoXUfJixIMnl5RoCQ3QTOOySOedPp/0SLOk0Nsh+hA==
X-Received: by 2002:a17:906:110e:b0:abe:cc65:8721 with SMTP id a640c23a62f3a-abecc6587dbmr435392466b.17.1740514584774;
        Tue, 25 Feb 2025 12:16:24 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed201218fsm194319666b.104.2025.02.25.12.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 12:16:24 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
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
Subject: [PATCH v7 net-next 00/14] bridge-fastpath and related improvements
Date: Tue, 25 Feb 2025 21:16:02 +0100
Message-ID: <20250225201616.21114-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset makes it possible to set up a software fastpath between
bridged interfaces. One patch adds the flow rule for the hardware
fastpath. This creates the possibility to have a hardware offloaded
fastpath between bridged interfaces. More patches are added to solve
issues found with the existing code.

To set up the fastpath with offloading, add this extra flowtable:

table bridge filter {
        flowtable fb {
                hook ingress priority filter
                devices = { lan0, lan1, lan2, lan3, lan4, wlan0, wlan1 }
                flags offload
        }
        chain forward {
                type filter hook forward priority filter; policy accept;
		ct state established flow add @fb
        }
}

Creating a separate fastpath for bridges.

         forward fastpath bypass
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
|    +---------------+               |
|    |  DSA-SWITCH   |               |
|    |               |    vlan 1     |
|    |               |      to       |
|    |   vlan 1      |   untagged    |
|    +---------------+---------------+
.         /                   \
 ------>lan0                 wlan1
        .  ^                 ^
        .  |                 |
        .  \_________________/
        .  bridge fastpath bypass
        .
        ^
     vlan 1 tagged packets

To have the ability to handle xmit direct with outgoing encaps in the
bridge fastpass bypass, we need to be able to handle them without going
through vlan/pppoe devices. So I've applied, amended and squashed wenxu's
patchset. This patch also makes it possible to egress from vlan-filtering
brlan to lan0 with vlan tagged packets, if the bridge master port is doing
the vlan tagging, instead of the vlan-device. Without this patch, this is
not possible in the bridge-fastpath and also not in the forward-fastpath,
as seen in the figure above.

There are also some more fixes for filling in the forward path. These
fixes also apply to for the forward-fastpath. They include handling
DEV_PATH_MTK_WDMA in nft_dev_path_info(). There are now 2 patches for
avoiding ingress_vlans bit set for bridged dsa user ports and foreign
(dsa) ports.

Another patch introduces DEV_PATH_BR_VLAN_KEEP_HW, needed for the
bridge-fastpath only.

Conntrack bridge only tracks untagged and 802.1q. To make the bridge
fastpath experience more similar to the forward fastpath experience,
I've added double vlan, pppoe and pppoe-in-q tagged packets to bridge
conntrack and to bridge filter chain.

Note: While testing direct transmit in the software forward-fastpath,
without the capability of setting the offload flag, it is sometimes useful
to enslave the wan interface to another bridge, brwan. This will make
sure both directions of the software forward-fastpath use direct transmit,
which also happens when the offload flag is set.

I have send RFC v2 as I previously only owned a dsa device. I now have
obtained a switchdev supporting SWITCHDEV_OBJ_ID_PORT_VLAN, and found
there was more to do to handle the ingress_vlans bit and corresponding
vlan encap.

I send v4 and above as non-RFC as the previous 2 RFC's did not get any
comment.

Changes in v7:
- Inside br_vlan_fill_forward_path_pvid(), replaced usage of
   br_vlan_group() with br_vlan_group_rcu() and
   nbp_vlan_group() with nbp_vlan_group_rcu().

Changes in v6:
- Conntrack double vlan and pppoe patch: Set ph and vhdr after the calls
   to pskb_may_pull().

Changes in v5:
- Conntrack double vlan and pppoe patch: Moved pskb_may_pull() up to the
   first switch statement, to the start of the cases. Removed the second
   switch statement. Replaced 0xffffffff with U32_MAX.
- Added patch removing hw_outdev, out.hw_ifindex and out.hw_ifidx members.
- Fix error path returned from nft_flow_offload_bridge_init().
- Cosmetics.

Changes in v4:
- Added !CONFIG_NET_SWITCHDEV version of
   br_switchdev_port_vlan_no_foreign_add().

Changes in v3:
- Squashed the two 'port to port' patches to avoid build errors when only
   one of the two commits is applied.

Changes in v2:
- Introduce DEV_PATH_BR_VLAN_KEEP_HW for use in the bridge-fastpath only.
   It is needed for switchdevs supporting SWITCHDEV_OBJ_ID_PORT_VLAN.
- Different approach for handling BR_VLFLAG_ADDED_BY_SWITCHDEV in
   br_vlan_fill_forward_path_mode() for foreign devices. Introduce
   SWITCHDEV_F_NO_FOREIGN, BR_VLFLAG_TAGGING_BY_SWITCHDEV and
   br_switchdev_port_vlan_no_foreign_add(). The latter function can be
   used to make sure the vlan was added to a switchdev native device.
   When that fails, adding the vlan with br_switchdev_port_vlan_add()
   means it was added to a switchdev foreign device.
- Clear ingress_vlans bit and corresponding encap for dsa user ports.
- Add check for ingress_vlans bit to nft_dev_fill_bridge_path().
- Adapted cover letter description to make clear the patches apply
   to software fastpath, making hardware-offloaded fastpath possible.
- Fixed clang error for vlan_hdr * and struct ppp_hdr * by adding block.
- Updated !CONFIG_BRIDGE_VLAN_FILTERING version of
   br_vlan_fill_forward_path_pvid().
- Removed erroneous check netif_is_bridge_master(ctx->dev) from
   dev_fill_bridge_path().
- Cosmetic changes.

Eric Woudstra (14):
  netfilter: nf_flow_table_offload: Add nf_flow_encap_push() for xmit
    direct
  netfilter: flow: remove hw_outdev, out.hw_ifindex and out.hw_ifidx
  netfilter: bridge: Add conntrack double vlan and pppoe
  netfilter: nft_chain_filter: Add bridge double vlan and pppoe
  bridge: Add filling forward path from port to port
  net: core: dev: Add dev_fill_bridge_path()
  netfilter :nf_flow_table_offload: Add nf_flow_rule_bridge()
  netfilter: nf_flow_table_inet: Add nf_flowtable_type flowtable_bridge
  netfilter: nft_flow_offload: Add NFPROTO_BRIDGE to validate
  netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to
    nft_dev_path_info()
  netfilter: nft_flow_offload: No ingress_vlan forward info for dsa user
    port
  bridge: No DEV_PATH_BR_VLAN_UNTAG_HW for dsa foreign
  bridge: Introduce DEV_PATH_BR_VLAN_KEEP_HW for bridge-fastpath
  netfilter: nft_flow_offload: Add bridgeflow to nft_flow_offload_eval()

 include/linux/netdevice.h                  |   3 +
 include/net/netfilter/nf_flow_table.h      |   5 +-
 include/net/switchdev.h                    |   1 +
 net/bridge/br_device.c                     |  23 ++-
 net/bridge/br_private.h                    |  12 ++
 net/bridge/br_switchdev.c                  |  15 ++
 net/bridge/br_vlan.c                       |  29 +++-
 net/bridge/netfilter/nf_conntrack_bridge.c |  83 ++++++++--
 net/core/dev.c                             |  66 ++++++--
 net/netfilter/nf_flow_table_core.c         |   1 -
 net/netfilter/nf_flow_table_inet.c         |  13 ++
 net/netfilter/nf_flow_table_ip.c           |  96 +++++++++++-
 net/netfilter/nf_flow_table_offload.c      |  15 +-
 net/netfilter/nft_chain_filter.c           |  20 ++-
 net/netfilter/nft_flow_offload.c           | 168 +++++++++++++++++++--
 net/switchdev/switchdev.c                  |   2 +-
 16 files changed, 492 insertions(+), 60 deletions(-)

-- 
2.47.1


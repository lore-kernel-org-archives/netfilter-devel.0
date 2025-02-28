Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB0F1C5486;
	Fri, 28 Feb 2025 20:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740773780; cv=none; b=JmYC5eEC1oAk4N1kEYCz6HVqcuPdacqRJSVmYUOIUy63v4dLONl/kYxtzZyDfldlEYTqjyRvUojp8nJhY8LG9ZciEONK3pgzZURstweAAW+LHCCMOJgNbeoFz9tgUddBnDAUIHJHoQ34/UlG0vaqKpknG7awLvF5Pr2uFCwwhzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740773780; c=relaxed/simple;
	bh=0RFW5tcp4yACx/SekSzgDs+LjBg6Kit2ueqz1ipNL48=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OKNKIuLSmSVxpHcQ4/095x9ELQMh02VxQkiXhyp46wfWzeMCqsW3wCqRcUobcwXJHnfkrJfuT7BDWKXa2lGcAYwbwKjm4Du7VbsxTpNwQT48m/fkvHga0sRQKG0iVf3+t996cEIRgo70WOjww8+f8WvDXtyqQg9/uyVsJAEumf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RnB9Eaw6; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RnB9Eaw6"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-abf3cf3d142so106844766b.2;
        Fri, 28 Feb 2025 12:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740773777; x=1741378577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ukvxk53p9GnrKz00DuMW/t8KFJJE9KRed6XPl/L5xk4=;
        b=RnB9Eaw68fwiDigzDrZGmCbFxTFzWl5XR0AhfzpQdkjAbIbiLqtCrqxLQBT9BoPt5O
         xT7/L1VGfGPE3oa+UJ4MncdZ7XzaVN9EPTKnKvJnR/9L8/c7xWHEKkHBW5RsuaMYmrhY
         8/zVvqe4RDVMtr2QURHMN+17sOZ82gXo1UaP/n7LsvxjTgUubBq6XjyS2hpuTimngIUI
         2cK8ud1GcNo7cB2VfeYOoVUDs8glO/9omBMrb+CGmAl0JFoVBrNlkpcMGVPe5k/eA0jy
         q1xGReYo5HC1CPtTkK0xXnkP71CS57sBAKI/QrrGBaD/MOSNbWthBAbcpQ/rY1NkgjfJ
         cnnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740773777; x=1741378577;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ukvxk53p9GnrKz00DuMW/t8KFJJE9KRed6XPl/L5xk4=;
        b=l2A152PiDXsTsYcSKiYHz+vXubkqkcWlRMl9p+v0yXO18yOY1CYzVYz5ZiRHBJzLZD
         tyI2jwQONz9w0MDLTgqQtlfIiJIbtaN/8x0jQRhVWH7mtXEelUuFWDVhI/fQ2Mqbm27o
         YMFeXyb0AAoAF8mnZiIVc0t9jweob1bxNC820G0ArJfntfhLb7jX0R4NNRzQFmLqSeoi
         as7lvjAiYyVv1yWT06d8e7wFzazDBYD8MDrRxElawqtJ1Jt+GLSB5/ek+hRoU4FWAWwL
         otBisL6eCEDmFDz6g8/M9P5UGxc8iPLIVb5JKW1PRzEcnhKRlOfoFSM6zuzGr3P3cKkk
         UItg==
X-Forwarded-Encrypted: i=1; AJvYcCUQry1xcFFa0rwUZXnjeoVKkIXZyeqW2kareOA1fPmrcvlNvvoJt66INbzGxM7zUCqF9haid5T6qP6dDszC@vger.kernel.org, AJvYcCV616w6z6TbUhsgAB+btk03xFQTeIse68V0nIv7VdZhwYxQ9vLdXFz2gHUhusi2V+UZjRfsdzwFQltwY/QphBAt@vger.kernel.org, AJvYcCVJY8+9oAvLFhN6y4MhCt85HJG12YAUZ5Go1kBDL2hbAqPFvjqylhuFLjfmYQ6xep5qXk6zH4tZxnIURtQlgmU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAZlDbg12Kzsi1LrWfuEQOf4j6zR1Jy3tLer5FGiNIZ7tVtE8W
	JREud3zDl3nLemleqlboCqY2axWxsxk4FuCMIpAOCzz5YEcXbubu
X-Gm-Gg: ASbGncuK4lurFjTy2BbB0LBwg7FoAKoV6noX+z0Mw6LQjA+H9Z5vroe1H1eowsdhc18
	kSaAUSTYQTqgL4OPt+mBh1UdoeVGcumsHWoyPL6r2ygi5ji6RAeKqyc4T0n7gmIBuxL40tJXxH+
	h0ZhTrRN+ivfhYpjc4RSo/jgw4tKOvyvcCzALWSmk3za9jbq46UgxYY1wuuKyYefUZspg9/aPOh
	l60evqBG14xn4avtsPQh3XKwDjKE6hXgE57Ork3PUMADvmSGeygBtHWqfbh1SL79IIB7ATNNoQJ
	Sutv6j+IlUzkRE6v+U8Uv7RMleFpHN+v/oRXoEmE4FuOVwHpxm6xvBbbfMsnRwy7WWQ4lLu8ijg
	LQ6ChkHkoHkrXE4mw/iLnsPdvw9y3l1/buASFLRHk16A=
X-Google-Smtp-Source: AGHT+IFi3QN94LoYUiIPRuS0EubYnvS4AeY8vcNVv01mDRusJEvQKVghy6Bwoph5/cT/4gpnxmhPPQ==
X-Received: by 2002:a05:6402:388a:b0:5e5:335:dad1 with SMTP id 4fb4d7f45d1cf-5e50335de57mr7321880a12.27.1740773776257;
        Fri, 28 Feb 2025 12:16:16 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c755c66sm340812666b.136.2025.02.28.12.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 12:16:15 -0800 (PST)
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
Subject: [PATCH v8 net-next 00/15] bridge-fastpath and related improvements
Date: Fri, 28 Feb 2025 21:15:18 +0100
Message-ID: <20250228201533.23836-1-ericwouds@gmail.com>
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

Changes in v8:
- Added commit on top: Avoid zero-length arrays in struct pppoe_hdr.

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

Eric Woudstra (15):
  net: pppoe: avoid zero-length arrays in struct pppoe_hdr
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

 drivers/net/ppp/pppoe.c                    |   2 +-
 include/linux/netdevice.h                  |   3 +
 include/net/netfilter/nf_flow_table.h      |   5 +-
 include/net/switchdev.h                    |   1 +
 include/uapi/linux/if_pppox.h              |   4 +
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
 18 files changed, 497 insertions(+), 61 deletions(-)

-- 
2.47.1


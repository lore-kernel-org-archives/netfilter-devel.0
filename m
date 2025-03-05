Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB8D207DF1;
	Wed,  5 Mar 2025 10:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741170608; cv=none; b=JzEgtPvz6Mcs7R4lpf7qlr4KPLk7/3mYyy88YWhE3GAKz10XnLiKebWc8tMded9gA2d2NEaOsx7HUF3+2XSwGqyQFSyXpTzF536/dg4mKPYe7bXSygammf8AF1adOPxhd2iXM5mRYmXW4oHXyvhZjBgdL6MxW+6kdHp2ETMDPi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741170608; c=relaxed/simple;
	bh=B4lHCixB5/kv3w+j2VP5bFx9obnTAvFYkuUSOEerqWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VPcBmUXM9A51Ilm5hcoPl9VlEx+mI7k+OwLkvvZUiKYxqbfPi8Uj5B2VLED4/Ec0+KVGXDSOFKOZT3LLQjnhQf0FGjwL6k6yCKrLIOey5r+hYh1oOQPFFq0TCo30CHMDSPCk8iuowwmxmay43dfBplzPy/CxgUpDZRZtMz0nWl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N5kVbrNH; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N5kVbrNH"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5e535d16180so4792533a12.1;
        Wed, 05 Mar 2025 02:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741170602; x=1741775402; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6sanML2Dhh94iBJereFlvYHp/47BSYsKw+xHcTZ++gc=;
        b=N5kVbrNHaRAzk6zViVfG5rccWiWSN6ah/WjiDv7wMdnCKrIaWDgy7/Nez+35YR7o+i
         TbTtPbrShi1BsfoqkBx/HVoaC5O+1Sov1vlMvQbAdKjklVoiHqS5TPh+pbmbbZ/sM7zW
         BEv6xTXMyeMHgrSbMo0hQG3mw8l3GHz40W8UZ37DmuAvXMsGiiPktQZ886Gqox6VvSmL
         39wkFwPkTe5oFAbx10eXtwqJ02m/f6J0YZ24l2BOSHmR03qXKOO9FOV/5Ug/LQz/YwSt
         Q5MJw9mcTKS7t0P8FchYGdnRTHxym1nDfd2wPYspXc3kvgHMgNGw20hl8QJ8eK7NbAr0
         +w/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741170602; x=1741775402;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6sanML2Dhh94iBJereFlvYHp/47BSYsKw+xHcTZ++gc=;
        b=Mq5vGb845Sbd4G2xgFqUFf0kkHG1OxQi2LR3a1bRK9LFS+Un5f9aRaZeU/fpSEoR3R
         o+aEQvp+LTn4DvlS7R11b7ZkQnmrr0Z83mdwLyxXnht9BTYNext8dcsz/UJ9Fhd3r0dq
         zvksP8aZk/DASfuC0YT2dVYv0tOQp05QDms4jYSuAcNA85mlkMKUX8iPvqwOKC2LKbJ9
         FtLIF2gbN9hvUOmEd3D7Z2KQB++fctYjEepzk4H+93cMHxUElyGlZDnZ5EaZgDkhZlbX
         DZDKumxgH+ECiw46J6HwPgpbXQMni07/2t50GoPrLdWEI8s51fCJLQOIJAzGp7VwskmZ
         2mVQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5NFOUlAP8ehLTqhrGJK6VlBhmm/0aSD93nbkHEwrJhWaAyi+GympiN0nIkjxG1bkvxVxUMRvLzZp5X+Ro66w=@vger.kernel.org, AJvYcCUaRo7fVHKYiPRF4yBLqnjwwar9LRrCGcBTd6wdvLM4nIm+X0Cf0zxAKpLt6yHxWni5+WC8+mbtI2Ym1bzX@vger.kernel.org, AJvYcCWYdQ51ob70pE0GP5gB0Xci5ecCRwuUHmdKKrNysq0UbMID3yf66tzuRySwYLJz1EFOfQWzw9VjXLMpN0GNLlje@vger.kernel.org
X-Gm-Message-State: AOJu0YycCNW1gByZ7UwQBIAMB4gp66ZfOj4ofHgwQkHWNtFCOW9tj1xW
	lJJ7/5M3RMXZEqxSr0NJPmUJD2Sq7aiLoIA5XSHz06q1xRNpjh83
X-Gm-Gg: ASbGncscX4U2bbRF2sYgIivAmMUFIrJ2SoPm1yNMTwKK6ytRkj2kCMp9wbpLdWR4R5D
	6pExJZQPgIbgmZbjdRWPHq0nWZXgxibXIsHNeF1HTMJ7VpBSAjOaqNLUPeJ4KPtDFu+l8m1TTkY
	riHNCGAQ8HO2x1F1qSigm2GscoB7eqjshLghIlFVQ0M0jHopeYYu2xduPH243FL2Cf23bewkLkJ
	4G7bNdfFwbGEuLHyPtGRM2sZppINtMkH3tvYmHX2bvJOBprMgBX7LcEmpKyjPCw6Y2KKxb84tps
	VfJj6/b+jS4/4VICyd4aOUnfMK+QdrDmEzKdBlO5y4ucQ6+WqIBj8hEIlxx0LybkeGvLei+7g9Q
	mHt4eO2WO/UEv9WvIyW3dTFenIUaOGZGCKo86bXLBC7NO20uly+s9g6cJbBLi9w==
X-Google-Smtp-Source: AGHT+IEquGmXyo0QZO6D8xBnPc2YdJ5ns+5Q/gwbofncoh7rX6vx5H6gyD7FpADTdefnpFFr3FhJMg==
X-Received: by 2002:a05:6402:2351:b0:5e4:af36:2315 with SMTP id 4fb4d7f45d1cf-5e59f3d4a3dmr6307326a12.12.1741170601891;
        Wed, 05 Mar 2025 02:30:01 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1f7161a4esm247154266b.161.2025.03.05.02.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 02:30:00 -0800 (PST)
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
Subject: [PATCH v9 nf 00/15] bridge-fastpath and related improvements
Date: Wed,  5 Mar 2025 11:29:34 +0100
Message-ID: <20250305102949.16370-1-ericwouds@gmail.com>
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

Changes in v9:
- No changes, resend to netfilter

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


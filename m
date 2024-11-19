Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B24B1991D2;
	Tue, 19 Nov 2024 10:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732011562; cv=none; b=UVivTwp6WypcsQyUBJFMtIjQqapXj1grmRggj5cYQ4Fy6x5qz+t6H9ig3hMjOUzhCES9N6hYi6DMMuK3y8t9mR2OyyZfAENJJ+TJoIS0dVsyiMMoZRs5Em8pdM/GXrDxg4tWS2z13AM1Re2L0o6ep4OCYFaExdXRtuIhZXbZ8Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732011562; c=relaxed/simple;
	bh=G/M97ATDjtXaD+DzB5XxokZ5jmmAD490WI5m3zuycpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rWG7U9D813dA+SzrU0Rz9DYSKrLcgHXRHNskQe8ejGnj0Inh1e3loJ+clMUtRvLiUbD4ZHF1lbqxQuqbiOVsni5qpAUe+p5FBIwqAkvoCRIGCJ0i3oQ51urZFmEnuE97icJQW0p1r2N2jCkC+TTvMIQLgiXq0zWfQrwLWiYq5do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ScmEt+/8; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ScmEt+/8"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9e8522c10bso846448566b.1;
        Tue, 19 Nov 2024 02:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732011559; x=1732616359; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yO7sxQUafAYucRUkN2IjUq6IUra83MUQ/OQ0OsuEu30=;
        b=ScmEt+/8Kxyzo/OiluH+S7aU8eYwt8OagJJzPzRlJQFWOtWV8tdam3XzEyQ5GW32dW
         oRfap/oevqV7yV60EgQz/ktre4tW8jx0WWfQ04kzv3UGWk3VzhDnNlMhv4F259mPfpfh
         PppYQIYLkIhD/sCe+kHcfhUqVthTiSPcS6sg/PMBDpFypiycv6jyFVd/oGlfLjLR8DSn
         48wWULycSgVFMQ5/0dd0eMONl3MWCjHT9OeDWxhTEyDQL30sPjL+BX4bsBMcjd5JVK2C
         5IfrUqoIjGP2LFwHSQz+vo3UZzcPRyqOgR5o4W4QlODAcTD+GA0khqsfFjb8fNdDGHH8
         UiQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732011559; x=1732616359;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yO7sxQUafAYucRUkN2IjUq6IUra83MUQ/OQ0OsuEu30=;
        b=ulqFq0R8OKYJ+HhsZigL/WXqqyHHtApfimeZM/08/UAgY1nERznrEzkdk8xW6ZCp7S
         pHM5qpALD+wQLjUhJb1xU7/4/E4VPRVB4drxTM+mOOotYXzIlQXXIsowIQWlhLTBlHbo
         VqiU3FBMUyNJmHjlJwd7YmTY/MFEFh/nyjffgrucx5VSGCHaKPP+C0EsPXJXiDTLaV+H
         9RIifl7LLd0KyFIETkKLetolrlT1sDTTaG1lZnBVyI+AY+AdMzAydFEmTN6HpzszBajk
         eaGiFLd+LOYYSljKc3zZHdhstTyUywR3TrCg4uZQFymDKtZoJt4DhN1lA7V0NS07UDna
         TIBg==
X-Forwarded-Encrypted: i=1; AJvYcCWPZtgzwc6Y10u3MwhEawuASYCdcUlNjtYDuBh+bgxOkdX8tNYDmHQsq/fRDP/59BLDLrXJI77VEy6yn8E=@vger.kernel.org, AJvYcCXWf1HqmwYIiG+mfZ1yzxb0pxZbW10MJeQvRYKD/17jkQgkflxO9DJ48vicllcEnKxDmz3DXcD9pwmSURall9tb@vger.kernel.org
X-Gm-Message-State: AOJu0YzcAR9ZmbKm2//nBhLRo06/7RNjSCNL3GvhjtAQyfmI+1RlO3g6
	4hz4pPNACXtHkr9dNCMQL4LrgmaVRfc44qTfVbVv9nGiiOaOpMAp
X-Google-Smtp-Source: AGHT+IHfClA1OO+Sq3mruClnwoe/BR7xI+sjeG3UEZ/v9gqMrSpB7FHcIFZ2f2w6kLP2kZj+vPyc1w==
X-Received: by 2002:a17:907:97c9:b0:a99:facf:cfc with SMTP id a640c23a62f3a-aa4c7e48f63mr248549566b.17.1732011558440;
        Tue, 19 Nov 2024 02:19:18 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e081574sm634875566b.179.2024.11.19.02.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 02:19:17 -0800 (PST)
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
Subject: [PATCH RFC v2 net-next 00/14] bridge-fastpath and related improvements
Date: Tue, 19 Nov 2024 11:18:52 +0100
Message-ID: <20241119101906.862680-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset makes it possible to set up a software fastpath between
bridged interfaces. This also creates the possibility to have a hardware
offloaded fastpath between bridged interfaces.

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

While testing direct transmit in the software forward-fastpath, it is
useful to enslave the wan interface to another bridge, brwan. This will
make sure both directions of the software forward-fastpath use direct
transmit.

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

I am sending RFC v2 as I previously only owned a dsa device. I now have
obtained a switchdev supporting SWITCHDEV_OBJ_ID_PORT_VLAN, and found
there was more to do to handle the ingress_vlans bit and corresponding
vlan encap.

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
  netfilter: bridge: Add conntrack double vlan and pppoe
  netfilter: nft_chain_filter: Add bridge double vlan and pppoe
  bridge: br_vlan_fill_forward_path_pvid: Add port to port
  bridge: br_fill_forward_path add port to port
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
 include/net/netfilter/nf_flow_table.h      |   3 +
 include/net/switchdev.h                    |   1 +
 net/bridge/br_device.c                     |  23 ++-
 net/bridge/br_private.h                    |   5 +
 net/bridge/br_switchdev.c                  |  15 ++
 net/bridge/br_vlan.c                       |  29 +++-
 net/bridge/netfilter/nf_conntrack_bridge.c |  88 +++++++++--
 net/core/dev.c                             |  66 ++++++--
 net/netfilter/nf_flow_table_inet.c         |  13 ++
 net/netfilter/nf_flow_table_ip.c           |  96 +++++++++++-
 net/netfilter/nf_flow_table_offload.c      |  13 ++
 net/netfilter/nft_chain_filter.c           |  20 ++-
 net/netfilter/nft_flow_offload.c           | 166 +++++++++++++++++++--
 net/switchdev/switchdev.c                  |   2 +-
 15 files changed, 490 insertions(+), 53 deletions(-)

-- 
2.45.2


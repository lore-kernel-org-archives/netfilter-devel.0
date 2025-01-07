Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C98154BE2;
	Tue,  7 Jan 2025 09:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736240765; cv=none; b=TAIsyl7/oTtbFevcanLjOaNhvs9ExHZsie2bf0g4xcSFXkHP08Uj9q200mRAUC3ej2mAGnLv77f9X3yppaf04mDB0Y+s4/n419BIDvhSXa5w+GSzQJmkVgby4xtM50YD+PhnbjL4Wpby/F+cHNrE/MxnIWRbZl6uUnbMGNbtxi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736240765; c=relaxed/simple;
	bh=+lrAL1nhmjOwtuCrjSGBusJ4m7eSyo0LJzq6XREbXLY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SClP6WbGTc9o4bf86FahgTf1i8MB4uwQXIthBegxjb/xZGl4vSOmQxzHa7JhhyO1VnRX5vL+uj6Hfeq4AynTOAAyMaxWrWCqxS8x6jKl3Uk1qUWw0bFJZeEbo/f35yy933lXuZGC6DzjIbxi3nwNe0xqBbappM2lr4OAjE7hx04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HslQfHyM; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HslQfHyM"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d4e2aa7ea9so28836367a12.2;
        Tue, 07 Jan 2025 01:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736240762; x=1736845562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Yf647nI7SHqGI80BBUzHOC/gY+pRTRu3FTTF5e5PvXw=;
        b=HslQfHyM76d4vAH5VtCIOP2s+kvzAAc50C2uTfHKXjpf9+3Fp5ASNwUAqNZR9X73iV
         uhKgKmkf/dHSp37wfhmRAWepSsKPR8HtbZjvC8kI/G9RLEhWE7Vzd6NSTYrebB2EKx2I
         fsnBTzkPCqnyhUTTOjrpDsejsftiJjSjKVNloJHQ81TuRa2IEbIcwWFMhuh3TmzZzoV7
         ygd3cJZokjAVcVG62a+ltnJIONfrNLbxmZVgP8KGppkrHZu1VbXMMG5ZAxzuEEbq3+8T
         GrEMxtnOV2ktRVtgJih4DY04ZCeQ9c2S9ojnhOjd1EAMu9ukKlSCTDdLL5i6OpmCKKQ6
         CKgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736240762; x=1736845562;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yf647nI7SHqGI80BBUzHOC/gY+pRTRu3FTTF5e5PvXw=;
        b=Ut988DeClfbPZ0PKP494fgpBMzd7H3bEsoOmrvspZYE+xbdm1o9nedkeYSC7b2U7fg
         MUFIEdkWcYPNpu1NS538bg4lmMWFzzLZKufYc5TuEby1RoT9VcGdCvQ6J65z2F3FBCsZ
         iKEsIeCfha1BoTr1plO6wR078Riszt3sXouWZGj4PY7n0p6lH7dReT1VWJ+kBX7871Cx
         7OsYUSKwplmG0nUneD1KxKqWID+c+xcHHocNnkDLUWOEcrRFJuy0hvZ6dxJUoIISah5g
         sWRpxajc4d2zuVl+r4K2ht+u1EAKHIoqQbIP20iyzGKbg7t/V65wumi6EeBKpEeybZS2
         FwiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCaXFc86EzCB3yVReghWdPNopcS+U8CVZD/+HO/6SLDYFsH11ZCkICqxMqzYXQdOGOPGec+Rkt81ZqaSlSWWEG@vger.kernel.org, AJvYcCXdg6Ah6/+UOyypdDEdZ1kbeaeZELBojBszzWODqwnysEwxDt8fRcfxyUmtBShRbTeY2dEmtSymW9SFb2k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWMdXhV3DnfKv3kAP1ec60Iz4LCpqnwu7WLN0IqS+stdcA3qsz
	s6Nv4h6aQ1QYoO0gEVyy27P54kUnylUd0WyMzvj7vPuLzB7JQLHc
X-Gm-Gg: ASbGnctarF1k7Oe5QmofXHJtAn9ygbKKS5rDvWdmoMW0FbRTqgZ62bUGc1ujYAGnoe/
	hAE3ic1QtNZRKq55JhjW5DO+5CXNSd6Fgf/aiRr35ehnwILcsoHWD4qPux84VDbuJgeTgvlsJPO
	L4twrZtp+rnAI3JwhVoyIwZX0FWY4lWMI7lGvtJi7/sj/5L6E4q9hOg7nopzL177COzbYa8CQI0
	I6Xmi1AtGEfpOpBXOH0GksRxnT84yKDpJ1saNaBukukdHHwQoKC/E2mCIUwV5snyGDP32eAvdWE
	yX5m9F4FbekUQKHPbEnKyWzHFn6k46fk67p0e2WXnEcJbWHWJeUXEiQYDjqcl2VG7Cc03S3qdA=
	=
X-Google-Smtp-Source: AGHT+IEqfnropOKSjHTeyHfKo1G2T5LbmT8gMHhBLT4HLZ1WLqNyAGZrwKDXof/oJBx8TuvP4LVrkw==
X-Received: by 2002:a05:6402:430c:b0:5d8:253:b7df with SMTP id 4fb4d7f45d1cf-5d81de22d07mr53758061a12.27.1736240761340;
        Tue, 07 Jan 2025 01:06:01 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80676f3f9sm24005333a12.23.2025.01.07.01.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 01:06:00 -0800 (PST)
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
Subject: [PATCH v4 net-next 00/13] bridge-fastpath and related improvements
Date: Tue,  7 Jan 2025 10:05:17 +0100
Message-ID: <20250107090530.5035-1-ericwouds@gmail.com>
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

Note: While testing direct transmit in the software forward-fastpath,
without the capability of setting the offload flag, it is sometimes useful
to enslave the wan interface to another bridge, brwan. This will make
sure both directions of the software forward-fastpath use direct transmit,
which also happens when the offload flag is set.

I have send RFC v2 as I previously only owned a dsa device. I now have
obtained a switchdev supporting SWITCHDEV_OBJ_ID_PORT_VLAN, and found
there was more to do to handle the ingress_vlans bit and corresponding
vlan encap.

I am now sending v4 as non-RFC as the previous 2 RFC's did not get any
comment.

Changes in V4:
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

Eric Woudstra (13):
  netfilter: nf_flow_table_offload: Add nf_flow_encap_push() for xmit
    direct
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
 include/net/netfilter/nf_flow_table.h      |   3 +
 include/net/switchdev.h                    |   1 +
 net/bridge/br_device.c                     |  23 ++-
 net/bridge/br_private.h                    |  12 ++
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
 15 files changed, 497 insertions(+), 53 deletions(-)

-- 
2.47.1


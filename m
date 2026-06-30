Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA983939C1
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2026 06:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782802679; cv=none; b=LEtjHVv8s4DwJDNPUOnrrqowWT04wgGpBxprV3c6nM7QC4XHLFMvwjqgXD/8RjVlbrCTd7Xf22qivkqGQq3FzIbN2NcJMbycWOeUZRowMHe4Ml2p2DipJ4eP7/4k8GNdmN1+3VZ1YNoR7ZsX2J+ei2A0k+5VNh9b/0qJHeLfY1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782802679; c=relaxed/simple;
	bh=AF8EzTYcmcfCcEiaIWGwus0xlZ0pc2RcYzxYiJaqerg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mbl562rSAHCmNAI7tt4AYaXpQkEbH33bErtKkPubuJ9MAhhf5G8hrXEjaDhpvB1icMaJ5v2rlwYjA9GZegFFXtkWgj1bi16uqX6bwkT4okL/Ejznh9S+nEXLEq3UUChbN1mq98yZNv5wzLW8wjKgLOwyj8AEFaELfFawLcZxGek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cCVuaW1H; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cCVuaW1H"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4624a44e152so3788203f8f.2
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 23:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782802677; x=1783407477; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wg2/qe+4da0BF+gj2Y7cJKdG+hCpLIZ0UIJ4logHsQY=;
        b=cCVuaW1Hc3GEjSZ9G8+DVAh1lcVhdi99+Twl9qDjyU+zwLx3PqxVsx8Znfu64qA89G
         MCFGYITxwjktV+AL55aC1m6YxTAQT5XCJ/hJUq20AksHxBtMuW4LEmuC4pmvME0CGDMY
         4n1yZdhIH1FNzy4EPnwFM2nUk6cSm0+jt84oAm+ahABrhTnIsd+z5LIGgwylA59hR9L9
         TC9d0IxD2mQ0ZXXzzgPUQKC9Cz3AIaNeisRR95xZN1GL92yYrA+bpWeM6Sg1sL8a58Dp
         UGz1p3d2N007cFmF5whnyQQGDWfPcEbbg/jIrMRNpEFzoCbcNGq3CXAiecbPr4L21O4n
         Gu7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782802677; x=1783407477;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wg2/qe+4da0BF+gj2Y7cJKdG+hCpLIZ0UIJ4logHsQY=;
        b=rD7ehqzehj8okgTD358B6m0JyhtAYlAy7twIQuuBQVolYY9uJAo/mPN4LiUJblXNz+
         F8erTw/Z9T1mP7NPKIyOI3XrFIsMgQ9AoOtggQXdvWhO7ua9+uPvS2cxu0tsnFhA+ZYk
         EWTzp9Z9gDQjaMUP0rH3tT47uvyaF9dLVIMfo4upVFd4C96M3lC2eUvmeRhb4v+yZcsh
         C1XIWl+Jdi+ZBwugffuRiR5x1KBqI69RU2eyVFFFOVdR+1XOucGEVF+HyzUTRetXE7Z4
         T/T5vv9yjk9P+8cBaxfeY93pTUMNdJB6rIuEC/UmmIO7pFbkmDol64Z7cq5IVtUXIgaQ
         puaw==
X-Gm-Message-State: AOJu0YzrX+1IdRhHL3N1SKT6hyo5XWpNIkXWUsOyFOH5hSeVY3IYXiGT
	27Qtjjg2QFmaBkgJ197xWQcTsRdXSkPYnSMPJSwieVbyZ5HzuzwoUSR37ckmAWIf
X-Gm-Gg: AfdE7cnwj+W9q1zxCtC3tv1R5zU1QFYRm6rv/PGQZqNI3U+5Y00DAOYZ7QRd4Ft2jr+
	o7zPhUMM23JGo4+XPJNXm6mOF3ULpl0zBrZrGR+YD+hium4qtv3LUwKL/BtSdP1Z/8/F60TgBCu
	85dC467OBMtiZKsqBOfLPRxi0tQXWUY20hMLj93AChn4+tofgXyEHYfiAYAeKNpRUmOGQ2u6v4v
	fZOnGB5JYZ6tIqXRZ53z9DixU5Xko6JHHmEOH1vNDG2H13IOxmYEZ8sePe6jALrfz6ZXmFU6VP3
	41DjsKX8mX0ndhNNL4heM3YT6hDuHprmqMujy5woz2r3Ji0hDP9vrlIVk4T0VwqWIbv8T2ZWeiE
	2A8bAvKW2P4R/KZmaLV7eSNnVElmNExiPq43NdHbijeNj16mA+RlV6UOFN9OaIx9qArhAMlJ/cN
	s+Tk8dHFA=
X-Received: by 2002:a05:6000:2dc4:b0:474:6a5b:85f8 with SMTP id ffacd0b85a97d-475506e98aemr3116459f8f.6.1782802676618;
        Mon, 29 Jun 2026 23:57:56 -0700 (PDT)
Received: from fedora ([46.205.218.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4756636cf26sm4570949f8f.19.2026.06.29.23.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 23:57:56 -0700 (PDT)
From: Daniel Pawlik <pawlik.dan@gmail.com>
To: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	razor@blackwall.org,
	idosch@nvidia.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	bridge@lists.linux.dev,
	coreteam@netfilter.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	rchen14b@gmail.com,
	lorenzo@kernel.org,
	Daniel Pawlik <pawlik.dan@gmail.com>
Subject: [PATCH v2 0/5] netfilter: nf_flow_table_path: L2 bridge offload
Date: Tue, 30 Jun 2026 08:57:30 +0200
Message-ID: <20260630065735.3341614-1-pawlik.dan@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds L2 bridge offload support to nft_flow_offload, allowing
bridged IPv4/IPv6 flows to be accelerated by the flowtable fast path
without requiring L3 routing.

Background
----------
Hardware flow offload engines (e.g. MediaTek PPE) can accelerate bridged
traffic but require that nft_flow_offload detect and handle bridged flows
differently from routed ones: no routing table lookup, MAC addresses from
the Ethernet header, and VLAN context pre-populated from the bridge port.

v2: Fix missing Returns: tags in kernel-doc comments for the three new
    bridge helpers (br_fdb_has_forwarding_entry_rcu,
    br_vlan_get_offload_info_rcu, br_vlan_is_enabled_rcu).

Patches
-------
1/5  net: export __dev_fill_forward_path
     Refactors dev_fill_forward_path() to expose __dev_fill_forward_path()
     which accepts a caller-supplied net_device_path_ctx, needed to
     pre-populate VLAN state before the forward path walk.

2/5  net: bridge: add flow offload helpers
     Adds br_fdb_has_forwarding_entry_rcu(), br_vlan_get_offload_info_rcu()
     and br_vlan_is_enabled_rcu() to expose bridge state to nft_flow_offload
     without requiring inclusion of net/bridge/br_private.h.

3/5  netfilter: nf_flow_table_path: add L2 bridge offload
     Core of the series. Adds nft_flow_offload_is_bridging() detection,
     nft_flow_route_bridging() which avoids nf_route() (fails for
     bridged-only subnets), MAC/VLAN pre-population for bridged flows,
     and a dst leak fix. nft_flow_route() becomes a thin dispatcher.

4/5  netfilter: nf_flow_table_path: handle DEV_PATH_MTK_WDMA in path info
     Fixes zero-source-MAC in PPE entries when a bridged flow traverses
     MT7996/MT7915 WiFi WDMA hardware.

5/5  netfilter: nf_flow_table_path: add VLAN passthrough support
     Records VLAN encap info for passthrough-mode bridge ports so hardware
     offload entries include the correct VLAN tag.

Rebase note
-----------
Originally developed against OpenWrt pending-6.18 patches by Ryan Chen
<rchen14b@gmail.com> and Bo-Cun Chen <bc-bocun.chen@mediatek.com>.
Rebased to current upstream: path discovery infrastructure moved to
nf_flow_table_path.c in commit 93d7a7ed0734 ("netfilter: flowtable: move
path discovery infrastructure to its own file"), so all netfilter changes
now land in that file rather than nft_flow_offload.c.

How to enable bridge offload
-----------------------------
1. Load kmod-br-netfilter so that bridged IP traffic traverses the
   netfilter forward chain.

2. Enable netfilter hooks on the bridge:
     echo 1 > /sys/class/net/<br>/bridge/nf_call_iptables
     echo 1 > /sys/class/net/<br>/bridge/nf_call_ip6tables

3. Register bridge member interfaces in the nft flowtable:
     table inet filter {
         flowtable f {
             hook ingress priority filter
             devices = { eth0, wlan0 }
         }
         chain forward {
             type filter hook forward priority filter
             meta l4proto { tcp, udp } flow add @f
         }
     }

Daniel Pawlik (1):
  net: bridge: add flow offload helpers

Ryan Chen (4):
  net: export __dev_fill_forward_path
  netfilter: nf_flow_table_path: add L2 bridge offload
  netfilter: nf_flow_table_path: handle DEV_PATH_MTK_WDMA in path info
  netfilter: nf_flow_table_path: add VLAN passthrough support

 include/linux/if_bridge.h          |  23 ++++
 include/linux/netdevice.h          |   2 +
 net/bridge/br_fdb.c                |  34 +++++
 net/bridge/br_vlan.c               |  47 +++++++
 net/core/dev.c                     |  32 +++--
 net/netfilter/nf_flow_table_path.c | 201 +++++++++++++++++++++++++++--
 6 files changed, 316 insertions(+), 23 deletions(-)

-- 
2.54.0


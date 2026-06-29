Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8590740627F
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 12:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782736388; cv=none; b=DBevePKASu26i7qQxfPDKMRhgQ/M1GL7E6WNu/+WFdLDNqEWKDWhMyB1jycJN3XogjDwNGGcZ9npI3rEuyLIOoz+v7R60+2LPYc+eadqmq+Ll5AInRI2Fn9vzPVY1jrDTAwkz/rMgp3LxUPo2Mx1jIr+uQHzprG6VimhPfdw9nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782736388; c=relaxed/simple;
	bh=mM7T15Z9HB8xLCpzDyCHSZPcHgPKPfrCug4yAJDcmQo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E3mpT+dMZljhqMl+dp2h3liqdLKUD/L5F0Lu628UcEawMuB1bD0LcsKOIYPTO3OQ0iFkhHuOpR7/MM8Hk9xz2B38c8/0DrOybvTQug/iEXiWyhtKU82iYXuYONMs73hnO5WjRIw9UBiW/k1GfawnQsIp5ir6BUlfXeo0uGHUW+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kefDkK/M; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kefDkK/M"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c125bcfd9a1so137488466b.1
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 05:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782736385; x=1783341185; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W6yfFGpGsowdA7nocV8Q2ZeGgDt/heljVkQt2pc3Sqk=;
        b=kefDkK/M/ejh8bFCNS87F0UIv2FohaVYlIztWiGxN4B16ZJT/KHQAuVXF7k4mnqe3M
         S/KCDfz97cx+Y6MLs94zFlGxp3FVBnD4I1EN0WyF5Lx+lmpKi1HnrIjBRFWdTZWwY7/R
         3ifU+4n9iVhEoHU451hs/YHwamFolsgi7knnDU21f8F2sij2V96CGKpXO1uEMbBrwNFf
         r6zn1XmQ96GkZ4lonZ4Tf3CP1w2/5oS79I8v8u/arW3w8mLhLoP8AiJ5OCZawb7OxbuK
         D4IDn4UWXr/1VTOvv3YxIcvzklehp7yEqYM3XFNulvD37tWRSPnrAg/s3kNNta8wwQo5
         61/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782736385; x=1783341185;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6yfFGpGsowdA7nocV8Q2ZeGgDt/heljVkQt2pc3Sqk=;
        b=pHvzGrdE3WOn0ixdZfkMuqf7vz6o1wi3HTY+eSg/KH0hZULciwyqymPqAGqecQ1tGg
         Wa8bJj1b/Xtl7KkCPyMNlXckEFRBtj/kaXGld6cXIkG+Lia1YapNfif3YdXUmpKD8akW
         K6Q4rYAdQJX2IXvV0isjXNrguxJ1QXEElF19UOyrMKSXE5A1Mo7tFo9+l+qODXUrRCI1
         lJhgZFtbsuXZS392uAoR2r4xUM1DMMAYeRAY48Es3Aq83X3voou5Ij+JyaNUJrP7koAh
         2gAiulKlcfakJDRA8l+6s+1gGxbcQ+rJWKNaLxd8PszSZRyFtuPbYt17+9Gj49xaCsDA
         69XQ==
X-Gm-Message-State: AOJu0YxUd4fGkuToN/UMdtdU3Oyi4LF8PkGJbz09IPKNxrPXwPkTBr0P
	9YuLaOv9jvht+Bx99Yhl8fDNru8AA4WyJ7wOsAvwQaOdNnJHK/RXzb8509jdGwOi
X-Gm-Gg: AfdE7clgf67sax1VgDokF36y004zjgINRqKpBgxPdudsTQfDehgOQwbxr6B9nuLMAQd
	mIi7EWF+CF+ZvMktgJudFCTCRv3NbxWqMDqj3fC+wALmf675Wc5GoCnwGgLFym28EQ8MVRqSgYY
	T9vsvCEEe8TNWjxqOd/5+4u5kWY79DvURSSMokMllayN/hBfx0Jb1LG3esX5PQjHQ5jgpybYC3T
	WF3vLbQlrlqRcklikKPfB7y2EYtgQL7yp0MF34Vyg8S5jYS6nGDos2dhIA55mpDmyLnLTFgGkBs
	u9EkYds77WQ1C5iQBEQB+CoVbslmsUeaHAoBjyaQS/XmJMyj9K5ISe5A1TkepKo4cUZTLE+GSlx
	m3M/0cpdeSTCFDLaQm5zJ3K6HMvsd9EpzmKHUoR3ovuHIRSZP5Qv0/u5MPvEoT1SbIrJ8TIwYT5
	AedHVOh9U=
X-Received: by 2002:a17:906:f116:b0:c12:2b66:352b with SMTP id a640c23a62f3a-c123342a062mr351983366b.5.1782736384619;
        Mon, 29 Jun 2026 05:33:04 -0700 (PDT)
Received: from fedora ([46.205.218.111])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbe05c22sm773866566b.39.2026.06.29.05.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 05:33:04 -0700 (PDT)
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
Subject: [PATCH 0/5] netfilter: nf_flow_table_path: L2 bridge offload
Date: Mon, 29 Jun 2026 14:32:48 +0200
Message-ID: <20260629123253.1912621-1-pawlik.dan@gmail.com>
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
     and a dst leak fix (allocation references in dsts[] were never
     released after nft_default_forward_path() transferred ownership).
     nft_flow_route() becomes a thin dispatcher.

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
 net/bridge/br_fdb.c                |  32 +++++
 net/bridge/br_vlan.c               |  45 +++++++
 net/core/dev.c                     |  32 +++--
 net/netfilter/nf_flow_table_path.c | 201 +++++++++++++++++++++++++++--
 6 files changed, 312 insertions(+), 23 deletions(-)

-- 
2.54.0


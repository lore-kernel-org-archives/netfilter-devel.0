Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794153226;
	b=Qa0pqPY9Y/ortY8Tk87aXzZ57W8yNmwKnigxz5QXqQV0stKibvhG/pDKaPZqCLsxllAc
	 IZVqHpc6HToWDaRoGsOtY5xAqmmt2mpmrD2kNdQyJ5/jzEpaPUfmAyOm61Vm6eLkIAet7
	 MvRXM86P2m0+HXaHBDTVp55yz9H2/z2rKXs4csyon600AjlcegxP0oheZg4WWZjeL/t3c
	 rBX/MRDKVQ/P0EdHGxJ1LbT4WeeNCktoZS6+PxNlPm8/S/Yra/PfQWp5ycalASx863c+U
	 Neh1HxcpxSJhC2MQF9J+xB7AX1VDV9LpVG1UH6rhp+E+Izc9Lfu3w0yOwlju2p/2snQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794153226;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=K8tG0sBF7Y5GlP51WViElxhrHpfyEqUrzO/fBUEmVg8=;
	b=k1DJQ8ZkI5IcYY4MeVfKKnuQ5J1G2gI6borlhoVzS+UQkhMsFQYiwU4Zty+U+/n2NVUg
	 GWbm9SJsHSlxH4YAJoRhCB+j+lWP5OBZcbl8FZDET+jlS5jfY9mLwvzSo/RWlrUP7kv8H
	 mOzfqBySLG31URcbtiif8MWCY4QzDqcew4qLzGCgMZ7x4+ZnCynhMGqEvOebLMBYouGBv
	 MOxnx/VMExluDL/QLgWuUWw7+RicdMJFY9DU/DnK4yC64PnEh2vcF3jOg5fSjciXlERgH
	 OOES5T3zRD3OUYgd+Jz1Ru7Dv8teNBDDINRqwY169aNTOAf08oRAOekJfOUY3WvSl4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=jdBtDWjZ;
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6873F606A320
	for <netfilter-devel@vger.kernel.org>; Sun,  8 Nov 2026 15:53:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6873F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=jdBtDWjZ
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4682977f9aso16923566b.1
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Nov 2026 07:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1794153225; x=1794758025; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=K8tG0sBF7Y5GlP51WViElxhrHpfyEqUrzO/fBUEmVg8=;
        b=jdBtDWjZHG5CUzNm32M14oMgSHsFKp9Y/CKm8FSWfpgzguAOR6lo1zlEbGrcrQ2TWi
         dFL1NQni1hq+mKZJLegWtmEGk9ZKN8JuM4K15/A/fbfj4s9rrEBE0REKLe9ZmHA74X9r
         b6vS1Pe2OEBkM47+8qAHYHyZG6kqyA8tCQs297SRzac6iFbUaEBIse5H6JCwF362WE99
         MIbHGwlVpViRiGdLeOpmv2jQAZDYmv1/SfBOpVKegiiptRe52N+z8twHnF4pPx0Vs+T8
         4il9r1znT6g0ilE714rt5BvRbvvsP6jHrixASZzfvm4lDV7ptbkYssMUnPVM9nsJyMcN
         jdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794153225; x=1794758025;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K8tG0sBF7Y5GlP51WViElxhrHpfyEqUrzO/fBUEmVg8=;
        b=NnvcuU+lM5H7SKDUsNPKO6jCyEJ4TEVFmPo8fOh+ypoX9TsxITtUhEm/nckIpV2OP1
         xeXJ4JnM1OZzWWvUGC/+Z8rpTwYYPqZqntdOUimP+Js6t8Dpymy5AzgfXxL44lHDinaj
         WHhirmJ/LVZEcOVe3gWupYWVFivMIPViBBE2hlQzvJaGSVN+DwQevlqjbeJUCyTKyYYp
         eDPzWdAEzk6hw++VR3ROI+l3A0WCZqhkgx9PpcYWSZKgu7w4qmHdiQMBd8cJZ8E/W4bG
         JjgeJGRw0ndzmTZ8yeQjs76xepIwYp5G1EBVSSWN6Zu8rSc/eBeK5yL1aOu6BuJzJwTZ
         /bKg==
X-Gm-Message-State: APuU4Z+1ZxCAl4g9880SRLXRX+L0BW3gVu9GlnkpNyIUc9YmVC7KKnlE
	ULZnVSFDv9YEf/iu4gJdiAEhMmgjADkOR9qqUfTTKLm/rj/LAU/9vVNFB+CSsAVufG4/hDFhpUU
	rjFLtwsEs
X-Gm-Gg: AYBFou2TW4oLGHT1IbtJE6qRNzhin4a0CglXKyfGkXqpGELMOY0YngS7R0W6JY7F99l
	o2qCaDOUO52/sxSPp230LBAclb/5O5SwgBrFJYmN73NuXiiU1BLzdOtUcFVIXlFr8TukZBMW8iG
	NJyoEEP2yDw9n6pQDIg/HG3d7g3yHNZj2+fWjFyQN5PVBwkZGXA727DEGTGUIq3itRHEfRNaKml
	0fzefB4aKqm4k9gLJa7g350pN4IvyHfex0sgxaom1tIYItr3wj3xeSoP+tvQq799IjWxXeWq9jC
	YopHBpZE5SxSs0X/JCaPBRasKmN+4p+PNqLMx/izgJp3rKOYQdrafXazs0Ac545hpxtCBJ4UVMW
	pVGY4XAOoxxew5l8UiZmGYx1hqOxrHt16XKP7UQTr3Iv/3INJ0Fbzv83pmynnYGB/Yv8M2UKhZA
	+hQGhdtqCNial86AototEIf3XTDxGYtAXZnqB+82Ln55ugUd7fIabf7TwODnygQFa1TlwodD+G/
	zcUi43gmDTyYiTyGbckRCDCyOIPAgU66WpEMlqI4XpnWSO6cbC4Od/GtzldjXYeeKl2Vd+Iycy9
	5cH7Tc5v7EWBeRZTXAwkXApVkZX8mKwOvbZIPBuOyt2hzGUqz2WxI3UN9x510Xzpz/oMcNmOIWW
	9eUVTSQAYtz3vPEptV2atJuLeYHfJVzIZu6pUkNBZMthPn5oEdnhj4+qyd9tUJBhfnNsABlOeSJ
	gtj0xyQM69ELFFr7mNSOyvholc117gWg+WvT1H0AIFM5G6+WI0BqwMbOlaGKr4Nn1cojJw0184p
	ndmOyNJPOy38V9nr9jSumSh6zEmU7YCxySolGTk0YD2RJ5Gd0zoNlrHvcB0K86kHvDZ7BdmCC6J
	BRbWf6E8MJJa+0XNNpo=
X-Received: by 2002:a17:907:3e82:b0:c2d:bf61:24d1 with SMTP id a640c23a62f3a-c4d6d1aefcamr131880266b.1.1794153224347;
        Sun, 08 Nov 2026 07:53:44 -0800 (PST)
Received: from Desktop (p54aff56f.dip0.t-ipconnect.de. [84.175.245.111])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d68d52f4bsm71648166b.8.2026.11.08.07.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 07:53:43 -0800 (PST)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>,
	netdev@vger.kernel.org,
	bridge@lists.linux.dev
Subject: [PATCH nf-next v9 0/2] netfilter: flowtable: tear down bridged flows on layer 2 roaming
Date: Sun,  8 Nov 2026 16:53:42 +0100
Message-ID: <20261108155344.35845-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A flowtable flow that transmits straight to a bridge port keeps sending
to the old port when the host moves to another port, for example a
Wi-Fi station roaming between access points.

Patch 1 makes the gc tear such a flow down. It is Pablo's patch with my
changes on top: it keeps his authorship, his Signed-off-by from his
posting and a note of what I changed, instead of the Co-developed-by
that v7 had. Patch 2 adds selftest cases.

The flow caches nothing about the bridge. The gc finds the bridge port
from out.ifidx through the vlan devices of the path and the bridge from
the port, and the tuple gains three bitfield members in free bits:
bridge_path (from Pablo's patch), bridge_vlan (the flag Pablo
suggested on v7) and port_vlans. struct flow_offload stays at 296 bytes
on x86_64.

Tested on nf-next 734bef548a96 in an x86_64 guest: nft_flowtable.sh
passes five runs out of five, two of them with PROVE_LOCKING, including
all twelve roaming cases in both of its passes, with no lockdep splat.
Without the port_vlans reset, the new stacked bridge case fails and the
other cases pass. net/netfilter and net/bridge build without warnings
with W=1 (x86_64 allmodconfig).

I used Claude (Anthropic) to help write these patches.

Changes in v9:
- reset port_vlans at each bridge in the forward path, so the gc checks
  the bridge the flow transmits on: with a vlan device of one bridge
  enslaved to another, v8 counted the vlans below both bridges, looked
  up the bridge port from the wrong device and read past encap[]
  (Sashiko)
- selftest: a bridge port that is a vlan device of another bridge
- selftest: the roaming cases give socat five times SOCAT_TIMEOUT, as
  roam_stop() ends it; on a loaded host a case took 109 s and the 60 s
  timeout ended the transfer before the check
- authorship: Pablo's patch is credited as such, with his sign-off
  from his posting and a note of my changes, instead of
  Co-developed-by; his paragraph on the switchdev notifier alternative
  is back in the commit message
- rebased onto current nf-next

Changes in v8:
- drop bridge_ifidx and bridge_vid (Pablo): the bridge port is found
  from out.ifidx through the vlan devices below the port, the vid comes
  from the encap stack (bridge_vlan bit) or is the pvid of an untagged
  port of a vlan_filtering bridge
- the fdb check sits in nf_flow_dst_valid() next to
  nf_flow_dst_check(), the hook is fdb_valid_dst() again, and the
  comments Pablo pointed out are gone

v8: https://lore.kernel.org/netfilter-devel/20261017235849.1066624-1-julius@bairaktaris.de/
v7: https://lore.kernel.org/netfilter-devel/20261014235628.197976-1-julius@bairaktaris.de/
v6: https://lore.kernel.org/netfilter-devel/20261004171605.3544792-1-julius@bairaktaris.de/
v5: https://lore.kernel.org/netfilter-devel/20260914072541.897040-1-julius@bairaktaris.de/
Pablo's patch: https://lore.kernel.org/netfilter-devel/20261014210256.1573072-1-pablo@netfilter.org/

Julius Bairaktaris (1):
  selftests: netfilter: nft_flowtable.sh: roam a host between two bridge
    ports

Pablo Neira Ayuso (1):
  netfilter: flowtable: tear down direct xmit flows when the fdb entry
    moves

 include/linux/netfilter.h                     |   7 +
 include/net/netfilter/nf_flow_table.h         |   8 +-
 net/bridge/Makefile                           |   2 +
 net/bridge/br.c                               |   2 +
 net/bridge/br_nf_utils.c                      |  38 +++
 net/bridge/br_private.h                       |  13 +
 net/netfilter/core.c                          |   3 +
 net/netfilter/nf_flow_table_core.c            |  45 +++-
 net/netfilter/nf_flow_table_path.c            |  20 +-
 .../selftests/net/netfilter/nft_flowtable.sh  | 251 ++++++++++++++++++
 10 files changed, 384 insertions(+), 5 deletions(-)
 create mode 100644 net/bridge/br_nf_utils.c


base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.53.0


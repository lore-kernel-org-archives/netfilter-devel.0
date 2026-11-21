Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795294538;
	b=wbNx/Ya8llZSTpxZYKfaoLxzMX7L+q6vUNUOttGRGHpi2hW21wt3Huq2AWbrxZksIFPC
	 o+LrrSL/9wk1u/cfTtXlOR9+/JgTvEqd3krIaPRmKeA590mVsRXEFZ8N64/n98T/apsbF
	 9szjUXgVR8u2YQtf7zxT+ebr24S5UeIMb6IJFdm/ptkQe/Y4nshwtTWCYtm/xon61iTBV
	 6GS3Kg/52jxTgS+3nexgIy5uCrtAIyTpDE5zY7e1kkzFp8KVivHfCiZpeT7XKV+jTOiDb
	 N39tpJZa/dxXXIlDJbsxliNNIZq2s5m+TcOjUY+Na+vFlms5lQkD20h8QTsVWqreuZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795294538;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=FH6CAC7V6zrcojqtjKmAk9ZWlQF+y6QKr70PrUGFm5M=;
	b=TZ58Qb9BnlT/bgqE/1V8uAlxITXU8mSvPokQ8KLQJliifYmgwlhEH+lXFgj6AeFfRtit
	 asKxU0zlWEIf9FIA/x++rmLcNa7cIp1mLpO0RsHg7im98PnoSbug13t00nOOY1ZXiD875
	 1XUelU9kDtAlKohtqxdPwMUJJkZZ2NseoasJfh4ie1Ed/RPUtYuDEHkvUpQJYLuQ8UKAu
	 rTA2Kgv2wJELA/KHqh1aZN4zDQN2m8LhPfBQyYrEEebHE6+CzVgphQmSFovoqa3NYobsX
	 lKSTdAI3iya3CSY/LBfdkAXRRkPFsAGHNsjO2bZixrd4QWIAhWP2b7lPuzNSE8jhvTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=jI0DfhXh;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F082606A335
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 20:55:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F082606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=jI0DfhXh
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c50933bdf4bso485473866b.1
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 12:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1795294536; x=1795899336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FH6CAC7V6zrcojqtjKmAk9ZWlQF+y6QKr70PrUGFm5M=;
        b=jI0DfhXhmytCvxyZCYk0sBeqom5DdS6FkfC3NWMuRZwIJ5//bHkwu73DeyicJ3eH8z
         Fyf0NAa+8EcSQ9XfArgLFzfPnPyd+szkggVJrM9M2DYSLbIFi40CiFr4QXhjzqs4YGZO
         ndhgomjI+p2FJJqBl0Dfr05g26DStFfgvyLJ2c13gNc4tRzAJtplta1rzNTZKbrw/UPl
         9UYE1Q3Nym2M+i/WEzg6J4rku28nhIpQl6DYKY6aECq0YuB5t+GHAcoaV6wIlIpPW4c1
         D+UqQh2BQaGA7TDZAfDj+RX4KTIDctNZ8QQAPC2dGil+GuM7LzGONQafG7VF3v/dVxtf
         U8xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795294536; x=1795899336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FH6CAC7V6zrcojqtjKmAk9ZWlQF+y6QKr70PrUGFm5M=;
        b=sg7d50c5LPmikw/QSR1WOA9ZK26HYKnywwYzmbZ8Lx+W3IhoNeFS9thjlDleayA7He
         lyuVJBX/T/vcFEZzpFF3oxLY0Y/ICtlR7zjsKWrhUDe+Ey6WOe4tj97ZrKO60Dfj3QiC
         DGlMK7/Ds4U3w0IqrH5mKAA4MCL1536N9AgbiVVg3+gAsDokvRZ3tVQc0YtQNC5Duy/9
         ZFBjQwf+nPjFmSfTMg+JCVRAXxgkHN+Q0r3b+zt9S0+JUaGh4y7LS5fmHVaViubqwnJH
         hDNpOfuY9ULJEiLyyb+2CweP5z8gyFNUZxL65k+Hh3u4vz81fW5hT+Zli3cO6qayOS3o
         yq4g==
X-Gm-Message-State: APuU4Z9+4thpbjLotPpDkWAdll2vwKQ06jf6PfMHt+dlOMdUdd/Twmyl
	v6YkwiP4Z2+OKvcSIinJf58F+elDdBPB9A7Kr7Gj7WM+HQW+9JwOWLbOsUagxD9yOxN5g9EvOeo
	S7fpgpClP
X-Gm-Gg: AZFdTZca23A5AMzxs0B/iyei/MYiNMlAZzLgMf8h7QIEyBNozsfbDs+hkBhtyBvhdGR
	KOcg7cejwJCtJgR61LrU+qBVgI9Sk6WzcIG1F7INx5mze03PA3wCfeG73IC1tlTxIZ6gR5LocDB
	OkhjSH9VEVh8ls60lPfoUzYPAx9YZcBk6hLYLxYe1ojRxuOXTKYu180JDghYgISHJlLTvG5cB89
	d/qP/atwteq/qzFQnvssfvH2BuV1yDe8rXQhKbpY72cECEV6AJ2z2GWtiG+uaPrQnlMGKK7MebE
	NDCU5IGWq8ok2sFScToA4uFUV6yM7bYdIO+XfEU0qhiOOv6yl2Iaa2k8FKSr26WK09mCcINsuHS
	uXgsN6tXs4J/YJkV2At3UGCGT0Gz29OuhOYE/eeggcFKDzvjhnwkdFwezvqWuWvgB5ZcVSF2yM3
	U18+5g5tM1ynahde0/QaB1ysjWDFv1oK+61ma8CsLHJD/Lwc6pp04cfc/DTTC8vKZzpXRTHMhR0
	UvLh6K9ntd+dOdaysQ6sW3GSExi/XdQN2m5jOWzOOkmbc4PqpT+vylIIGgXEla6wEdS1orloQhj
	bJpmTUZJ/ayv+0gfNqvAZQ4KDq/OVP9wLIZSN9e0zPBqynoHveuwob8TxxXN+THyDsneVrIwewi
	nZLwpaOz+RJwXZF7E3DO8adbRMJSagnXV1uVgOM12XK4fAJbOGfW/Ojx/40vkNR7CGT6OybltC7
	+GKgDSOyAd2orCvJ8YyCDEpsuEKUIfYRg0Pf7l8C0ZVZ0f2muieR8O5Kyj34MIYq5rylZ2p9k0X
	yiUId1P9F0Wvd68pyX+nH1n5kwwLN3v/kXI0lMW4fKMHLVH4kHW2mu3/87q1gBtcxuwPjQ8PbpH
	N/ix3EJQkLD+M0OE6LWbAkRwXxLaxdlGAyzeQ8Bqq4H9nKDJ/GzQnbM=
X-Received: by 2002:a17:907:3e86:b0:c36:777f:824c with SMTP id a640c23a62f3a-c51315851d7mr813630666b.4.1795294535198;
        Sat, 21 Nov 2026 12:55:35 -0800 (PST)
Received: from Desktop.tail070c67.ts.net (p200300f2470dfa000000000000000a27.dip0.t-ipconnect.de. [2003:f2:470d:fa00::a27])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513aea28f4sm237136666b.33.2026.11.21.12.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 12:55:34 -0800 (PST)
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
	bridge@lists.linux.dev,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH nf-next v11 0/3] netfilter: flowtable: tear down bridged flows on layer 2 roaming
Date: Sat, 21 Nov 2026 21:55:32 +0100
Message-ID: <20261121205535.1888592-1-julius@bairaktaris.de>
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
to the old port when the host moves to another port, for example a Wi-Fi
station roaming between access points.

The series applies on top of Pablo's "netfilter: flowtable: unify direct
and neigh xmit path" series (nf, v6):
https://lore.kernel.org/netfilter-devel/20261120225227.3565643-1-pablo@netfilter.org/
His series is posted for nf; this series is for nf-next and applies once
nf, with his series, has been merged into nf-next.

Patch 1 is a bridge fix the series needs: br_fill_forward_path() fills a
path to a port that does not forward (STP blocking or disabled, an MST
vlan not forwarding), so the flowtable transmits where the bridge would
not. Patch 2 makes the gc tear a flow down when the fdb entry moves or
the port no longer forwards in its vid. It is Pablo's patch with my
changes on top: it keeps his authorship, his Signed-off-by from his
posting and a note of what I changed. Patch 3 adds selftest cases.

The gc finds the bridge port from out.ifidx through the vlan devices of
the path and the bridge from the port, and looks the entry up in the vid
the forward path used, which the tuple now keeps in out.bridge_vid. With
two bridges on the path it also checks the outer one. Neigh xmit flows
need no such check: a forward path through a bridge always makes the
flow direct xmit. struct flow_offload grows from 296 to 312 bytes on
x86_64; its slab cache is SLAB_HWCACHE_ALIGN, so an object takes 320
bytes either way. A gc pass over 2000 flows, 1021 of them offloaded to a
bridge port, took 368 to 393 us with the series and 261 to 276 us
without it (median of each of three runs), and no flow was torn down.

Tested on nf-next 994089a3fa38 with Pablo's series in an x86_64 guest:
nft_flowtable.sh passes three runs out of three with PROVE_LOCKING and
three out of three with KASAN and PROVE_LOCKING, including the twenty
roaming cases in both of its passes, with no lockdep or KASAN report.
Without this series every roaming case but "del" and "age" fails, the
two tunnel cases included. net/netfilter and net/bridge build without
warnings with W=1 (x86_64 allmodconfig), each patch on its own, and with
BRIDGE_VLAN_FILTERING off.

I used Claude (Anthropic) to help write these patches.

Changes in v11:
- rebased onto nf-next and Pablo's xmit series: the gc checks the fdb
  entry after his nf_flow_dst_check_gc()
- selftest: the host roams below an IPIP and an IP6IP6 tunnel on the
  router; Pablo's series offloads such a flow as direct xmit to the
  bridge port

Changes in v10:
- the tuple keeps the vid of the fdb lookup (out.bridge_vid) instead of
  the bridge_vlan bit and the port pvid: a bridge vlan that leaves the
  port untagged is popped from the encap stack (DEV_PATH_BR_VLAN_UNTAG)
  or never pushed (DEV_PATH_BR_VLAN_KEEP), so v9 looked in the pvid of
  the port, which is another vlan when the untagged one is not the pvid,
  and kept the stale flow (Sashiko). This answers Pablo's v7 question on
  bridge_vid: no bit can recover that vid
- the gc also tears the flow down when the port stops forwarding in its
  vid (STP blocking or a disabled port, a vlan removed from the port,
  vlan_filtering toggled); v9 kept sending to a disabled port and in a
  vlan removed from the port. The new patch 1 keeps the forward path
  from recreating such a flow
- with two stacked bridges the gc checks the outer one too; v9 checked
  only the bridge of the transmit port and missed a move on the outer
- selftest: vid 10 untagged on ports of pvid 1 through a vlan device on
  the bridge and through the bridge pvid; a move from behind the inner
  to a port of the outer bridge; the host's port disabled; the vlan
  leaving the port; vlan_filtering turned off before a roam
- selftest: the IPv4 roaming cases turn IPv6 off on the host, whose
  router solicitations crossed the bridge and refreshed the entry the
  "age" case waits to expire (2 of 8 runs failed)
- selftest: lines wrapped to 80 columns, namespace names initialised
  (NIPA checkpatch and shellcheck on v9)
- Cc coreteam and linux-kselftest (NIPA cc_maintainers on v9)

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
- authorship: Pablo's patch is credited as such, with his sign-off from
  his posting and a note of my changes, instead of Co-developed-by; his
  paragraph on the switchdev notifier alternative is back in the commit
  message
- rebased onto current nf-next

Changes in v8:
- drop bridge_ifidx and bridge_vid (Pablo): the bridge port is found
  from out.ifidx through the vlan devices below the port, the vid comes
  from the encap stack (bridge_vlan bit) or is the pvid of an untagged
  port of a vlan_filtering bridge
- the fdb check sits in nf_flow_dst_valid() next to nf_flow_dst_check(),
  the hook is fdb_valid_dst() again, and the comments Pablo pointed out
  are gone

v10: https://lore.kernel.org/netfilter-devel/20261115005555.645727-1-julius@bairaktaris.de/
v9: https://lore.kernel.org/netfilter-devel/20261108155344.35845-1-julius@bairaktaris.de/
v8: https://lore.kernel.org/netfilter-devel/20261017235849.1066624-1-julius@bairaktaris.de/
v7: https://lore.kernel.org/netfilter-devel/20261014235628.197976-1-julius@bairaktaris.de/
v6: https://lore.kernel.org/netfilter-devel/20261004171605.3544792-1-julius@bairaktaris.de/
v5: https://lore.kernel.org/netfilter-devel/20260914072541.897040-1-julius@bairaktaris.de/
Pablo's patch: https://lore.kernel.org/netfilter-devel/20261014210256.1573072-1-pablo@netfilter.org/

Julius Bairaktaris (2):
  net: bridge: fill a forward path only to a port that forwards
  selftests: netfilter: nft_flowtable.sh: roam a host between two bridge
    ports

Pablo Neira Ayuso (1):
  netfilter: flowtable: tear down direct xmit flows when the fdb entry
    moves

 include/linux/netfilter.h                     |   7 +
 include/net/netfilter/nf_flow_table.h         |  22 +-
 net/bridge/Makefile                           |   2 +
 net/bridge/br.c                               |   2 +
 net/bridge/br_device.c                        |   2 +-
 net/bridge/br_forward.c                       |  19 +
 net/bridge/br_nf_utils.c                      |  35 ++
 net/bridge/br_private.h                       |  14 +
 net/netfilter/core.c                          |   3 +
 net/netfilter/nf_flow_table_core.c            |  68 ++-
 net/netfilter/nf_flow_table_path.c            |  29 +-
 .../selftests/net/netfilter/nft_flowtable.sh  | 390 ++++++++++++++++++
 12 files changed, 587 insertions(+), 6 deletions(-)
 create mode 100644 net/bridge/br_nf_utils.c


base-commit: 994089a3fa3882f27f4bed9fc5815ee7df502e88
prerequisite-patch-id: d7af24391d138e7c6afe5585de4a14c8bba23c67
prerequisite-patch-id: dfb16f54f47b0c18b09eeeeccba9725bd15a6c7d
prerequisite-patch-id: 9949846db34c9fa718ff1968445bcb618920f93b
-- 
2.53.0


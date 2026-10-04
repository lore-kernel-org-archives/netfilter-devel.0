Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A80470E84
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134203; cv=none; b=iQBXEia0O4JOqmopE4xb1UfUcjKOYXbNqZ2NTfa7YjEeA3OvkOhzzO2x6kMLe8Rz+4BbTvruHdssLga3tLrj/LsF0VaEOUHPMDqsUxba5BXS2T0zMPOBQ3LLD8Kd09fY5QhwytlfeT2dzBOrYw31beoW3DPWXJWzmTccB6aTU7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134203; c=relaxed/simple;
	bh=bmE6DJq5mQYt8ACvF1ZIyWP9iLVRBzWtezcMwXt3IsY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fS1ZXbH+oXU5UyMtm3YLXtZ4KbkpwMKw9JWYF/+vppU7zdrNgw3BxwLijCdaDgUhy05//qogMhY5D/ZGTNJbPFa8oqvV6MZZvqGMafD12x+QJ1k/Pm5MSJUiR6NUqygJStGlx/nCqaYvPcxk8v0YhHI7+4bwKbOojQ98/fHTtOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=zxAXwcy0; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="zxAXwcy0"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6aa850436d3so1050491a12.2
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 10:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791134199; x=1791738999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TlaQzqtT4L/X0UVb7t9+uS9vqwfYnLXqmrlooszQDxo=;
        b=zxAXwcy08QW2QkJf7VIp31UHdQhVL68lgB0JEDGWR8QA7h8+7jE3REcLYMDKnYl6Q+
         RAutXssSpHHCf9kvoNGCMCvnGfeX4WsvnrLV/anvM1CSC5Qc9CVP+2208Also9XwOdr1
         tHFWcKmmNenZE+Owe3aFaSC6WFqdlZDRo3E5gCH3kxbsu5bEJ7qsrLCPML6IvXUvNi41
         mZMpcX595P5a2+Fg0bv6qEiNhmXK4TxfqlYdg4lI4epAgMOZ6Y80KzuNAVUFvLkrlbbz
         nIzZmJQQFaokpafRbamYcVTwNJA/CFHVjQTyl6HA9zLYAL2VVQnWXHMvlHDy0NDXDiz1
         +KTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134199; x=1791738999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TlaQzqtT4L/X0UVb7t9+uS9vqwfYnLXqmrlooszQDxo=;
        b=sZpqRZBWVNk0iQEsGQ2Y/tsM+m6wWEMkmX/OOlPc4Tn6H18dRlVqmYbxc5uP/DyP42
         NguD6zgkUdUDTSgqboKo2rkg8fcI/H11mm581hChQaiIEv4TlErr/12u8NKdxTHBBLPa
         3FPkO0Ewy0gzZ20/JDZ/iRkC7iJ/OPKM++ND5DWOr74miNwSAatmRXh6mBz1FB2ZEBg/
         Jb9jLGdsazTUqUMgkNifP2oB3XMV/38HdMZx3dqUmeq0b/SsSsCym6rtwjWIKmw6T5u5
         knunPdVxxVOLX3KcIM5mqufzT+h9rD3lbDvcyGjWLVh+8a9h2P8048BrOh8+uBwX+vg8
         K1FA==
X-Forwarded-Encrypted: i=1; AKwUvBz5x30RXZWRUTNlBfMBLfWx6M2qGJuaVE9kJEKAs68wW9bTPJevDIJ7feAN9lhw5xA0HC+xj7Ii3maV1sKmZrk=@vger.kernel.org
X-Gm-Message-State: AFq9FYLAoZwJKFA3glkLpIxLZWMgkiT3YVrWPrJHl9EmPdaGBByiGv0d
	Yp1OcJ/QZk4AV6303CZRcCCzA0+DqE5xqkY6JShtnXx6nIfV0Tgq08pxemHUjy1PJg==
X-Gm-Gg: AYBFou1J3ooPEG3NojMMzVLtXJENoI/X/hrdKQJQ059WRi32IY6QprWxJJ1UvZdUBv9
	Hd/3mvYr0z4z+vCOhxMs0OCkZlZAiZDg7KWc5j+uZC5aqJ683p3ZpHqRL0iisuWxFFdzrWKz+Rx
	ieythxz+L/kD3o50IXapz4TznMLtxALWDpjC05ZaaCAxm/uM/PXNL8mftmcikg/dtAgyz3t6LII
	JnUDcZgguQPj9um7CW4aNOVoHkSMXoRSsx+e764jZOeNn7WqJW8bftyphTH7LOayoFk+MnnxTze
	6fnCmWf8eB0kNqFI4O+NEbnCnj6oot0OSNAtfpryqCWV+IdeZi6UEnzWyBk5czU30IkfsAeR/yG
	3Bi+r6WVdIV280880mJZxpm0nmtIXi8zXUybiEyoWjMMQNbJmlCMs6WOtVm4Q4mFH8D5k/nh64u
	iIdTayJbh7ZHK11vUNRi2MlkUwEofphVzy77rfU4BC0g9rG0vP+2NWHp00TnCSpBQ/K4ctGRbxZ
	Lwcqj/YEHR6NZusx+xSwm8wxC+fUhZrFdtaYkFilKQWb1wlDYUSk+TSeLrgIx4jO+GY3ymJY55M
	a5/Z6hrFHQ3Bs+apkfF32OAjEK+rgHopzdb9qdfy21VpOttLkUjOEgQ4bb1l5TEZZXRzWu7o1xO
	jwjOOf9CSVtJNn9CAWhibC2j71/bPyMant1UgXPIQdk2rRSBkQIoi5yCHWXrT59Cw63MQllwyzY
	jo37bbAOJwLNYTAmop8HbNZrA=
X-Received: by 2002:a05:6402:2709:b0:6af:a64f:bd44 with SMTP id 4fb4d7f45d1cf-6afada35853mr4633290a12.45.1791134198617;
        Sun, 04 Oct 2026 10:16:38 -0700 (PDT)
Received: from Desktop (pd9513667.dip0.t-ipconnect.de. [217.81.54.103])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6afb014784bsm2256819a12.3.2026.10.04.10.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 10:16:37 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	lorenzo@kernel.org,
	nbd@nbd.name,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v3 0/3] netfilter: flowtable: carry a priority into the offload
Date: Sun,  4 Oct 2026 19:16:33 +0200
Message-ID: <20261004171636.3545085-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Packets forwarded by the flowtable skip the ruleset, so a priority set
with "meta priority set" before "flow add" is lost after the first
packets. Patch 2 stores skb->priority in the flow, applies it in the
software fast path and passes it to drivers as FLOW_ACTION_PRIORITY.
Patch 1 makes mlx5 ignore that action on flowtable flows, so flows it
offloads today stay offloaded. Patch 3 adds a selftest.

v2 review asked whether this should be a flowtable attribute instead.
A per-flow priority covers both one class per flowtable and a class
chosen per connection, with existing syntax:

  meta priority set 1:3 flow add @ft
  udp dport 5060 meta priority set 1:3 flow add @ft

An attribute needs one flowtable per class. nft rejects a device in
two flowtables of the same table with -EEXIST, so it also needs one
table per class. Pablo, is the per-flow approach fine with you?

mlx5 maintainers: patch 1 is needed before patch 2 and is meant to go
through nf-next; an Acked-by would allow that.

The selftest passes with the series, and its priority checks fail with
only patch 3 applied (QEMU, three runs). The mlx5, airoha and mtk
changes are compile-tested only; Lorenzo, a Tested-by on airoha would
be welcome. struct flow_offload grows by 8 bytes.

Changes in v3:
- new patch 1 for mlx5
- airoha uses the priority for its QoS queue (Lorenzo Bianconi)
- describe the tc flower effect and the TOS-derived priority
- rebased onto nf-next

v2: https://lore.kernel.org/netfilter-devel/20260902155136.4963-1-julius@bairaktaris.de/
v1: https://lore.kernel.org/netfilter-devel/20260901092632.369248-1-julius@bairaktaris.de/

Julius Bairaktaris (3):
  net/mlx5e: Ignore FLOW_ACTION_PRIORITY on flowtable offload
  netfilter: flowtable: carry a priority into the offload
  selftests: netfilter: nft_flowtable.sh: check the priority a flow
    carries

 Documentation/networking/nf_flowtable.rst     |   4 +-
 drivers/net/ethernet/airoha/airoha_ppe.c      |   3 +
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |   1 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/en/tc/act/act.c        |   1 +
 .../mellanox/mlx5/core/en/tc/act/act.h        |   1 +
 .../mellanox/mlx5/core/en/tc/act/prio.c       |  22 ++++
 include/net/netfilter/nf_flow_table.h         |   1 +
 net/netfilter/nf_flow_table_ip.c              |   6 +
 net/netfilter/nf_flow_table_offload.c         |  11 ++
 net/netfilter/nft_flow_offload.c              |   2 +
 .../selftests/net/netfilter/nft_flowtable.sh  | 110 ++++++++++++++++++
 12 files changed, 162 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/prio.c


base-commit: 87b80c2f6b05cad9f0ff9136709c62a0f59923e3
-- 
2.53.0


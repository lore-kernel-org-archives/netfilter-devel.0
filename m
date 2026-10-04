Received: from mail-ej2-f41.google.com (mail-ej2-f41.google.com [74.125.228.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE9246E017
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 17:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134185; cv=none; b=ANiJr0YlE52CwgHnzg4rFZLZSRo66e/Funqot4iNYfqzZdtlgFPUdAg2l9B8HxCPGMqygGLimVYQsDrn7LbewtXc/gK7Vp1MhpkCXIRIzr2RT+SSGip2OCcf1J2+G9m6pfkhp6ldlwE0OM91LuI1sELm26rGkLxvLUOaqwZcYSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134185; c=relaxed/simple;
	bh=ITxbZyy/8+4On80Giq8R9Rj7Fl1GPU/lQNDmPuwvfH0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rXAem31iKx5kxfCSayibum40ro5xRwONTpeDLVvJl1kBLde5uTXrMVvmc6f6JVuF7TDOpVE1ca64kNTmy+pqmYCX/0U+KogKJ4lmSit5Crp0vGnqB8A2hGVi/qdE2FxnP4QhHd8wUsG6QZbDrPKt25ayk1EHN2y6/ygVasqChnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=mfNJwzLN; arc=none smtp.client-ip=74.125.228.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="mfNJwzLN"
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2e0b486d91so194211066b.2
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 10:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791134180; x=1791738980; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=REM+0eVSevhhqRi1ya4wokt6SQ21EvmCZ8tdDdEeLnE=;
        b=mfNJwzLNnGo1k+13OZt08ghMO+MTewabqrH3O8b3uR0wZv60U7jgUtjeTT9dAKsd1g
         HgRHrdJUVJV/7R/WnEePvFkqFgl6malSQiCETefJGVy2N/da4cai7v8re9eGX3LrAlwa
         lBBO6EnSwamA0dX2Hmwt7sxYHJUYPLiYL6J3fV7A332Z7zdc5oVMjfvqAPiTvemxcz15
         mevIllKwfabl1+UY2gp6BMhou50p9bo0Mvsn8BuzhgBSar/pogu1rxWo17eA5tQKPWNQ
         DVxJhGMnHtUZWfN0fc9QwnMcwZtVbcbZmQhZhv78362coqgJomul/K3SO7Dy/5tw7I5f
         4Mtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134180; x=1791738980;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=REM+0eVSevhhqRi1ya4wokt6SQ21EvmCZ8tdDdEeLnE=;
        b=pIOhj7MjU8hi94HseoEv0/i9YnNHME75vdiXoaektHLYqr2XZ2O30jgG3LBuAigjj5
         oeKr6b+vsaUyGPN9IxOsLdXusqwzcFUddpN5bVo0qhRdaSGVjth7e5ZIIUn0lq69OTey
         jEd3LlcK0p2DCWeTTSd6e8zAAC1yVVPgu7JBOG3McAOIHptJqYZO/5I4pXGNo4LNbHtE
         ZnvYgzjmqJIxkOWbzZMTXO0NboVDqPInaR2pD8HK6jnkaPzgcsQSoF0qYwsOLlrZOkvv
         MihTqqHjq2SD+t2lAZl3xmdXNjnjIp6+jgpfIpR3RtUv3CmevKLzs9Jidnnpq+LqaAdS
         Yh4g==
X-Gm-Message-State: AFuF++mR20eKNFeR+6BUUMSDFMlYA0GY4VT+mgBmOkje4o3KO1K/RZFZ
	LW6YXvDd3vkSfskgPoWY22qEnnS+Ae9+nmwUYXXVweVVc6j0BW6Q3GFCnXTZBw2zHinrbmY5CM+
	UK3rxGA==
X-Gm-Gg: AYBFou0Ey1ANBga5wDw+MeuMQYa2wv/eg1Z5VJJ5lN9YAeswwqYGt+nI4YJHGJFJDrD
	E5G+uXf/ybo3zhujJfFjf5yjm69kQd+XhKFgQOBgj4+/UMfTZC3bvMCYJvJp6W78apTspUwod5S
	hc68GesHg96QkimycNPGUeL4JiTtUJzSKO17+1RvPY4IWGGYLU4YNPmCH6xY3KGUaHr6BuXvQJ7
	/++M0Z27ymp9Wv3ZbDma0bdFRMwIe/ExGiBviuqePPb6JNwy/ZFCB4MgCTWoX75odCRZ2s2cIK0
	PH/W8xsU0ZTdy37gzSNuKnS+TiYO5gi2M6ALZbhcwEQH3abc24oaAD9ymosvOtarlEn0eenJQEq
	gUieBWPO3O1DnfNE2KvOOLTRxu43YkLk7cpOs7z8YybIoL6uTaJTTAgWoMqrCJoAdgE/kQYpQY1
	/vPDM7Wgnn9tWpURZ9ThpzE/LNYQUt/JE3+W+HEKMAbZhdGxQ0rtS+vK3gbH/Y+EEA4gFhxh0nY
	oIvkYzE2Rt9EJC7Om5PnVOljyaf4u6BtdeUX1/sq8KfAl29ffOWuUZXk2fPkRizUYd22uprxQTr
	kbqTXa6zL4OCVCB6cnAp7CcWwzoD/buDK2oOP1AjjREe/REcC543fCLy6Yfh3yVOdwg9LxGzab3
	F5gHR9Fs/N87jse1MF6ogPf9jVD/y5wkRJC8tKhnKTZ7XzBUmBOWP+Nt2TlAJVe7HXKopXgTjVW
	aU09gXrL081R789OktgmLFRcs=
X-Received: by 2002:a17:907:cf86:b0:c26:19de:9ad3 with SMTP id a640c23a62f3a-c2e4af70e4emr698023766b.43.1791134180574;
        Sun, 04 Oct 2026 10:16:20 -0700 (PDT)
Received: from Desktop (pd9513667.dip0.t-ipconnect.de. [217.81.54.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e4cd278cesm314885266b.37.2026.10.04.10.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 10:16:19 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nbd@nbd.name
Subject: [PATCH nf-next 0/3] netfilter: flowtable: update upper device stats in the fast path
Date: Sun,  4 Oct 2026 19:16:13 +0200
Message-ID: <20261004171616.3544880-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the software flowtable, packets bypass the bridge, VLAN, PPPoE and
tunnel devices above the flowtable device, so their counters only see
the first packets of each connection. The classic forwarding path
always counts them, so this series does too, without a flag.

Patch 1 adds VLAN stats helpers; it touches include/linux/if_vlan.h, so
a netdev ack would let it go through nf-next. Patch 2 updates the
counters from the fast path with the lengths the classic path counts.
Patch 3 adds bridge, VLAN and tunnel counter checks to nft_flowtable.sh,
which fail without patches 1 and 2.

Hardware offloaded flows are not counted. A GSO packet sent through a
PPPoE device counts once, not once per segment.

Cost: struct flow_offload grows from 296 to 328 bytes (slab object 320
to 384). Forwarding from a bridge with a VLAN port to a veth in an x86
guest, mean of three interleaved runs without/with the series: TCP
55.7/55.0 Gbit/s, 64 byte UDP 177/173 kpps.

This series was written with the help of an AI coding assistant. I have
reviewed and tested it.

Julius Bairaktaris (3):
  8021q: add vlan_dev_sw_netstats_rx_add() and
    vlan_dev_sw_netstats_tx_add()
  netfilter: flowtable: update upper device stats in the fast path
  selftests: netfilter: nft_flowtable.sh: check upper device counters

 include/linux/if_vlan.h                       | 36 ++++++++++
 include/net/netfilter/nf_flow_table.h         |  8 ++-
 net/netfilter/nf_flow_table_core.c            |  3 +
 net/netfilter/nf_flow_table_ip.c              | 53 +++++++++++++++
 net/netfilter/nf_flow_table_path.c            |  9 +++
 .../selftests/net/netfilter/nft_flowtable.sh  | 67 +++++++++++++++++++
 6 files changed, 175 insertions(+), 1 deletion(-)


base-commit: 87b80c2f6b05cad9f0ff9136709c62a0f59923e3
-- 
2.53.0


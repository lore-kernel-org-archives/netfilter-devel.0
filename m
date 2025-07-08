Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FE514883F;
	Tue,  8 Jul 2025 15:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751987547; cv=none; b=O1IQojaHuicNnrJLGU6lzHjTEXRG8UbdMjnxtzWBXrms4N7RB3D7PvG0eQGK+GnJvhnZsCCroXDU/8BugPx46wdf6lr6J91qlCfQA1c3yuvNaaQR1qmyo9cEVKLldpCmbXlE20KA7o6CmL/2hqRzFyEEtu9PJa7AGVnuZI+cGlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751987547; c=relaxed/simple;
	bh=MgsSBh18JLwXEgMfnryp+3Hhf+eOukwRcV5U3PxpKmw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dlFw1Kbiq+lqQhU2rkuNNmy1S/KzPCAuuMqYrT0GgXwBttw3XNDxJfmSmdpe51mtWGAkqdfuWjQ4zQ1lFj00c8HPfyocfEOOSdsEti0EspXs1LAPFny5ubZzYufnRZM/63gSUeKIKaxdvsID/oRqLZnhYUXubBfwI1YxIldSmOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vq+/08oq; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vq+/08oq"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ae0bc7aa21bso957854966b.2;
        Tue, 08 Jul 2025 08:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751987545; x=1752592345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0ZYL1RGMT/K0LlOy87I7m++u7kv6axMD0GR0HL7h5zY=;
        b=Vq+/08oqbKzL9QYzhVXuDHF801p7YxYpZ9eXn5kcsOkdTCFsyCPeisfqtw6baMKdNc
         Ny+QNgyi0ksLPFi34rZ4sJ+2drZK3AH3A/AlH9nE3SaxBmt3EBXyFFIZP8k3GslaQHux
         DzlZoI1Dt+JOPUAojfUoKE7WR+vGUS722bRNoiB137A5K2gd/W38RQzVtj5uWwKKx6Ys
         uL4bkLcbdeKDO10HM/fAENvxjuNfcNurDF7reEeXAA08yMlDdLh9ljf6C5kcYfpUwSj8
         x8aa2BbGvAwqzHu55ndcMDAuH9RUnDQ5LpXwztUrFlqXtlrKvLP1svgknJblZG/VNVJD
         /seA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751987545; x=1752592345;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0ZYL1RGMT/K0LlOy87I7m++u7kv6axMD0GR0HL7h5zY=;
        b=D1Xk4Qk4F4iJ8Zzz7dI8o/yIyVciK0Sr71RnFF8ny8EXQ/7J4ZxPJOueymYBTLWYbH
         +D9HPj05xaheoXWqE1Ym9j+0mFyGJdKnP6terRWc3x8v8rVYvgEb+aMp/2orppfC6zTu
         8rv1vhnEThbrtGZdO/U+iY4n5s2R+tbp310IgSAgX1QnDCMbjI+YAB6Tyrtl/IF/BE+B
         /nSEhks+n5kHOQVs3W7c3kp1/0oQPa5tNltcsPtSX6dt1TykqvFXVSWMs/0fi+TvNJsk
         PwQDwy/Czbe4i8dQNnmG81fzHB51OxU10n09xqsh3k6Cj2b3ZxuvAF7o8VRnZaiCEQAA
         5oGw==
X-Forwarded-Encrypted: i=1; AJvYcCUNpXqm6wzV17kw3HOGt8gP7DJQPCL4HvM11oZJsZdBYIzIFmM4HUsC5MOG2OVyABAs065+m2c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXIfN8QeUR2qo7+YvPH4t4V3J7EbK/emtjY+GZNQKV7ii83I2P
	oMOoNH5vtmrBvWFnLyzumgRQ9+A6EYAElr8CMj3OE4GObs177qU24b81qbZM4g==
X-Gm-Gg: ASbGncth7XWwZspIkbBEXr1Tz0vJeqkw1DvXJwbYAOuNeNwRyHUuuN47RJcMI6A1dUT
	ywgtK85In8xVVQEIiNP7C3GgTB6dZyxBCsM0cniEU0ImLRMVx+GTwFG4yPIzxC+O2dguR3vAQZZ
	ytO4PiXeq7LB1SXE6N8V0/BdEpNysfM6XVewYAsEpU+rT5rft8LyES9kLi+6TjIZJCSn0elyeGk
	de0gS/Z1T+S2rJlOTNrWQKtk9URsPDDHBjhwgShwYkPLsvTOUc1azoCc0062akD8sSYeZT+Y6PG
	gZQAqcnDzBW8B9QSTNQJlXWVXbRqqTz2DsS6HcoLkypTDJETUomu1RahrbILXdd8EI/RGtLEehg
	kE7E8tXnmbgYOZyGYOcHHdc950RzQlvpdKNbt5qFbGE5alzYoPGRwtewKW36H6FYk5Q3zGyWq6j
	BRqve6
X-Google-Smtp-Source: AGHT+IEg50XwmWBdMLZG24B4Ehm6r/xs54BofsDZ22irp8Q6G+B8nupCQ9DaPVQAuFF45zjxCT1mmw==
X-Received: by 2002:a17:907:6d04:b0:ae0:34d4:28a5 with SMTP id a640c23a62f3a-ae3fe3dafd3mr1617297266b.0.1751987544354;
        Tue, 08 Jul 2025 08:12:24 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6b02a23sm907596766b.112.2025.07.08.08.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 08:12:23 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v14 nf-next 0/3] conntrack: bridge: add double vlan, pppoe and pppoe-in-q
Date: Tue,  8 Jul 2025 17:12:06 +0200
Message-ID: <20250708151209.2006140-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Conntrack bridge only tracks untagged and 802.1q.

To make the bridge-fastpath experience more similar to the
forward-fastpath experience, add double vlan, pppoe and pppoe-in-q
tagged packets to bridge conntrack and to bridge filter chain.

Changes in v14:

- nf_checksum(_patial): Use DEBUG_NET_WARN_ON_ONCE(
   !skb_pointer_if_linear()) instead of pskb_may_pull().
- nft_do_chain_bridge: Added default case ph->proto is neither
   ipv4 nor ipv6.
- nft_do_chain_bridge: only reset network header when ret == NF_ACCEPT.

Changes in v13:

- Do not use pull/push before/after calling nf_conntrack_in() or
   nft_do_chain().
- Add patch to correct calculating checksum when skb->data !=
   skb_network_header(skb).

Changes in v12:

- Only allow tracking this traffic when a conntrack zone is set.
- nf_ct_bridge_pre(): skb pull/push without touching the checksum,
   because the pull is always restored with push.
- nft_do_chain_bridge(): handle the extra header similar to
   nf_ct_bridge_pre(), using pull/push.

Changes in v11:

- nft_do_chain_bridge(): Proper readout of encapsulated proto.
- nft_do_chain_bridge(): Use skb_set_network_header() instead of thoff.
- removed test script, it is now in separate patch.

v10 split from patch-set: bridge-fastpath and related improvements v9

Eric Woudstra (3):
  netfilter: utils: nf_checksum(_partial) correct data!=networkheader
  netfilter: bridge: Add conntrack double vlan and pppoe
  netfilter: nft_chain_filter: Add bridge double vlan and pppoe

 net/bridge/netfilter/nf_conntrack_bridge.c | 88 ++++++++++++++++++----
 net/netfilter/nft_chain_filter.c           | 59 ++++++++++++++-
 net/netfilter/utils.c                      | 20 +++--
 3 files changed, 144 insertions(+), 23 deletions(-)

-- 
2.47.1


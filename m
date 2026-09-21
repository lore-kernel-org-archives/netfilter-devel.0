Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1F8320CD3
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 02:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789959233; cv=none; b=Jw7K1YiFZmFQxrEP7RkBkJxMFGZgLLVhnAY5QbfXPh5T3AdgWbb/GJYjweNrYDsq3ISJC1wYja/qlIZXGAnTyOJUZ3BmG7YYbUbcn+0tupsBc8R/giJ+elfoy34R7dr2I22gyFtIBsqqtQgoxLx0X11xX3qo/TJX9vjdIsmW9JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789959233; c=relaxed/simple;
	bh=1z8hxM5s9yvUWFN2dVotJ68WWyLuICEJqjli3GIQhLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ku6kkLFLGpobQ32WklTsbpkqaq28EEwNJ0yOYt3tEwhWQWBdcduCvCaQGw8UAB835NrDGOR3vzWD7ilt5l6RTIjozDkyGe/n/valSLgYKJlzLiQ0OWTuMLyykGs1h+AmrKBiaKyyANrEe2AIEGXDhsQ2aC0XAyEh+ot1Y3Jfwas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rU/v4GBi; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rU/v4GBi"
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-52fb76bcb1fso28473631cf.0
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Sep 2026 19:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789959229; x=1790564029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z/1dyv75kvDtXna7My+DxwKsoa7QIaIFxsslk0GYF3w=;
        b=rU/v4GBi+Uf82FgKKMkVvIar/ScJzSORjOU7TXZqVWZvxI419H01gqtLz4hRGyep/J
         LXVFIdIhI0L501PYQVRWEarOo5MUDsPNQ8nSq+kuvM7zLmfdVEK41MMq8qdU05VSc7mK
         7l6r9QD5iu+Z+XziNx2D7QCm+jwXWFH2daKp4fSKK0Rhq9unMbpKlfzCAfOYNLzo4WPV
         y0AOcmI1NKDJAMvsKxHciD2Tw2GkCaX5vEyaDRKhmP7xxyvrdKHSJpoCulpnS+ReqhnC
         xcnJjrvoaVS3M8T0EmL2sJejJC8XzCgckFtdXV7jXwLdYeYCGitsf/eRNnkLKy63KUuO
         O1LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789959229; x=1790564029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z/1dyv75kvDtXna7My+DxwKsoa7QIaIFxsslk0GYF3w=;
        b=ykg4tNgTgzFHw52GTGP8Ntujs7Z7CADgJOXJvXCFObA0qaUHqbZQrK1EE+8lS++ztL
         Xr4lf5dYGjJkqBSE4kztuJtWa8ogZB+2YCcFKqj5oON+TKbjRJtMFV1sfiSSbJ6RB6VO
         CSZOCY5eOIHr2N8OmPuG13wveoZl0CT5F6GlEvGQxI+D82uPz9qNxC/bJmOmJ4PSZ93a
         uQYHat45SMH/1jU6N4lBW0C357SQe2KsDV4yaoTXiYqokyHtxR8iOQNsOr3fPUkyklhr
         QJpfd+i+hwPCCUuZ+1BZJvuPnZN1bG7oVespyQKB8EbLJYbiKGDUt8cEhROF/bB2+hg/
         DQYA==
X-Forwarded-Encrypted: i=1; AKwUvBxg8JfnjiHL8HSWKZqEXPgrOGRXTrh1yU9Lm3zPPz1Y3Id+rBP0mFQhJN1m5mmdHyqeIMIjnvzbnyljBQUe0Ug=@vger.kernel.org
X-Gm-Message-State: AFuF++le6t19Am/rwQ9R2NvZXEQRKqrkC36CtGbunvb5UYMenLeuIFK7
	DDarMi2ywkAQzbp0ghCO4keQYet6Dr/VkgAlkKL3y4tXQFvpRFNZwrM0
X-Gm-Gg: AYBFou1aCEMPKDEG2IWHCBJDvD7arb/AoO8M6HYetYpmPcLgS//ghOEhLOaaw2ObkeC
	wjer6Z+fc9p9hUafOccTc8ncNuPSGSPVpsoqQobiuF/Mq9vXG2pZQWtb7LTYcv3XXnTIN+mOCJj
	MbPSVMLeiSVhF8ox/swl31axJk9z9Thb3IzfI/kijnkSeXxiO8FmunU4ornCBJdpXwE62Hl06MH
	aLYCmmx5Nzvq4e0ceHBGQA4iKfHRDVSv2Ew8GCTBujuuVuTWD6IiENeUCViRA2JfIUmrMceTJKo
	QHk1DyyyNj16d7delkdwO7zH9bWS7LtCG/lU2NQJIN/dR0wAqJ+qrzA5OLoHzrwY+Q1KWwaL5KQ
	QX//Ajv8nGJUGZRZuueEL35fKjttb4qkYXi6QRGdBk+fdOXTsnfROVG8QL7wcb4Q2fWRdVbnol0
	HqUGcVM525wB0+ZaVMrZijqsK9HWu53NMuG2qkHNVZ1/r0+Zn+hEabR52bYONUf97202k+oXr5p
	1OrHjx6u6cQdKjq8RfZ5So2zeEv4ss6jOMSxOWpoUUOS/T0tbBxkrQ9UBnbch+vZ5MH6kRe
X-Received: by 2002:a05:620a:3187:b0:939:d913:9a74 with SMTP id af79cd13be357-93bf56ef696mr809392485a.46.1789959228703;
        Sun, 20 Sep 2026 19:53:48 -0700 (PDT)
Received: from localhost.localdomain ([2601:155:4200:2c80:64b9:5e22:f77c:324e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93bedb3de58sm528732785a.37.2026.09.20.19.53.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Sep 2026 19:53:48 -0700 (PDT)
From: Paulos Yibelo <habte.yibelo@gmail.com>
To: netdev@vger.kernel.org
Cc: richard@nod.at,
	anton.ivanov@cambridgegreys.com,
	johannes@sipsolutions.net,
	willemdebruijn.kernel@gmail.com,
	jasowangio@gmail.com,
	mst@redhat.com,
	eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com,
	andrew+netdev@lunn.ch,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	razor@blackwall.org,
	idosch@nvidia.com,
	dsahern@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	linux-um@lists.infradead.org,
	virtualization@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v5 0/2] net: prevent partial checksums from modifying network headers
Date: Sun, 20 Sep 2026 22:53:39 -0400
Message-ID: <20260921025341.44846-1-habte.yibelo@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20260920004733.6473-1-habte.yibelo@gmail.com>
References: <20260920004733.6473-1-habte.yibelo@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A virtio-net header can supply CHECKSUM_PARTIAL metadata whose checksum
start resolves inside the network header after link-layer removal.
Software checksum completion can then modify header bytes which the stack
has already parsed.

Patch 1 validates the checksum start against an explicit data-relative L3
origin. It covers TUN/TAP, virtio-net, AF_PACKET, UML, nested VLAN
headers, and tunnel metadata. It does not rely on skb header state which
may not yet be established.

Patch 2 independently validates the checksum start against the parsed
IPv4 or IPv6 header length in all four IP fragmentation implementations
which complete partial checksums.

The v4 Sashiko findings were correct. Patch 1 used
skb_network_offset() before all receive callers had established it.
Patch 2 compared a signed checksum offset with an unsigned IPv4 header
length. This revision fixes both findings and covers the corresponding
bridge and IPv6 fragmentation paths.

Validation included strict checkpatch, focused x86 and UML W=1 builds,
an offset-boundary model, and application of the exact mail series to the
stated base.

Changes in v5:
- Pass an explicit data-relative L3 origin through the virtio-net
  converter and audit every in-tree caller.
- Parse Ethernet and nested VLAN headers without mutating skb header
  state.
- Propagate virtio-header conversion failures in UML.
- Keep the IPv4 comparison signed and add matching parsed-header checks
  to the IPv4/IPv6 output and bridge-netfilter fragmentation paths.
- Drop Michael S. Tsirkin's Acked-by and David Ahern's Reviewed-by tags
  because both patches changed materially.

Link: https://lore.kernel.org/netdev/20260920004733.6473-1-habte.yibelo@gmail.com/

Paulos Yibelo (2):
  net: validate virtio checksum start after network header
  ip: reject partial checksums covering network headers

 arch/um/drivers/vector_transports.c        | 10 ++-
 drivers/net/tun_vnet.h                     | 28 +++++++-
 drivers/net/virtio_net.c                   |  8 ++-
 include/linux/virtio_net.h                 | 76 ++++++++++++++++++----
 net/bridge/netfilter/nf_conntrack_bridge.c | 21 ++++--
 net/ipv4/ip_output.c                       | 23 +++++--
 net/ipv6/ip6_output.c                      | 12 +++-
 net/ipv6/netfilter.c                       | 12 +++-
 net/packet/af_packet.c                     |  6 +-
 9 files changed, 157 insertions(+), 39 deletions(-)


base-commit: 1e24c4f2ee44be0eee94092b5d13cbdb4bdf0d60
-- 
2.46.0

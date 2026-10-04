Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F454A6CD8
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 21:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791149082; cv=none; b=fLTksXz7fm6hMA6YVnIMgNSHWcp6isnC8Mv3ka7fkRCSBEu0x4ivAGzPjyVplGuKE92D8bBK4oMzt5fWyqS1Oh/zFWBa3MRMByP6fqgabBWbjnKWtAW6KGr5GyQdAwIAEL4FO3App7chPXMtuwU5NPMLdAPG+DFWElMdU8VIbhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791149082; c=relaxed/simple;
	bh=g4wrCZPfDP7wCd12CyPcGfR1zTDHVfS0kS2wAb83fj4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UwM457aelG/5dYJ4El9yCWpsKrWxEMmIguq5UeDSj2xwM/XECdmQ+vD73UJ0fF92d5MSXrpEs/E1Z56Jeg5Eyt9sRdglxXVXG2SCv5Ei4ntmryIT5ZmjUdjqtMXZMWnQiddniRmJQkmNpqHl///p/BYJ6pio1obiY06ks7hdINM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CCUpQU01; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CCUpQU01"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48afcfc4bf5so862854f8f.1
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 14:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791149079; x=1791753879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iquxO7jnYX2lg3f86GXs02ckl6WQPTZjoaobmRLuQcU=;
        b=CCUpQU01Lv1NGE+Il3KDrp25QTAZ7kx6DavhIz3lMYR2bCTzwh2NIkk27IiSkGOfJi
         lqOFssOR4opwNZV8pQ231NsSq2d7xpHAnsZiWqPCEat8Ql2rGV3i77lao7sbuR5VpNHA
         WB4bgtrPU7axCCS4yEgTFGerXEHg+Sc4eKBFc92K+R4IoT6tSSefqdjwZjK24wCsuRUV
         Hq6hVIHMIxSpLCAB/XN08xnz4aiR9kiLADBtADMM/EoeRjUPkcm2BejyWZpVZg/HArT2
         dQdVB/gCI8t0EL87uRj4ZOuReU+bCGPYUhHHuXu5DSjn64Nvz9gE0frIEDRJVjg3t8/U
         xb8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791149079; x=1791753879;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iquxO7jnYX2lg3f86GXs02ckl6WQPTZjoaobmRLuQcU=;
        b=hAkr6vkn38b57Ji29vgmP3DwUx9zGWsx0EdWXL9cQK4phOXD8aSSE3Lbhk4wu1ZfbG
         RxQLid+NK0uHz4OSCRG4UyyJxPBMAP9UIxoCjLTMjFW1BGgiPgq9xvnxake5yA9USa2u
         gNkT6QVNf6MTwvD1Cb/dCnp4Rz16bfPeRzjYB4Fq6NJFf8ZZ+AlfjnkwfASnSm989MxF
         ukwc9BB90NN+HIJDVlt3BiBWhZsMbWP1wtQzU2VFCIP+vhpZfejTu5cs32QUigNrynJN
         Nkpcm7QjsNtqvXlkSTMT1c3LnhkJN/T7ZEqT3Y3oigDbruggpXwvdhRD+zuDj7as5KJ5
         pyAw==
X-Forwarded-Encrypted: i=1; AKwUvByBGOnjEW8QvHtlU+OXRiQeZnKpGoCUaqbY0gl+4I+df/kiDnZ20mdeQznrBDt7Hitqs+wg20QjRFyMh8ZXqKs=@vger.kernel.org
X-Gm-Message-State: AFq9FYL/e4emO0c330gR6qJC946N1E0VpxXnEqzo9DsW6hg4ibixia+f
	vlRBGZIViAHWREf2RXZg7Xy58oxwujpoa0ptKHxrlNj6SdVPtMn8/Fcx
X-Gm-Gg: AYBFou3XrIDuJFTSJOJKtKbaLQf0z5qCaX3VyiUoNEG+jtGZrtGpsaj/1JnTed5cfFz
	hiB53qFA2+NzGiNu35Igf9VbcXKYZleKlYzSG6PQS/HlmsXlBoAEON9guRhP9Ysdwd7BI48fwb1
	u7/9826zlxM9id+E+bmwkNJnbUo9Vr/HbnIsufaeUb2TWUXV0U5TYEVrHFPSwJ18I4vQRtrw9W8
	KiO8g/QRDv+BnkZzSXowa1UQFsFE5R72K6uOMKfRCOFoFYEtU8JrA5SNLcfYFeS23AsIIBEWevF
	tXxsv9F0VAKLl9ADC4f3TzucpulTmewwbNfthNlhdk9vtBP0K/zDr1bqL/TsUh3a8HJc+6mMDqd
	VUYcvZd2HMMI42CKk95to0qsRdL8zomfiHVbDkLHQFVOA1AcY+lB74WtFToLrLJKnTBSB3HS2i7
	inl+ih6qar1LDbvwW8TP+JVK8QKojssiS+guUSU86eQ8V0CQCYUgQotaVYthY4kTJMq1BOGi6ht
	byyirM9bObv8s8BjZ2qWSxgWRFryy/lSh6mDB096R7pTmLGY3J2IlFH4h5Q
X-Received: by 2002:a5d:6f01:0:b0:48b:6b4:db5c with SMTP id ffacd0b85a97d-48c47c8d305mr9575410f8f.6.1791149079168;
        Sun, 04 Oct 2026 14:24:39 -0700 (PDT)
Received: from andreayoga.localdomain ([195.122.200.174])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b38104417sm20407354f8f.27.2026.10.04.14.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 14:24:38 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Cc: Andrea Parri <parri.andrea@gmail.com>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Bernhard Thaler <bernhard.thaler@wvnet.at>,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf v2 0/2] netfilter: preserve bridge egress VLAN tags
Date: Sun,  4 Oct 2026 23:24:26 +0200
Message-ID: <20261004212429.3648-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Conntrack-reassembled packets forwarded by a VLAN-aware bridge must
retain the VLAN state selected for their egress port when br_netfilter
refragments them.

The first patch saves the VLAN metadata for IPv6 as well as IPv4. The
second clears stale ingress tags on reused fragments when the egress
packet is untagged.

Both patches were tested under virtme-ng on a VLAN-aware bridge with
br_netfilter and nftables conntrack. With the series applied, all
fragments have the expected tag. The test is available on request.

Changes in v2:
  - Add a second fix to clear stale ingress VLAN tags from reused
    frag_list skbs on untagged egress.
  - Document the reproduced symptoms and the separate IPv4 and IPv6
    origins, narrow the first fix's claim to newly built fragments,
    reword the helper comment, and make the helper take a const skb.

v1: https://lore.kernel.org/all/20260928161830.351199-1-parri.andrea@gmail.com/

Andrea Parri (2):
  netfilter: br_netfilter: restore VLAN tag on refragmented IPv6 packets
  netfilter: br_netfilter: clear stale VLAN tag on refragmented packets

 net/bridge/br_netfilter_hooks.c | 51 +++++++++++++++++----------------
 1 file changed, 26 insertions(+), 25 deletions(-)

-- 
2.53.0


Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5A6315789
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 18:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758825063; cv=none; b=P/YbBdppv94bGLphgjIDCyjFmD9zP7Hhsggo+7xH5dD9I/kHdLkDqalvjnac9ehThSE4EJ1gLHAe5AmEO/gjrXAf/19hzkC6DpzTLe01260Q+g4sWWJN5Mla7l6NczEqaysRxbv14gI8cdasok++Lg5Y5h8+7D16ERarRQDnlh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758825063; c=relaxed/simple;
	bh=mWfnCyX4ZXZBEuQ+MvwGx9mVDI5hxd/cIA20xBbVsbA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QqVFZfV6gW7QPeVyjvbhDHaL/JR4QtbvSsr8LLnYB1O/G9uP1qihrNs0ezvRnzQ4A9fI3TxegUoDE+Ps9OUYwMWAto+1OnAoYqLQHKlAyQyFIlxds9gOklFfXPR1k3toitUFqpLwz8KnhdpBx5DC9tgi9fps/z9N6V8S3/H3MYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hZ5+EDRe; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hZ5+EDRe"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b0787fdb137so218026466b.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 11:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758825059; x=1759429859; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K7V70C2OYgSvApO6vEjdxKmgkWi6ODruqlWoYJimYJ4=;
        b=hZ5+EDReDctyaFWHCfaM4Id+b/7//sW9WhR09jZ4oCFzhZL8MV55Lw1+n3zlIyW+Uf
         uaY9wvrv3yX3mG8G+eM2w6fptZhAGAZHilxjRnto1kxAohdLC3+XsWV+9kLufxdFr6G6
         MdNOHl/mMUO1Tf0RAmN28YlsjyAllYDtl0u7SZGSXnS3Ae0i+rIT8j1Bl8kj67KwF/Ck
         XhPeHG3rQ1tTFABoV+Y6t3BPxZjzbwm+CdMMNVIHOmQtY8y+bZuanVQn590ZVFyrFqm9
         eHGCIH9GCqI1f7qg4L6IuE/MWvrkNsd2HjAx3S+tczVTwihPu/9Z2h7nwnlOTi2+gF6g
         gwkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758825059; x=1759429859;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K7V70C2OYgSvApO6vEjdxKmgkWi6ODruqlWoYJimYJ4=;
        b=QYDHAuW7kiX7I0rBkA9MaJkujYxcxCjGmHnE0XknWx+2iAYYsrY+7KmcHuMgKUcX2G
         8EKC4DguXo/jVwQch08i/szdlMaYEAOtUZHUFwo8TfbVjzy8tY+Sq5QZy0jD5/t7v43Y
         hXd70x53cuMXi+8qWCtM2QZpU2GER2EIDPFNOQfIUN5Tv/LKM74mAALesJzakj6iqzxO
         CbUbhg4VftQCtz3Si24h7XT2EtXW1R9D354EGS2dnP24DvUNOOK7FEnxsMX9vc0J1bXO
         7UKL4DaKFe5Yg1h6E7AIY1kkztLqaFU7K/bKb7vyCVHrtyhxwGqzsr1Lr8BOra2asPwn
         yx1g==
X-Gm-Message-State: AOJu0YxbIAKL4Lxfi/2CQBLdKBpA4deohgPh/uIjvSyp30EpoEizCzgc
	CHIZ/YjaFP47/64oAgXJ9mB1kCWr8MkkeaUZaeW5nla2BrDNpSQ5jMiD
X-Gm-Gg: ASbGnctCbQkOK2l2uT1Cy1Dfdr25pSkFR8q/kKPn/PJtAnmejRNEqJsl8BKq1zHjd/U
	G9Xtxb0UctQBoVJhL3D4HXhn9Leb5xjUD7E17cRUYCTGGPvIZ4JmuB5fQCMik0DBC4DOm92SpyW
	TwrBTFYHgSxJreELYh+eS96hd3w3GS04LaTgezrt/hBVhU5uwWpDGmD2TLF/sXlkpXxlXxeX3gL
	TtdpNOr1bqKVs8+Oc1f2vMuuw7X7wt7aTs0FQp5IJhdXy+PuJh/VjXRE78M9aaRznQ9DWnYV1qp
	+4mMRC7CmSshiw1l+V9tX7a80gU+4mUJ0TcJYZE17K8Wqp0mGSqfZP8Yz6vrTA98VGxWxOUXfR2
	4Gmqz2UjJSyziLpLzSgyB3xzlxiUFDu1asFvajzNeJ4O/5lkCqp7ntNbDOejFNhRKf5+gWhP7rO
	DFr+8QAT3xZBV1RIyYkA==
X-Google-Smtp-Source: AGHT+IHkLAofooZVh3BAd89JwDIkjnucLG6nJfCAeGHO8bJNdmfj/gTKINUMsN2WpKXV8iwBOnj4tg==
X-Received: by 2002:a17:907:3d4c:b0:b0d:ee43:d762 with SMTP id a640c23a62f3a-b34b9f5b4c4mr419901366b.4.1758825058790;
        Thu, 25 Sep 2025 11:30:58 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3545a9c560sm211198666b.107.2025.09.25.11.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 11:30:58 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v15 nf-next 0/3] conntrack: bridge: add double vlan, pppoe and pppoe-in-q
Date: Thu, 25 Sep 2025 20:30:40 +0200
Message-ID: <20250925183043.114660-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.50.0
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

Changes in v15:

- Do not munge skb->protocol.
- Introduce nft_set_bridge_pktinfo() helper.
- Introduce nf_ct_bridge_pre_inner() helper.
- nf_ct_bridge_pre(): Don't trim on ph->hdr.length, only compare to what
   ip header claims and return NF_ACCEPT if it does not match.
- nf_ct_bridge_pre(): Renamed u32 data_len to pppoe_len.
- nf_ct_bridge_pre(): Reset network_header only when ret == NF_ACCEPT.
- nf_checksum(_partial)(): Use of skb_network_offset().
- nf_checksum(_partial)(): Use 'if (WARN_ON()) return 0' instead.
- nf_checksum(_partial)(): Added comments

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

 include/net/netfilter/nf_tables.h          | 48 +++++++++++
 net/bridge/netfilter/nf_conntrack_bridge.c | 97 ++++++++++++++++++----
 net/netfilter/nft_chain_filter.c           | 17 +++-
 net/netfilter/utils.c                      | 28 +++++--
 4 files changed, 164 insertions(+), 26 deletions(-)

-- 
2.50.0


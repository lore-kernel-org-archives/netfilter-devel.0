Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DF435BDC7
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Feb 2026 19:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771790344; cv=none; b=H1qWRup5Fr8WGrb4/vs5KG2cOZG/TL0ak7NVMFF3abSqPPxMz6X33ergsYxcnXMTTdO64JynNeP62bdosv7KJYWbRa3mUnhi35wtmiQxPzURTwt+vNYtbnKM8VeZjjtoQmFKDujG4QzY1eA1SAsPfSyJIEPiTojCdAgiNMEgfX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771790344; c=relaxed/simple;
	bh=2r0CUzvJW0jUKiBlQ8CAUks8FkA5M+bm5AgY23WtjyM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZE/gNs56MKct0RSDDAVRD6mEg+2gLkCZii5qNKk+m790UHECgEGuPVBhEirVGcqFLzGGj3tPz9G6y5TPujv0mRzzcR8vXMLZ1E5ykaeIqsa6vS/1GSt31KuQDtPoUmhcYmeo0A6ItCZnFNWWI7olFnVHGWP2swd1LNAH+tREVBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mHwWiTl2; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mHwWiTl2"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65a2fea1a1eso7610693a12.0
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Feb 2026 11:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771790341; x=1772395141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0QUz8L/CWko35QAQoLR3+2iYYOTyA5StSVzZHwFaV9s=;
        b=mHwWiTl2s8gycdG3ji++VEgMcnuFx8cQddjV6Q5mELECSxfwdY0h6SBftlcGXNlCto
         YKQEwA7dgNqar50inT9NyQtFZGtHEmUWTan1LExLfMY9LAJG84ldXONnEoeSEXVRL9ce
         n+LfyXtW5J/AEJOU6fYd5cu1UNDHdeAFc6QCRnT4ypeld8sRBxSVxuZdJWvCL/mso3Ml
         4Gr82oW7Qv6q2EPCUEXPaBGXqjI2kLDEuJmdlIfk1kdXId++UmRfjHB7GNvjVjErROia
         j8q8NNDC46EEkXEirTEBV4lVSQkoiOZCnvke/NS54Tqvr6d5OGtAHMnU+CX0Ix40Zvnv
         EMlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771790341; x=1772395141;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0QUz8L/CWko35QAQoLR3+2iYYOTyA5StSVzZHwFaV9s=;
        b=r94HK0V0SdYymSDtkKAou56G/1ImxQmqyuqUFBMZLpIVQjeLlZNR5oBIr83LY57svj
         NGUQU/uG6fQxsydPMNZ80/rmwwU6nnQw8glWO6FZKVkPuKABc90CSG4dwG5pidM+eX1A
         7HOwHe8iVmVk0iAlXpoMkSLTHxF0+B5D3kGCrYiwkHmXvIPL+WQbvK60pgxJXgIU3Cvd
         VNGGO86beduuBTxMWX6R6zK83DD0zwnHXxP5mJLMo8X1tWCNOLHrBt4zCw6HGpgvngL/
         RdRpGaXQFxTT/Nvvg3e2iGqd+4nCwoJzkYXKxNS+pOC/5jq8EogJp6UEGwms/MVVm26Z
         279w==
X-Gm-Message-State: AOJu0Yxs8mtM4tuEIXw9pw5Mej+YMeWJQakPF8DqF1Tgl6MbRumli6SN
	xLriXylXC8ghh7VAPGlQ1pBkAnibvt/jrWl+GknkUaUU0XcQjRv9uGe9
X-Gm-Gg: AZuq6aLpR3JO12f+qwkOdyJswfVnPwGOXMMypOJ+SqpweaYWRxa2PQK7zeC8VQP1x4b
	QClQBy1Jq3B0ZguiJ/ZjSdFJPJctleui9oNoavU4aoHPqqWslXZcUFZD6MNtVqEjPI3nQ0l3BBM
	s4q+1FNI2JhoBGs22di1/FITAf4eSKg0tcaS8lwoOnj6JnIbot465oyVrfYZ5zk9lkcdz+T39o/
	MA+MCvrULVsPBCJPGRspTwvxYUP2aXLQscccwv5fZHE2wjQ3eoXBrg1opg0+GmeEm6BwRFyXmol
	/vfNUQCnqOzD5iaJenqhFhkhlcobCP/DX57epLGEpx1ZI2QDcLV4c7ogzsVKlYxmbG2Y72GzJCS
	A65IbjjN/M3SO9VtNXLCfoy2ld3mT8S8bDc9hAx7atbY5K5eeRERVPpMypOq0+AntDFvxNX2ETp
	M/zpP9ghA/FqXSQpC4a2lVfH47QG484yZkLocUHAh2Nw7p/7V8CYBXPUkH62TDcD2nGsMz589So
	Z1TvKydO4TLJEZlDLg1ExzNdePCXYPNN4BpWR6TmmiM6BcsMlavdi2cwjhed+cPsA==
X-Received: by 2002:a17:907:ea8:b0:b88:3877:d922 with SMTP id a640c23a62f3a-b9080f34a6bmr415866766b.10.1771790341184;
        Sun, 22 Feb 2026 11:59:01 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084c5c514sm246125466b.5.2026.02.22.11.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 11:59:00 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
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
Subject: [PATCH v18 nf-next 0/4] conntrack: bridge: add double vlan, pppoe and pppoe-in-q
Date: Sun, 22 Feb 2026 20:58:39 +0100
Message-ID: <20260222195845.77880-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Conntrack bridge only tracks untagged and 802.1q.

To make the bridge-fastpath experience more similar to the
forward-fastpath experience, introduce patches for double vlan,
pppoe and pppoe-in-q tagged packets to bridge conntrack and to
bridge filter chain.

Changes in v18:

- Rebased
- ‎nf_conntrack_bridge: added #include <linux/ppp_defs.h>
- nf_checksum(_partial)(): changed WARN_ON to WARN_ON_ONCE.
- nft_set_bridge_pktinfo(): changed call to pskb_may_pull() to
   skb_header_pointer().

Changes in v17:

- Add patch for nft_set_pktinfo_ipv4/6_validate() adding nhoff argument.
- Stopped using skb_set_network_header() in nft_set_bridge_pktinfo,
   using the new offset for nft_set_pktinfo_ipv4/6_validate instead.
- When pskb_may_pull() fails in nft_set_bridge_pktinfo() set proto to 0,
   resulting in pktinfo unspecified.

Changes in v16:

- Changed nft_chain_filter patch: Only help populating pktinfo offsets,
   call nft_do_chain() with original network_offset.
- Changed commit messages.
- Removed kernel-doc comments.

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

Eric Woudstra (4):
  netfilter: utils: nf_checksum(_partial) correct data!=networkheader
  netfilter: bridge: Add conntrack double vlan and pppoe
  netfilter: nft_set_pktinfo_ipv4/6_validate: Add nhoff argument
  netfilter: nft_chain_filter: Add bridge double vlan and pppoe

 include/net/netfilter/nf_tables_ipv4.h     | 21 +++--
 include/net/netfilter/nf_tables_ipv6.h     | 21 +++--
 net/bridge/netfilter/nf_conntrack_bridge.c | 93 ++++++++++++++++++----
 net/netfilter/nft_chain_filter.c           | 59 ++++++++++++--
 net/netfilter/utils.c                      | 28 +++++--
 5 files changed, 177 insertions(+), 45 deletions(-)

-- 
2.53.0


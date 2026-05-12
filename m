Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC7435675A
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 10:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778582056; cv=none; b=pw+q07AajSpNMJieBtQ2GBe976cNiKvMTheWRBotHUTGT7GaLsSYG+TpAv+QXjql9LGVygh+0W5HhTNSXXKo9y52ma1P/L8ITuRmv/dMRP1oWi9kmuKdU14ivAfxf7L6FlzdZCsz1+Gf28+WWeajrK6s8k9fRAxlWJ6eKNrjm9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778582056; c=relaxed/simple;
	bh=i9Asqei4efexr6K9Dxu3hIacS9ENwy3ZmHOz6cviPfw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ckz2rXU9aMepY0xne9cAdUkJOW8L9W+QokzljEBohCVHLJEHhXlbipHN5edAsTbUpiNX/Sld9rQRvi3M/GpR21BEGDpyjWvD7UVgVlY5iJPuWRABQo5khI8YaFBLWuzF3F6XAcdJ9ndY6UpWv3xBlFnsyF6U8EPEHU1Y3yo2o0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AnGWrN1j; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AnGWrN1j"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-670ab084a39so9039180a12.3
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 03:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778582050; x=1779186850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e6uyOtwIR++/MDHnkbSW1HQI60jV8V86JJaTfeYsrdo=;
        b=AnGWrN1jXZg0UEySfShr8HemUBgV3rp/MdYlxkj6aEJ5qycfDWIx2nFUgFp88klBOk
         sJ9IZf55BU2W7q7eH7VqgX8caPSlzBGGZiZ+QTI9GWnbjR5adMY/SF0nJPrRdNihq8bZ
         KuYbwLc5MWno3nHXZWRgo4Wq9BMmtUsdR6B89bBrZX+usqAmIm9We+8bbzjEq6YO9avC
         gR05deYxQCoXrvctx9AK19PCTBpmVBmNRm+dQaRIkxPwmIDOeP5G5PUqH0cG/aGGn4xX
         TJT/KcrrpBUXecP8wgz3MbaQfpOANao70movkvj6CUSUmcGhW2li0QY3IVoMgFZM9i3I
         PI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778582050; x=1779186850;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e6uyOtwIR++/MDHnkbSW1HQI60jV8V86JJaTfeYsrdo=;
        b=lRz8kF+Z1E6BB9GehAgscaTfN7pcJFVsxIfsz87VYJjPE4dsuY1XVyWA2V8P7ozgCT
         8LD45Maooez4h6KneJf1LaRGMdO2TjFVsCnVf80YcUjyylIFsq724ZWak7IdnK4t34Rh
         oZwvrfF/U6vcjGNeW4R4nEGjW3aeG5Z4tYuZ432YZf1Fg/J05wtUKVA4xvtsNL9D+NG9
         GZhYOXNjcUD0xH0hofdG4dT+46LSb4X7tr0yVpaegviL8RwILPf9mg4EG/BFgJdaTV0A
         ycCeCzKLJR/jolZaDYfz2OUo4S2lzmo6IMkUwFzqiEqxRpI8jHWNT/qalEK3sLs1ljkd
         f+IA==
X-Gm-Message-State: AOJu0Ywqjo9U/Qubd9UtfOodBRrPmG32jjN7SlhQcMttdRx88gjJ9gyp
	wFWT3/zURXZo6KvpxNjKXWpJ9nvNt1JVkBnm5jIj29NiGIqU3jwjHr0p
X-Gm-Gg: Acq92OGIZj8+iNQXPwS1i19dsSjJ2dDyBppfhPOwxFDUjEVkMV748IHCly088n17zlX
	LS2Ju0FJHAOLaI9+yOPnU7/kHAFMXTYbHW9XLaUMoxK++JTzcoQk9HLxW5Nx1DPZ+RhyadZPPt3
	WY8owutVHv68bJhpWl2WxEI0rz4byt28tL8SoaCQzVYCjIXK3gcq03vdQqSxjSmO0ol/JZvkNdI
	qLXRopvKPEgbVZLi7IKSjRB+vGBXhtFKHgS81Zbpo1m9bs1bhUMVespDlB3rmacWHI1jNd7N+Hk
	f2pJZh1ep2TShQ+/pExkG95ODzUZv0SoCBFjbGANZ3fnIzsztO4JMb9QV1F/7yLapS8eY2anmNF
	873TP6KGQbIJNg/SoEzWspPIDDOET+rBYzi0kxkOdZ/MZVYsv7w/qPsIWK5cW/iQ6BhjQBySOzl
	I6PlbnR1/KqnwZ13IIzHEFQ6Kbp6D/l2R1by+L8le5eZv7F4hPAJkZHXLT32U+waT4k6djxG4LM
	9N2NGnwX04pwDUw3kVibmGckV3D5UT/noLGekScjNrEEMhdhncU9Ns=
X-Received: by 2002:a05:6402:4315:b0:66e:8ca6:e79f with SMTP id 4fb4d7f45d1cf-680cf3642bbmr1368517a12.13.1778582050230;
        Tue, 12 May 2026 03:34:10 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67ef0e1c044sm4629218a12.27.2026.05.12.03.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 03:34:09 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
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
Subject: [PATCH v20 nf-next 0/2] conntrack: bridge: add double vlan, pppoe and pppoe-in-q
Date: Tue, 12 May 2026 12:33:45 +0200
Message-ID: <20260512103347.102746-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Conntrack bridge only tracks untagged and 802.1q.

To make the bridge-fastpath experience more similar to the
forward-fastpath experience, introduce patches for double vlan,
pppoe and pppoe-in-q tagged packets to bridge conntrack.

Changes in v20:

- Moved skb_pull/push for icmpv4/6 checksum calculation correction to
   underlying functions, as these underlying functions are also called
   directly. Adjusted commit title and message accordingly.
- Altered nf_ct_bridge_pre_inner() so it can also be used when doing
   re-fragmentation.
- Added ip-fragmented packet handling for double vlan, pppoe and
   pppoe-in-q.
- Renamed nf_ct_bridge_pre_inner() to nf_ct_bridge_inner(), as it is also
   used in nf_ct_bridge_post().
- Dropped "netfilter: nft_chain_filter: Add bridge double vlan and pppoe".
- Dropped "netfilter: nft_set_pktinfo_ipv4/6_validate".
  (They are replaced by other patches using meta).
- Dropped "Add net: pppoe: avoid zero-length arrays in struct pppoe_hdr"
  (It is applied separately)

Changes in v19:

- Add net: pppoe: avoid zero-length arrays in struct pppoe_hdr.
   (It was part of other patch-set of mine, moved to this patch-set)

Changes in v18:

- Rebased
- nf_conntrack_bridge: added #include <linux/ppp_defs.h>
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

Eric Woudstra (2):
  netfilter: utils: nf_ip(6)_checksum(_partial) correct
    data!=networkheader
  netfilter: bridge: Add conntrack double vlan and pppoe

 include/linux/netfilter_bridge.h           |   6 +
 net/bridge/netfilter/nf_conntrack_bridge.c | 203 ++++++++++++++++++---
 net/netfilter/utils.c                      |  52 +++++-
 3 files changed, 228 insertions(+), 33 deletions(-)

-- 
2.53.0


Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670D7402B8A;
	Fri, 31 Jul 2026 15:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512054; cv=none; b=MH+vFBuVnAIe3VVgAv+EYQCp2xfs8yDpL5Bj1XhohVH1skmCUWK0k/5mC6qtaZSBNf2uTw11F9FRC7KCnBQ4XtBoKInu3PlU+E3l23SOcWLJtTpjQsCA4Ap/6MwQw9JG9vgjc2Wg0dNc085hmU+ocski01X8MnnEakLRjvXBx9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512054; c=relaxed/simple;
	bh=tSPXSz0Ppy76GoaQ0pT9DFZBo1BzG8XXfo5ZVhrZUwo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qMPLia1NAXvNhc+jDXkfcg+m8VoT6+ZV6xn443G4EGTKSVWyKW2fCSTwYnYH27Ape3jnv/lJ6PreRBAOBiHH7IQCg2odxDT0kbU9R3Dy8FN3GJ9c9gN6qaeXO7O6L/iR1APUjvTNCkaHqUvayYFuYry6IpVrhyLpI0w0+H5m5Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vgbM3sBG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vgbM3sBG"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A33A0602A5;
	Fri, 31 Jul 2026 17:34:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785512051;
	bh=Sgt90GZ60YUypKSrF4qNa07o+a0udM9g191tsZDbX04=;
	h=From:To:Cc:Subject:Date:From;
	b=vgbM3sBGWbBTloSsmtvUKircTvv7TsDPUHpJowdlMWD3XDyBz2TK/ASJQTPfdehiC
	 I89dTFiUYJlrW1PAGaLzs27sn34uxAcYmeUpeCz/7JBcCDH4YYO9qdkAa6bEOGXExi
	 rtJIXOuux+DLqItj+34G2bX4+ZE1MKeJneTZ68jmMdo5AIAU2REhV39HHZrP3RitTJ
	 kZDVLx/SePMf+lo91AWdFSIk88UitpP7ok8elxvf8pLiMM+rCZccGBuY0YJk22CMmo
	 oVPg5Vb0LzfAne+k+tydWM3rPcmypaEr+X9DiGNZDlVPDIrIM8xO6HcGeBsrr6I6/a
	 cqVj02W4OItzg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 0/9] Netfilter updates for net-next
Date: Fri, 31 Jul 2026 17:33:53 +0200
Message-ID: <20260731153402.851224-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter updates for net-next:

1) Update conncount to use the original tuple after ct lookup to ensure
   consistent counting, from Fernando F. Mancera.

2) Remove redundant net_device field in info structure that helps
   parse the flowtable path discovery.

3) Move net_device to flowtable check to the flowtable discovery
   path parser. This is preparation work to pass the tunnel dst_entry
   via .fill_forward_path.

4) Update DSA .fill_forward_path to break at the user DSA, since
   the conduit DSA is not used in the datapath. This slighly simplifies
   the flowtable path discovery parser.

5) Do not advance index in the path stack prematurely, otherwise
   it points to uninitialized slots on error. Not an issue currently
   but it could be once tunnel dst_entry is passed via .fill_forward_path.

6) Pass the tunnel dst_entry via dev_fill_forward_path().

7) Update ipip and ip6ip6 tunnels to pass the dst_entry through
   dev_fill_forward_path().

8) Call skb_valid_dst() before accessing skb_dst() to ensure dst_entry
   is not a template.

9) Use UNACK timeout when RST packet does not match the expected
   window while in ESTABLISHED state, the existing approach the CLOSE
   state timeout which is only 10 seconds. Adopt a more conservative
   timeout by default for this case.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-07-31

Thanks.

----------------------------------------------------------------

The following changes since commit 2fbade66245059c78daeaccfce13ecf499fffb51:

  Merge branch 'net-mctp-usb-add-support-for-mctp-over-usb-v1-1' (2026-07-30 16:55:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-26-07-31

for you to fetch changes up to bf80e6802273a900311b44e47c9b1a59c6d2473c:

  netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets (2026-07-31 14:47:03 +0200)

----------------------------------------------------------------
netfilter pull request 26-07-31

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: conncount: normalize tuple and zone on successful ct lookup

Minghao Zhang (1):
      netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets

Pablo Neira Ayuso (7):
      netfilter: flowtable: consolidate net_device field in nft_forward_info struct
      netfilter: flowtable: consolidate flowtable device check
      net: dsa: stop at the user device in .fill_forward_path
      net: do not advance stack index from dev_fwd_path()
      net: pass dst via net_device_path in dev_fill_forward_path()
      netfilter: flowtable: release tunnel route on error when building forward path
      netfilter: nf_tables: call skb_valid_dst() before skb_dst()

 drivers/net/ethernet/airoha/airoha_ppe.c        |  10 ++-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c |  10 ++-
 include/linux/netdevice.h                       |   2 +
 net/core/dev.c                                  |  44 +++++++---
 net/dsa/user.c                                  |   3 +-
 net/ipv4/ipip.c                                 |   2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c             |   6 +-
 net/ipv6/ip6_tunnel.c                           |   4 +-
 net/ipv6/netfilter/nf_reject_ipv6.c             |   8 +-
 net/netfilter/nf_conncount.c                    |   2 +
 net/netfilter/nf_conntrack_proto_tcp.c          |   5 +-
 net/netfilter/nf_flow_table_path.c              | 103 ++++++++----------------
 net/netfilter/nft_meta.c                        |   6 +-
 net/netfilter/nft_rt.c                          |   6 +-
 net/netfilter/nft_xfrm.c                        |   9 ++-
 15 files changed, 121 insertions(+), 99 deletions(-)

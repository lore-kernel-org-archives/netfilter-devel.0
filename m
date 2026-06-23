Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F7F23D2B1;
	Tue, 23 Jun 2026 22:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782252957; cv=none; b=u/1fNyDqlUv1JGmw8maBg2HIYwEy+spzrdBrNR/PomcvQEx61KTQ5lACX++ExBcFOgoDSZyVxxBT0uwSGzu3hxkl7Y4SIHuvF2/cO8R8Bcqbdip+sRQQSgfMsF1JTwU4TuhY8lV6DSTxhP2oiFGul2z9s4fjSpDitYnaKRj7CLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782252957; c=relaxed/simple;
	bh=YjVtdJy+L1yQfS11Ok8T84a99kNXonKUTEflc+MvcKM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tii4m0rqUL7b1urDHT59DuE+Fagpff8gdYQ7b2Z2H/I5UTax7p4pAo94BVi43rQR/H6ZNYN9SX+03iv/DNejOxn4aQfC53sitjjc+UXLw+8zh8/nDDodnGZa8WLPKEuhiAV+w2JdnXZoOf769nwPo/fHmrGu09A3KHBaFsoBqds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WjtAuoio; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WjtAuoio"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D3CA96019B;
	Wed, 24 Jun 2026 00:15:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782252953;
	bh=k6lBIv6rU9US0qk2zk6Geq/S+U1eDJnbqh1QKtBWJ1w=;
	h=From:To:Cc:Subject:Date:From;
	b=WjtAuoio6WWaADMtGlSyxgbv2ZDZrsehG+P5cwN7aTNp7yqa25Adkb5dCTE17nE/0
	 8IFsnhwYIfDrWwVq3QbM4ot/HflzOrxTfzbxNeOq+Y4BSWWh7yt6m4XGhCphbBG44A
	 pIoQvr1QGAbF40MWsy6CahHc97Nic82Ji/f1HIJGBi7b0ZCrfzqrMqE+vueox+a5/U
	 d0azSo57xHYC6K6Vw+wRtQp/pxDtzhQA/8djjNnTT6iNRLjPdByl73b3hSgwRnseXg
	 OYWVsgs1oFE37ghfLN0ntuHiXiiGNuGpxj36d6AtZa9bSBuIteIrsRYB2Prc6X0JO3
	 cRA/2lFmwyOTg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 00/14] Netfilter fixes for net
Date: Wed, 24 Jun 2026 00:15:33 +0200
Message-ID: <20260623221548.701545-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for net:

1) Add a workaround to avoid a possible crash if nf_nat and nft_chain_nat are
   compiled built-in and nf_nat fails to register, allowing nft_chain_nat to
   access the incorrect pernetns area. This is crash specific of all built-in
   compilation. From Matias Krause.

2) Revisit conncount GC optimization for confirmed conntracks, skip GC round
   if IPS_ASSURED is set on. This is addressing an issue for corner case
   use case scenario involving locally generated traffic. No crash, just a
   functionality fix. From Fernando F. Mancera.

3) Validate iph->ihl in flowtable IPIP tunnel support, from Lorenzo Bianconi.
   This a sanity check to bounces back malformed IPIP packets to classic
   forwarding path.

4) Kdoc fixes for x_tables.h, from Randy Dunlap.

5) Use info->options so nft_synproxy_tcp_options() stays on the same local
   snapshot, otherwise eval path can observe inconsistent mix of mss and
   timestamps. From Runyu Xiao.

6) Add conntrack_sctp_collision.sh to cover for SCTP INIT collisions.
   From Yi Chen.

7) Do not allow NFPROTO_UNSPEC targets if family is NFPROTO_BRIDGE in
   nft_compat. This allows to use non-sense targets such as xt_nat leading
   to crash. From Florian Westphal.

8) Add a selftest queueing from bridge family. From Florian Westphal.

9) Do not allow to reset a conntrack helper via ctnetlink. This feature
   antedates the creation of the conntrack-tools, and it is not used
   I don't have a usecase for it, I prefer to remove than fixing it.

10) Add deprecation warning for IPv4 only conntrack helpers for PPTP
    and IRC. From Florian Westphal.

11) Store the master tuple in the expectation object and use it,
    otherwise SLAB_TYPESAFE_RCU rules allow to display incorrect
    master tuple information through ctnetlink.

12) Run expectation eviction when inserting an expectation with no
    helper, this is a fix for the nft_ct custom expectation support.

13) Fix nft_ct custom expectation timeouts, userspace provides a
    timeout in milliseconds but kernel assumes this comes in seconds.
    From Florian Westphal.

14) Cap maximum number of expectations per class to 255 expectations
    per master conntrack at helper registration. This is a fix to
    restrict the maximum number of expectations per master conntrack
    which can be a issue for the new lazy GC expectation approach.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-06-23

Thanks.

P.S: Sashiko has been reporting "Failed to apply" with recent patches,
     I suspect it relies on the Linus' tree which does not contain
     yet the patches that were recently included in the last PR.
     If it fails to deliver a report, I can provide a list of list
     to the reviews that sashiko provided when patches were posted to
     the netfilter-devel mailing list.

----------------------------------------------------------------

The following changes since commit a986fde914d88af47eb78fd29c5d1af7952c3500:

  bnx2x: fix potential memory leak in bnx2x_alloc_mem_bp() (2026-06-22 18:39:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-06-23

for you to fetch changes up to 397c8300972f6e1486fd1afd99a044648a401cd5:

  netfilter: nf_conntrack_helper: cap maximum number of expectation at helper registration (2026-06-23 13:10:48 +0200)

----------------------------------------------------------------
netfilter pull request 26-06-23

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: nf_conncount: prevent connlimit drops for early confirmed ct

Florian Westphal (4):
      netfilter: nft_compat: ebtables emulation must reject non-bridge targets
      selftests: nft_queue.sh: add a bridge queue test
      netfilter: conntrack: add deprecation warnings for irc and pptp trackers
      netfilter: nft_ct: expectation timeouts are passed in milliseconds

Lorenzo Bianconi (1):
      netfilter: flowtable: Validate iph->ihl in nf_flow_ip4_tunnel_proto()

Mathias Krause (1):
      netfilter: nf_nat: avoid invalid nat_net pointer use on failed nf_nat_init()

Pablo Neira Ayuso (4):
      netfilter: ctnetlink: do not allow to reset helper on existing conntrack
      netfilter: nf_conntrack_expect: store master_tuple in expectation
      netfilter: nf_conntrack_expect: run expectation eviction with no helper
      netfilter: nf_conntrack_helper: cap maximum number of expectation at helper registration

Randy Dunlap (1):
      netfilter: x_tables.h: fix all kernel-doc warnings

Runyu Xiao (1):
      netfilter: nft_synproxy: stop bypassing the priv->info snapshot

Yi Chen (1):
      selftests: netfilter: conntrack_sctp_collision.sh: Introduce SCTP INIT collision test

 include/linux/netfilter/x_tables.h                 | 29 +++++--
 include/net/netfilter/nf_conntrack_expect.h        |  1 +
 include/net/netfilter/nf_conntrack_helper.h        |  4 +
 net/netfilter/Kconfig                              | 11 +--
 net/netfilter/nf_conncount.c                       | 11 ++-
 net/netfilter/nf_conntrack_broadcast.c             |  1 +
 net/netfilter/nf_conntrack_expect.c                | 12 ++-
 net/netfilter/nf_conntrack_helper.c                |  9 ++-
 net/netfilter/nf_conntrack_irc.c                   |  2 +
 net/netfilter/nf_conntrack_netlink.c               | 23 +-----
 net/netfilter/nf_conntrack_pptp.c                  |  2 +
 net/netfilter/nf_flow_table_ip.c                   |  8 +-
 net/netfilter/nf_nat_core.c                        | 10 +++
 net/netfilter/nft_compat.c                         | 24 +++++-
 net/netfilter/nft_ct.c                             | 21 ++++-
 net/netfilter/nft_synproxy.c                       |  9 +--
 .../net/netfilter/conntrack_sctp_collision.sh      | 89 ++++++++++++++++------
 tools/testing/selftests/net/netfilter/nft_queue.sh | 66 ++++++++++++++--
 18 files changed, 246 insertions(+), 86 deletions(-)

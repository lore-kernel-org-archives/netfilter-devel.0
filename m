Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14414432BF5;
	Mon, 10 Aug 2026 19:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390837; cv=none; b=W/9c1GWh/9gYgx51WnYYuxm12N7a+T6XT3ioBQfV3itOdEDoINwzSUcnInK8OgcvonfvZGzJSiUQOkD/2XNuOzrayJ78DgVKyL1w5J03hDliQIKZDdl4bM1Klu2fplR+VWvRWvZczwSeFd+GRpc68AH+NYiQn+c/kEMIZNRd4OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390837; c=relaxed/simple;
	bh=0EAjSCXnYUyYuIsO3Q9piIJNNl7gSfuePnwiWuXg9FY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kztdg3qnJT0EmrMx5qFXqwVOjvxTI22WFPeOD8amJq276xnW1UcdHDJ0eIvoU6jYJEZT/Mm6b7+mmmZR1CmaRBpmbXMcMbbfWfzH3+Dd0B2Aa+97JGyE4V63lZ42NY/O7yxGd5s/nk08yxmR3NDw7kA1pcoaFv3rIoGJaBDWmOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kFt6DTWa; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kFt6DTWa"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3AB1860191;
	Mon, 10 Aug 2026 21:40:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786390823;
	bh=DnF6D6doch70BjOG5tsyGGWCSkYdLOl6oZ2xlWpR0cQ=;
	h=From:To:Cc:Subject:Date:From;
	b=kFt6DTWaXMqSSUsYCAXWnCVkqpxW3SsuBBTBxXNbNe1ipAlQx4DNLL9icb5wocPSK
	 oscUMwmRshovnRXpckr/VDTR9+UWSt8twudTyXwQv5oCaH17ujj31tLUkfkIdCi+31
	 hTs7DsgPW+u2m2SsYXbrzYUcNd71xsV7dWhdqUyhLtNPGRsin6A1hID4gLR3MooF8q
	 ys4fzaOe+Y7BjteKUmomVPEnQL/edGqd0wJ1Kd+FbzxmD3Plr1blYIKgIhCaxNrJGF
	 8EZ3/IxtrN20kRVrtdDS2gLSyf0DCfNdUgtYTcASqxysdfqoyTvEwuhWklDMcUYrSJ
	 g3nN2ngEOwJ1A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 00/12] Netfilter updates for net
Date: Mon, 10 Aug 2026 21:40:03 +0200
Message-ID: <20260810194015.932627-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter updates for net-next.
This includes an enhancement to detect ct memleaks easier via
DEBUG_NET and flowtable preparation patches for IPv4 over IPV6
and vice-versa. This also includes a fix for the nft_ct custom
expectation support.

1) Add DEBUG_NET_WARN_ON_ONCE to nf_ct_set() to spot ct memleaks.

2) Pass struct net_device_path_ctx to dev_fill_forward_path() to
   make it easier to pass more parameters to this function.
   From Lorenzo Bianconi.

3) Add ether_type field to net_device_path context structucture.

4) Rename tun.l3_proto field to tun.inner_proto.

5) Rename ctx.tun.proto to ctx.tun.inner_proto.

6) Store ether_type in flowtable context.

7) Move IPv4 and IPv6 xmit path to a helper function.

8) Move encapsulation header parser out of the flowtable lookup
   function.

9) Rework nft_ct custom expectation support to address a possible
   reallocation of ct extension area while expectation list also
   contains expectations. Move datapath to a ct helper to fix it.

10) Ensure timeout is always lowered for the non-closing RST case
    in the TCP connection tracking.

11) Bail out when inserting already dead expectation, this should
    not ever happen, hence report it via DEBUG_NET.

12) Comestic updates for improving the conntrack selftest dump and
    flush userspace program, from Qingshuang Fu.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-08-10

Thanks.

----------------------------------------------------------------

The following changes since commit 001b5d347d8ba39b2dccaefcc57967b18caec8fe:

  Merge branch 'net-devmem-allow-rx-buf-size-page_size-per-binding' (2026-08-07 18:32:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-26-08-10

for you to fetch changes up to 736fb8632217bd27da6b2e3f1f8cbbe3193fc2d8:

  selftests: netfilter: conntrack_dump_flush: remove unused variables and fix typo (2026-08-10 21:20:44 +0200)

----------------------------------------------------------------
netfilter pull request 26-08-10

----------------------------------------------------------------
Lorenzo Bianconi (1):
      net: pass net_device_path_ctx to dev_fill_forward_path()

Pablo Neira Ayuso (10):
      netfilter: add DEBUG_NET_WARN_ON_ONCE to skb_set_nfct()
      net: netfilter: add ether_type to net_device_path_ctx and use it
      netfilter: flowtable: rename tun.l3_proto to tun.inner_proto
      netfilter: flowtable: rename ctx.tun.proto to ctx.tun.inner_proto
      netfilter: flowtable: store ethertype in flowtable context
      netfilter: flowtable: move ipv4 and ipv6 xmit path to function
      netfilter: flowtable: detach layer 2 encapsulation parser from lookup
      netfilter: nft_ct: move custom expectation support to helper
      netfilter: conntrack: always lower timeout for non-closing RST packets
      netfilter: nf_conntrack_expect: bail out on insert dead expectations

Qingshuang Fu (1):
      selftests: netfilter: conntrack_dump_flush: remove unused variables and fix typo

 drivers/net/ethernet/airoha/airoha_ppe.c           |   7 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |   7 +-
 include/linux/netdevice.h                          |   5 +-
 include/linux/skbuff.h                             |   1 +
 include/net/ip_vs.h                                |   2 +-
 include/net/netfilter/nf_conntrack_helper.h        |   1 +
 include/net/netfilter/nf_flow_table.h              |   2 +-
 net/core/dev.c                                     |  18 +--
 net/ipv4/ipip.c                                    |   5 +-
 net/ipv6/ip6_tunnel.c                              |   5 +-
 net/netfilter/nf_conntrack_core.c                  |   2 +-
 net/netfilter/nf_conntrack_expect.c                |   6 +
 net/netfilter/nf_conntrack_helper.c                |  14 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   3 +-
 net/netfilter/nf_flow_table_ip.c                   | 167 ++++++++++++---------
 net/netfilter/nf_flow_table_path.c                 |  17 ++-
 net/netfilter/nft_ct.c                             | 167 +++++++++++++++------
 net/openvswitch/conntrack.c                        |  12 +-
 net/sched/act_ct.c                                 |   6 +-
 .../selftests/net/netfilter/conntrack_dump_flush.c |  31 ++--
 20 files changed, 305 insertions(+), 173 deletions(-)

Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814F82DF719;
	Sun, 18 Oct 2026 00:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792285010; cv=none; b=Ze5HnKmmYW7iL+o7akMA8JLQaPpgTZfJsrVpTk25esndsXggLVIusj17T7CNPZMtr3hOf03E0KQZGRYvwqiMtkCYNOUoAOAg8c/V8sMI17Koevsq8ho/lVDhLNXaXGwSouCth1uq8jxmky7qj22GIIfJIhs95Ewzzld+geV7xWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792285010; c=relaxed/simple;
	bh=YjV+rOYLz2RdAPVt77TuHJtClJzKeBHqDB1deKQALTE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zvx5RYM4J3w7m3yDqEApZ64nddhazCbsi7SMgCSlXZf/8YMQ4dG9EpTPEOKsusIugFPA2PfRWfzxSk+nxN78ETmyvHiXLOdSWAT2ok/IYT59DW1w5/PUdUri8KGIGNiQPw8CQ8QQZPRl8QJalR4lEbnmMZsQrt+f5B5MDR8JdZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=j59037oJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="j59037oJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792285005;
	bh=+rW2fTfedRCps+LZcxg9239fAO2sGTs7XJe15BkPNFI=;
	h=From:To:Cc:Subject:Date:From;
	b=j59037oJXkWfFJEHGumURVKXsyGDaoZ5rvghXM8FQCN8KniaCGkSgkMh3LZRAA/U5
	 RqJigrVW2vADT0MVQjoQW2AGhg96I5Ty0kBXub4Ni/1WvzIjoi7+zBZY00Tnnd/lAN
	 chdJ1cM77LVD2GoJmVrGYEFZBKtadO9J2Hcvh2mZnfFmC/QrtR9K91omVW8bcyzEBm
	 OsEMaWb+qsKshBHy415nn2MxdVkC1Ka4glGsSRXb/z9xygZ+2wgXRDMwzuG1sX47vp
	 OrGp0UKkW9N8G1uCZVfkRbncTyplAJ0m+ev3V/U+9OqNF7upyikE7DO1ebMyDsP3xR
	 ByG8kZoC9wWew==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6903260057;
	Sun, 18 Oct 2026 02:56:45 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 00/15] Netfilter updates for net-next
Date: Sun, 18 Oct 2026 02:56:23 +0200
Message-ID: <20261018005638.1776148-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter/IPVS updates for net-next:

1) Disable br_netfilter in userns and schedule it for removal in 2027,
   from Florian Westphal.

2) Update selftest nft_queue.sh to make it more stable on debug
   kernels, from Jakub Kicinski.

3) Fix a overflow in IPVS sync messages which can only happen in very
   old 2.6 kernels, from Julian Anastasov.

4) Finer grain packet drop in nfnetlink_queue when dependency objects
   are going away, from Antonio Ojea.

5) Add a selftest for the nfnetlink_queue packet drop case, also
   from Antonio Ojea.

6) Flush conntrack gc worker when existing netns to address a unlikely
   UaF, from Florian Westphal.

7) Switch nf_tables chain types to use rcu, otherwise module removal
   can trigger UaF, also from Florian.

8) Remove redundant parsing in nft_exthdr for the tcp options case,
   from Fernando F. Mancera.

9) Remove redundant skb_header_pointer() calls in nft_exthdr for tcp
   options, from Fernando F. Mancera.

10) Fix conntrack_vrf.sh selftest return value in zone subtest,
    from Florian Westphal.

11) Restrict raw table in nft_compat to specific family, hook and
    priority, from Florian Westphal.

Prepare the flowtable to support for IPv4 over IPv6 tunneling and
vice-versa, this includes 4 patches from Lorenzo Bianconi.

12) Explicitly set inner protocol when popping header, this is not
    needed for the existing IPIP and IP6IP6 case because skb->protocol
    remains the same.

13) Simplify tuple tunnel information fill up when parsing outer
    tunnel IP headers.
    
14) Add a new encap_proto which determines the outer tunnel protocol
    family.

15) Prepare flowtable forwarding path to deal with mixed IPv4-IPv6
    tunnels.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-10-18

Thanks.

----------------------------------------------------------------

The following changes since commit a5e7d8e446af9803e37a3b6a4d416fb41178348f:

  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2026-10-05 17:51:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-10-18

for you to fetch changes up to d0107f38162279d9cb0e012210731176265f835d:

  netfilter: flowtable: unify tunnel push for IPv4 and IPv6 (2026-10-18 02:42:04 +0200)

----------------------------------------------------------------
netfilter pull request 26-10-18

----------------------------------------------------------------
Antonio Ojea (2):
      netfilter: nf_queue: limit the hook drop flush to the unregistered hook point
      selftests: netfilter: nft_queue: check the scope of the hook drop flush

Fernando Fernandez Mancera (2):
      netfilter: nft_exthdr: remove redundant op parsing in tcp_set_init
      netfilter: nft_exthdr: avoid 60 bytes stack buffer in TCP option mangling

Florian Westphal (5):
      netfilter: disable br_netfilter in user namespaces
      netfilter: conntrack: fix unlikely UaF in gc worker
      netfilter: nf_tables: switch chain_types array to rcu
      selftests: netfilter: fix return value in zone subtest
      netfilter: nft_compat: restrict raw table targets/matches

Jakub Kicinski (1):
      selftests: netfilter: nft_queue.sh: only queue icmp echo request/reply

Julian Anastasov (1):
      ipvs: fix buffer overflow when sending sync messages

Lorenzo Bianconi (4):
      netfilter: flowtable: set inner protocol when popping tunnel header
      netfilter: flowtable: populate tunnel tuple regardless of inner protocol
      netfilter: flowtable: add encap_proto to flow_offload_tunnel
      netfilter: flowtable: unify tunnel push for IPv4 and IPv6

 Documentation/networking/bridge.rst                |   5 +-
 include/linux/netdevice.h                          |   1 +
 include/net/netfilter/nf_flow_table.h              |   1 +
 include/net/netfilter/nf_queue.h                   |   3 +-
 net/bridge/br_netfilter_hooks.c                    |  33 ++--
 net/ipv4/ipip.c                                    |   1 +
 net/ipv6/ip6_tunnel.c                              |   1 +
 net/netfilter/core.c                               |   2 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |  23 +--
 net/netfilter/nf_conntrack_core.c                  |   7 +-
 net/netfilter/nf_flow_table_ip.c                   | 170 +++++++++++++--------
 net/netfilter/nf_flow_table_path.c                 |   2 +
 net/netfilter/nf_internals.h                       |   2 +-
 net/netfilter/nf_queue.c                           |   4 +-
 net/netfilter/nf_tables_api.c                      |  94 ++++++++----
 net/netfilter/nfnetlink_queue.c                    |  41 ++++-
 net/netfilter/nft_chain_nat.c                      |   1 +
 net/netfilter/nft_compat.c                         |  15 ++
 net/netfilter/nft_ct.c                             |   2 +-
 net/netfilter/nft_exthdr.c                         |  34 +++--
 .../selftests/net/netfilter/conntrack_vrf.sh       |  25 ++-
 tools/testing/selftests/net/netfilter/nf_queue.c   |  22 ++-
 tools/testing/selftests/net/netfilter/nft_queue.sh | 110 ++++++++++++-
 23 files changed, 456 insertions(+), 143 deletions(-)

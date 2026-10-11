Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DC6382373;
	Sun, 11 Oct 2026 22:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756002; cv=none; b=ZKecFUkhJr8ElEK/Ed50ucH/KZ3tXPhcTRl7dRbZP7JRcYRUv4SZ6mnVsaR1bRyw2n9iplqPanLFfv977xjUVjWYif8eThsAjUfSaAfxgNDRrufuOhN3oByIBXSlhGfKa9xGwqBLQ+pehxAmcWxxYtOxnz2XsGke384XfzGhKdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756002; c=relaxed/simple;
	bh=jRDgEER/HT/TUE7SNU/DtpQFcERThBAlD0Oe0j/APzI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZUqgtWHKL0xhkxVpspOIn70aYZ5mb5kNp+9FRz5t8Ob221xpgLNTjALqIDXUqLoT3YxnfIEESY2YxPglY2ncaebK2RrzfoSB5lXg0ud4QLQX9PV7toiLzvxE05k8wtERVt2Xxn5PB/BDwdhvka0UoML7N2HTsz4+eYCXUU2C8Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gpl3LQ1E; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gpl3LQ1E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791755997;
	bh=aEezfQAKJSx4Mm+mDvuPjswUA6Hu5hdALV94K9pkVVw=;
	h=From:To:Cc:Subject:Date:From;
	b=gpl3LQ1E/SQ+EPFEaG2H89hDk77+/9YtE9pwJLsQo7zC5c4z1eh4Cdou9A8vtI1Os
	 IG1CcemyTc6hfLrbGCm9lRvEVktxqMBsra4RIwkz9+tw8Ii85/L11KerTQGLKvW/Zt
	 6yzxb1RQMv65WyoNEHVMrGrJukbycDItMsE75AMm+XzVaqztJCsjVxK7C9L1a11uMG
	 uIt8ZLAEZilLkiZrsBaHtAvCuixViQ4zu9AaA6fXgp+9u9qb8Ui5vd81XeLuwEt1vc
	 xSN3pRdodcvjE1gAydxpaINpHqfHtMQAums8vpFCaPCfa6uwWHL9hSrNH3L5xJNyA4
	 2+DOYqRtDG3Xw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 38D8D60060;
	Sun, 11 Oct 2026 23:59:57 +0200 (CEST)
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
Subject: [PATCH net-next 00/15] Netfilter/IPVS updates for net-next
Date: Sun, 11 Oct 2026 23:59:38 +0200
Message-ID: <20261011215953.1334630-1-pablo@netfilter.org>
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

2) Prepare the flowtable to support for IPv4 over IPv6 tunneling and
   vice-versa, this includes 5 patches from Lorenzo Bianconi.

3) Update selftest nft_queue.sh to make it more stable on debug
   kernels, from Jakub Kicinski.

4) Fix a overflow in IPVS sync messages which can only happen in very
   old 2.6 kernels, from Julian Anastasov.

5) Flush conntrack gc worker when existing netns to address a unlikely
   UaF, from Florian Westphal.

6) Switch nf_tables chain types to use rcu, otherwise module removal
   can trigger UaF, also from Florian.

7) Add two new helper functions to validate that socket is of inet type,
   coming in 2 patches from Florian Westphal.

8) Remove redundant parsing in nft_exthdr for the tcp options case,
   from Fernando F. Mancera.

9) Remove redundant skb_header_pointer() calls in nft_exthdr for tcp
   options, from Fernando F. Mancera.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-10-11

Thanks.

----------------------------------------------------------------

The following changes since commit a5e7d8e446af9803e37a3b6a4d416fb41178348f:

  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2026-10-05 17:51:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-10-11

for you to fetch changes up to b4074bbf5c23b05bd34022ade979f3d5f4e86516:

  netfilter: nft_exthdr: avoid 60 bytes stack buffer in TCP option mangling (2026-10-11 23:29:26 +0200)

----------------------------------------------------------------
netfilter pull request 26-10-11

----------------------------------------------------------------
Fernando Fernandez Mancera (2):
      netfilter: nft_exthdr: remove redundant op parsing in tcp_set_init
      netfilter: nft_exthdr: avoid 60 bytes stack buffer in TCP option mangling

Florian Westphal (5):
      netfilter: disable br_netfilter in user namespaces
      netfilter: conntrack: fix unlikely UaF in gc worker
      netfilter: nf_tables: switch chain_types array to rcu
      netfilter: add nf_skb_sk helper and use it
      netfilter: add nf_sk_to_full_sk helper and use it

Jakub Kicinski (1):
      selftests: netfilter: nft_queue.sh: only queue icmp echo request/reply

Julian Anastasov (1):
      ipvs: fix buffer overflow when sending sync messages

Lorenzo Bianconi (6):
      netfilter: flowtable: recognize IPv4/IPv6 in tunnel proto matching
      netfilter: flowtable: set inner protocol when popping tunnel header
      netfilter: flowtable: populate tunnel tuple regardless of inner protocol
      netfilter: flowtable: add encap_proto to flow_offload_tunnel
      netfilter: flowtable: refactor MTU check for tunnel offload
      netfilter: flowtable: unify tunnel push for IPv4 and IPv6

 Documentation/networking/bridge.rst                |   5 +-
 include/linux/netdevice.h                          |   1 +
 include/net/netfilter/nf_flow_table.h              |   1 +
 include/net/netfilter/nf_socket.h                  |  35 ++++
 net/bridge/br_netfilter_hooks.c                    |  33 +++-
 net/ipv4/ipip.c                                    |   1 +
 net/ipv4/netfilter.c                               |   3 +-
 net/ipv6/ip6_tunnel.c                              |   1 +
 net/ipv6/netfilter.c                               |   3 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |  23 ++-
 net/netfilter/nf_conntrack_core.c                  |   5 +
 net/netfilter/nf_flow_table_ip.c                   | 215 +++++++++++++--------
 net/netfilter/nf_flow_table_path.c                 |   2 +
 net/netfilter/nf_tables_api.c                      |  94 ++++++---
 net/netfilter/nft_chain_nat.c                      |   1 +
 net/netfilter/nft_exthdr.c                         |  34 ++--
 net/netfilter/nft_socket.c                         |  16 +-
 net/netfilter/xt_socket.c                          |  26 +--
 tools/testing/selftests/net/netfilter/nft_queue.sh |   2 +-
 19 files changed, 336 insertions(+), 165 deletions(-)

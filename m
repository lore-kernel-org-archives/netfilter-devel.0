Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74352161313;
	Wed,  9 Oct 2024 21:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728509946; cv=none; b=HV9k5wMKhphRPw1mN566iLFrmvHOsH0rlDeM6q9REBquTPyZrRxT10Av48MrBABTTvDTGrjsAamxF9dF0oFIenoN3KxjcJUf7tRqD7nVU/WRos/jhIOfKYwH3Ukzoom17l4mnJp8ICIdRCk8qAuixNB/PCbZOJxNEJI022oq93Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728509946; c=relaxed/simple;
	bh=b4oPjxZh2/RUjTPIuUlJCnctWWy61oGAIvx7IsP0yls=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aeMqekIDMU5OqYEZuHsoUNBcHH81S6ji/dGRVdgi/udhLF7b4yRg8sN/8QF4/GLX/4KtvouIXo57ZL2P/scM8gIjyDf27+V7rUdNF2/qINv2B6OsKLg7XMrTpNaAXpH0d2kz6x+IZGDUZBREQl9x5zw8T6afu32fcNMd8eUjqXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 0/3] Netfilter fixes for net
Date: Wed,  9 Oct 2024 23:38:55 +0200
Message-Id: <20241009213858.3565808-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for net:

1) Restrict xtables extensions to families that are safe, syzbot found
   a way to combine ebtables with extensions that are never used by
   userspace tools. From Florian Westphal.

2) Set l3mdev inconditionally whenever possible in nft_fib to fix lookup
   mismatch, also from Florian.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-10-09

Thanks.

----------------------------------------------------------------

The following changes since commit 983e35ce2e1ee4037f6f5d5398dfc107b22ad569:

  net: hns3/hns: Update the maintainer for the HNS3/HNS ethernet driver (2024-10-09 13:40:42 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-10-09

for you to fetch changes up to c6a0862bee696cfb236a4e160a7f376c0ecdcf0c:

  selftests: netfilter: conntrack_vrf.sh: add fib test case (2024-10-09 23:31:15 +0200)

----------------------------------------------------------------
netfilter pull request 24-10-09

----------------------------------------------------------------
Florian Westphal (3):
      netfilter: xtables: avoid NFPROTO_UNSPEC where needed
      netfilter: fib: check correct rtable in vrf setups
      selftests: netfilter: conntrack_vrf.sh: add fib test case

 net/ipv4/netfilter/nft_fib_ipv4.c                  |   4 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |   5 +-
 net/netfilter/xt_CHECKSUM.c                        |  33 +++++--
 net/netfilter/xt_CLASSIFY.c                        |  16 +++-
 net/netfilter/xt_CONNSECMARK.c                     |  36 ++++---
 net/netfilter/xt_CT.c                              | 106 ++++++++++++++-------
 net/netfilter/xt_IDLETIMER.c                       |  59 ++++++++----
 net/netfilter/xt_LED.c                             |  39 +++++---
 net/netfilter/xt_NFLOG.c                           |  36 ++++---
 net/netfilter/xt_RATEEST.c                         |  39 +++++---
 net/netfilter/xt_SECMARK.c                         |  27 +++++-
 net/netfilter/xt_TRACE.c                           |  35 ++++---
 net/netfilter/xt_addrtype.c                        |  15 ++-
 net/netfilter/xt_cluster.c                         |  33 +++++--
 net/netfilter/xt_connbytes.c                       |   4 +-
 net/netfilter/xt_connlimit.c                       |  39 +++++---
 net/netfilter/xt_connmark.c                        |  28 +++++-
 net/netfilter/xt_mark.c                            |  42 ++++++--
 .../selftests/net/netfilter/conntrack_vrf.sh       |  33 +++++++
 19 files changed, 459 insertions(+), 170 deletions(-)

Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A71921B424D;
	Sat, 11 Jan 2025 23:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736636891; cv=none; b=eKGf3CnIlXdOuIqzzun2ECsc0t+1Y3jFZNgAckkaMLGwkJ4mV8c+6iJccOJieAu9z80m1mB2Zt4RkoGpVXmAdgu8AafUIx2d6rgVexuzJFhm4jHw6FJEABQFCbpZ7vOJ6k6V992O6AVjF0eB8gZ/z0Jd+PDi5fTJtq2RZby/WXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736636891; c=relaxed/simple;
	bh=T40lurc75oOC0lBeYBBQX0NTUgNENShgCJ4EYp+HLrc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TXuoSQ0K9NXEBSAy9TvkzZOU/uWbPz8mYYPSlAa1/m9I5X33jyTK8PwPIvHu1VcjwGzBhnXpA5nF2ZMKElB3H3PxCy23ulCbYTCq/ScF1aGT5BjIS8blvkUSxLoCUDy4FWkBEOnAUq/BCVm31Skwb977odKY5q+7HC6WZ/C8yTk=
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
	fw@strlen.de,
	kadlec@netfilter.org
Subject: [PATCH net-next 0/4] Netfilter/IPVS updates for net-next
Date: Sun, 12 Jan 2025 00:07:56 +0100
Message-Id: <20250111230800.67349-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains a small batch of Netfilter/IPVS updates
for net-next:

1) Remove unused genmask parameter in nf_tables_addchain()

2) Speed up reads from /proc/net/ip_vs_conn, from Florian Westphal.

3) Skip empty buckets in hashlimit to avoid atomic operations that results
   in false positive reports by syzbot with lockdep enabled, patch from
   Eric Dumazet.

4) Add conntrack event timestamps available via ctnetlink,
   from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-01-11

Thanks.

----------------------------------------------------------------

The following changes since commit 3e5908172c05ab1511f2a6719b806d6eda6e1715:

  Merge tag 'ieee802154-for-net-next-2025-01-03' of git://git.kernel.org/pub/scm/linux/kernel/git/wpan/wpan-next (2025-01-04 17:02:55 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-01-11

for you to fetch changes up to 601731fc7c6111bbca49ce3c9499c2e4d426079d:

  netfilter: conntrack: add conntrack event timestamp (2025-01-09 14:42:16 +0100)

----------------------------------------------------------------
netfilter pull request 25-01-11

----------------------------------------------------------------
Eric Dumazet (1):
      netfilter: xt_hashlimit: htable_selective_cleanup() optimization

Florian Westphal (2):
      ipvs: speed up reads from ip_vs_conn proc file
      netfilter: conntrack: add conntrack event timestamp

tuqiang (1):
      netfilter: nf_tables: remove the genmask parameter

 include/net/netfilter/nf_conntrack_ecache.h        | 12 ++++++
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |  1 +
 net/netfilter/ipvs/ip_vs_conn.c                    | 50 ++++++++++++----------
 net/netfilter/nf_conntrack_ecache.c                | 23 ++++++++++
 net/netfilter/nf_conntrack_netlink.c               | 25 +++++++++++
 net/netfilter/nf_tables_api.c                      |  7 ++-
 net/netfilter/xt_hashlimit.c                       |  6 ++-
 7 files changed, 97 insertions(+), 27 deletions(-)

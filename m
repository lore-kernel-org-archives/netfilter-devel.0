Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F49B2BAF4;
	Thu, 11 Sep 2025 14:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757601507; cv=none; b=ugsU0FkhNP5n1aZh+v8gw15YqExna5VZWTd3URjQ/mkDX1ABbfTxTquDHY/Yb/evjIol+IlHm5v3DY+hyBdf45XbqOxjUymYw54WM9oUqZcC0h19/1bo2fWLVSuwmKXOPBgIjcl6TFPNrZ/kC1qcliLAyBCYU8hyihyresh8FUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757601507; c=relaxed/simple;
	bh=pDRXFedbe0uYMJT+15rV01hS8FK/86WWS3VIsOOu1ro=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YlqADGHgodfGj+2iG4ivlMX2qWseouJfmLF8WAp6+Q4Blvbs7+hnh0FwloxKE5lHfH52isZ88jHklkWT89HdQhvYWl4hMxkMFRclaQg3I+qEr5xbeawSJ086tnh+b9DXgR+wkrjq4wRBKY7H6VpIi/J2xbJAkVMjbJ7y+Ov0eFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B3DB96014E; Thu, 11 Sep 2025 16:38:23 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 0/5] netfilter: updates for net-next
Date: Thu, 11 Sep 2025 16:38:14 +0200
Message-ID: <20250911143819.14753-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following patchset contains Netfilter changes for *net-next*:

1) Don't respond to ICMP_UNREACH errors with another ICMP_UNREACH
   error.
2) Support fetching the current bridge ethernet address.
   This allows a more flexible approach to packet redirection
   on bridges without need to use hardcoded addresses. From
   Fernando Fernandez Mancera.
3) Zap a few no-longer needed conditionals from ipvs packet path
   and convert to READ/WRITE_ONCE to avoid KCSAN warnings.
   From Zhang Tengfei.
4) Remove a no-longer-used macro argument in ipset, from Zhen Ni.

Please, pull these changes from:
The following changes since commit 5adf6f2b9972dbb69f4dd11bae52ba251c64ecb7:

  Merge branch 'ipv4-icmp-fix-source-ip-derivation-in-presence-of-vrfs' (2025-09-11 12:22:40 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-09-11

for you to fetch changes up to db99b2f2b3e2cd8227ac9990ca4a8a31a1e95e56:

  netfilter: nf_reject: don't reply to icmp error messages (2025-09-11 15:40:55 +0200)

----------------------------------------------------------------
netfilter pull request nf-next-25-09-11

----------------------------------------------------------------
Andres Urian Florez (1):
      selftest:net: fixed spelling mistakes

Fernando Fernandez Mancera (1):
      netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support

Florian Westphal (1):
      netfilter: nf_reject: don't reply to icmp error messages

Zhang Tengfei (1):
      ipvs: Use READ_ONCE/WRITE_ONCE for ipvs->enable

Zhen Ni (1):
      netfilter: ipset: Remove unused htable_bits in macro ahash_region

 include/uapi/linux/netfilter/nf_tables.h         |  2 ++
 net/bridge/netfilter/nft_meta_bridge.c           | 11 +++++++++
 net/ipv4/netfilter/nf_reject_ipv4.c              | 25 ++++++++++++++++++++
 net/ipv6/netfilter/nf_reject_ipv6.c              | 30 ++++++++++++++++++++++++
 net/netfilter/ipset/ip_set_hash_gen.h            |  8 +++----
 net/netfilter/ipvs/ip_vs_conn.c                  |  4 ++--
 net/netfilter/ipvs/ip_vs_core.c                  | 11 ++++-----
 net/netfilter/ipvs/ip_vs_ctl.c                   |  6 ++---
 net/netfilter/ipvs/ip_vs_est.c                   | 16 ++++++-------
 tools/testing/selftests/net/netfilter/nft_nat.sh |  4 ++--
 10 files changed, 91 insertions(+), 26 deletions(-)

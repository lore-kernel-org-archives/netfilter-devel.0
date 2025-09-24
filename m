Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0C32046BA;
	Wed, 24 Sep 2025 14:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758722829; cv=none; b=XixkdFath3DuFQjbixHCBIpunjZjvQst/XXi0lHS8C+gR7SgOxZ9MkaEPqTVX0ZbwG0ytNI3L8dVKzsd3qgdmfQI+Ojv6VlHtQgstlxc8NJDN0dG/vj3q+JUrcdEtWb7IPRrxm/oSahiwyzvMOMSH/xYwVwLZ1xf4o/ILm7yodI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758722829; c=relaxed/simple;
	bh=xX4Po4T1MGFBREqf1YLXCv22GMwmVSmWzSin8ykR3lE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZmhYWUN2T4GwmssmLYdexLLDCvf0NtyWRK7MkXV5gNITXHZL0q/chNMlFWVx/lcT3W3hiqgB2E2FCD2yiFdN2aBazeiEe68yzbNrNqJ5OR6jJiOMuoiuuV/RcSX2tn97T5gG0uIqWd5HwiOGMABAtGe4TRUGXBH5Cg44sd+OZjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3E732601C9; Wed, 24 Sep 2025 16:07:04 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 0/6] netfilter: fixes for net-next
Date: Wed, 24 Sep 2025 16:06:48 +0200
Message-ID: <20250924140654.10210-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net-next*:

These fixes target next because the bug is either not severe or has
existed for so long that there is no reason to cram them in at the last
minute.

1) Fix IPVS ftp unregistering during netns cleanup, broken since netns
   support was introduced in 2011 in the 2.6.39 kernel.
   From Slavin Liu.
2) nfnetlink must reset the 'nlh' pointer back to the original
   address when a batch is replayed, else we emit bogus ACK messages
   and conceal real errno from userspace.  From Fernando Fernandez Mancera.
   This was broken since 6.10.

3) Recent fix for nftables 'pipapo' set type was incomplete, it only
   made things work for the AVX2 version of the algorithm.

4) Testing revealed another problem with avx2 version that results in
   out-of-bounds read access, this bug always existed since feature was
   added in 5.7 kernel.  This also comes with a selftest update.

Last fix resolves a long-standing bug (since 4.9) in conntrack /proc
interface:
Decrease skip count when we reap an expired entry during dump.
As-is we erronously elide one conntrack entry from dump for every expired
entry seen.  From Eric Dumazet.

Please, pull these changes from:
The following changes since commit dc1dea796b197aba2c3cae25bfef45f4b3ad46fe:

  tcp: Remove stale locking comment for TFO. (2025-09-23 18:21:36 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-09-24

for you to fetch changes up to c5ba345b2d358b07cc4f07253ba1ada73e77d586:

  netfilter: nf_conntrack: do not skip entries in /proc/net/nf_conntrack (2025-09-24 11:50:28 +0200)

----------------------------------------------------------------
netfilter pull request nf-next-25-09-24

----------------------------------------------------------------
Eric Dumazet (1):
      netfilter: nf_conntrack: do not skip entries in /proc/net/nf_conntrack

Fernando Fernandez Mancera (1):
      netfilter: nfnetlink: reset nlh pointer during batch replay

Florian Westphal (3):
      netfilter: nft_set_pipapo: use 0 genmask for packetpath lookups
      netfilter: nft_set_pipapo_avx2: fix skip of expired entries
      selftests: netfilter: nft_concat_range.sh: add check for double-create bug

Slavin Liu (1):
      ipvs: Defer ip_vs_ftp unregister during netns cleanup

 net/netfilter/ipvs/ip_vs_ftp.c                     |  4 +-
 net/netfilter/nf_conntrack_standalone.c            |  3 ++
 net/netfilter/nfnetlink.c                          |  2 +
 net/netfilter/nft_set_pipapo.c                     |  9 ++--
 net/netfilter/nft_set_pipapo_avx2.c                |  9 ++--
 .../selftests/net/netfilter/nft_concat_range.sh    | 56 +++++++++++++++++++++-
 6 files changed, 73 insertions(+), 10 deletions(-)

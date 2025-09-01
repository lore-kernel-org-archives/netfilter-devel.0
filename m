Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE972EB5CD;
	Mon,  1 Sep 2025 08:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756714139; cv=none; b=bwb2QkKEf+EQHdflvmLfFqohtRKDPRUrlMasHNe1SAccvRu+v2WXEJegtci5VnAIeKeNsLC0XnXBowYEFYNIO2O6iBS6Tp6KIRHnx8wZRw/Rb+kUKiUsdG/iNGdFen7Qse6lp24HrTlURCTX1F5s0GSNQWh4ohRB2ikPALxDGuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756714139; c=relaxed/simple;
	bh=nQB6c/6Pql0LIdhI31eXS3b7r83NsNLe/8YRJx4NRW8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I3aIbhCkc/eVvC1KaP+33NTOmqBScrKvjISPF6wiaSEKejQZVcA80cMI8wp52EjVtaCqjnle0jI/F8IhDcTsMexqvXCJnB/AqovA5Jvkfd0ok1BxvGJFcNoWZJ2OFeTSZg0owe/+fmtiJfIvETsMoW2sBM0rKFz4vT2gEHVdsRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 71496605E6; Mon,  1 Sep 2025 10:08:47 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 0/8] netfilter: updates for net-next
Date: Mon,  1 Sep 2025 10:08:34 +0200
Message-ID: <20250901080843.1468-1-fw@strlen.de>
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

1) prefer vmalloc_array in ebtables, from  Qianfeng Rong.
2) Use csum_replace4 instead of open-coding it, from Christophe Leroy.
3+4) Get rid of GFP_ATOMIC in transaction object allocations, those
     cause silly failures with large sets under memory pressure, from
     myself.
5) Introduce new NFTA_DEVICE_PREFIX attribute in nftables netlink api,
   re-using old NFTA_DEVICE_NAME led to confusion with different
   kernel/userspace versions.  This refines the wildcard interface
   support added in 6.16 release.  From Phil Sutter.
6) Remove test for AVX cpu feature in nftables pipapo set type,
   testing for AVX2 feature is sufficient.
7) Unexport a few function in nf_reject infra: no external callers.
8) Extend payload offset to u16, this was restricted to values <=255
   so far, from Fernando Fernandez Mancera.

Please, pull these changes from:
The following changes since commit 864ecc4a6dade82d3f70eab43dad0e277aa6fc78:

  Merge branch 'net-add-rcu-safety-to-dst-dev' (2025-08-29 19:36:34 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-09-01

for you to fetch changes up to 0618948e58e09e1ebf59078bf5b7841bbd1ce1d2:

  netfilter: nft_payload: extend offset to 65535 bytes (2025-09-01 09:53:17 +0200)

----------------------------------------------------------------
netfilter pull request nf-next-25-09-01

----------------------------------------------------------------
Christophe Leroy (1):
  netfilter: nft_payload: Use csum_replace4() instead of opencoding

Fernando Fernandez Mancera (1):
  netfilter: nft_payload: extend offset to 65535 bytes

Florian Westphal (4):
  netfilter: nf_tables: allow iter callbacks to sleep
  netfilter: nf_tables: all transaction allocations can now sleep
  netfilter: nft_set_pipapo: remove redundant test for avx feature bit
  netfilter: nf_reject: remove unneeded exports

Phil Sutter (1):
  netfilter: nf_tables: Introduce NFTA_DEVICE_PREFIX

Qianfeng Rong (1):
  netfilter: ebtables: Use vmalloc_array() to improve code

 include/net/netfilter/ipv4/nf_reject.h   |   8 --
 include/net/netfilter/ipv6/nf_reject.h   |  10 ---
 include/net/netfilter/nf_tables.h        |   2 +
 include/net/netfilter/nf_tables_core.h   |   2 +-
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/bridge/netfilter/ebtables.c          |  14 ++--
 net/ipv4/netfilter/nf_reject_ipv4.c      |  27 +++---
 net/ipv6/netfilter/nf_reject_ipv6.c      |  37 ++++++---
 net/netfilter/nf_tables_api.c            |  89 +++++++++++---------
 net/netfilter/nft_payload.c              |  20 +++--
 net/netfilter/nft_set_hash.c             | 100 ++++++++++++++++++++++-
 net/netfilter/nft_set_pipapo.c           |   3 +-
 net/netfilter/nft_set_pipapo_avx2.c      |   2 +-
 net/netfilter/nft_set_rbtree.c           |  35 ++++++--
 14 files changed, 242 insertions(+), 109 deletions(-)

-- 
2.49.1


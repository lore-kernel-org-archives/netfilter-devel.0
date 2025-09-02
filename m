Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1285331E102;
	Tue,  2 Sep 2025 13:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820157; cv=none; b=lN3VBV5MKiYLOwmJRtBNRqexZ0kvCJI1gDBT08gpHip7tYsHyVnycmMQXKf0+V7H5Eec8YQuXOMznC7lh/zSB7rXBoBOoA6R4WqAvVP3LcyM2VIhtec21v/im/JHd6u6eHYiTru6KGfv2KK9FfHZz19FogVnfyJGb8Ch/6/ySIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820157; c=relaxed/simple;
	bh=AQnTmEdaOCpQw2USGrT5sDgjoLpNoOja1NImeuyWf5g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nRXLQa3vX+Ve0p/H6bPVFZ8w1OsFrFes5xArUSpSKlCk1YtR9Jb0n/m/G03rocy52zrtuUdKLdYF8RVylcno5DaMvIKUQbpYEQoHrLlwCBKtsQRAd/fC9c/m4GKD497GuhgxFdWntAhANLxOPv8cz2CTQJaK13TVuQQDgPmsjGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E85E660298; Tue,  2 Sep 2025 15:35:53 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 0/7] netfilter: updates for net-next
Date: Tue,  2 Sep 2025 15:35:42 +0200
Message-ID: <20250902133549.15945-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: drop patch 5, to be routed via net tree. No other changes.

Hi,

The following patchset contains Netfilter fixes for *net-next*:

1) prefer vmalloc_array in ebtables, from  Qianfeng Rong.
2) Use csum_replace4 instead of open-coding it, from Christophe Leroy.
3+4) Get rid of GFP_ATOMIC in transaction object allocations, those
     cause silly failures with large sets under memory pressure, from
     myself.
5) Remove test for AVX cpu feature in nftables pipapo set type,
   testing for AVX2 feature is sufficient.
6) Unexport a few function in nf_reject infra: no external callers.
7) Extend payload offset to u16, this was restricted to values <=255
   so far, from Fernando Fernandez Mancera.

Please, pull these changes from:
The following changes since commit cd8a4cfa6bb43a441901e82f5c222dddc75a18a3:

  Merge branch 'e-switch-vport-sharing-delegation' (2025-09-02 15:18:19 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-09-02

for you to fetch changes up to 077dc4a275790b09e8a2ce80822ba8970e9dfb99:

  netfilter: nft_payload: extend offset to 65535 bytes (2025-09-02 15:28:18 +0200)

----------------------------------------------------------------
netfilter pull request nf-next-25-09-02

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

Qianfeng Rong (1):
      netfilter: ebtables: Use vmalloc_array() to improve code

 include/net/netfilter/ipv4/nf_reject.h |   8 ---
 include/net/netfilter/ipv6/nf_reject.h |  10 ----
 include/net/netfilter/nf_tables.h      |   2 +
 include/net/netfilter/nf_tables_core.h |   2 +-
 net/bridge/netfilter/ebtables.c        |  14 ++---
 net/ipv4/netfilter/nf_reject_ipv4.c    |  27 +++++----
 net/ipv6/netfilter/nf_reject_ipv6.c    |  37 ++++++++----
 net/netfilter/nf_tables_api.c          |  47 +++++++---------
 net/netfilter/nft_payload.c            |  20 ++++---
 net/netfilter/nft_set_hash.c           | 100 ++++++++++++++++++++++++++++++++-
 net/netfilter/nft_set_pipapo.c         |   3 +-
 net/netfilter/nft_set_pipapo_avx2.c    |   2 +-
 net/netfilter/nft_set_rbtree.c         |  35 +++++++++---
 13 files changed, 209 insertions(+), 98 deletions(-)

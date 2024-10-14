Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9BE2132117;
	Mon, 14 Oct 2024 11:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728904470; cv=none; b=JmxkL/PTOCosU04q2ORsbly7e0dv+XOhEmbZZ8YBtQDMTK4CpeE3ctAhCwi1zhTYi000/eic0CYeCHcZWj3k8l1bXqDUnyRTFvDbtsqEC3tuQkZ41sx6eSaFSVw26Ls1vYSad/OvN/bkOVEa+PnPkf9PQ6wTz3ChESXlrlYc8yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728904470; c=relaxed/simple;
	bh=m3oA3DjQG0zAgXDJR6EQNfJPvp53CEpoyvjfzeSTx1I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cm5zJI4LNHzZHGIsuWMhUC/yMOitrB0dDxWDJSCu6fEQC56Ui1o6BfjGj5ldIY1ERiINGIrtv91SzYU+TljmcqN/cA7kkhDhM0SlJ2SqfmhuZ4FkGeRiGDmKp4dP6DPQylzTCNqA7gyUoT4ZnoQI1D1YdnHeGJc7rlqVmadL2ZQ=
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
Subject: [PATCH net-next 0/9] Netfilter updates for net-net
Date: Mon, 14 Oct 2024 13:14:11 +0200
Message-Id: <20241014111420.29127-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following series contains Netfilter updates for net-next:

1) Fix sparse warning in nf_tables related to use of percpu counters,
   from Uros Bizjak.

2) use strscpy_pad in nft_meta_bridge, from Justin Stitt.

3) A series from patch #3 to patch #7 to reduce memory footprint of set
   element transactions, Florian Westphal says:

   When doing a flush on a set or mass adding/removing elements from a
   set, each element needs to allocate 96 bytes to hold the transactional
   state.

   In such cases, virtually all the information in struct nft_trans_elem
   is the same.

   Change nft_trans_elem to a flex-array, i.e. a single nft_trans_elem
   can hold multiple set element pointers.

   The number of elements that can be stored in one nft_trans_elem is limited
   by the slab allocator, this series limits the compaction to at most 62
   elements as it caps the reallocation to 2048 bytes of memory.

4) Document legacy toggles for xtables packet classifiers, from
   Bruno Leitao.

5) Use kfree_rcu() instead of call_rcu() + kmem_cache_free(), from Julia Lawall.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-24-10-14

Thanks.

----------------------------------------------------------------

The following changes since commit f66ebf37d69cc700ca884c6a18c2258caf8b151b:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2024-10-03 10:05:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-24-10-14

for you to fetch changes up to 9539446cc659e390942b46df871f8abdd4750999:

  netfilter: replace call_rcu by kfree_rcu for simple kmem_cache_free callback (2024-10-14 12:30:20 +0200)

----------------------------------------------------------------
netfilter pull request 24-10-14

----------------------------------------------------------------
Breno Leitao (1):
      netfilter: Make legacy configs user selectable

Florian Westphal (5):
      netfilter: nf_tables: prefer nft_trans_elem_alloc helper
      netfilter: nf_tables: add nft_trans_commit_list_add_elem helper
      netfilter: nf_tables: prepare for multiple elements in nft_trans_elem structure
      netfilter: nf_tables: switch trans_elem to real flex array
      netfilter: nf_tables: allocate element update information dynamically

Julia Lawall (1):
      netfilter: replace call_rcu by kfree_rcu for simple kmem_cache_free callback

Justin Stitt (1):
      netfilter: nf_tables: replace deprecated strncpy with strscpy_pad

Uros Bizjak (1):
      netfilter: nf_tables: Fix percpu address space issues in nf_tables_api.c

 include/net/netfilter/nf_tables.h      |  25 +--
 net/bridge/netfilter/Kconfig           |   8 +-
 net/bridge/netfilter/nft_meta_bridge.c |   2 +-
 net/ipv4/netfilter/Kconfig             |  16 +-
 net/ipv6/netfilter/Kconfig             |   9 +-
 net/netfilter/nf_conncount.c           |  10 +-
 net/netfilter/nf_conntrack_expect.c    |  10 +-
 net/netfilter/nf_tables_api.c          | 370 +++++++++++++++++++++++++--------
 net/netfilter/xt_hashlimit.c           |   9 +-
 9 files changed, 330 insertions(+), 129 deletions(-)

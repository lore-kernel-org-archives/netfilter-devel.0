Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33FF21917D7;
	Wed,  6 Nov 2024 23:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730936803; cv=none; b=cEuBfa2Ut5k1KBJZgo9oQXPYX0Gv7cOFiBKMCbEspeTEYpXTebAlT8roh8wupysPVR/y+nwwevsmPUSyd6ot4Oz44luAKuh6MqSJC9tvJZry44r6nFkeZxhLem/t/lJOOt7mhk/+d/IvU3QS9dGiDvc6+vMdq5ld5iur9nXPQRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730936803; c=relaxed/simple;
	bh=6/MVy899qQ45oLAPpA6Mm2wuDappAXUAZWnu+IVK5So=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iVISeNmYAAlo/etKmydtQp7SnfjV3mWb9/TldZ0oNUoSYYQg0WnpajAeFveX0gcL0Ocaqo9Csgxr6zLpviB4H4LHADnwU6Hp9cgRGqN+iYiUAnxU88CocfFBe31NLnglR5GHRzle+W9X/dlAP29PzDbRQRg3NjLIyWCsQbmZUsI=
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
Subject: [PATCH net-next 00/11] Netfilter updates for net-next
Date: Thu,  7 Nov 2024 00:46:14 +0100
Message-Id: <20241106234625.168468-1-pablo@netfilter.org>
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

1) Make legacy xtables configs user selectable, from Breno Leitao.

2) Fix a few sparse warnings related to percpu, from Uros Bizjak.

3) Use strscpy_pad, from Justin Stitt.

4) Use nft_trans_elem_alloc() in catchall flush, from Florian Westphal.

5) A series of 7 patches to fix false positive with CONFIG_RCU_LIST=y.
   Florian also sees possible issue with 10 while module load/removal
   when requesting an expression that is available via module. As for
   patch 11, object is being updated so reference on the module already
   exists so I don't see any real issue.

   Florian says:

   "Unfortunately there are many more errors, and not all are false positives.

   First patches pass lockdep_commit_lock_is_held() to the rcu list traversal
   macro so that those splats are avoided.

   The last two patches are real code change as opposed to
   'pass the transaction mutex to relax rcu check':

   Those two lists are not protected by transaction mutex so could be altered
   in parallel.

   This targets nf-next because these are long-standing issues."

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-24-11-07

Thanks.

----------------------------------------------------------------

The following changes since commit f66ebf37d69cc700ca884c6a18c2258caf8b151b:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2024-10-03 10:05:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-24-11-07

for you to fetch changes up to cddc04275f95ca3b18da5c0fb111705ac173af89:

  netfilter: nf_tables: must hold rcu read lock while iterating object type list (2024-11-05 22:07:12 +0100)

----------------------------------------------------------------
netfilter pull request 24-11-07

----------------------------------------------------------------
Breno Leitao (1):
      netfilter: Make legacy configs user selectable

Florian Westphal (8):
      netfilter: nf_tables: prefer nft_trans_elem_alloc helper
      netfilter: nf_tables: avoid false-positive lockdep splat on rule deletion
      netfilter: nf_tables: avoid false-positive lockdep splats with sets
      netfilter: nf_tables: avoid false-positive lockdep splats with flowtables
      netfilter: nf_tables: avoid false-positive lockdep splats in set walker
      netfilter: nf_tables: avoid false-positive lockdep splats with basechain hook
      netfilter: nf_tables: must hold rcu read lock while iterating expression type list
      netfilter: nf_tables: must hold rcu read lock while iterating object type list

Justin Stitt (1):
      netfilter: nf_tables: replace deprecated strncpy with strscpy_pad

Uros Bizjak (1):
      netfilter: nf_tables: Fix percpu address space issues in nf_tables_api.c

 include/net/netfilter/nf_tables.h      |   3 +-
 net/bridge/netfilter/Kconfig           |   8 +-
 net/bridge/netfilter/nft_meta_bridge.c |   2 +-
 net/ipv4/netfilter/Kconfig             |  16 +++-
 net/ipv6/netfilter/Kconfig             |   9 ++-
 net/netfilter/nf_tables_api.c          | 132 +++++++++++++++++++--------------
 net/netfilter/nft_flow_offload.c       |   4 +-
 net/netfilter/nft_set_bitmap.c         |  10 ++-
 net/netfilter/nft_set_hash.c           |   3 +-
 9 files changed, 119 insertions(+), 68 deletions(-)

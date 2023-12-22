Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB4DD18044;
	Fri, 22 Dec 2023 11:57:23 +0000 (UTC)
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
Subject: [PATCH net-next 0/8] Netfilter updates for net-next
Date: Fri, 22 Dec 2023 12:57:06 +0100
Message-Id: <20231222115714.364393-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter updates for net-next:

1) Add locking for NFT_MSG_GETSETELEM_RESET requests, to address a
   race scenario with two concurrent processes running a dump-and-reset
   which exposes negative counters to userspace, from Phil Sutter.

2) Use GFP_KERNEL in pipapo GC, from Florian Westphal.

3) Reorder nf_flowtable struct members, place the read-mostly parts
   accessed by the datapath first. From Florian Westphal.

4) Set on dead flag for NFT_MSG_NEWSET in abort path,
   from Florian Westphal.

5) Support filtering zone in ctnetlink, from Felix Huettner.

6) Bail out if user tries to redefine an existing chain with different
   type in nf_tables.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-23-12-22

Thanks.

----------------------------------------------------------------

The following changes since commit 56794e5358542b7c652f202946e53bfd2373b5e0:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-12-21 22:17:23 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-23-12-22

for you to fetch changes up to aaba7ddc8507f4ad5bbd07988573967632bc2385:

  netfilter: nf_tables: validate chain type update if available (2023-12-22 12:15:28 +0100)

----------------------------------------------------------------
netfilter pull request 23-12-22

----------------------------------------------------------------
Felix Huettner (1):
      netfilter: ctnetlink: support filtering by zone

Florian Westphal (3):
      netfilter: nft_set_pipapo: prefer gfp_kernel allocation
      netfilter: flowtable: reorder nf_flowtable struct members
      netfilter: nf_tables: mark newset as dead on transaction abort

Pablo Neira Ayuso (1):
      netfilter: nf_tables: validate chain type update if available

Phil Sutter (3):
      netfilter: nf_tables: Pass const set to nft_get_set_elem
      netfilter: nf_tables: Introduce nft_set_dump_ctx_init()
      netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET requests

 include/net/netfilter/nf_flow_table.h              |   9 +-
 net/netfilter/nf_conntrack_netlink.c               |  12 +-
 net/netfilter/nf_tables_api.c                      | 147 +++++--
 net/netfilter/nft_set_pipapo.c                     |   2 +-
 tools/testing/selftests/netfilter/.gitignore       |   2 +
 tools/testing/selftests/netfilter/Makefile         |   3 +-
 .../selftests/netfilter/conntrack_dump_flush.c     | 430 +++++++++++++++++++++
 7 files changed, 567 insertions(+), 38 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/conntrack_dump_flush.c

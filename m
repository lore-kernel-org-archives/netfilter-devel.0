Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC151BB6A0;
	Fri, 15 Nov 2024 13:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731677541; cv=none; b=dsMUF4QQCRsVC/em1jBB7/J5AY1p6f9TzapL6ZjsbwcC4o0lkwPgJfQnEuUiIMuGIx2hWrpEMYl9nDCDS0Kj1PcGcVTluI61OBUPjZc6k+so6W4jxh8Cf1gqn5kIEE5hklpBq3C0jHtLMFeWyUVQEDJQdUHBjFS6K+i+C7GNteA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731677541; c=relaxed/simple;
	bh=ZEWQJ6AcVNMHQ5Fzqr1gxhbHqZu7vODLWQFHegteBIA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=RvUsekF84B3BR/Exo2R6FzAQSfnF+zVgE8yTkQUo+8vtD3KVnMJPnUW+NQqt3yX+nExUqSr7/PVo80eolekaY07gbXHdOQUQszon3dMXsg6Me1eGHEfzeLMNqZt2tepQcvkGolKXONE/zLY2ajCmJDVh6ZFkRWpCb7Nvzl0c/Kc=
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
Subject: [PATCH net-next 00/14] Netfilter updates for net-next
Date: Fri, 15 Nov 2024 14:31:53 +0100
Message-Id: <20241115133207.8907-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter updates for net-next:

1) Extended netlink error reporting if nfnetlink attribute parser fails,
   from Donald Hunter.

2) Incorrect request_module() module, from Simon Horman.

3) A series of patches to reduce memory consumption for set element transactions.
   Florian Westphal says:

"When doing a flush on a set or mass adding/removing elements from a
set, each element needs to allocate 96 bytes to hold the transactional
state.

In such cases, virtually all the information in struct nft_trans_elem
is the same.

Change nft_trans_elem to a flex-array, i.e. a single nft_trans_elem
can hold multiple set element pointers.

The number of elements that can be stored in one nft_trans_elem is limited
by the slab allocator, this series limits the compaction to at most 62
elements as it caps the reallocation to 2048 bytes of memory."

4) A series of patches to prepare the transition to dscp_t in .flowi_tos.
   From Guillaume Nault.

5) Support for bitwise operations with two source registers,
   from Jeremy Sowden.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-24-11-15

Thanks.

----------------------------------------------------------------

The following changes since commit 544070db6c8b0c403e4c6befbc76b52831b897da:

  Merge branch 'mlx5-esw-qos-refactor-and-shampo-cleanup' (2024-11-11 19:28:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-24-11-15

for you to fetch changes up to b0ccf4f53d968e794a4ea579d5135cc1aaf1a53f:

  netfilter: bitwise: add support for doing AND, OR and XOR directly (2024-11-15 12:07:04 +0100)

----------------------------------------------------------------
netfilter pull request 24-11-15

----------------------------------------------------------------
Donald Hunter (1):
      netfilter: nfnetlink: Report extack policy errors for batched ops

Florian Westphal (5):
      netfilter: nf_tables: add nft_trans_commit_list_add_elem helper
      netfilter: nf_tables: prepare for multiple elements in nft_trans_elem structure
      netfilter: nf_tables: prepare nft audit for set element compaction
      netfilter: nf_tables: switch trans_elem to real flex array
      netfilter: nf_tables: allocate element update information dynamically

Guillaume Nault (5):
      netfilter: ipv4: Convert ip_route_me_harder() to dscp_t.
      netfilter: flow_offload: Convert nft_flow_route() to dscp_t.
      netfilter: rpfilter: Convert rpfilter_mt() to dscp_t.
      netfilter: nft_fib: Convert nft_fib4_eval() to dscp_t.
      netfilter: nf_dup4: Convert nf_dup_ipv4_route() to dscp_t.

Jeremy Sowden (2):
      netfilter: bitwise: rename some boolean operation functions
      netfilter: bitwise: add support for doing AND, OR and XOR directly

Simon Horman (1):
      netfilter: bpf: Pass string literal as format argument of request_module()

 include/net/netfilter/nf_tables.h        |  25 +-
 include/uapi/linux/netfilter/nf_tables.h |  18 +-
 net/ipv4/netfilter.c                     |   2 +-
 net/ipv4/netfilter/ipt_rpfilter.c        |   2 +-
 net/ipv4/netfilter/nf_dup_ipv4.c         |   2 +-
 net/ipv4/netfilter/nft_fib_ipv4.c        |   3 +-
 net/netfilter/nf_bpf_link.c              |   2 +-
 net/netfilter/nf_tables_api.c            | 385 ++++++++++++++++++++++++-------
 net/netfilter/nfnetlink.c                |   2 +-
 net/netfilter/nft_bitwise.c              | 166 ++++++++++---
 net/netfilter/nft_flow_offload.c         |   4 +-
 11 files changed, 484 insertions(+), 127 deletions(-)

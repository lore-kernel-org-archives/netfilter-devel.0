Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE42C148833;
	Thu, 27 Jun 2024 11:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719487642; cv=none; b=O1mLEfkPZdXhzYnjzZaB8SDYuQqN88grgPCJ+mVktZFGdR37XQDpr7VgAk4rnINc13S1SLAb4/vN34Jqb7FrNcIoM6xS4vV22PUjGH7UQAbrAYzL4cbA8IfZiM1KktE+m7HbSsyC69EfyG63+QtbaTm1Y9c0TdE8V2WAOv6wFJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719487642; c=relaxed/simple;
	bh=AjqaV/zIfOToM4PlUU/A9sSIUe/RdllymlNneEvF22I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QghJEbTdM4xOLvk420phdDNiZg3P+Fwb/Y9IUBFGUE4Jd6YpbFjXzt5GPEGHf+xYmW28keD7QYd58W9T+wqQPdA/mRt7oO26UDnfpJfxC6qsb1o4dMbOR6xjzc+jsNVrnEmlGIbVNmh9kBr2PVo7OM2h3n7U2B4LrowyEwcLWRo=
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
Subject: [PATCH nf-next 00/19] Netfilter/IPVS updates for net-next
Date: Thu, 27 Jun 2024 13:26:54 +0200
Message-Id: <20240627112713.4846-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter/IPVS updates for net-next:

Patch #1 to #11 to shrink memory consumption for transaction objects:

  struct nft_trans_chain { /* size: 120 (-32), cachelines: 2, members: 10 */
  struct nft_trans_elem { /* size: 72 (-40), cachelines: 2, members: 4 */
  struct nft_trans_flowtable { /* size: 80 (-48), cachelines: 2, members: 5 */
  struct nft_trans_obj { /* size: 72 (-40), cachelines: 2, members: 4 */
  struct nft_trans_rule { /* size: 80 (-32), cachelines: 2, members: 6 */
  struct nft_trans_set { /* size: 96 (-24), cachelines: 2, members: 8 */
  struct nft_trans_table { /* size: 56 (-40), cachelines: 1, members: 2 */

  struct nft_trans_elem can now be allocated from kmalloc-96 instead of
  kmalloc-128 slab.

  Series from Florian Westphal. For the record, I have mangled patch #1
  to add nft_trans_container_*() and use if for every transaction object.
   I have also added BUILD_BUG_ON to ensure struct nft_trans always comes
  at the beginning of the container transaction object. And few minor
  cleanups, any new bugs are of my own.

Patch #12 simplify check for SCTP GSO in IPVS, from Ismael Luceno.

Patch #13 nf_conncount key length remains in the u32 bound, from Yunjian Wang.

Patch #14 removes unnecessary check for CTA_TIMEOUT_L3PROTO when setting
	  default conntrack timeouts via nfnetlink_cttimeout API, from
	  Lin Ma.

Patch #15 updates NFT_SECMARK_CTX_MAXLEN to 4096, SELinux could use
	  larger secctx names than the existing 256 bytes length.

Patch #16 fixes nfnetlink_queue with SCTP traffic, from Antonio Ojea.

Patch #17 adds a selftest for SCTP traffic under nfnetlink_queue,
	  also from Antonio.

Patch #18 adds a selftest to exercise nfnetlink_queue listeners leaving
	  nfnetlink_queue, from Florian Westphal.

Patch #19 increases hitcount from 255 to 65535 in xt_recent, from Phil Sutter.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-24-06-27

Thanks.

----------------------------------------------------------------

The following changes since commit c4532232fa2a4f8d9b9a88135a666545157f3d13:

  selftests: net: remove unneeded IP_GRE config (2024-06-25 08:37:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-24-06-27

for you to fetch changes up to 8871d1e4dceb6692ea8217b1fc835c4bf2e93d97:

  netfilter: xt_recent: Lift restrictions on max hitcount value (2024-06-27 01:55:57 +0200)

----------------------------------------------------------------
netfilter pull request 24-06-27

----------------------------------------------------------------
Antonio Ojea (2):
      netfilter: nfnetlink_queue: unbreak SCTP traffic
      selftests: netfilter: nft_queue.sh: sctp coverage

Florian Westphal (12):
      netfilter: nf_tables: make struct nft_trans first member of derived subtypes
      netfilter: nf_tables: move bind list_head into relevant subtypes
      netfilter: nf_tables: compact chain+ft transaction objects
      netfilter: nf_tables: reduce trans->ctx.table references
      netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx
      netfilter: nf_tables: pass more specific nft_trans_chain where possible
      netfilter: nf_tables: avoid usage of embedded nft_ctx
      netfilter: nf_tables: store chain pointer in rule transaction
      netfilter: nf_tables: reduce trans->ctx.chain references
      netfilter: nf_tables: pass nft_table to destroy function
      netfilter: nf_tables: do not store nft_ctx in transaction objects
      selftests: netfilter: nft_queue.sh: add test for disappearing listener

Ismael Luceno (1):
      ipvs: Avoid unnecessary calls to skb_is_gso_sctp

Lin Ma (1):
      netfilter: cttimeout: remove 'l3num' attr check

Pablo Neira Ayuso (1):
      netfilter: nf_tables: rise cap on SELinux secmark context

Phil Sutter (1):
      netfilter: xt_recent: Lift restrictions on max hitcount value

Yunjian Wang (1):
      netfilter: nf_conncount: fix wrong variable type

 include/net/netfilter/nf_tables.h                  | 222 +++++++----
 include/uapi/linux/netfilter/nf_tables.h           |   2 +-
 net/core/dev.c                                     |   1 +
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   4 +-
 net/netfilter/nf_conncount.c                       |   8 +-
 net/netfilter/nf_tables_api.c                      | 411 ++++++++++++---------
 net/netfilter/nf_tables_offload.c                  |  40 +-
 net/netfilter/nfnetlink_cttimeout.c                |   3 +-
 net/netfilter/nfnetlink_queue.c                    |  12 +-
 net/netfilter/nft_immediate.c                      |   2 +-
 net/netfilter/xt_recent.c                          |   8 +-
 tools/testing/selftests/net/netfilter/nft_queue.sh | 113 ++++++
 12 files changed, 546 insertions(+), 280 deletions(-)

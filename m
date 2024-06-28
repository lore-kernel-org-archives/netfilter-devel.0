Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 246F71C688C;
	Fri, 28 Jun 2024 16:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719590725; cv=none; b=aizSQomcEIz0T9KKC0tnj3Af8v/z53ljaWV2vTyzPflOIdMjI/7XnzmPVliMMhMn+NmEn4vJxWZqYpX2xKwALU4shfYEHB4Y8Sr7f2S2drC0dBbeyZELpJqFwqbg8aDNCBP0pnFPqNsa5jYPESxGjECSDIX9PO5Wh6aixng5rxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719590725; c=relaxed/simple;
	bh=KlGOqq1sJgN8F7D6z2r4JZGzTXSEEMfJJgaUTcDofoQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BvZf4fD7oQ9Cx8TigptAKLAs+FNbGZ8xZegLXkuDxJaJYvOz89ykaLzHu3AXQ8LOyn8uRMCIRygAvKLmg98fjh6O/lYWPXMNPnW/IyNcQRuMxPedzgP510xu8EzJZOYx65zuazQNcKvzJoBaVHAh8wDBy5v7n2KrSVjULg4pmiQ=
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
Subject: [PATCH net-next 00/17] Netfilter/IPVS updates for net-next
Date: Fri, 28 Jun 2024 18:04:48 +0200
Message-Id: <20240628160505.161283-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Note: New PR excluding SCTP nfqueue updates.

-o-

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

Patch #16 adds a selftest to exercise nfnetlink_queue listeners leaving
          nfnetlink_queue, from Florian Westphal.

Patch #17 increases hitcount from 255 to 65535 in xt_recent, from Phil Sutter.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-24-06-28

Thanks.

----------------------------------------------------------------

The following changes since commit c4532232fa2a4f8d9b9a88135a666545157f3d13:

  selftests: net: remove unneeded IP_GRE config (2024-06-25 08:37:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-24-06-28

for you to fetch changes up to f4ebd03496f6b67940b0af92ce885c1d0dc9e121:

  netfilter: xt_recent: Lift restrictions on max hitcount value (2024-06-28 17:57:50 +0200)

----------------------------------------------------------------
netfilter pull request 24-06-28

----------------------------------------------------------------
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
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   4 +-
 net/netfilter/nf_conncount.c                       |   8 +-
 net/netfilter/nf_tables_api.c                      | 411 ++++++++++++---------
 net/netfilter/nf_tables_offload.c                  |  40 +-
 net/netfilter/nfnetlink_cttimeout.c                |   3 +-
 net/netfilter/nft_immediate.c                      |   2 +-
 net/netfilter/xt_recent.c                          |   8 +-
 tools/testing/selftests/net/netfilter/nft_queue.sh |  37 ++
 10 files changed, 459 insertions(+), 278 deletions(-)

Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F08AB1C683;
	Sun, 12 May 2024 16:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715530491; cv=none; b=BjrK/9QtSk+3WmifVGfqriV1EEyQoBEys9alMynMuAcUyaHvDPrRUqvcTlUTuRoZF/Zag0ZRYgA9Px22ZI4cCugu+NJ8+5ca/ees2o7ESWEFBhSaGcSUlTgy/cprkn1ncMwaBJ473/Qu+PhiuMz7sXPAFP0cvR07hGxlZzuKnu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715530491; c=relaxed/simple;
	bh=jqchNsA1s9gWMqw2QxSXW5jRUWHZGceNJbRhw8hCw5g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=hwvdWm+zZoj0XfntjXNWgRdCMKsxWTlnBZS5j8HObT12vDuSeJ80QgHol+201Jf1XG9Ps2buB+KEjRLM/anbTCfC0VgbrETW7OCwCxIBuv8Rq6i9UUcF23d0M9C8O7JSJxbkkryx8m7fr+/k8eRxpSPBIe8IX9Luc7Mf8FxBtlg=
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
Subject: [PATCH net-next 00/17] Netfilter updates for net-next
Date: Sun, 12 May 2024 18:14:19 +0200
Message-Id: <20240512161436.168973-1-pablo@netfilter.org>
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

Patch #1 skips transaction if object type provides no .update interface.

Patch #2 skips NETDEV_CHANGENAME which is unused.

Patch #3 enables conntrack to handle Multicast Router Advertisements and
	 Multicast Router Solicitations from the Multicast Router Discovery
	 protocol (RFC4286) as untracked opposed to invalid packets.
	 From Linus Luessing.

Patch #4 updates DCCP conntracker to mark invalid as invalid, instead of
	 dropping them, from Jason Xing.

Patch #5 uses NF_DROP instead of -NF_DROP since NF_DROP is 0, also from Jason.

Patch #6 removes reference in netfilter's sysctl documentation on pickup
	 entries which were already removed by Florian Westphal.

Patch #7 removes check for IPS_OFFLOAD flag to disable early drop which allows
	 to evict entries from the conntrack table, also from Florian.

Patches #8 to #16 updates nf_tables pipapo set backend to allocate the
	 datastructure copy on-demand from preparation phase, to better deal
	 with OOM situations where .commit step is too late to fail.
	 Series from Florian Westphal.

Patch #17 adds a selftest with packetdrill to cover conntrack TCP state
	 transitions, also from Florian.

Patch #18 use GFP_KERNEL to clone elements from control plane to avoid
	 quick atomic reserves exhaustion with large sets, reporter refers
	 to million entries magnitude.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-24-05-12

Thanks.

----------------------------------------------------------------

The following changes since commit cdc74c9d06e72addde01092d09f13bb86d3ed7d0:

  Merge branch 'gve-queue-api' (2024-05-05 14:35:48 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-24-05-12

for you to fetch changes up to fa23e0d4b756d25829e124d6b670a4c6bbd4bf7e:

  netfilter: nf_tables: allow clone callbacks to sleep (2024-05-10 11:13:45 +0200)

----------------------------------------------------------------
netfilter pull request 24-05-12

----------------------------------------------------------------
Florian Westphal (12):
      netfilter: conntrack: documentation: remove reference to non-existent sysctl
      netfilter: conntrack: remove flowtable early-drop test
      netfilter: nft_set_pipapo: move prove_locking helper around
      netfilter: nft_set_pipapo: make pipapo_clone helper return NULL
      netfilter: nft_set_pipapo: prepare destroy function for on-demand clone
      netfilter: nft_set_pipapo: prepare walk function for on-demand clone
      netfilter: nft_set_pipapo: merge deactivate helper into caller
      netfilter: nft_set_pipapo: prepare pipapo_get helper for on-demand clone
      netfilter: nft_set_pipapo: move cloning of match info to insert/removal path
      netfilter: nft_set_pipapo: remove dirty flag
      selftests: netfilter: add packetdrill based conntrack tests
      netfilter: nf_tables: allow clone callbacks to sleep

Jason Xing (2):
      netfilter: conntrack: dccp: try not to drop skb in conntrack
      netfilter: use NF_DROP instead of -NF_DROP

Linus Lüssing (1):
      netfilter: conntrack: fix ct-state for ICMPv6 Multicast Router Discovery

Pablo Neira Ayuso (2):
      netfilter: nf_tables: skip transaction if update object is not implemented
      netfilter: nf_tables: remove NETDEV_CHANGENAME from netdev chain event handler

 Documentation/networking/nf_conntrack-sysctl.rst   |   4 +-
 include/net/netfilter/nf_tables.h                  |   4 +-
 include/uapi/linux/icmpv6.h                        |   1 +
 net/ipv4/netfilter/iptable_filter.c                |   2 +-
 net/ipv6/netfilter/ip6table_filter.c               |   2 +-
 net/netfilter/nf_conntrack_core.c                  |   4 +-
 net/netfilter/nf_conntrack_proto_dccp.c            |   4 +-
 net/netfilter/nf_conntrack_proto_icmpv6.c          |   4 +-
 net/netfilter/nf_tables_api.c                      |  16 +-
 net/netfilter/nft_chain_filter.c                   |   6 +-
 net/netfilter/nft_connlimit.c                      |   4 +-
 net/netfilter/nft_counter.c                        |   4 +-
 net/netfilter/nft_dynset.c                         |   2 +-
 net/netfilter/nft_last.c                           |   4 +-
 net/netfilter/nft_limit.c                          |  14 +-
 net/netfilter/nft_quota.c                          |   4 +-
 net/netfilter/nft_set_pipapo.c                     | 258 ++++++++++-----------
 net/netfilter/nft_set_pipapo.h                     |   2 -
 tools/testing/selftests/net/netfilter/Makefile     |   2 +
 tools/testing/selftests/net/netfilter/config       |   1 +
 .../net/netfilter/nf_conntrack_packetdrill.sh      |  71 ++++++
 .../selftests/net/netfilter/packetdrill/common.sh  |  33 +++
 .../packetdrill/conntrack_ack_loss_stall.pkt       | 118 ++++++++++
 .../packetdrill/conntrack_inexact_rst.pkt          |  62 +++++
 .../packetdrill/conntrack_rst_invalid.pkt          |  59 +++++
 .../packetdrill/conntrack_syn_challenge_ack.pkt    |  44 ++++
 .../netfilter/packetdrill/conntrack_synack_old.pkt |  51 ++++
 .../packetdrill/conntrack_synack_reuse.pkt         |  34 +++
 28 files changed, 639 insertions(+), 175 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nf_conntrack_packetdrill.sh
 create mode 100755 tools/testing/selftests/net/netfilter/packetdrill/common.sh
 create mode 100644 tools/testing/selftests/net/netfilter/packetdrill/conntrack_ack_loss_stall.pkt
 create mode 100644 tools/testing/selftests/net/netfilter/packetdrill/conntrack_inexact_rst.pkt
 create mode 100644 tools/testing/selftests/net/netfilter/packetdrill/conntrack_rst_invalid.pkt
 create mode 100644 tools/testing/selftests/net/netfilter/packetdrill/conntrack_syn_challenge_ack.pkt
 create mode 100644 tools/testing/selftests/net/netfilter/packetdrill/conntrack_synack_old.pkt
 create mode 100644 tools/testing/selftests/net/netfilter/packetdrill/conntrack_synack_reuse.pkt

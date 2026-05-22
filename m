Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E223AE6E9;
	Fri, 22 May 2026 10:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779446588; cv=none; b=hGqCJJzCO5GH58MylmoeKfJM/1FFXRYgw7PbSFkP5VGp0yu0aWmTvRzo8oy24AzrmNy10aDQEEtgSwsKm2bxxbakENC41y5zduegGda2mYaZ8qMHYQSkKynrZfT9ny2iftJsxrd396r+QepQREd2X3uIlcgvXuxP34NaBPw9p70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779446588; c=relaxed/simple;
	bh=eQirfMVx3RWwlpKvJbG47nZ4pxybJU3gpMkrTiud1VY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S29k4ZfFjOItYQuC2/uaBiPlFmtZQq3qsw2O8FKEO9dVUhhPEtLBVC72tyZeJ2EJCILTQk8G9R2K+1CwPpo2JBrlKZHs7zLQ8+IrPbpGQ6ZfUDUqxHjyRt86HvyFLPru2tAeWDTMvcLHknZwuOmbEnobtsS+pc4CQq4qkEAmeIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ADCBD605BD; Fri, 22 May 2026 12:43:03 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 00/10] netfilter: updates for net
Date: Fri, 22 May 2026 12:42:47 +0200
Message-ID: <20260522104257.2008-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net*.
Patches 7+8 fix a regression from 7.1-rc1. Everything else
is from 2.6.x to 5.3 releases.  There are additional known
issues with these patches (drive-by-findings in related code).

There are many old bugs all over netfilter and our ability to review
feature patches has come to a complete halt due to lack of time.
There are further security bugs that we cannot address
due to lack of time, maintainers and reviewers.

Other remarks: The xtables 32bit compat interface is already
off in many vendor kernels, the plan is to remove it soon.

Tentative plan is to make a nf-next -> net-next PR with feature
removals and less urgent fixes on monday.

1) Prevent RST packets with invalid sequence numbers from forcing TCP
   connections into the CLOSE state without a direction check.
   From Hamza Mahfooz.
2) Re-derive the TCP header pointer after skb_ensure_writable in
   synproxy_tstamp_adjust. Prevent use-after-free and invalid checksum
   updates caused by stale pointers during buffer expansion.
   From Chris Mason.
3) Fix a race condition causing keymap list corruption in conntracks gre/pptp
   helper.
4) Use raw_smp_processor_id() in xt_cpu to prevent splats under
   PREEMPT_RCU.
5) Disable netfilter payload mangling in user namespaces (nft_payload.c
   and nf_queue).
   TCP option mangling via nft_exthdr.c remains enabled.
   There will be followups here to restrict resp. revalidate
   headers.
6) Fix an out-of-bounds read in ebtables's compat_mtw_from_user function.
7) Use list_for_each_entry_rcu() to traverse fib6_siblings in
   nft_fib6_info_nh_uses_dev(). Ensure safe list walking under RCU.
8) Fix an out-of-bounds read in nft_fib_ipv6 caused by incorrect list
   traversal.
9) Add nft_fib_nexthop selftest to netfilter. Cover nexthop enumeration for
    single, group, and multipath route shapes.
    All three nft_fib6 fixes from Jiayuan Chen.
10) Fix destination corruption in shift operations when source and destination
    registers overlap.  Reject partial register overlap for all operations
    from control plane.  From Fernando Fernandez Mancera.

Please, pull these changes from:
The following changes since commit 68993ced0f618e36cf33388f1e50223e5e6e78cc:

  Merge tag 'net-7.1-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-05-21 14:39:12 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-05-22

for you to fetch changes up to 18014147d3ee7831dce53fe65d7fc8d428b02552:

  netfilter: nf_tables: fix dst corruption in same register operation (2026-05-22 12:28:46 +0200)

----------------------------------------------------------------
netfilter pull request nf-26-05-22

----------------------------------------------------------------

Chris Mason (1):
  netfilter: synproxy: refresh tcphdr after skb_ensure_writable

Fernando Fernandez Mancera (1):
  netfilter: nf_tables: fix dst corruption in same register operation

Florian Westphal (4):
  netfilter: nf_conntrack_gre: fix gre keymap list corruption
  netfilter: xt_cpu: prefer raw_smp_processor_id
  netfilter: disable payload mangling in userns
  netfilter: ebtables: fix OOB read in compat_mtw_from_user

Hamza Mahfooz (1):
  netfilter: conntrack: tcp: do not force CLOSE on invalid-seq RST
    without direction check

Jiayuan Chen (3):
  netfilter: nft_fib_ipv6: walk fib6_siblings under RCU
  netfilter: nft_fib_ipv6: handle routes via external nexthop
  selftests: netfilter: add nft_fib_nexthop test

 .../linux/netfilter/nf_conntrack_proto_gre.h  |   7 +-
 include/net/netfilter/nf_tables.h             |   7 +
 net/bridge/netfilter/ebtables.c               |  30 ++++
 net/ipv6/netfilter/nft_fib_ipv6.c             |  18 ++-
 net/netfilter/nf_conntrack_core.c             |   8 +
 net/netfilter/nf_conntrack_pptp.c             |   8 +-
 net/netfilter/nf_conntrack_proto_gre.c        | 106 +++++++++---
 net/netfilter/nf_conntrack_proto_tcp.c        |   3 +-
 net/netfilter/nf_synproxy_core.c              |   2 +
 net/netfilter/nfnetlink_queue.c               |   6 +-
 net/netfilter/nft_bitwise.c                   |  18 ++-
 net/netfilter/nft_byteorder.c                 |  13 +-
 net/netfilter/nft_payload.c                   |   3 +
 net/netfilter/xt_cpu.c                        |   2 +-
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../net/netfilter/nft_fib_nexthop.sh          | 152 ++++++++++++++++++
 16 files changed, 338 insertions(+), 46 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_fib_nexthop.sh
-- 
2.53.0

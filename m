Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9880F3B19D1;
	Tue,  7 Apr 2026 14:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775571349; cv=none; b=i/AjnHTZ3Cl7hZzANaTy5rb5vtZl1rBZjDU/UFkIXiAlhrS15FCanUqricOgi305tncg44igZPTujj1z4nbiEEpb8jWABH0sGc7jx22E5CvSXpEMQcBmUQbL31wx6yuAk/e1sron5Y1SKKI/inAOTWAYnmT6EJfx5JhYtFzxQtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775571349; c=relaxed/simple;
	bh=6qZjZyJ9GLCN60E6LWzWhxaj/3spMGIYtEashTkIS8E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k33TJJFnxs5SQsueO7rJa9QmmzzG9DGOsddo+rzXaIynOzH7nU5RNnBKhU7rRiBfaK6ubvrv5Q3soW1WjYa9p0pMmJXVZUEWytOwuAXZjeasLbEAP1VAwexQyXJ6Ixueg05CZopFRjdf4EsTKAQFJ72NAdGHlPwpmaAmIxjZV98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1AC7A60660; Tue, 07 Apr 2026 16:15:45 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 00/13] netfilter: updates for net-next
Date: Tue,  7 Apr 2026 16:15:27 +0200
Message-ID: <20260407141540.11549-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net-next*:

1) Fix ancient sparse warnings in nf conntrack nat modules, from
   Sun Jian.
2) Fix typo in enum description, from Jelle van der Waa.
3) remove redundant refetch of netns pointer in nf_conntrack_sip.
4) add a deprecation warning for dccp match.
   We can extend the deadline later if needed, but plan atm is to
   remove the feature.
5) remove nf_conntrack_h323 debug code that can read out-of-bounds
   with malformed messages. This code was commented out, but better
   remove this.
6+7) add more netlink policy validations in netfilter.
   This could theoretically cause issues when a client sends e.g.
   unsupported feature flags that were previously ignored, so we
   may have to relax some changes. For now, try to be stricter and
   reject upfront.
8+9) minor code cleanup in nft_set_pipapo (an nftables set backend).
10) Add nftables matching support fro double-tagged vlan and pppoe
    frames, from Pablo Neira Ayuso.
11) Fix up indentation of debug messages in nf_conntrack_h323 conntrack
    helper, from David Laight.
12) Add a helper to iterate to next flow action and bail out if the
    maximum number of actions is reached, also from Pablo.
13) Impose more retrictions on expectations attached via ctnetlink
    control plane by restricting this based on the helper attached to
    the master conntrack, also from Pablo Neira Ayuso.

Please, pull these changes from:
The following changes since commit 97a8355b6a715c79c090b906894e12dc3934b3fe:

  Merge branch 'net-mlx5e-xdp-add-support-for-multi-packet-per-page' (2026-04-07 13:34:08 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-26-04-07

for you to fetch changes up to ead9479042e7349e3deab204add7b7ccebe20429:

  netfilter: ctnetlink: restrict expectfn to helper (2026-04-07 15:48:16 +0200)

----------------------------------------------------------------
netfilter pull request nf-next-26-04-07

----------------------------------------------------------------
David Laight (1):
  netfilter: nf_conntrack_h323: Correct indentation when H323_TRACE
    defined

Florian Westphal (7):
  netfilter: nf_conntrack_sip: remove net variable shadowing
  netfilter: add deprecation warning for dccp support
  netfilter: nf_conntrack_h323: remove unreliable debug code in
    decode_octstr
  netfilter: add more netlink-based policy range checks
  netfilter: nf_tables: add netlink policy based cap on registers
  netfilter: nft_set_pipapo: increment data in one step
  netfilter: nft_set_pipapo_avx2: remove redundant loop in lookup_slow

Jelle van der Waa (1):
  netfilter: nf_tables: Fix typo in enum description

Pablo Neira Ayuso (3):
  netfilter: nft_meta: add double-tagged vlan and pppoe support
  netfilter: nf_tables_offload: add nft_flow_action_entry_next() and use
    it
  netfilter: ctnetlink: restrict expectfn to helper

Sun Jian (1):
  netfilter: use function typedefs for __rcu NAT helper hook pointers

 include/linux/netfilter/nf_conntrack_amanda.h | 15 +++--
 include/linux/netfilter/nf_conntrack_ftp.h    | 17 +++---
 include/linux/netfilter/nf_conntrack_irc.h    | 15 +++--
 include/linux/netfilter/nf_conntrack_snmp.h   | 11 ++--
 include/linux/netfilter/nf_conntrack_tftp.h   |  9 ++-
 include/net/netfilter/nf_conntrack_helper.h   |  3 +-
 include/net/netfilter/nf_tables.h             |  4 ++
 include/net/netfilter/nf_tables_ipv4.h        | 17 ++++--
 include/net/netfilter/nf_tables_ipv6.h        | 16 +++--
 include/net/netfilter/nf_tables_offload.h     | 10 ++++
 include/uapi/linux/netfilter/nf_tables.h      |  6 +-
 net/ipv4/netfilter/nf_nat_h323.c              |  2 +
 net/netfilter/ipset/ip_set_core.c             |  2 +-
 net/netfilter/nf_conntrack_amanda.c           | 10 +---
 net/netfilter/nf_conntrack_ftp.c              | 10 +---
 net/netfilter/nf_conntrack_h323_asn1.c        | 45 ++++++--------
 net/netfilter/nf_conntrack_helper.c           |  5 +-
 net/netfilter/nf_conntrack_irc.c              | 10 +---
 net/netfilter/nf_conntrack_netlink.c          |  2 +-
 net/netfilter/nf_conntrack_sip.c              |  3 +-
 net/netfilter/nf_conntrack_snmp.c             |  7 +--
 net/netfilter/nf_conntrack_tftp.c             |  7 +--
 net/netfilter/nf_dup_netdev.c                 |  5 +-
 net/netfilter/nf_nat_sip.c                    |  1 +
 net/netfilter/nf_tables_api.c                 | 20 +++++--
 net/netfilter/nf_tables_core.c                |  2 +-
 net/netfilter/nfnetlink_acct.c                |  2 +-
 net/netfilter/nfnetlink_cthelper.c            |  2 +-
 net/netfilter/nfnetlink_hook.c                |  2 +-
 net/netfilter/nfnetlink_log.c                 |  4 +-
 net/netfilter/nfnetlink_osf.c                 |  2 +-
 net/netfilter/nfnetlink_queue.c               |  2 +-
 net/netfilter/nft_bitwise.c                   |  6 +-
 net/netfilter/nft_byteorder.c                 |  4 +-
 net/netfilter/nft_cmp.c                       |  2 +-
 net/netfilter/nft_compat.c                    |  2 +-
 net/netfilter/nft_connlimit.c                 |  2 +-
 net/netfilter/nft_ct.c                        |  6 +-
 net/netfilter/nft_dynset.c                    |  3 +-
 net/netfilter/nft_exthdr.c                    |  9 ++-
 net/netfilter/nft_fib.c                       |  2 +-
 net/netfilter/nft_hash.c                      |  4 +-
 net/netfilter/nft_immediate.c                 |  6 +-
 net/netfilter/nft_inner.c                     |  2 +-
 net/netfilter/nft_limit.c                     |  2 +-
 net/netfilter/nft_log.c                       |  2 +-
 net/netfilter/nft_lookup.c                    |  4 +-
 net/netfilter/nft_meta.c                      | 58 ++++++++++++++++++-
 net/netfilter/nft_numgen.c                    |  2 +-
 net/netfilter/nft_objref.c                    |  2 +-
 net/netfilter/nft_osf.c                       |  4 +-
 net/netfilter/nft_payload.c                   |  8 +--
 net/netfilter/nft_queue.c                     |  2 +-
 net/netfilter/nft_quota.c                     |  2 +-
 net/netfilter/nft_range.c                     |  2 +-
 net/netfilter/nft_rt.c                        |  2 +-
 net/netfilter/nft_set_pipapo.c                |  4 +-
 net/netfilter/nft_set_pipapo.h                |  3 -
 net/netfilter/nft_set_pipapo_avx2.c           | 32 +++-------
 net/netfilter/nft_socket.c                    |  2 +-
 net/netfilter/nft_synproxy.c                  |  4 +-
 net/netfilter/nft_tunnel.c                    |  6 +-
 net/netfilter/nft_xfrm.c                      |  6 +-
 net/netfilter/xt_dccp.c                       |  3 +
 64 files changed, 271 insertions(+), 195 deletions(-)
-- 
2.52.0

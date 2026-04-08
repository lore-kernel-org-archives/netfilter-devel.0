Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D56339B2D;
	Wed,  8 Apr 2026 06:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775628272; cv=none; b=iTtl0lEyenRW/OgdNyIFZEIE/m68qqZejejO7tfN+KYgSTAu7FhLcc9JsE60v+Ij1X8ACQBWUHDJzfqAdcMISHyhVmv1sGpcTZuOq9MtngappyfZi4eu4VaCDKHTcqO5YJNwDPkf/XHt85bKbEZOaV8bLm4Rqi8iD5eWE2ZAafs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775628272; c=relaxed/simple;
	bh=3kLCuPE13cGBXk5qOEbHuockj0A+sW3WkOD5gRGrc74=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iyX84FXwqwWTXVFCILFrQeQUocqG59Dk7pue+1Y+MvPjoCMOhtQXrZHqh8Kb33odYMxYxOI6zvHmO9M2WyCPKWn8AXwIIsBPBtEqM3Vl9QvkKS5AQc9Ku84NLOyZjo7f3dvweYLhM3V7oVXUBDeGX2n+s4UTlkzIK01ZqGtriC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7E356604AA; Wed, 08 Apr 2026 08:04:28 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [GIT PULL v2 net-next] netfilter: updates for net-next
Date: Wed,  8 Apr 2026 08:04:19 +0200
Message-ID: <20260408060419.25258-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No changes since v1, I only dropped the last patch (13/13).  This is also
why I am not resending the individual patches again.

The following PR contains Netfilter updates for *net-next*:

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

Please, pull these changes from:
The following changes since commit b3e69fc3196fc421e26196e7792f17b0463edc6f:

  Merge branch 'net-pull-gso-packet-headers-in-core-stack' (2026-04-07 19:02:18 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-26-04-08

for you to fetch changes up to c6f85577584b5f8414141ae389e974b8ca6a698b:

  netfilter: nf_tables_offload: add nft_flow_action_entry_next() and use it (2026-04-08 07:51:31 +0200)

----------------------------------------------------------------
netfilter pull request nf-next-26-04-08

----------------------------------------------------------------

David Laight (1):
  netfilter: nf_conntrack_h323: Correct indentation when H323_TRACE defined

Florian Westphal (7):
  netfilter: nf_conntrack_sip: remove net variable shadowing
  netfilter: add deprecation warning for dccp support
  netfilter: nf_conntrack_h323: remove unreliable debug code in decode_octstr
  netfilter: add more netlink-based policy range checks
  netfilter: nf_tables: add netlink policy based cap on registers
  netfilter: nft_set_pipapo: increment data in one step
  netfilter: nft_set_pipapo_avx2: remove redundant loop in lookup_slow

Jelle van der Waa (1):
  netfilter: nf_tables: Fix typo in enum description

Pablo Neira Ayuso (2):
  netfilter: nft_meta: add double-tagged vlan and pppoe support
  netfilter: nf_tables_offload: add nft_flow_action_entry_next() and use
    it

Sun Jian (1):
  netfilter: use function typedefs for __rcu NAT helper hook pointers

 include/linux/netfilter/nf_conntrack_amanda.h | 15 +++--
 include/linux/netfilter/nf_conntrack_ftp.h    | 17 +++---
 include/linux/netfilter/nf_conntrack_irc.h    | 15 +++--
 include/linux/netfilter/nf_conntrack_snmp.h   | 11 ++--
 include/linux/netfilter/nf_conntrack_tftp.h   |  9 ++-
 include/net/netfilter/nf_tables.h             |  4 ++
 include/net/netfilter/nf_tables_ipv4.h        | 17 ++++--
 include/net/netfilter/nf_tables_ipv6.h        | 16 +++--
 include/net/netfilter/nf_tables_offload.h     | 10 ++++
 include/uapi/linux/netfilter/nf_tables.h      |  6 +-
 net/netfilter/ipset/ip_set_core.c             |  2 +-
 net/netfilter/nf_conntrack_amanda.c           | 10 +---
 net/netfilter/nf_conntrack_ftp.c              | 10 +---
 net/netfilter/nf_conntrack_h323_asn1.c        | 45 ++++++--------
 net/netfilter/nf_conntrack_irc.c              | 10 +---
 net/netfilter/nf_conntrack_sip.c              |  3 +-
 net/netfilter/nf_conntrack_snmp.c             |  7 +--
 net/netfilter/nf_conntrack_tftp.c             |  7 +--
 net/netfilter/nf_dup_netdev.c                 |  5 +-
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
 59 files changed, 262 insertions(+), 191 deletions(-)

-- 
2.52.0

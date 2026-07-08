Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F972222C5;
	Wed,  8 Jul 2026 14:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783519403; cv=none; b=G+/ikZnndWAwGjM/t4tL6OugVSFW5fYXwHe0Jf9ePp7K+dexsuecFwM7agtv2Yr+7+K/sWiF3KVSe84HbtgNbrNUlHdMIYnO01pub/db/2eUobOg4OBOH40leOEPpq0I5GRwJ8IxBA9JqzHZoBlD0zVgWf/sG/8OQdnnaVljaNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783519403; c=relaxed/simple;
	bh=5cxBzQsfLJdRoWvA5ssYYkPx4c8bS6l4OBynz9QZfLw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g8EschLoIUsCn9DF5OzJ5WSIIcKMcQbXu4DpVmnhFeYNgaLoimt+xXJO4GMtOEttuItaj4oczs8Aa+20nG9FuJGkV6lR7ZEtgoPfCXwHsxDdv56w/kZ2Bw13O9hxkdSfhToRyQaXMLm2WAyYMiqCOeTOto8fuqgBoj6fvuZ7zo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 44B196059E; Wed, 08 Jul 2026 16:03:19 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 00/17] netfilter: updates for net
Date: Wed,  8 Jul 2026 16:02:52 +0200
Message-ID: <20260708140309.19633-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net*.

Most of these are LLM fixes for old issues flagged by sashiko/LLMs.

Many of these trigger drive-by-findings in sashiko. In particular:

- many load/store tearing and missing memory barriers, races
  etc. in ipset, esp. with GC and resizing.
  Keeping the proposed patches spinning for yet-another-iteration
  keeps legit fixes back, so I prefer to add these now and follow
  up with other reports later.
- flowtable work queue still has possible races with teardown,
  but same rationale as with ipset: drive-by findings, not
  problems coming with the flowtable IPIP changeset in this PR.
- ever since unreadable frag skb support was added in 6.12, we can no
  longer do: BUG_ON(skb_copy_bits( ...): it will fire with such skbs.
  Mina Almasry is looking at similar patterns elsewhere in the stack.

1) Guard skb->mac_header adjustment after IPv6 defragmentation in
nf_conntrack_reasm.  From Xiang Mei.

2) NUL-terminate ebtables table names before calling find_table_lock() to
prevent stack-out-of-bounds reads.  Also from Xiang Mei.

3) Zero the ebtables chainstack array, else error unwind may free bogus
pointer when CPU mask is sparse.  All three issues date from 2.6 days.

4) Ensure ebtables module names are c-strings, same bug pattern as 2).
Bug added in 4.6.

5) Fix catchall element handling for inverted lookups in nft_lookup. Fold the
catchall lookup into ext before computing the match status.  Was like
this ever since catchall elements got introduced in 5.13.
From Tamaki Yanagawa.

6-9) ipset updates from Jozsef Kadlecsik:
- mark rcu protected areas correctly
- address gc and resize clash in the comment extension
- add/del backlog cleanup in the error path
- allocate right size for the generic hash structure

10-12): IPIP flowtable updates from Pablo Neira Ayuso:
 - Use the current direction's route when pushing IPIP headers
   Fix incorrect headroom and fragmentation offset calculations.
 - Avoid hardware offload for IPIP tunnels due to lack of driver support.
 - Support IPIP tunnels with direct xmit in netfilter flowtable.
   dst_cache and dst_cookie are moved outside the union to share route
   state across flows.  This is a followup to work done in 6.19 cycle.

13) Don't BUG() on skb_copy_bits error. Handle unreadable fragments by
either returning an error or restricting the copy operations to linear area,
This became an issue when unreable frag support was merged in 6.12.

14-16): IPVS updates from Yizhou Zhao:
 - Pass parsed transport offset to IPVS state handlers.
   update callback signatures.
 - use correct transport header offset on state lookp in TCP.
   As-is it was possible for ipv6 extension header data to be
   treated as L4 header.
 - same for SCTP.  This was also broken since 2.6 days.

17) Ensure inner IP headers in ICMP errors are in the skb headroom after
stripping outer headers. Add more checks for the length of inner headers.
This was broken since 3.7 days.
From Julian Anastasov.

Please, pull these changes from:
The following changes since commit 6d27e29a90bc6a717b97c6ddcd866db7bd8e4adc:

  Merge branch 'ipv4-ipv6-fix-uaf-and-memory-leak-in-igmp-mld' (2026-07-08 14:41:04 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-07-08

for you to fetch changes up to 3f7a535ff0fa627a0132803e4c2f903ceffcbc1c:

  ipvs: ensure inner headers in ICMP errors are in headroom (2026-07-08 15:33:44 +0200)

----------------------------------------------------------------
netfilter pull request nf-26-07-08

----------------------------------------------------------------

Florian Westphal (3):
  netfilter: ebtables: zero chainstack array
  netfilter: ebtables: module names must be null-terminated
  netfilter: handle unreadable frags

Jozsef Kadlecsik (4):
  netfilter: ipset: mark the rcu locked areas properly
  netfilter: ipset: exclude gc when resize is in progress
  netfilter: ipset: cleanup the add/del backlog when resize failed
  netfilter: ipset: allocate the proper memory for the generic hash structure

Julian Anastasov (1):
  ipvs: ensure inner headers in ICMP errors are in headroom

Pablo Neira Ayuso (3):
  netfilter: flowtable: use dst in this direction when pushing IPIP header
  netfilter: flowtable: IPIP tunnel hardware offload is not yet support
  netfilter: flowtable: support IPIP tunnel with direct xmit

Tamaki Yanagawa (1):
  netfilter: nft_lookup: fix catchall element handling with inverted lookups

Xiang Mei (2):
  netfilter: nf_conntrack_reasm: guard mac_header adjustment after IPv6 defrag
  netfilter: ebtables: terminate table name before find_table_lock()

Yizhou Zhao (3):
  ipvs: pass parsed transport offset to state handlers
  ipvs: use parsed transport offset in TCP state lookup
  ipvs: use parsed transport offset in SCTP state lookup

 include/net/ip_vs.h                     |  3 +-
 include/net/netfilter/nf_flow_table.h   |  7 +-
 net/bridge/netfilter/ebtables.c         | 12 +++-
 net/ipv6/netfilter/nf_conntrack_reasm.c |  5 +-
 net/netfilter/ipset/ip_set_hash_gen.h   | 85 ++++++++++++++++---------
 net/netfilter/ipvs/ip_vs_core.c         | 31 +++++----
 net/netfilter/ipvs/ip_vs_proto_sctp.c   | 18 ++----
 net/netfilter/ipvs/ip_vs_proto_tcp.c    | 11 +---
 net/netfilter/ipvs/ip_vs_proto_udp.c    |  3 +-
 net/netfilter/nf_flow_table_core.c      | 19 +++---
 net/netfilter/nf_flow_table_ip.c        | 21 +++---
 net/netfilter/nf_flow_table_offload.c   | 22 ++++++-
 net/netfilter/nfnetlink_log.c           | 26 +++++---
 net/netfilter/nfnetlink_queue.c         | 16 +++--
 net/netfilter/nft_lookup.c              | 10 +--
 net/netfilter/xt_u32.c                  | 16 +++--
 16 files changed, 196 insertions(+), 109 deletions(-)

-- 
2.54.0


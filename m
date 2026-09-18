Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2361509F16
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 15:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746005; cv=none; b=Afc0v2Ch2AcvoatBGc2t2s/HUaE29MccoNPf0zZJvLSfXDV0nwUjUxl/QJTSbs6Snf8DISUcO//1VpKpE2rTbs7K36ZLUyFgUcCmP+6rG7DnfdPW6lZ25K1cGNd8vjpjIRJwj7qGywzTh6deQrWIGromnkLIbiNq1A5fFqNvKk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746005; c=relaxed/simple;
	bh=apI6qqfzVZ0tzQpabn12kK97ztLBm2ozw3t4RppWwPI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pnb22nBouKXa1dM9a/54JLTE302yj0F+uI+dFau/J16izqKNCaZ0Mjn2cj6oC6GwpPLcRKIFv+PAXqsCAsg9ccoqY+AcwlFEDnWeUIonyCswpuD8Nx6d14JVjIf/VTjgOHgCxx7mzedySxw1uGY9HLqnunV8U78rZTFWd3mdK3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5344460468; Fri, 18 Sep 2026 17:39:50 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v3 0/6] netfilter: harden conntrack vs ingress pipeline rewrites
Date: Fri, 18 Sep 2026 16:58:03 +0200
Message-ID: <20260918145809.12938-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3: more LLM comments.  Only changes are in patches 1, 5 and 6.
v2: address LLM comments.  Only changes are in patches 1 and 6.

netfilter is very allergic to packets changing while they are within the
processing pipeline.

- we rely on ip/ipv6 stack to check ip header integrity, later
  parts of conntrack, e.g. helpers, rely on conntrack to have
  sanity-checked e.g. th->doff.

- parts that bypass inet (e.g. bridge) replicate those sanity
  checks on l3 headers.

- Other hardening changes to nf_queue and nft_payload.c have clamped
  down on the ability to mangle packet in arbitary ways in-between
  hooks.

Another remaining problem is conntrack itself: if nf_conntrack_in finds
the skb already has an nf_conn attached, no further checks are done.

This isn't correct anymore, such nf_conn could have been attached by
output hook (loopback case) or tc conntrack action.  In between those
mangling is possible.  This patchset aims to add sanity checks for this.

1) Validate skb->_nfct against current L3/L4 headers from nf_conntrack_in().
Drop stale conntrack references and trigger re-lookups if mismatches occur.

2) Refactor nf_confirm() logic into separate functions for protocol offset
determination and helper calls.

3) Verify L4 protocol matches the helper's expected protocol before calling a
conntrack helper. Skip IPv4 fragments and packets without payload. Update
nft_ct to set the L4 protocol in newly allocated helpers.

4) Replace open-coded conntrack helper invocation with nf_ct_call_helper().
Add checks to ensure the helper can process packets.  This also reduces
copypaste with tc and ovs.

5) Harden nf_conntrack helper invocation via tuple revalidation. Verify
packet tuples match connection tracking entries. Check for sane TCP
headers in TCP traffic.

6) Validate timeout object protocols against the conntrack tuple protocol
before attachment. Prevent potential out-of-bounds reads caused by
protocol state mismatches.

Earlier attempt to fix offenders instead:
 https://lore.kernel.org/netdev/20260819204210.23722-1-fw@strlen.de/

Florian Westphal (6):
  netfilter: nf_conntrack: validate skb->_nfct and packet headers
  netfilter: nf_conntrack: refactor helper call logic in nf_confirm()
  netfilter: nf_conntrack: verify L4 protocol before calling helper
  netfilter: conntrack: replace open-coded helper invocation
  netfilter: nf_conntrack: harden helper invocation with tuple
    revalidation
  netfilter: nft_ct: validate timeout object protocol

 include/net/netfilter/nf_conntrack_helper.h |   2 +
 net/netfilter/nf_conntrack_core.c           | 115 ++++++++++++-
 net/netfilter/nf_conntrack_ovs.c            |  53 +-----
 net/netfilter/nf_conntrack_proto.c          | 173 ++++++++++++++++----
 net/netfilter/nft_ct.c                      |  45 +++--
 5 files changed, 283 insertions(+), 105 deletions(-)

-- 
2.55.0


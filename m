Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805A44A3E
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Sep 2024 19:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727207144; cv=none; b=BIfwHT4azpBx0+vQF7Pb3MOyeh7i+ECfu2/dfndffwildb3ZRjtvTGeWhQaftUWhLbKf0osn6lo/w8KWTnmixTaOoo2xNK8TSjY+mD72LfoZJQoGGwE7gqjjFMRMJz73edesDiGBdZbXe69yA9qPUF6jSGI7yO37IF2ZB+YKE/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727207144; c=relaxed/simple;
	bh=3MIopoKUSSiJAe2voDpTjM1rVtHEs7hWwry0WjZhlSo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OesA1sj5iHf/nzKg1hr+ejmJvPUsVPkMv9/NPdmRrzRtXxFNndewnt5p89ciWR/4hmBPv8uN50Xw+8gzsuCUy7HJPrldVWfeROWN8WhxmIYDI/M62BY1He0gRRIwiDJAuGez6RnBkRqzflOYBSYh64gGFwj0mLJocDd4wuHuxq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1stBTf-0004nG-CQ; Tue, 24 Sep 2024 21:45:39 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: cmi@nvidia.com,
	nbd@nbd.name,
	sven.auhagen@voleatech.de,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/7] netfilter: rework conntrack/flowtable interaction
Date: Tue, 24 Sep 2024 21:44:08 +0200
Message-ID: <20240924194419.29936-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series resolves a few problems with flowtables when entries are
moved from offload (hw/sw offload) back to the conntrack slowpath.

First patch fixes conntrack reset validation, we must clear MAXACK flag
on reset packets in the sw flow offload path, conntrack state is stale,
it cannot validate reset sequence number.

Second patch adds mandatory locking when manipulating ct state flags.

Third patch is a cleanup patch so existing API can be re-used when
we lack an skb.

Patch 4 is a small preparation patch to reuse existing api and
get rid of redundant one later.

Patch 5 moves timeout extension logic from conntrack GC to flowtable
GC worker.

Patch 6 prevents accidental unwanted growth of conntrack timeout
when handling packets of same flow in slowpath at same time.

Patch 7 is an optimization to keep entry in software flowtable
when a fin is received.

NB: nftables flowtable selftest needs a minor fixup to exect 300s
timeout instead of 5 days after inital move to slowpath, this is the
only observed failure with nf kselftests or nftables shell tests.

Florian Westphal (7):
  netfilter: nft_flow_offload: clear tcp MAXACK flag before moving to
    slowpath
  netfilter: nft_flow_offload: update tcp state flags under lock
  netfilter: conntrack: remove skb argument from nf_ct_refresh
  netfilter: flowtable: prefer plain nf_ct_refresh for setting initial
    timeout
  netfilter: conntrack: rework offload nf_conn timeout extension logic
  netfilter: nft_flow_offload: never grow the timeout when moving
    packets back to slowpath
  netfilter: nft_flow_offload: do not remove flowtable entry for fin
    packets

 Patches vs. nf-next, but could be applied to nf too.

 include/net/netfilter/nf_conntrack.h   |  18 +--
 net/netfilter/nf_conntrack_amanda.c    |   2 +-
 net/netfilter/nf_conntrack_broadcast.c |   2 +-
 net/netfilter/nf_conntrack_core.c      |  13 +-
 net/netfilter/nf_conntrack_h323_main.c |   4 +-
 net/netfilter/nf_conntrack_sip.c       |   4 +-
 net/netfilter/nf_flow_table_core.c     | 200 ++++++++++++++++++++++---
 net/netfilter/nf_flow_table_ip.c       |   5 +-
 net/netfilter/nft_ct.c                 |   2 +-
 net/netfilter/nft_flow_offload.c       |  16 +-
 10 files changed, 207 insertions(+), 59 deletions(-)

-- 
2.44.2


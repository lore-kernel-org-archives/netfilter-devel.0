Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CD72882BC
	for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2025 13:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747922011; cv=none; b=RT0RadhJCySOx/M09uYFHzLtzc0WVyuXoCKdQyTJbMs7U1bKuKiXWkz8CATLHXFhzeIS/6y3u3cF+teU8Wt9j49h4tP5kTY98X1JxOewugXJ80+/nQS2MiC1JVhBGY1s2GyxCZMaewe13svSpgtQ95m8ohttezsyjFXhZXJwlBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747922011; c=relaxed/simple;
	bh=TYuhMCvSOI1bX8KqkSxEsB9kRjUdmHsH8004UCDto0I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jg63IMycnAl9DUfYHFw7idXkpE9TSDOmZGasWwYcGDjncKhuSyyPSskCM7yqqM/NRBCM4qCeo6wlGb8tpEmkLhcc+oOYSf77hPoDW9Hct95DqStixsDWvAzWr1rqb6Xt5g+lt01raDkHa/4XFe1gU5U6yDtaQZ+TOZ/aEelqIbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D17976014F; Thu, 22 May 2025 15:53:27 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 0/2] netfilter: nf_tables: include conntrack state in trace messages
Date: Thu, 22 May 2025 15:49:32 +0200
Message-ID: <20250522134938.30351-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2:
Address feedback from Pablo: don't reuse nft_ct_keys, but add extra
ct_trace attributes.  No other changes.

Add the minimal relevant info needed for userspace ("nftables monitor
trace") to provide the conntrack view of the packet:

- state (new, related, established)
- direction (original, reply)
- status (e.g., if connection is subject to dnat)
- id (allows to query ctnetlink for remaining conntrack state info)

Example:
trace id a62 inet filter PRE_RAW packet: iif "enp0s3" ether [..]
  [..]
trace id a62 inet filter PRE_MANGLE conntrack: ct direction original ct state new ct id 32
trace id a62 inet filter PRE_MANGLE packet: [..]
 [..]
trace id a62 inet filter IN conntrack: ct direction original ct state new ct status dnat-done ct id 32
 [..]

First patch is a needed prerequisite to avoid a module dependency.
Second patch adds the needed info.

Updated patch for libnftnl will follow shortly, the nftables patch
doesn't need adjustment: it uses libnftl for all trace accesses.

Florian Westphal (2):
  netfilter: conntrack: make nf_conntrack_id callable without a module
    dependency
  netfilter: nf_tables: add packets conntrack state to debug trace info

 include/linux/netfilter.h                |  1 +
 include/uapi/linux/netfilter/nf_tables.h |  8 ++++
 net/netfilter/nf_conntrack_core.c        |  6 +++
 net/netfilter/nf_tables_trace.c          | 54 +++++++++++++++++++++++-
 4 files changed, 68 insertions(+), 1 deletion(-)

-- 
2.49.0


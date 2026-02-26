Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D880444D68A
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 20:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772137299; cv=none; b=fEX9BhmOblCZoCmTFixdgT+hQX6eK+DPb1zNpwk8DJwbexxpSASSBVs7Teer5OzSnTm1U05Ee8zeP4N5jGltJJ7k0iW2T2NcKA198lX3m0AnqrpvwP0Ktg55o/JAfAsMTx03PAxvA+Pi6z1A3eX29ATKZeY1PXb3ZAMvCALGX8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772137299; c=relaxed/simple;
	bh=hv4laLnj9hFYRIS5SlxpecOMpP35sKDhL7yK/G7XCPM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JLdRSU/1xPbAdlBydCzhWQZwvyV/S8PvQ6JyJjBlRXlu98twHypCSmR6gr7nFOV/rJzHonn8ro9N7CiNcjr8vZhEr+eEZN5Znlohm7hA3YDMLuQBDNKetpLFgNlZpn7g9Wc+nGugQc9tQbQ0odhJm4U3/7po2TCvISzpH0Bri4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DB7EA60336; Thu, 26 Feb 2026 21:21:35 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 0/3] ipv6: switch nft_fib_ipv6 to fib6_lookup
Date: Thu, 26 Feb 2026 21:21:23 +0100
Message-ID: <20260226202129.15033-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Existing code works but it requires a temporary dst object that is
released again right away.

Switch to fib6_lookup + RT6_LOOKUP_F_DST_NOREF: no need for temporary dst
objects and refcount overhead anymore.

Provides ~13% improvement in match performance.

First two patches are preparations:
We need to export fib6_lookup, only alternative would be an indirection
via the ipv6 stub, but thats expensive.

Also, nft_fib_ipv6 uses a helper that requires a ipv6 dst, but we no
longer have that.  Split this and let the new helper work without the
dst object.

Changes since v1:
- fix compiler error without ipv6 multi-table support
- split ipv6_anycast_destination, use the new helper

Florian Westphal (3):
  ipv6: export fib6_lookup for nft_fib_ipv6
  ipv6: make ipv6_anycast_destination logic useable without dst_entry
  netfilter: nft_fib_ipv6: switch to fib6_lookup

 include/net/ip6_route.h           | 15 ++++--
 net/ipv6/fib6_rules.c             |  3 ++
 net/ipv6/ip6_fib.c                |  3 ++
 net/ipv6/netfilter/nft_fib_ipv6.c | 79 +++++++++++++++++++------------
 4 files changed, 66 insertions(+), 34 deletions(-)

-- 
2.52.0


Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1CA37267D
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2026 19:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772564546; cv=none; b=Y9bDENEpCWEtg/uzouxUxmhfwrVHR8OI6dMcEyWMK8kMqrEF7GWoMaTTNIZ+BgBsCybVVEh8w2n4SUNyxB2SJsr+9kEeWY9Q+LcoUofJ238K/+PDpg42hAAO9mBEua263u1x2BrXJTfj6Pzoo9ixRkaW71F/zQijCXyx75utEZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772564546; c=relaxed/simple;
	bh=BV/q+xn5OcKG2klUL/CFHlAKb3qVoXenlAHBdev1ois=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SDOkyBqEIrOB4j3m+eUNhSCkdRR7uAO4KONt8sU0IXvazgwGJhZUMetE1viiRBulqb+9eMHS5fTxYgXbhBWKfUauLt17pmaEwmLgdD+gRU4WhPcrHcGohm/gkiS44g9kNGlIp2KCkDZa0vh3B2O54qpaD5q3gnvC7fuozZKD3k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8DA8C60CFF; Tue, 03 Mar 2026 20:02:23 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/2] netfilter: nft_set_pipapo: fix UaF during gc walk
Date: Tue,  3 Mar 2026 20:02:06 +0100
Message-ID: <20260303190218.19781-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Yiming Qian reports Use-after-free in the pipapo set type:
  Under a large number of expired elements, commit-time GC can run for a very
  long time in a non-preemptible context, triggering soft lockup warnings and
  RCU stall reports (local denial of service).

As-is, elements are unlinked from the clone.  But the expired elements
are also reachable from the live copy.

Therefore, we must not queue them for freeing until after the clone
has been exposed to other CPUs and one grace period has elapsed.

Split gc into unlink + reclaim phase to resolve this bug.

Florian Westphal (2):
  netfilter: nft_set_pipapo: split gc in unlink and reclaim phase
  netfilter: nft_set_pipapo: prevent soft lockup during gc walk

 net/netfilter/nft_set_pipapo.c | 69 +++++++++++++++++++++++++---------
 net/netfilter/nft_set_pipapo.h |  4 ++
 2 files changed, 56 insertions(+), 17 deletions(-)
-- 
2.52.0


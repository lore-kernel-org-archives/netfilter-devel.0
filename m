Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921B32BEFEF
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 13:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664539; cv=none; b=c8BefEIwUP0JaerEH1SpCv+ULxyj3qp6/oUbxXaQlQoXsefTWRuy8LyeSHgG+UfNkgMvchZ4mVXNxw5IKs3gdrMLquR+piBG6ZwpHIO9iPSRImQqLrdSNGVvbFfNLE9OEGsvm5bVFzFgUyuxkll7Y1B+uLSTg38SFZ1SAuNMsQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664539; c=relaxed/simple;
	bh=Vy1wG0XilpLoAKyuHnMHn2vhs78Vgq/pPketGgBzlQk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mLOSmiuucsqncwwMYKuJYSKUh8aJkvq3N7+enggMKGnDriTyvOKJa2ugs4mrKHKEDAVNU6yObo3sRjK9jz1MeSHSk2QQ00HMSC6phAea+EXwWzmTs/8tQKXxluC6MCEzKjkF/WjwGKNfoP2KyQ+MNQWON9o8cIGZsffD2PhOcO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E3DF860388; Tue, 25 Aug 2026 15:28:55 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 0/5] netfilter: ipset: rhashtable conversion
Date: Tue, 25 Aug 2026 15:28:38 +0200
Message-ID: <20260825132843.1692-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Identical resend except for a one-line kfree_rcu change in patch 3.

This series contains the initial rhashtable conversion. I elided
several followup commits that remove dead code, e.g. the region locking
or the resize callback, this will be sent later as a followup.

1) Add rhashtable boilerplate stubs to netfilter ipset. Implement rhashtable
initialization and destruction.

2) Add rhltable boilerplate stubs to Netfilter IPSet. Prepare switching from
rhashtable for sets sharing hash keys.

3) Replace ipset internal hash tables with rhashtables. Introduce
RHL_MAX_CHAINLEN to explicitly bound chain length. Keep automatic
rhashtable shrinking disabled to prevent errors during set dumping.

4) Restore SET_WITH_FORCEADD eviction logic in ipset. Add
mtype_remove_random() helper to identify key slots for eviction.

5) Report CIDR storage memory size to userspace, including dynamic allocation.

Florian Westphal (5):
  netfilter: ipset: add rhashtable boilerplate stubs
  netfilter: ipset: add rhltable boilerplate stubs
  netfilter: ipset: replace internal hash table with rhashtable
  netfilter: ipset: re-add forceadd support
  netfilter: ipset: also report mem size for cidr storage to userspace

 net/netfilter/ipset/ip_set_hash_gen.h      | 1618 ++++++++------------
 net/netfilter/ipset/ip_set_hash_netiface.c |   24 +-
 2 files changed, 672 insertions(+), 970 deletions(-)

-- 
2.54.0


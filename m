Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0CD28DF3A
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Aug 2025 08:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755850551; cv=none; b=bfw4AB/cxIPPV3dHQAfTRHg7NlP8rjfh8bo9Y51PYeClYAsgl3zULTbT9lzUw7ocHb9mUjXfPQszQfdL2hsGKZWNoTeqjiq+TqA8lUD8ctVf5/2B8m45gGYUDGsZmjLhfcwIDDCzajZv4p89B2rHVEw2SnBDJS4wx5h0hobN0QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755850551; c=relaxed/simple;
	bh=I+IKGUvP6G1lwRsft52wtPMZvptnY245ad/78K1eX6A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k44xftzxXAliGihTGPSqANVxef4RTiofDZnmwg9MDOhg0h19926u1/MVTLsL/L/cb6AMs+DL93Fy61gLSslxYUUuHVLnuUSBLF54bUKY6cnA8+n5/N4TbxzNmOuAXS4wF+M0MGvPE/AM2XUxvDRhv7SFpOXnDozTho+y+E8M/eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 668A360298; Fri, 22 Aug 2025 10:15:47 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 0/2] netfilter: nf_tables: avoid atomic allocations for set flush
Date: Fri, 22 Aug 2025 10:15:36 +0200
Message-ID: <20250822081542.27261-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sven Auhagen reports memory allocation errors during set flush.
This is because of GFP_ATOMIC allocations because rhashtable walker
uses rcu and cannot sleep.

Build a linear list in rhashtable walker, drop rcu read lock and
then call the iter callback in a second loop.

This allows use of GFP_KERNEL allocations.

The second loop has no noticeable impact on set flush durations, even
for large (800k entries) sets.

Florian Westphal (2):
  netfilter: nf_tables: allow iter callbacks to sleep
  netfilter: nf_tables: all transaction allocations can now sleep

 include/net/netfilter/nf_tables.h |   2 +
 net/netfilter/nf_tables_api.c     |  47 ++++++--------
 net/netfilter/nft_set_hash.c      | 102 +++++++++++++++++++++++++++++-
 net/netfilter/nft_set_rbtree.c    |  35 +++++++---
 4 files changed, 147 insertions(+), 39 deletions(-)

-- 
2.49.1

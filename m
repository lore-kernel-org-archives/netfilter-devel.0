Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E2F12DD8A
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Nov 2024 15:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731513362; cv=none; b=dEmav5Gi/Vx1veCwpV8BHXrMYcujB1UXpSPoT7/4GtP7vwkR37bHenOucX7Fgw2MsxtHfubC60cdriPiY6GXxM/Z1B+PeTRHjhsYshUoEvbMmDZ1QkC7u37Wjr0Lv2jGhRcRyk6BlLFuqVYfSQz6NrxLrrFkW8Jume9HlgpECnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731513362; c=relaxed/simple;
	bh=sHvTzNQUF7oKh7E6FmfM+dawwxrdEZMmt+BC/UTMonY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dBikryHg81hmnmdLKFCWV8Cyg8VwbEFzGzfMtGefcWRgt92R6AxBiuaMNXa713lNbY0dHpOvw/dTKuDqJVruoIF9pBe8fJIIYFrfbQSP8yK0oGgynKP7aSj6VmQ5vPHUo+aY5HR2ZOsi/RYOMdSYKyRpZcgVZx4BL2Tc0lsivcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tBFil-0007IZ-Tl; Wed, 13 Nov 2024 16:55:55 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v5 0/5] netfilter: nf_tables: reduce set element transaction size
Date: Wed, 13 Nov 2024 16:35:48 +0100
Message-ID: <20241113153557.20302-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v5: rework patch 3 commit message.
    update/add comments in patch 5.
    replace list init by comment in patch 5.

No other changes.

Changes in v4:
fix a typo in patch 3 commit message.

Changes in v3:
I failed to realize that nft_audit leaks one implementation detail
to userspace: the length of the transaction log.
This gets fixed by patch 3 which adds needed helper to increment
the count variable by the number of elements carried by the compacted
set update.

Also fix up notifications, for update case, notifications were
skipped but currently newsetelem notifications are done even if
existing set element is updated.

Most patches are unchanged.
"prefer nft_trans_elem_alloc helper" is already upstreamed so
its dropped from this batch.

v2: only change is in patch 3, and by extension, the last one:
During transaction abort, we need to handle an aggregate container to
contain both new set elements and updates.  The latter must be
skipped, else we remove element that already existed at start of the
transaction.

original cover letter:

When doing a flush on a set or mass adding/removing elements from a
set, each element needs to allocate 96 bytes to hold the transactional
state.

In such cases, virtually all the information in struct nft_trans_elem
is the same.

Change nft_trans_elem to a flex-array, i.e. a single nft_trans_elem
can hold multiple set element pointers.

The number of elements that can be stored in one nft_trans_elem is limited
by the slab allocator, this series limits the compaction to at most 62
elements as it caps the reallocation to 2048 bytes of memory.

Florian Westphal (5):
  netfilter: nf_tables: add nft_trans_commit_list_add_elem helper
  netfilter: nf_tables: prepare for multiple elements in nft_trans_elem
    structure
  netfilter: nf_tables: prepare nft audit for set element compaction
  netfilter: nf_tables: switch trans_elem to real flex array
  netfilter: nf_tables: allocate element update information dynamically

 include/net/netfilter/nf_tables.h |  25 +-
 net/netfilter/nf_tables_api.c     | 385 ++++++++++++++++++++++++------
 2 files changed, 321 insertions(+), 89 deletions(-)

-- 
2.45.2


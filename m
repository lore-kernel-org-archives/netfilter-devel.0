Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9306220C47E
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 14:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729089111; cv=none; b=NAcB6aTF6DUOeofuxAGez1laSY1KKP+qwW/j+Y8VzAXl/nGQDo4N7+uan63QLXa3X56wxdXZMFNdBApxgnzmz42DOGNI8niLyyT5Z+tTHScsXIfA70AWJdFL/tKGykAYqqyJQ+zLjll9yc6FiBwLGHH5c3J7DYIe865DZOjY1ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729089111; c=relaxed/simple;
	bh=l/XD91P4e+rYeoEM37IifqbWmZeFxf9srl+F06Awxho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FwOkfpAPw0ZbbiY0cUQqvDb0w1f7cEXxVItQeN8sdkyqX1VSRZBuOWd7X8quUt2WNlH6+TPyhlkFV0dVppXnzgddI335QJjjJWkEcTUvtIH4X5k0BK3/3t5UK4FQGDiChDrHJhxIr3VA+MwGrp4A9XymcTjLD/5M9oIBcuGz3u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t153s-0002Aa-3Z; Wed, 16 Oct 2024 16:31:40 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v3 0/5] netfilter: nf_tables: reduce set element transaction size
Date: Wed, 16 Oct 2024 15:19:07 +0200
Message-ID: <20241016131917.17193-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3:
I failed to realize that nft_audit leaks one implementation detail
to userspace: the length of the transaction log.

This is bad, but I do not know if we can change things to make
nft_audit NOT do that.  Hence add a new workaround patch that
inflates the length based on the number of set elements in the
container structure.

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
  netfiler: nf_tables: preemitve fix for audit failure
  netfilter: nf_tables: switch trans_elem to real flex array
  netfilter: nf_tables: allocate element update information dynamically

 include/net/netfilter/nf_tables.h |  25 +-
 net/netfilter/nf_tables_api.c     | 368 +++++++++++++++++++++++-------
 2 files changed, 304 insertions(+), 89 deletions(-)

-- 
2.45.2


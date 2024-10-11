Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53396FB0
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2024 01:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608945; cv=none; b=ZIahRlZYXqOmYIEmpH0vkfTOwJnuqIhpfX27gmgcu1OY8q9fNx4YKqSZrO2sAFJD/Ye10gDv5tOuxioP8lrffoWhz4+I4uDlYW3Dc8CffHaecwp709bme1cU0BsJcg25a/M4ut1XQ+eg272fKxAqWz8lwVFCmD/I8RiNHj8hoPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608945; c=relaxed/simple;
	bh=Rpeu7KjF7XSnCtEVHrfjGoyxaJ391SYhfUtmKL3p604=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kRq4Votl8FGig/namY0zR49i4KLt92fxNmdAVcZ1a1GOgaJK03TirqnI/IZMNeV/DBAAZPewF/tQk2hBIeZkdx4Px/8FXxRailhMrxjrp2+YbI50gwMpdAeCjE9HFJh4VLaH8sg/tzoYn9+hJzORfHABULlHeQDLl/tL1hde1EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sz49N-0006wo-UZ; Fri, 11 Oct 2024 03:09:01 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 0/5] netfilter: nf_tables: reduce set element transaction size
Date: Fri, 11 Oct 2024 02:32:58 +0200
Message-ID: <20241011003315.5017-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
  netfilter: nf_tables: prefer nft_trans_elem_alloc helper
  netfilter: nf_tables: add nft_trans_commit_list_add_elem helper
  netfilter: nf_tables: prepare for multiple elements in nft_trans_elem
    structure
  netfilter: nf_tables: switch trans_elem to real flex array
  netfilter: nf_tables: allocate element update information dynamically

 include/net/netfilter/nf_tables.h |  25 ++-
 net/netfilter/nf_tables_api.c     | 354 +++++++++++++++++++++++-------
 2 files changed, 289 insertions(+), 90 deletions(-)

-- 
2.45.2


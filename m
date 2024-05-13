Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766A1150998
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 13:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715605769; cv=none; b=ApVLqEHwTPpysiAXFq/sXiid4N2cyoGudX/AhZEpzB9LMGPpuK7Gmu82vxGNi2gTCIMpdolNevL/FivxWFpmuW6KfvCRX0W9vCcBNxNrU3UMnDYuQBc8dmM/9Z2xjZpQ9OrVpeJ/1Y33qK0v7DPxYdBUe30WkCPITHsQSfZL2lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715605769; c=relaxed/simple;
	bh=QfQknhbj4TTh3ZiuEIhqtT3m06EwRvVBB1K4KFPgzNM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZXY9R7E1h2hQ6ygmpWUdP+o6m8lPRBXlrrqovjgWLUSNg7Q7e7EEBwpYuQD5M7/5p0WZRVGPh9A4Ltu/E/NC8Yl8+M3qk07u1FcjqDOeXoc1yB+u4wH2mcsP0lvrO5Rer6ioUQ2RxKEHPGNDz+r5Qjo2xTwUv7NfUsgadSWPkrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s6VQj-0001Od-Hh; Mon, 13 May 2024 15:09:25 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 00/11] netfilter: nf_tables: reduce transaction log memory usage
Date: Mon, 13 May 2024 15:00:40 +0200
Message-ID: <20240513130057.11014-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The transaction log can grow to huge values.
Insertion of 1.000.000 elements into a set, or flushing a set with
1.000.000 elements will eat 128 byte per element, i.e. 128 MiBi.

This series compacts the structures. After this series, struct
nft_trans_elem can be allocated from kmalloc-96 slab, resulting
in a 25% memory reduction.

To further reduce flush/mass-insert several approaches come
to mind:

1. allow struct nft_trans_elem to hold several elements.
2. add a kernel-internal, dedicated nft_trans_elem_batch that
   is only used for flushing (similar to 1).
3. Remove 'struct net' from nft_trans struct.  This reduces
   size of nft_trans_elem to 64 bytes, which would halve memory
   needs compared to the current state.

I have tried to do 3), its possible but not very elegant.

You can have a look at the general idea at
https://git.kernel.org/pub/scm/linux/kernel/git/fwestphal/nf-next.git/commit/?h=nft_trans_compact_01&id=5269e591563204490b9fad6ae1e33810a9f4c39d

I have started to look at 1) too, but unlike this compaction
series it looks like this will make things even more complex
as we'll need to be careful wrt. appending more set elements to
an already-queued nft_trans_elem (must be same msg_type, same set,
etc).

This series has seen brief testing with kasan+kmemleak and
nftables.git selftests.

Feedback and comments welcome.

Florian Westphal (11):
  netfilter: nf_tables: make struct nft_trans first member of derived subtypes
  netfilter: nf_tables: move bind list_head into relevant subtypes
  netfilter: nf_tables: compact chain+ft transaction objects
  netfilter: nf_tables: reduce trans->ctx.table references
  netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx
  netfilter: nf_tables: pass more specific nft_trans_chain where possible
  netfilter: nf_tables: avoid usage of embedded nft_ctx
  netfilter: nf_tables: store chain pointer in rule transaction
  netfilter: nf_tables: reduce trans->ctx.chain references
  netfilter: nf_tables: pass nft_table to destroy function
  netfilter: nf_tables: do not store nft_ctx in transaction objects

 include/net/netfilter/nf_tables.h | 152 +++++++----
 net/netfilter/nf_tables_api.c     | 402 +++++++++++++++++-------------
 net/netfilter/nf_tables_offload.c |  40 +--
 net/netfilter/nft_immediate.c     |   2 +-
 4 files changed, 363 insertions(+), 233 deletions(-)

-- 
2.43.2


Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A201AB531
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Sep 2024 15:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726067831; cv=none; b=QSnj4ZDiNR8f2pMf4pQmR0rUUgaKnlXQlnH4AZe2neyatcOs0UDOjMXQ0UWHvyrDgkb6cSvGb800ChYBWKLGZ9r8mhAFHRh7gbE9sbcrsTEgqyhk7Co2BvbskTx1R2waZivhFbBH+SIdsljIO32VV16iuYIlLk2Xk1NAMYY7ky8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726067831; c=relaxed/simple;
	bh=ICRDvkk52uDZn1dg+s+IxGTsjc5/IIGA9MumTSo6Pzo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kWHGaTVHX3ZmgTRJjvKPwAcaqQLR3/UNtgH1DkxulpXiroRhFiCBfmzbH/KrmkSThXHAvetOvlBEV/bKKmsDrKrtjAnml4UMFOWOJGh7dODvMBfVCGknXwWcDQVIQyT7/O1acfbY2cdAWENXqqrBinP0l8qua5nO7n3Vd5Lipzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1soP5Z-0004DX-1E; Wed, 11 Sep 2024 17:17:01 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/5] netfilter: nf_tables: reduce set element
Date: Wed, 11 Sep 2024 17:00:17 +0200
Message-ID: <20240911150027.22291-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

 include/net/netfilter/nf_tables.h |  25 +--
 net/netfilter/nf_tables_api.c     | 348 +++++++++++++++++++++++-------
 2 files changed, 283 insertions(+), 90 deletions(-)

-- 
2.44.2


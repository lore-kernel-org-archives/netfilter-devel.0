Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1A812B156
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2024 12:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714046941; cv=none; b=YwbLdZSQPOTb3E0XXUK3tSaopBD7AYPqofji5VghBnt3jYXtL0+Jm0IndBhii+h7CDtHd8QGkcbi/QM9OWuWHYcpeGfcASPmHjkXHyUTuY1tq+ld8UhxWrW9PsAoCZlekVHyJJIfbD+J7DSZaiw2NswPpRklgVn2u15gsRpxyno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714046941; c=relaxed/simple;
	bh=Yrm+gBiqXzECirOGHtZYntlDf2idwaBLUIfF0lR9a/g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZTdi9twtxM9zYdhWrr+EE085ns12t8gHVjay5c/DHzljiRduhzIgLFannDJg0wKcaEs07UlCCXmQdBTaYiMCNXRcZQqNNY9YapLgoNbPAgYGUSSriF8k7tlpTfXSSL9w8f6iHZnv7UGxWCe399NruzzZC+6UoiBBFQwHDVEQnZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzxuL-0007nY-F4; Thu, 25 Apr 2024 14:08:57 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 0/8] nft_set_pipapo: remove cannot-fail allocations on commit and abort
Date: Thu, 25 Apr 2024 14:06:39 +0200
Message-ID: <20240425120651.16326-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v1:
 - rebase on top of nf/net-next tree
 - patch
   "netfilter: nf_tables: pass new nft_iter_type hint to walker" has
   been removed, a similar change has been applied already

I've retained Stefanos RvB tags for commits that have not been changed.
Tested with nftables py/shell tests and nft_concat_range on a debug
kernel.

V1 cover letter:

pipapo keeps one active set data (used from datapath) and one shadow
copy, in priv->clone, used from transactional path to update the set.

On abort and commit, the clone/shadow becomes the active set,
and a new clone is made for the next transaction.

The problem with this is that we cannot fail in ->commit.

This patchset rearranges priv->clone allocation so the cloning occurs on
the first insertion/removal.

set flush needs a bit of extra work, this is done by adding a iter_type
hint to the walker callbacks so that a set flush will be able to perform
the needed clone.

The dirty flag is no longer meaningful after these changes, so last
patch removes it again.

After this patch it is possible to elide calls to nft_setelem_remove
from the abort path IFF the set backend implements an abort() function,
but this change isn't included here.

Florian Westphal (8):
  netfilter: nft_set_pipapo: move prove_locking helper around
  netfilter: nft_set_pipapo: make pipapo_clone helper return NULL
  netfilter: nft_set_pipapo: prepare destroy function for on-demand clone
  netfilter: nft_set_pipapo: prepare walk function for on-demand clone
  netfilter: nft_set_pipapo: merge deactivate helper into caller
  netfilter: nft_set_pipapo: prepare pipapo_get helper for on-demand clone
  netfilter: nft_set_pipapo: move cloning of match info to insert/removal path
  netfilter: nft_set_pipapo: remove dirty flag

 net/netfilter/nft_set_pipapo.c | 261 ++++++++++++++++-----------------
 net/netfilter/nft_set_pipapo.h |   2 -
 2 files changed, 126 insertions(+), 137 deletions(-)

-- 
2.43.2


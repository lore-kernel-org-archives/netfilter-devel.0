Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E3A56471
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 08:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133740; cv=none; b=l9Y5QPfmGOilmeYcTU7h1Eaf+H908Rw8ARAU2heVgE++/LxDf6lANY6WuBw6zkRsEN43wl4SUT2bUzEh7tT/VdLzPXddzB5+qo1CK8mE70CIDQlZs0VHgpAZ3wH6C1+aMKVPvJlfhlMBr6P4oKCa21pdP1iNWEpGN9/s0FiyhHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133740; c=relaxed/simple;
	bh=w9zfRKK6fltoyYrxzE4GKztu5zioXKmHer3QMk5bXGg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K83I4W/jCd56aILEWvcO0v5QjoFv3tJ3g2NpU2lCtJqiFuDtIx4dg4SMHKAmLbXXISA2qnJgViSP+EEyojOXnOI4bDVCZeaoEWMd6yS+lHl5prwYo3N/D4FZqMS5hXbdjxDqeIQdA7yK0egZj8tvz7sRPSCRuGQaZEwjmfyrYMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rrwCG-0005wP-Lb; Wed, 03 Apr 2024 10:42:16 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/9] nft_set_pipapo: remove cannot-fail allocations on commit and abort
Date: Wed,  3 Apr 2024 10:41:00 +0200
Message-ID: <20240403084113.18823-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Florian Westphal (9):
  netfilter: nft_set_pipapo: move prove_locking helper around
  netfilter: nft_set_pipapo: make pipapo_clone helper return NULL
  netfilter: nft_set_pipapo: prepare destroy function for on-demand clone
  netfilter: nft_set_pipapo: prepare walk function for on-demand clone
  netfilter: nf_tables: pass new nft_iter_type hint to walker
  netfilter: nft_set_pipapo: merge deactivate helper into caller
  netfilter: nft_set_pipapo: prepare pipapo_get helper for on-demand clone
  netfilter: nft_set_pipapo: move cloning of match info to
    insert/removal path
  netfilter: nft_set_pipapo: remove dirty flag

 include/net/netfilter/nf_tables.h |  12 ++
 net/netfilter/nf_tables_api.c     |   1 +
 net/netfilter/nft_set_pipapo.c    | 259 +++++++++++++++---------------
 net/netfilter/nft_set_pipapo.h    |   2 -
 4 files changed, 140 insertions(+), 134 deletions(-)

-- 
2.43.2


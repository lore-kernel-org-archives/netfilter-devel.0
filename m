Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36326634E1
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 08:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709801188; cv=none; b=h17m+sVzZxgv67V9FHDdBuxZe6saZt89c1W8tjMBUZrqhEWgmstG2LyPYGZX80Bv/w/ljqImpFsJntf7RuGUCB8diQZk0b9EEyaUSB45jywT1mAu7aebzWy2EfTYATJQEQOiqJx/YD3cVsvB431tHDpNpJxmOl7widJgCAo0WeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709801188; c=relaxed/simple;
	bh=5QUQTOkD5MR8ltxJdinQ9O3QZJH0wNJvIwDCTF08qew=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RgbvWglIbYPX41UQn5gPwo13oQFj9P+9EHP0adiH9AZgizGaGxlWf1FbiRALKEUncuGLJM5QqMV806/L17eblYgAn1lw8vlDRzOo7FTrpmz0f0Sl+ri1QWEFGkl5weir33xwrUJldMv9XP+/5FCdF4DBwD5XkEcbCbe0A2OaDy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1ri9OS-0005Jp-46; Thu, 07 Mar 2024 09:46:24 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/9] netfilter: nf_tables: rewrite gc again
Date: Thu,  7 Mar 2024 09:40:04 +0100
Message-ID: <20240307084018.2219-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

First couple of patches could be applied, as they add more warns/checks
to the control plane.

Actual gc changes are not for merging, this is for archive only; I don't
see a compelling reason at this time to do this.

The implemeneted strategy is to have the async gc (rhashtable) enqueue
the *key* of *gc candidates*, rather than the actual expired elements.

Therefore no races with control plane are possible and the "gc sequence"
can be removed.

If async gc enqueues element e and control plane removes it before
gc has a chance to run, then gc will no longer find it -> no op.

If control plane removes and re-adds -> gc candidate is not expired ->
no op.

Downside is the vast increase in memory (instead of just storing a
pointer, we need to be able to store the max key size, i.e. 64 byte).

I'll mark most of this as RFC in patchwork so we can recover this work
later if there is any issue with the exising gc mechanism that this
approach would avoid.

Florian Westphal (9):
  netfilter: nf_tables: warn if set being destroyed is still active
  netfilter: nf_tables: decrement element counters on set removal/flush
  netfilter: nf_tables: add lockdep assertion for chain use counter
  netfilter: remove nft_trans_gc_catchall_async handling
  netfilter: nf_tables: condense catchall gc
  netfilter: nf_tables: add in-kernel only query that will return
    expired/dead elements
  netfilter: nf_tables: prepare for key-based deletion from workqueue
  netfilter: nf_tables: remove expired elements based on key lookup only
  netfilter: nf_tables: remove gc sequence counter

 include/net/netfilter/nf_tables.h        |  27 +--
 include/uapi/linux/netfilter/nf_tables.h |   5 +
 net/netfilter/nf_tables_api.c            | 280 ++++++++++++++---------
 net/netfilter/nft_set_bitmap.c           |   5 +-
 net/netfilter/nft_set_hash.c             |  39 ++--
 net/netfilter/nft_set_pipapo.c           |   6 +-
 net/netfilter/nft_set_rbtree.c           |   8 +-
 7 files changed, 216 insertions(+), 154 deletions(-)

-- 
2.43.0


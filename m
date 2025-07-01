Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA130223707
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Jul 2025 18:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751395983; cv=none; b=Hpi9Li8RMQZ2o9kR4lMICR4/UprGVDdnJoFEtGzRalaYjStVhs+BGNLjjzVNCdRK8gqHTHDyARXC74gtASHMrUIQ4TKPSfDnTY2/GrmKvu4czpDUuDD7dcpaqLSEdF7WI7PYh311sVoxm/uCma4jr/Bw5grII1J4tAPrriJ6N1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751395983; c=relaxed/simple;
	bh=zkabNZ+mbodDsVmlbdcUq0VBhgo3NfNAJyqGRDo+yeE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZIf2B7gG7xGBVtmjvVMBjxHDuJ+pKM/tFLV0EYn5qT6gichZhWXU04LmnOaiISbn/2qHr7BJKQce3s1amRwNMBJTIU7p6/MAlOB4i8VADgkmvdd6WGdO2gHJnG7Fmp+yoUNjxc0T1S7GOpLfJl+XC2cCClD/F/EwkxJPMUFClMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 43B8E6061F; Tue,  1 Jul 2025 20:52:53 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/5] netfilter: nft_set updates
Date: Tue,  1 Jul 2025 20:52:37 +0200
Message-ID: <20250701185245.31370-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series serves as preperation to make pipapos avx2 functions
available from the control plane.

First patch removes a few unused arguments.
Second and third patch simplify some of the set api functions.

The fourth patch is the main change, it removes the control-plane
only C implementation of the pipapo lookup algorithm.

The last patch allows the scratch maps to be backed by vmalloc.

Florian Westphal (5):
  netfilter: nft_set_pipapo: remove unused arguments
  netfilter: nft_set: remove one argument from lookup and update
    functions
  netfilter: nft_set: remove indirection from update API call
  netfilter: nft_set_pipapo: merge pipapo_get/lookup
  netfilter: nft_set_pipapo: prefer kvmalloc for scratch maps

 include/net/netfilter/nf_tables.h      |  14 +-
 include/net/netfilter/nf_tables_core.h |  50 +++---
 net/netfilter/nft_dynset.c             |  10 +-
 net/netfilter/nft_lookup.c             |  27 ++--
 net/netfilter/nft_objref.c             |   5 +-
 net/netfilter/nft_set_bitmap.c         |  11 +-
 net/netfilter/nft_set_hash.c           |  54 +++----
 net/netfilter/nft_set_pipapo.c         | 205 ++++++++-----------------
 net/netfilter/nft_set_pipapo_avx2.c    |  25 +--
 net/netfilter/nft_set_rbtree.c         |  40 +++--
 10 files changed, 185 insertions(+), 256 deletions(-)

-- 
2.49.0


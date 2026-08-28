Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3280B25B08B
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2026 15:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787930622; cv=none; b=t8f64pHUXjurp2PQW6CRVn9G7ZhjZ50nk7VPCgeXKPRV5S5K04a3igUi9/mpQe/FxfUAxGyajjh0/mFXrdp1MqGNqAd5HMtb1UQ63MnO0DoryGzHxsbwXm3X8iWpDoJ/dQnbpzfqOb9raIr88xB1TfA3POxcN0vB475vqZ5MDMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787930622; c=relaxed/simple;
	bh=Y789hCCMcoShYldcZGk2RZQW3KEzD4UuSBFGDtn4ejw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dmXxWpcF+Pd9sDMD61SzNwlTzCr5K+YT3qNuKQfFBCHWfHIP5ubaks55k3ddiIGCnBqL5lU5xSjLCY0MnaWopcpgw8UUBKFp0lmkGMGWt5UfDdWhh6kMITy4qcHKJRW9xuenQeyxfoFrtwzt0VKVHcUGdeWcKoGm/kQ1euKajE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BF3CC607D4; Fri, 28 Aug 2026 17:23:37 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v3 0/5] netfilter: ipset: rhashtable conversion
Date: Fri, 28 Aug 2026 17:22:51 +0200
Message-ID: <20260828152256.8759-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mostly identical to v2.  See patches for details on what changed.

This series contains the initial rhashtable conversion. I elided
several followup commits that remove dead code, e.g. the region locking
or the resize callback, this will be sent later as a followup.

1) Add rhashtable boilerplate stubs to netfilter ipset. Implement rhashtable
initialization and destruction.

2) Add rhltable boilerplate stubs to Netfilter IPSet. Prepare switching from
rhashtable for sets sharing hash keys.

3) Replace ipset internal hash tables with rhashtables. Introduce
RHL_MAX_CHAINLEN to explicitly bound chain length. Keep automatic
rhashtable shrinking disabled to prevent errors during set dumping.

4) Restore SET_WITH_FORCEADD eviction logic in ipset. Add
mtype_remove_random() helper to identify key slots for eviction.

Florian Westphal (5):
  netfilter: ipset: add rhashtable boilerplate stubs
  netfilter: ipset: add rhltable boilerplate stubs
  netfilter: ipset: replace internal hash table with rhashtable
  netfilter: ipset: re-add forceadd support
  netfilter: ipset: also report mem size for cidr storage to userspace

 net/netfilter/ipset/ip_set_hash_gen.h      | 1629 ++++++++------------
 net/netfilter/ipset/ip_set_hash_netiface.c |   24 +-
 2 files changed, 682 insertions(+), 971 deletions(-)

-- 
2.54.0


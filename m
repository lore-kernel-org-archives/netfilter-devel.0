Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4114C45C6F6
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 16:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787587430; cv=none; b=XFdIzPuo1t/DTibrcdOXSLVPre2EkzXAr8yHEqNXru0056tZY9O7XbjmdMda3SghC1INbIe7KAzDud2yrcpmRHKnqUXJybAmSeJbmrqOLdh5NEx7Gg9Pa2FBMMUEI7SxSTPTlqnu5yz0mHzRJs0GSxqMOB2iwsj54vkfKFF7Mt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787587430; c=relaxed/simple;
	bh=9BTLz8CJM0yiPdMwhtAqtwPU2f4arFeYZ9UUFsRJKZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s6zQUXTEnjb+E4f3VjxA5K/v3zqPcm5atbWT5XYWjGK5gWyt7/g1bsr5lgR1DnqQLhg24+onceyTyiSZQIa8jQSljxQjjAYokOIs0JWsHle1dWgcSMRn8hC9nm2pCiHeXt6A4A4W0G1Uw78eFxTDa/wuf0js8CdmgB8Xh+NdRLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3BAAB6035B; Mon, 24 Aug 2026 18:03:39 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/5] netfilter: ipset: rhashtable conversion
Date: Mon, 24 Aug 2026 18:03:23 +0200
Message-ID: <20260824160328.12099-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

5) Report CIDR storage memory size to userspace, including dynamic allocation.

Florian Westphal (5):
  netfilter: ipset: add rhashtable boilerplate stubs
  netfilter: ipset: add rhltable boilerplate stubs
  netfilter: ipset: replace internal hash table with rhashtable
  netfilter: ipset: re-add forceadd support
  netfilter: ipset: also report mem size for cidr storage to userspace

 net/netfilter/ipset/ip_set_hash_gen.h      | 1618 ++++++++------------
 net/netfilter/ipset/ip_set_hash_netiface.c |   24 +-
 2 files changed, 672 insertions(+), 970 deletions(-)

-- 
2.54.0


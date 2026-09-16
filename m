Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D9A37E5D8
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 12:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789563128; cv=none; b=oScNDuwuM5IdtF0xZkkkw5N4kJbeTVSCwaji3AD7BRaU9lTMry/Smu4paGhQT0YuAXN465r8QCjAjehHVJWHv5O+1Xyp5bjjCEb01DT/ezv/1pqg8JbsFhESsfKwdw40X/DB/G/A9OyWY86pX/UnavYPULsOBsnncCW2Roof+Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789563128; c=relaxed/simple;
	bh=g83P7Q5LCwqX4a3Eiq026zB+yRl2P61avrmsFmrNFKs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F3B5/+O2Ltl/xC0JbUoF7R6V+x4ZDeaUIKYEAZlQunC3VZpZL0LDSqYMC3eg8gatvOSvlwQGUXfy3rydk8dZbnhvun18puAgfSOvTaNByTjKoEhfGyc2AiKtHv10SlReEGv1R74LMXbITA4YViQXoa4aKpFF1KPx+9zIp9PtZWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BC0BA6035B; Wed, 16 Sep 2026 14:52:03 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v5 0/6] ipset: replace internal hash table with rhashtable
Date: Wed, 16 Sep 2026 14:51:45 +0200
Message-ID: <20260916125151.28062-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v5: add Herbert Xu's new rhashtable_flush_and_free() to rhashtable, this
replaces my own version from v4.  I also dropped a few follwup patches
with further changes/cleanups, not strictly required for initial
conversion.

1) Add rhashtable_flush_and_free, From Herbert Xu.
The initial user of this function is added in patch 4.

2) Add rhashtable boilerplate stubs to ipset. Implement its initialization
and destruction logic.

3) Add rhltable boilerplate stubs to netfilter ipset. Prepare for handling
distinct elements sharing the same hash key.

4) Replace ipset internal hash tables with rhashtables.
Retain legacy configuration options.

5) Restore SET_WITH_FORCEADD eviction support to netfilter ipset. Add
mtype_remove_random() helper to facilitate element eviction during
additions.

6) Report dynamic CIDR storage memory size to userspace.

Florian Westphal (5):
  netfilter: ipset: add rhashtable boilerplate stubs
  netfilter: ipset: add rhltable boilerplate stubs
  netfilter: ipset: replace internal hash table with rhashtable
  netfilter: ipset: re-add forceadd support
  netfilter: ipset: also report mem size for cidr storage to userspace

Herbert Xu (1):
  rhashtable: Add rhashtable_flush_and_free helper

 include/linux/rhashtable.h                 |   40 +-
 lib/rhashtable.c                           |  187 ++-
 net/netfilter/ipset/ip_set_hash_gen.h      | 1607 ++++++++------------
 net/netfilter/ipset/ip_set_hash_netiface.c |   24 +-
 4 files changed, 830 insertions(+), 1028 deletions(-)

-- 
2.55.0

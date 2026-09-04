Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ACD37CD29
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 18:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788548018; cv=none; b=PDJRujbXOZaOWTZ7G1c8gi5XFJvcHtTyuzOC8olRBIrMyAw8BEwayGOSCIfyMpIg2YXzK6EJmgoW34vZ4STSxPlqOF37Y0oiTZ1dnuawz+wERJl2dbI1uGohDWixpk8dg8WtbDDRJUHDs54Y1yS3uXOZrPkaZ12dnYjeDwFQd5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788548018; c=relaxed/simple;
	bh=mdSseTuBhnv4tcZFRMuT45Or0RUSaSFM5MqroXvbxsg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nIbdKCO0Hdy1P+xnS2jyaNj6hy+jEv3oU//FZmbBBFPmDL/qzw3wEHahJRcYGFrO7LhzUyjO2p6ES/hQIotyV4V260oONCAjPut7Eqymsk8yL9BkAcMMNyyPYvx/FoAHl3hKHObFsXtrECkzHbXShpwoeVboXzX4rJV+j0wDSVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D270260405; Fri, 04 Sep 2026 20:53:33 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 00/13] ipset: replace internal hash table with rhashtable
Date: Fri,  4 Sep 2026 20:53:08 +0200
Message-ID: <20260904185321.30313-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v4: add rhashtable_flush_and_free() helper to rhashtable, then
use it in patch 4.

Sending the entire thing at once as this is now deferred to -next anyway
due to need for new rhashtable function.

It would be possible to stop after 're-add forceadd' and push
the rest in a different merge request in case this is too much for
one nf-next -> net-next batch.

1) Add rhashtable_flush_and_free helper to rhashtable.

2) Add rhashtable boilerplate stubs to ipset. Implement initialization and
destruction of the rhashtable.

3) Add rhltable boilerplate stubs to netfilter ipset.

4) Replace ipset internal hash tables with rhashtable. Enforce an explicit
chain length limit via RHL_MAX_CHAINLEN. Maintain backward compatibility
for old configuration options.

5) Restore forceadd support in ipset by re-implementing removed eviction
logic. Add a helper to locate random key slots for potential element
replacement.

6) Include dynamic memory allocation for CIDR storage in userspace reports.

7) Remove obsolete data_next stubs in netfilter ipset. Retain only the
necessary stubs for specific backend netmask expansion.

8) Remove last region lock usage in ipset. Move locking responsibility to
kadt, uadt, and flush callbacks. Keep IPSET_TEST bitmap types lockless.

9) Remove multi-flag from netfilter ipset. Eliminate legacy logic used for
skipping identical entries and sizing hash buckets.
From Jozsef Kadlecsik.

10) Remove ipset resize functionality.  Also from Jozsef.

11) Remove trivial kvfree wrapper in netfilter ipset.

12) Replace rcu_read_lock_bh() with plain rcu_read_lock.

13) Improve ipset lockdep coverage by removing always-true arguments to
rcu_dereference_protected(). Add assertions to verify mutex holding in
specific callpaths.

Florian Westphal (11):
  rhashtable: add rhashtable_flush_and_free helper
  netfilter: ipset: add rhashtable boilerplate stubs
  netfilter: ipset: add rhltable boilerplate stubs
  netfilter: ipset: replace internal hash table with rhashtable
  netfilter: ipset: re-add forceadd support
  netfilter: ipset: also report mem size for cidr storage to userspace
  netfilter: ipset: remove obsolete data_next stubs
  netfilter: ipset: remove last region lock usage
  netfilter: ipset: remove trivial kvfree wrapper
  netfilter: ipset: use plain rcu_read_lock
  netfilter: ipset: improve lockdep coverage

Jozsef Kadlecsik (2):
  netfilter: ipset: remove multi-flag
  netfilter: ipset: remove resize completely

 include/linux/netfilter/ipset/ip_set.h       |   22 +-
 include/linux/rhashtable.h                   |   19 +
 lib/rhashtable.c                             |  127 ++
 net/netfilter/ipset/ip_set_bitmap_gen.h      |   10 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c       |   16 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    |   15 +-
 net/netfilter/ipset/ip_set_bitmap_port.c     |   16 +-
 net/netfilter/ipset/ip_set_core.c            |   77 +-
 net/netfilter/ipset/ip_set_hash_gen.h        | 1618 +++++++-----------
 net/netfilter/ipset/ip_set_hash_ip.c         |   11 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c      |   19 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c     |   12 +-
 net/netfilter/ipset/ip_set_hash_ipport.c     |   13 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c   |   13 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |   13 +-
 net/netfilter/ipset/ip_set_hash_mac.c        |    9 +-
 net/netfilter/ipset/ip_set_hash_net.c        |   12 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |   38 +-
 net/netfilter/ipset/ip_set_hash_netnet.c     |   20 +-
 net/netfilter/ipset/ip_set_hash_netport.c    |   13 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c |   21 +-
 net/netfilter/ipset/ip_set_list_set.c        |   27 +-
 22 files changed, 932 insertions(+), 1209 deletions(-)

-- 
2.55.0

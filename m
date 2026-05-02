Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A9A54652
	for <netfilter-devel@vger.kernel.org>; Sat,  2 May 2026 07:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777708609; cv=none; b=VJykvtPdGhiiSub7JTJGfbSWMOa0WX8xrH8095XAwyVR7mnlqzz9ZEU8PBOxBsNy55LqfUljXJObIpQUwWbL6F44Tr4pqjuIcT5uHkuG10i2LVLJnPzfa/a1BInOtpc3gIP6zas0avtijj6rIs14qknFLIMhgYP4Ut8lPKX83pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777708609; c=relaxed/simple;
	bh=NXhrytk3agRuEAb3+AyYspuZoXLUP0F5bkQNXIIAivc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P0Tp/cz//W7JZOJjfmrdVrwDFzNKdKjIP+CEAG9YdwwyT6Dnruqgaji1wJJBl2sDn3894W4ZRhBXAtf3BmJbaRCqOV04WZmav8kIa2TbEvl+It9qkvyYsQJPSL5raUY46XXtOCFA22MSpzDYnp4ZTUut8v4r8uV39mqT7N+CeGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BDBA1605BD; Sat, 02 May 2026 09:56:45 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: tristan@talencesecurity.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/5] netfilter: xtables: fix module unload and teardown races
Date: Sat,  2 May 2026 09:56:34 +0200
Message-ID: <20260502075639.7440-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

1) Fixes a potential NULL dereference in xtables hook unregistration during
network namespace exit. Allocate hook operations within xtables core
*before* registering the table to avoid exposing a table with NULL
operations. Ensure tables stop processing packets before teardown
if hook registration fails.

2) Refactor xtables to use a single `xt_unregister_table_pre_exit` function.
Eliminate code duplication by centralizing table unregistration logic
within the xtables core. ebtables cannot be changed due to incompatibility.

3) Unregister netfilter table templates before module removal. This prevents
a race condition where userspace instantiates a new table after the pernet
unreg removed the current table.

4) Add `xtables_unregister_table_exit` to fully unregister netfilter tables
during module removal. Unlink the table from dying lists, then free hook
operations. Fixes an issue where userspace couldn't re-instantiate tables
after `rmmod`.

5) Refactor ebtables table removal to a two-stage scheme, mirroring recent
x_tables updates. Ensure table operations assignment happens while holding
the ebt mutex.

Florian Westphal (5):
  netfilter: xtables: allocate hook ops while under mutex
  netfilter: x_tables: add and use xt_unregister_table_pre_exit
  netfilter: x_tables: unregister the templates first
  netfilter: x_tables: add and use xtables_unregister_table_exit
  netfilter: ebtables: move to two-stage removal scheme

 include/linux/netfilter/x_tables.h        |   4 +-
 include/linux/netfilter_arp/arp_tables.h  |   1 -
 include/linux/netfilter_ipv4/ip_tables.h  |   1 -
 include/linux/netfilter_ipv6/ip6_tables.h |   1 -
 net/bridge/netfilter/ebtable_broute.c     |   2 +-
 net/bridge/netfilter/ebtable_nat.c        |   2 +-
 net/bridge/netfilter/ebtables.c           |  52 +++++---
 net/ipv4/netfilter/arp_tables.c           |  53 ++------
 net/ipv4/netfilter/arptable_filter.c      |   4 +-
 net/ipv4/netfilter/ip_tables.c            |  59 ++-------
 net/ipv4/netfilter/iptable_filter.c       |   4 +-
 net/ipv4/netfilter/iptable_mangle.c       |   4 +-
 net/ipv4/netfilter/iptable_nat.c          |   1 +
 net/ipv4/netfilter/iptable_raw.c          |   4 +-
 net/ipv4/netfilter/iptable_security.c     |   4 +-
 net/ipv6/netfilter/ip6_tables.c           |  56 ++-------
 net/ipv6/netfilter/ip6table_filter.c      |   4 +-
 net/ipv6/netfilter/ip6table_mangle.c      |   4 +-
 net/ipv6/netfilter/ip6table_nat.c         |   1 +
 net/ipv6/netfilter/ip6table_raw.c         |   4 +-
 net/ipv6/netfilter/ip6table_security.c    |   4 +-
 net/netfilter/x_tables.c                  | 144 +++++++++++++++++++---
 22 files changed, 205 insertions(+), 208 deletions(-)

-- 
2.53.0

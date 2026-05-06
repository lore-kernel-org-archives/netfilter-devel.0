Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5073ECBEA
	for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2026 10:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778062061; cv=none; b=VvuPE+WaQaLORKVkl4tvJk/jsyKb2mHUIN3Yln10iOU//OulL++ITNvxPiYIMl66H0wgwxAZ5hHXvPeGkgKTtBpLrTV+G8Ob6tuF4nu3Q6kC0kJN0v3sEYiQgJ/Dsa+1eIixJcIctfDQVAJf9T9NXgw7EI7f8jDnOK1W85BYifQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778062061; c=relaxed/simple;
	bh=cUVsyQ+CPii9GgDPNBfUJk8Yd+wAcu6Xo9FUYbCsgSM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JZ2ztMjwMnU9efw82GsNuPbjO2QkdFo/ZB8XguK3/JaHGuDwE/6c6G4D6QRdrfdkrs1SWE2911Dn1owjJ5B7KXmZESOjNEhh/fI61nmz0G5dphB4GtGAKVyP627YhmClLgsIv3o2mqwoEkAhNEn3hCbQu0C/gki320eaeOkgsXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 278AF605F3; Wed, 06 May 2026 12:07:34 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: tristan@talencesecurity.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf 0/8] netfilter: xtables: fix module load and teardown races
Date: Wed,  6 May 2026 12:07:12 +0200
Message-ID: <20260506100728.2664-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3:
- sashiko spotted a wrong error unwind in iptable_nat.c in last patch.
- alter Reported-by tag for Tristan Madani as requested
- no other changes.

1) Allow initial x_tables table replacement without emitting an audit log
message. Delay the register message until after hooks are wired up to
avoid unnecessary unregister logs during error unwinding.

2) Fix a NULL dereference by allocating hook ops before adding the table to
the per-netns list. Use `synchronize_rcu()` during error unwinding to
ensure the table stops processing packets before teardown. Defer audit log
register message until all operations succeed.

3) Refactor xtables to use a single `xt_unregister_table_pre_exit` function.
Eliminate code duplication by centralizing table unregistration logic
within the xtables core. ebtables cannot be changed due to incompatibility.

4) Unregister xtables templates before module removal. This prevents
a race condition where userspace instantiates a new table after the pernet
unreg removed the current table.

5) Add `xtables_unregister_table_exit` to fully unregister netfilter tables
during module removal. Unlink the table from dying lists, then free hook
operations.

6) Implement a two-stage removal scheme for ebtables following the x_tables
pattern. Assign table->ops while holding the ebt mutex to prevent exposing
partially-filled structures.

7) Fix ebtables module initialization race. Register the template last in
table initialization functions. Prevent table instantiation before pernet
operations are available.

8) Fix a race condition in x_tables module initialization. Ensure pernet ops
are fully set up before exposing the table to userspace.

Florian Westphal (8):
  netfilter: x_tables: allow initial table replace without emitting
    audit log message
  netfilter: xtables: allocate hook ops while under mutex
  netfilter: x_tables: add and use xt_unregister_table_pre_exit
  netfilter: x_tables: unregister the templates first
  netfilter: x_tables: add and use xtables_unregister_table_exit
  netfilter: ebtables: move to two-stage removal scheme
  netfilter: ebtables: close dangling table module init race
  netfilter: x_tables: close dangling table module init race

 include/linux/netfilter/x_tables.h        |   4 +-
 include/linux/netfilter_arp/arp_tables.h  |   1 -
 include/linux/netfilter_ipv4/ip_tables.h  |   1 -
 include/linux/netfilter_ipv6/ip6_tables.h |   1 -
 net/bridge/netfilter/ebtable_broute.c     |  14 +-
 net/bridge/netfilter/ebtable_filter.c     |  14 +-
 net/bridge/netfilter/ebtable_nat.c        |  12 +-
 net/bridge/netfilter/ebtables.c           |  60 +++++---
 net/ipv4/netfilter/arp_tables.c           |  53 +------
 net/ipv4/netfilter/arptable_filter.c      |  27 ++--
 net/ipv4/netfilter/ip_tables.c            |  59 +-------
 net/ipv4/netfilter/iptable_filter.c       |  27 ++--
 net/ipv4/netfilter/iptable_mangle.c       |  29 ++--
 net/ipv4/netfilter/iptable_nat.c          |   6 +-
 net/ipv4/netfilter/iptable_raw.c          |  26 ++--
 net/ipv4/netfilter/iptable_security.c     |  27 ++--
 net/ipv6/netfilter/ip6_tables.c           |  56 +------
 net/ipv6/netfilter/ip6table_filter.c      |  26 ++--
 net/ipv6/netfilter/ip6table_mangle.c      |  27 ++--
 net/ipv6/netfilter/ip6table_nat.c         |   6 +-
 net/ipv6/netfilter/ip6table_raw.c         |  24 +--
 net/ipv6/netfilter/ip6table_security.c    |  27 ++--
 net/netfilter/x_tables.c                  | 177 ++++++++++++++++++----
 23 files changed, 361 insertions(+), 343 deletions(-)

-- 
2.53.0


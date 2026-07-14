Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED88729D270
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jul 2026 13:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784035603; cv=none; b=FEZZ+VuyW72Avz9tt1tjKi3QvcdM8MfO3f+zggT0asxLQfFmHZzO3gR4JYFsjEAjSkeiG+St1qHkKvNPD8NOROJtUGJUcnXGtyG4wHSWt4gVrI5NUWx+apARmxhUGo5YO9/xtvw4InyG5IVkFfM/pEKBTcO4Nt+oZkLXGHs4xeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784035603; c=relaxed/simple;
	bh=kUBTtWjkrtBgG8YUGq+GrnwYimrCAahrT2FwiVzqS3g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p3P9k88WOSw5dghFgPLanHJKOv9v8jynFEzeC31CahWlBcstiBDmwyknulggFE3edyk5TTLznG0izAH7WCD9IGgCrL0WtHIKl1B7qN4VXvq2A1hBI27Td8gOy8O/9wpX7CAcxW9wi23uYotzbMNxOOCNkJieKpiW+fok8SGbxaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CB62160288; Tue, 14 Jul 2026 15:18:40 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nf-next 00/12] netfilter: ipset: convert to rhashtable
Date: Tue, 14 Jul 2026 15:18:16 +0200
Message-ID: <20260714131828.10685-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is an initial RFC patchset to convert the hash types to rhashtable.
Main conversion is in patch 8.  First patches contain small drive-by
fixes, patches after 8 contain further simplifications/cleanups.
Last patch adds back the FORCEADD support dropped in the conversion
commit (diff was getting too large...).

The next step is to go through the ipset test failures and figure out
which ones hint at actual bugs and which ones are just harmless cosmetic
issues (that could be suppressed by tinkering with diff.sh in ipset tests).

Notable likely valid remaining bugs:
 - iphash: IP: Compare sorted save and restore: [..] FAILED
 - hash:net,iface.t: Check 10.0.1.1 with eth0:
 Failed test: ../src/ipset [..] 10.0.1.1,eth0
 Warning: 10.0.1.1,eth0 is in set test.

I'd like to eventually get rid of more set->lock places, remove all
usage of rcu_dereference_protected(.. , 1), but thats not too urgent
atm.

1) Rework ipset CIDR bookkeeping.  I had to remove this one from the last
nf batch at the last minute because of a buildbot report. See next patch.

2) Fix a few nits in patch 1), to be squash-merged.

3) Add small wrappers for hash and bucket sizes to reduce noise in the
actual conversion patch.

4) add and use tmtype_del_cidr_all helper to simplify the upcoming
rewrite.

5) Use ip_set_init_comment_slow to prevent race conditions in hash ipset
types. Add lockdep annotations.

6) Same as 5, but for remove: adds ip_set_ext_destroy_slow.

7) Add rhashtable boilerplate stubs to ipset. Initialize and destroy the
rhashtable without ever adding elements.

8) Replace ipset's internal hash table with rhashtable.  FORCEADD is
removed here, and added back in last patch.

9) Use plain rcu_read_lock, not _bh variants.

10) Better lockdep annotations in ipset_dereference. Add assertions to
more places.

11) Remove the last region lock usage in ipset. Move lock responsibility to
kadt, uadt, and flush callbacks.

12) Re-add forceadd support for rhashtable in ipset. Implement
mtype_remove_random() to evict elements when the set is full.

Florian Westphal (11):
  netfilter: ipset: rework cidr bookkeeping fixups
  netfilter: ipset: add small wrappers for hash and bucket sizes
  netfilter: ipset: add and use mtype_del_cidr_all helper
  netfilter: ipset: add and use ip_set_init_comment_slow
  netfilter: ipset: add and use ip_set_ext_destroy_slow
  netfilter: ipset: add rhashtable boilerplate stubs
  netfilter: ipset: replace internal hash table with rhashtable
  netfilter: ipset: use plain rcu_read_lock
  netfilter: ipset: use correct lockdep annotation in ipset_dereference
  netfilter: ipset: remove last region lock usage
  netfilter: ipset: re-add forceadd support for rhashtable

Jozsef Kadlecsik (1):
  netfilter: ipset: rework cidr bookkeeping

 include/linux/netfilter/ipset/ip_set.h       |   44 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h      |    6 +
 net/netfilter/ipset/ip_set_bitmap_ip.c       |   11 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    |    9 +-
 net/netfilter/ipset/ip_set_bitmap_port.c     |   11 +-
 net/netfilter/ipset/ip_set_core.c            |   35 +-
 net/netfilter/ipset/ip_set_hash_gen.h        | 1552 ++++++------------
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |    4 +-
 net/netfilter/ipset/ip_set_hash_net.c        |    4 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |    4 +-
 net/netfilter/ipset/ip_set_hash_netnet.c     |   12 +-
 net/netfilter/ipset/ip_set_hash_netport.c    |    4 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c |   12 +-
 net/netfilter/ipset/ip_set_list_set.c        |   13 +
 14 files changed, 629 insertions(+), 1092 deletions(-)

-- 
2.54.0

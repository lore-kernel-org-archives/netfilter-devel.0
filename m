Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E4F31353B
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Nov 2025 16:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762361304; cv=none; b=rfz/w5BqUoR575qgeISKo6Cxsa6hKoC9Hm0dr4OHQlhT0pwrGKqC67BbIrRcRSGZ6kte3OJKMA5+lGEpT3aKBhR+TwoKf/605db3EV2Z61v5zaVRUEkipLMRThmt//OyYenmZ9QfT7T4FxvgV0nM78wQon+8n80Hz9BmA3GmQS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762361304; c=relaxed/simple;
	bh=9roF8bbw0/9WvJoHDZakay1AKQp3GHj4Y6zfyzLlCxo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NNljnzeD5bhvOuFtPI7zZFH5s2/nkKMD18w/iu1LJQBorijDP2qwcPWz5Leed/ImD/uQ+vQr6/ic9umIwBE9ItipbY/rlejDGmk9MthqztL8E1wqY4gyK8ZxM9UGy7v8tQ9vDrCOxYwOMuevjVne6e4gkBxjS5orsmDXr0mr7zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7673B6031F; Wed,  5 Nov 2025 17:48:14 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: pablo@netfilter.org
Subject: [RFC nf-next 00/11] netfilter: conntrack: pernet hash tables
Date: Wed,  5 Nov 2025 17:47:54 +0100
Message-ID: <20251105164805.3992-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set moves nf_conntrack to use separate pernet hash tables.

Only partially tested, not yet for merge.

Not converted here and left for a later date:
- we still use a global array of locks to guard hash tables.
- only one (global) hash secret
- memory accounting is not resolved here, after this patchset,
  single netns can hog system memory as there are no limits (anymore).
  This will need memcg integration for nf_conn structs, but the patchset
  that does it isn't complete yet.
  Alternative would be to keep the constraint added in first patch, i.e.
  let nf_max_conntrack be bound by the init_net setting
  (and then maybe remove the constraint later).
- ovs/tc 100% untested.
- bpf ct helpers untested.

Patches 1 and 2 are not dependant on the rest and could go in
regardless of the rest of the series (after more testing).

Only upside of this patchset that I can see is faster conntrack dumps:
we no longer need to skip foreign netns-owned entries.

Downside is the excess indirections required for the pernet table
accesses.

We also need to be careful on lookup and iteration, we can still
observe foreign netns conntracks due to SLAB_TYPESAFE_BY_RCU reuse.
This is also the reason why nf_conn retains the struct net pointer,
I think thats better than going back to pernet slab caches.

Florian Westphal (10):
  netfilter: conntrack: don't schedule gc worker when table is empty
  tests: netfilter: conntrack_resize: prepare for pernet conntrack table
  netfilter: conntrack: pass pointer to buckets instead of index
  netfilter: conntrack: split hashtable auto-size to helper function
  netfilter: conntrack: move nf_conntrack_hash to struct net
  netfilter: conntrack: init and start independent gc workers when needed
  netfilter: conntrack: make nf_conntrack hash table pernet
  netfilter: conntrack: delay conntrack hashtable allocation until needed
  netfilter: conntrack: allow non-init-net to change table size
  netfilter: nf_nat: make bysource hash table pernet

lvxiafei (1):
  netfilter: netns nf_conntrack: per-netns
    net.netfilter.nf_conntrack_max sysctl

 .../networking/nf_conntrack-sysctl.rst        |   8 +-
 include/net/netfilter/nf_conntrack.h          |  42 +-
 include/net/netfilter/nf_conntrack_core.h     |   1 -
 include/net/netns/conntrack.h                 |   3 +
 net/netfilter/nf_conntrack_bpf.c              |   5 +
 net/netfilter/nf_conntrack_core.c             | 368 +++++++++++-------
 net/netfilter/nf_conntrack_expect.c           |   2 +-
 net/netfilter/nf_conntrack_netlink.c          |  30 +-
 net/netfilter/nf_conntrack_proto.c            |   6 +-
 net/netfilter/nf_conntrack_standalone.c       |  42 +-
 net/netfilter/nf_nat_core.c                   | 100 +++--
 net/openvswitch/conntrack.c                   |   6 +
 net/sched/act_connmark.c                      |   6 +
 net/sched/act_ct.c                            |   7 +
 net/sched/act_ctinfo.c                        |   7 +
 .../net/netfilter/conntrack_resize.sh         |  26 +-
 16 files changed, 434 insertions(+), 225 deletions(-)
-- 
2.51.0

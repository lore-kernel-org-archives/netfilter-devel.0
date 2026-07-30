Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891D3387566
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 18:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785436755; cv=none; b=P9GfrUWge9rky+z+kVTEXSJ/yhBjRpJ1iDqLkC+8WWMJdgNWbh8yh11cRvUf6fOKoPeeZ65+a4UYqUIbq1MY9abiGbuZiRSB1Yq5kOeZLXwXUvk0KCF2gE8ddu9dJIkNi12BFslgO8HpK8XdIepfzSBa1cUfTNU3QXd8vmh4gxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785436755; c=relaxed/simple;
	bh=gQTKdK+p3r1dzsMV+wjQVg7eO3TmtrtkakAzyuKj1aM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jn8IfqxiE3z9bm9adfieE3hc9X3wYm3h1LQy/hxtly7ZKk4jk61ZRQ3erlHX9UbxvigtuUzvhXdaWuv2x03MHGEkRjgdPyBYXzTxb2LBkoIB6hcUk1QAJ5SldsJa96ahzhfcvWs1pDAm5l5CcHbAxYkmZvB2joZ17z0Pp6MOf1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F199360380; Thu, 30 Jul 2026 20:38:58 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/5] netfilter: ipset fixes and rhastable prep work
Date: Thu, 30 Jul 2026 20:38:48 +0200
Message-ID: <20260730183853.21868-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series contains a few fixes and prepation work for the
ipset rhashtable conversion.  The rhashtable conversion patch set is
too large to post in one pile and has one external dependency that is not
yet in nf (queued in crypto tree).

I discussed this with Jozsef and we think that targeting the rhashtable
conversion to nf tree is preferrable to nf-next due to the volume of LLM
reports.

1) Rework ipset CIDR bookkeeping with an RCU-based method to ensure
safety on weakly-ordered architectures. Replace in-place updates with
structure replacement. From Jozsef Kadlecsik.

2) Switch ext_size to atomic64_t in ipset to prevent races during parallel
updates.  Also from Jozsef.

3) Add small wrappers for hash and bucket sizes in netfilter ipset. Prepare
for rhashtable conversion.

4) Add and use mtype_del_cidr_all helper in netfilter ipset. Reduce size of
upcoming rhashtable conversion.

5) Switch ipset destruction to use RCU work. Fix a bug where rhashtable
destruction triggered a sleeping function. Enable future decoupling of set
destruction and GC work.

Florian Westphal (3):
  netfilter: ipset: add small wrappers for hash and bucket sizes
  netfilter: ipset: add and use mtype_del_cidr_all helper
  netfilter: ipset: switch to rcu work

Jozsef Kadlecsik (2):
  netfilter: ipset: rework cidr bookkeeping
  netfilter: ipset: switch ext_size to atomic64_t

 include/linux/netfilter/ipset/ip_set.h       |   6 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h      |   4 +-
 net/netfilter/ipset/ip_set_core.c            |  52 ++--
 net/netfilter/ipset/ip_set_hash_gen.h        | 304 +++++++++++++------
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |   4 +-
 net/netfilter/ipset/ip_set_hash_net.c        |   4 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |   4 +-
 net/netfilter/ipset/ip_set_hash_netnet.c     |  12 +-
 net/netfilter/ipset/ip_set_hash_netport.c    |   4 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c |  12 +-
 net/netfilter/ipset/ip_set_list_set.c        |   4 +-
 11 files changed, 266 insertions(+), 144 deletions(-)

-- 
2.54.0

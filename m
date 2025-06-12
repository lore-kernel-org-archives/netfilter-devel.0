Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743E01442F4
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 11:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749729153; cv=none; b=jMhHLZAG1Dn0CMLT/Ty3JEFsCvbOwPv3udy4LO92mqjblfomGYbvAsJn+As9DsB7G4QNa6D0mWj2y1fXG42rzypK1JQLXZ2kl2jrh0KTvagXlqOmOFyr0aLG1bH+0sFB051xpxKoT0z0dfPkfqMwyYsWZP2Nwgbsz4+8Dlf7oWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749729153; c=relaxed/simple;
	bh=LXhKu7XhFQwPQ3aQOXSa7jT1UJqPaTyaASbp6BgGguM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N5Lfh8n5u1tlaJpA40573RaO5xxLYvehrdqUr+FOpM5NX9JnHtCgM9zixhd8ySD5oZCrRDgdaCWtA5WL25MiQ28ewu05V+jv1cMgXI1z9nP9O4MeWsSBqND0gf4GzxAWUf/cqt+28kNSC48wlNigf4ZDUnG9ImnOnhC+DY9eT1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RDdvgUNk; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RDdvgUNk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JO5myhU+dgwjUlSxXuuhckjP3UJkrw8z4qUyAy5voeY=; b=RDdvgUNkb9SBwXWY9QjUmTxdXb
	40chANwMKrPF3UB2gKnU7fFiASPwvtzu1SVHzQF/SQLY2uzrU0ETAkBpvMr76jYPdg43vadB9hfsZ
	GFQE9lo8rnL6Zdq4O5YPBZiZuV+YjDnXC5wEER8VzH9lFGEiWKIi8H2KNRWR+KQuLcVN0MV4TGVwB
	F1xiIPpY5vgdHjCluOsJkQ7MzjkHv0niLHEDp6VrnKoF81WeP7fzNxPOOu/2RCQHqOiwPICWdehDK
	q1td8aMvrULl27mcrEisCf5uh7c6xQJxjgWlFNcD8uw07Eh9AQrZcekiVUpstErLoNUJM+sgXvTbg
	q+QCO2nQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPgTt-000000006G0-33YC;
	Thu, 12 Jun 2025 13:52:29 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/7] Misc fixes
Date: Thu, 12 Jun 2025 13:52:11 +0200
Message-ID: <20250612115218.4066-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 is the most relevant one as an upcoming kernel fix will trigger
the bug being fixed by it.

Patches 2-5 are related to monitor testsuite, either fixing monitor
output or adjusting the test cases.

Patch 6 adjusts the shell testsuite for use with recent kernels (having
name-based interface hooks).

Patch 7 is an accidental discovery, probably I missed to add a needed
.json.output file when implementing new tests.

Phil Sutter (7):
  netlink: Fix for potential crash parsing a flowtable
  netlink: Do not allocate a bogus flowtable priority expr
  monitor: Correctly print flowtable updates
  json: Dump flowtable hook spec only if present
  tests: monitor: Fix for single flag array avoidance
  tests: shell: Adjust to ifname-based hooks
  tests: py: Properly fix JSON equivalents for netdev/reject.t

 src/json.c                                    | 22 +++--
 src/monitor.c                                 | 14 ++--
 src/netlink.c                                 |  8 +-
 tests/monitor/testcases/flowtable-simple.t    |  2 +-
 tests/monitor/testcases/map-expr.t            |  2 +-
 tests/monitor/testcases/set-concat-interval.t |  2 +-
 tests/monitor/testcases/set-interval.t        |  2 +-
 tests/monitor/testcases/set-maps.t            |  2 +-
 tests/monitor/testcases/set-mixed.t           |  2 +-
 tests/monitor/testcases/set-multiple.t        |  4 +-
 tests/monitor/testcases/set-simple.t          |  2 +-
 tests/py/netdev/reject.t.json                 | 66 ++++++++++-----
 tests/py/netdev/reject.t.json.output          | 81 +++++++++++++++++++
 tests/shell/features/ifname_based_hooks.sh    | 12 +++
 .../chains/netdev_chain_dormant_autoremove    |  3 +
 .../flowtable/0012flowtable_variable_0        |  9 ++-
 tests/shell/testcases/listing/0020flowtable_0 |  8 +-
 tests/shell/testcases/transactions/0050rule_1 | 19 -----
 .../transactions/dumps/0050rule_1.json-nft    | 11 ---
 .../transactions/dumps/0050rule_1.nft         |  0
 20 files changed, 193 insertions(+), 78 deletions(-)
 create mode 100644 tests/py/netdev/reject.t.json.output
 create mode 100755 tests/shell/features/ifname_based_hooks.sh
 delete mode 100755 tests/shell/testcases/transactions/0050rule_1
 delete mode 100644 tests/shell/testcases/transactions/dumps/0050rule_1.json-nft
 delete mode 100644 tests/shell/testcases/transactions/dumps/0050rule_1.nft

-- 
2.49.0


Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B63435507
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2026 10:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802929; cv=none; b=g4Ozk/dJN35egaJdEvcFjzMY16bZFthonHqXBz2YkJ9qGbvifRNCMc70Z8H0xVQGif0ymCHnX88lXd69KtXJ+NU0Jo/b1V7pfCEmexk8LEFEnndb/3zxoib3QYC2Ioox5rWjU1rOtqyW6wDU972NsZI3n/AXjM/67+JapZiHtdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802929; c=relaxed/simple;
	bh=PzDAiqo5vUhrwGIGZMIanB6qUUBNo7/7SkL6l/1DHp8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NRPQOmjLWkI/GraTR66li1JM2USCupv7+kX60rXhF4VmUo0BE/blakxWlvSyzJrn3gSARMSlOf5XIHQhGkOKeJlM/DLCtQxL8P3DK1VGs3ecATz4PvPjjDucTY+AC8c01ii9IwCptN7vU2bPJ4A0G6QYIBe7trHLZNTG9FCyeng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BC3B960E86; Thu, 23 Jul 2026 12:35:14 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: kadlec@netfilter.org
Cc: <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 0/5] ipset test updates
Date: Thu, 23 Jul 2026 12:34:59 +0200
Message-ID: <20260723103504.3175-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are extensions to existing test cases, no tests are
disabled and all tests are expected to pass regardless if
the rhashtable patch set is applied or not.

1) Introduce IPSET_MACHINE_SLOW to prevent ipset test timeouts on slow
machines. Increase the slack value to 30s when this flag is set.

2) Prefer tail -n in hash:net.t tests to avoid Fedora 44 error.

3) Use diff -u instead of cmp in tests to improve error readability.

4) Add a UaF reproducer to hash:net,iface.t. Verify that deleting
non-existing elements fails without triggering an incorrect free.

5) Add a test for CIDR matching with the "multi" flag in match_target.t.

Florian Westphal (5):
  tests: check_extensions: introduce and use IPSET_MACHINE_SLOW
  tests: hash:net.t: prefer tail -n
  tests: prefer diff -u to cmp
  tests: hash:net,iface.t: add reproducer for UaF
  tests: match_target.t check for proper cidr matching

 tests/check_extensions | 23 +++++++++++++++++++----
 tests/hash:net,iface.t |  5 +++++
 tests/hash:net.t       |  2 +-
 tests/iphash.t         |  8 ++++----
 tests/match_target.t   | 14 +++++++++++++-
 tests/restore.t        |  2 +-
 6 files changed, 43 insertions(+), 11 deletions(-)

-- 
2.54.0

Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21D146EB7D
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jul 2024 21:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720128872; cv=none; b=Q3+iqt/qlRf4IzyB58lg4n8T/25Dt2R9dIF6MaCtGMAA8tF3t2Ru4JOBR6hSBdZDOHFa0LdnU5qkuSH8AbF6WrTMqIYno7Vfa43fR1FGGShVTQoxN5clpV3Y/94ZSU/yjbAEyDkQ0BwapMOj2XofZwjtd2/+vbraDhP8OykKsGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720128872; c=relaxed/simple;
	bh=ZuWJOQ1Fy4DF0molgA6xkcAQRr4xS8T+/xAyvD2nBE4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=p9V/hPhNgD9tLptCK9BzA+908aw1gdTr9+7Xl/r5E00OVfXvB36K6QQpvFmDg6btLuzcd0MbHyYF/GJ8lX1b5vr9NTtApv+n1MyWdLGxBsT04C4Fo7AuNhWIgeOgIafBS0Ps2v21v/bbyxJ6I+wWigcC3onfL5uELeBNm7wweZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/4] unbreak element deletion in map with ranges
Date: Thu,  4 Jul 2024 23:34:19 +0200
Message-Id: <20240704213423.254356-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following series fixes element deletion in maps with ranges
(ie. those with interval flag set on):

 # nft delete element ip filter mymap { 0-2400000 }
 BUG: invalid range expression type set element
 nft: src/expression.c:1472: range_expr_value_low: Assertion `0' failed.
 Aborted

Same BUG notice is reported when deleting catchall in maps with ranges,
this is related to the src/interval.c code that deals with element
deletions.

Patch #1 sets on expr->len for catchall elements since this is required
	 by map element deletion, which relies on mergesort.

Patch #2 sets on EXPR_F_KERNEL for catchall elements which is required
	 by map element deletion to identify matching elements already
	 in the kernel.

Patch #3 fixes set element deletion in maps with ranges. Use expr->left
         to fetch the key range but still expr->flags to fetch
	 EXPR_F_REMOVE and the expression itself when moving elements
	 to the purge list.

Patch #4 extends test coverage for this usecase.

Pablo Neira Ayuso (4):
  evaluate: set on expr->len for catchall set elements
  segtree: set on EXPR_F_KERNEL flag for catchall elements in the cache
  intervals: fix element deletions with maps
  tests: shell: cover set element deletion in maps

 src/evaluate.c                                | 12 ++++++-
 src/intervals.c                               | 31 +++++++++-------
 src/segtree.c                                 |  4 ++-
 tests/shell/testcases/maps/delete_element     | 28 +++++++++++++++
 .../testcases/maps/delete_element_catchall    | 35 +++++++++++++++++++
 .../maps/dumps/delete_elem_catchall.nft       | 12 +++++++
 .../testcases/maps/dumps/delete_element.nft   | 12 +++++++
 7 files changed, 119 insertions(+), 15 deletions(-)
 create mode 100755 tests/shell/testcases/maps/delete_element
 create mode 100755 tests/shell/testcases/maps/delete_element_catchall
 create mode 100644 tests/shell/testcases/maps/dumps/delete_elem_catchall.nft
 create mode 100644 tests/shell/testcases/maps/dumps/delete_element.nft

-- 
2.30.2


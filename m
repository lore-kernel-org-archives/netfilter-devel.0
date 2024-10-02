Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9559E1D173A
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 19:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727897943; cv=none; b=dpZ4C0GKjdtcWPJwqjfn3pZglZUwCJ4YLn15d4xTZUIQ02aNI7j8YVr+Uk6GTngL3CkdIYnb9dJQx3nXdlZQWXgImqvFhMHAWyEoveMMy3lD1jAuuyE9f8OYY9pY7X8KUCRECtKbj1nTuoHR86beea8QxGlXvbdRxnpBne00n2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727897943; c=relaxed/simple;
	bh=MMRVxKX0OhpqBHu9mnzXt3bewDZ9vHI8QfFqK74Ebv4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SXbfgP4RM9DlUpMtDDsF6AfOpqeXSVfDBDZxeiVgbcIPM60AOX4Yi2PoyrAGBvdDbUkuXWLhwJVuXSsp7BWE5ZrMrCk+wcsywklcCoqnR9k813DWODBfKgvcKiu6/vMV6hM9m+nVj5ILfM3enA1y7tI94bWmPyVJtO2ilBwi2Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dHjYVHQ4; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dHjYVHQ4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4pYSRdnGzZKGRZffsUYil6kI1t3WUGP8szu1/17kvsA=; b=dHjYVHQ4g/osjJLf74/ImW3Z/n
	oGoPa8ycw9SJeVxQSt+JUeuTL/imYDb9wPHZ66yk7fN6VEX6dFfsQP5uUY8kpojnyHsKGsPweochu
	yzZM1bF1YUy6DfpbsPtbvD/P3aaHM/Yt1+0mPhjBITCv56JIj5EshmZo27nw/UpDi7VnrnOLdLjCY
	SK7PCOrmUB4OObhhowYKnuvxUCOv5lXFueqyqUiwNlgrsoti7KNCxB+7qxu2+z5V/LFcr3CGaFck9
	gw7RrRg/c2/x+89BH25VUkd+fjm1FdHwIQK03E9GpahUEJEgHYmAEld82sgKM0PBpKDzIX9rm8DoJ
	OhM9zeIg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sw5Bc-0000000030v-0Jng;
	Wed, 02 Oct 2024 21:39:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/9] Support wildcard netdev hooks and events
Date: Wed,  2 Oct 2024 21:38:44 +0200
Message-ID: <20241002193853.13818-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is the second (and last?) step of enabling support for
name-based and wildcard interface hooks in user space. It depends on the
previously sent series for libnftnl.

Patches 1-4 are fallout, fixing for deficits in different areas.

Patches 5 and 6 extend parser and serializer to accept and correctly
pass interface wildcards on to the kernel.

Patch 7 adjusts shell test cases to the different behaviour (removed
interfaces no longer disappearing from hook specs), mostly stored dump
adjustments.

Patches 8 and 9 extend nft monitor to print NEWDEV/DELDEV events and
extend the monitor testsuite to cover the code.

Phil Sutter (9):
  json: Support typeof in set and map types
  tests: py: Fix for storing payload into missing file
  monitor: Recognize flowtable add/del events
  tests: monitor: Run in own netns
  mnl: Support simple wildcards in netdev hooks
  parser_bison: Accept ASTERISK_STRING in flowtable_expr_member
  tests: shell: Adjust to ifname-based flowtables
  tests: monitor: Support running external commands
  monitor: Support NFT_MSG_(NEW|DEL)DEV events

 doc/libnftables-json.adoc                     |   7 +-
 include/json.h                                |  20 +++
 include/linux/netfilter/nf_tables.h           |  10 ++
 include/netlink.h                             |   1 +
 include/rule.h                                |   1 +
 src/json.c                                    |  46 ++++++-
 src/mnl.c                                     |  19 ++-
 src/monitor.c                                 | 125 ++++++++++++++++++
 src/parser_bison.y                            |  11 +-
 src/parser_json.c                             |  15 +++
 src/rule.c                                    |  15 +++
 tests/monitor/run-tests.sh                    |  72 +++++++++-
 tests/monitor/testcases/chain-netdev.t        |  66 +++++++++
 tests/monitor/testcases/flowtable-simple.t    |  66 +++++++++
 tests/monitor/testcases/map-expr.t            |   2 +-
 tests/monitor/testcases/set-concat-interval.t |   3 +
 tests/py/nft-test.py                          |   5 +-
 .../chains/dumps/netdev_chain_0.json-nft      |  17 +++
 .../testcases/chains/dumps/netdev_chain_0.nft |   3 +
 .../netdev_chain_dormant_autoremove.json-nft  |   5 +-
 .../dumps/netdev_chain_dormant_autoremove.nft |   2 +-
 .../dumps/0012flowtable_variable_0.json-nft   |  10 +-
 .../dumps/0012flowtable_variable_0.nft        |   4 +-
 .../testcases/json/dumps/netdev.json-nft      |  13 ++
 tests/shell/testcases/json/dumps/netdev.nft   |   3 +
 .../listing/dumps/0020flowtable_0.json-nft    |   6 +-
 .../listing/dumps/0020flowtable_0.nft         |   2 +
 .../maps/dumps/0012map_concat_0.json-nft      |  21 ++-
 .../maps/dumps/0017_map_variable_0.json-nft   |  18 ++-
 .../maps/dumps/named_limits.json-nft          |  55 ++++++--
 .../dumps/typeof_maps_add_delete.json-nft     |   9 +-
 .../maps/dumps/typeof_maps_update_0.json-nft  |   9 +-
 .../maps/dumps/vmap_timeout.json-nft          |  22 ++-
 .../packetpath/dumps/set_lookups.json-nft     |  42 ++++--
 .../sets/dumps/0048set_counters_0.json-nft    |   9 +-
 .../testcases/sets/dumps/inner_0.json-nft     |  34 ++++-
 .../set_element_timeout_updates.json-nft      |   9 +-
 tests/shell/testcases/transactions/0050rule_1 |  19 ---
 .../transactions/dumps/0050rule_1.json-nft    |  11 --
 .../transactions/dumps/0050rule_1.nft         |   0
 40 files changed, 706 insertions(+), 101 deletions(-)
 create mode 100644 tests/monitor/testcases/chain-netdev.t
 create mode 100644 tests/monitor/testcases/flowtable-simple.t
 delete mode 100755 tests/shell/testcases/transactions/0050rule_1
 delete mode 100644 tests/shell/testcases/transactions/dumps/0050rule_1.json-nft
 delete mode 100644 tests/shell/testcases/transactions/dumps/0050rule_1.nft

-- 
2.43.0


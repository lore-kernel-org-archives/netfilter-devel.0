Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF96A471267
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 11:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786621569; cv=none; b=Cg1dZUCs/my/DgTf1lOREaUmwE1lPA7JS77dvJDlK7DZYrOIcHC0If06Y8ej5pzfWrP8ksbfRqbfWEebML2ocZ57FQXDSGLl4bq2glY12+EtlX+yZ43KyJCMPQhtf5zGUbDhFChq3nfjCCOSL4gsYKb50TErtOYGZArj9jIZKqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786621569; c=relaxed/simple;
	bh=ZKSLF6eLSFwPywgbSvpEZIPx1PwdwR/CE+gBW1+SJdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JSs+OIB7QQDh0nOxBl6wBl3w+yRdV7W50Qju5SEfdNd7MrZeJruZutL5/n4QHbG3hll/XXXa8KdV/WJpI7ZtJL3yV5I1RjyNs65GDhxJtdzbKxxmgSL9/Qtpi1JLhncK8N9mtrbaZ9wVFo9Dnu0WMT2nKbV2S2Njtm3XpnEesi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZeysOIUf; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZeysOIUf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OwsARPC5rD4NI2EcIf0XNF7VBEsXKgz/fg/Xqd/p/i4=; b=ZeysOIUfC/u4+21f8Vw92zXMPV
	HgYYQi4TN0y7hlwwwMv7sV4N/pqQTwOc8Z0FS+YbwA4l5Vh1bMI52ts2Md8GaOn4US7R4ubcuc7Dq
	WNAeNfaMI8mhhjSh4GYHydpGcsX5DuG9x0Bk9Hvs+ZULsBEorBsKY7biJiGYdlEtK7VtJqRcoWR8u
	pulnOL2M9b3hQFXwS/YCcjhFH7kAkcSvkJ5o6xQu8lgXYfk3hEjmQFvk1i2TSP0VnnutT5JSQzdrp
	uOYCqckDHXnHFrFhil1QDNJ9aatQzLnlo7f1j3gYZiFgphQvC4s+DdmWL7tuElsNVSd1gOsCHrq+G
	a9hxQaHA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wuTso-000000002H0-0S4d;
	Thu, 13 Aug 2026 13:46:02 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Avinash Duduskar <avinash.duduskar@gmail.com>
Subject: [nft PATCH 0/2] tests: shell: Keep dumps with numeric protocol values
Date: Thu, 13 Aug 2026 13:45:54 +0200
Message-ID: <20260813114556.2685869-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adjust the test wrapper to create dumps with --numeric-protocol option
(patch 1) and update all dumps (patch 2).

One could also set --stateless, py test suite does that, too. Though
there are tests (in packetpath dir) which seem to rely upon counter or
other stateful data to be matched in dump files, so keep state for now.

Phil Sutter (2):
  tests: shell: Use --numeric-protocol for dumps
  tests: shell: Convert dumps to numeric protocols

 tests/shell/helpers/test-wrapper.sh           |  9 ++--
 .../cache/dumps/0003_cache_update_0.json-nft  |  4 +-
 .../cache/dumps/0003_cache_update_0.nft       |  4 +-
 .../chains/dumps/0041chain_binding_0.nft      |  4 +-
 .../maps/dumps/0010concat_map_0.json-nft      |  2 +-
 .../testcases/maps/dumps/0010concat_map_0.nft |  2 +-
 .../testcases/maps/dumps/0013map_0.json-nft   |  2 +-
 .../shell/testcases/maps/dumps/0013map_0.nft  |  2 +-
 .../maps/dumps/anon_objmap_concat.json-nft    |  4 +-
 .../maps/dumps/anon_objmap_concat.nft         |  2 +-
 .../maps/dumps/named_limits.json-nft          | 14 ++---
 .../testcases/maps/dumps/named_limits.nft     | 14 ++---
 .../maps/dumps/nat_addr_port.json-nft         | 16 +++---
 .../testcases/maps/dumps/nat_addr_port.nft    | 16 +++---
 .../maps/dumps/typeof_maps_0.json-nft         |  6 +--
 .../testcases/maps/dumps/typeof_maps_0.nft    |  4 +-
 .../dumps/typeof_maps_add_delete.json-nft     |  2 +-
 .../maps/dumps/typeof_maps_add_delete.nft     |  2 +-
 .../dumps/0012different_defines_0.json-nft    |  4 +-
 .../nft-f/dumps/0012different_defines_0.nft   |  2 +-
 .../dumps/named_set_as_protocol_dep.json-nft  |  4 +-
 .../nft-f/dumps/named_set_as_protocol_dep.nft |  2 +-
 .../testcases/nft-f/dumps/sample-ruleset.nft  |  4 +-
 .../optimizations/dumps/merge_reject.json-nft | 12 ++---
 .../optimizations/dumps/merge_reject.nft      |  4 +-
 .../dumps/merge_stmts_concat.json-nft         |  4 +-
 .../dumps/merge_stmts_concat.nft              |  2 +-
 .../dumps/merge_vmap_raw.json-nft             | 10 ++--
 .../optimizations/dumps/merge_vmap_raw.nft    | 10 ++--
 .../optimizations/dumps/merge_vmaps.json-nft  |  4 +-
 .../optimizations/dumps/merge_vmaps.nft       |  2 +-
 .../dumps/exclusive_start_cond.json-nft       | 52 +++++++++----------
 .../parsing/dumps/exclusive_start_cond.nft    | 42 +++++++--------
 .../parsing/dumps/large_rule_pipe.json-nft    | 24 ++++-----
 .../parsing/dumps/large_rule_pipe.nft         | 12 ++---
 .../0037_set_with_inet_service_0.json-nft     | 10 ++--
 .../dumps/0037_set_with_inet_service_0.nft    | 10 ++--
 .../shell/testcases/sets/dumps/0047nat_0.nft  |  2 +-
 .../sets/dumps/0067nat_concat_interval_0.nft  |  6 +--
 .../sets/dumps/0067nat_interval_0.nft         |  2 +-
 .../testcases/sets/dumps/set_eval_0.json-nft  |  4 +-
 .../shell/testcases/sets/dumps/set_eval_0.nft |  2 +-
 .../sets/dumps/sets_with_ifnames.json-nft     |  4 +-
 .../sets/dumps/sets_with_ifnames.nft          |  4 +-
 .../transactions/dumps/0049huge_0.json-nft    | 16 +++---
 .../transactions/dumps/0049huge_0.nft         |  8 +--
 46 files changed, 186 insertions(+), 185 deletions(-)

-- 
2.54.0


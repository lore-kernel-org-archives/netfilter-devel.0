Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D88332143F
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 14:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756477526; cv=none; b=ltUSEWBH2qWkH6CcvZgMVoEoRoSJWJ/KWKB3fqOBqngSiEVOF0a6B/s3CebHnZQY4V0toIzoMT0tB7tPFXbxTZHnzPQYz1pA6OBcuWzWt9Ea9ioPymoNU3vnlsD6qgiE+/i0A6yeftoqORODMj6IP3kDugalW/uCttYo0S2Qzr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756477526; c=relaxed/simple;
	bh=6zcE1ScvCNqHXnXsuaVDcWmhQS+ZCiJA20Uqo3Rnk38=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZvhWImkzXRybzQxr9GAT/gLu1veWdVD2RxBOxYlSoso6iG3ld6cQ5udpbQhCfuCuAg82zCOEwolhYVIHJ5sjskxIgd/TsmG2FkUy8uDJp+hSzdlhr/Nc+lZeGH11GA4JUiXrcClnHP7EuI1sEfYe39E5nnEa33bHMXmmiZTd04k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fVmvXCH2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fVmvXCH2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=afnVvZZIdXLSLKG9RR2wLDezwSgYtjBah6vX9PNdCNk=; b=fVmvXCH2PbNXt1P4z4vetxvwfM
	ta1pEo5OPyidn+tCP3x10j5TMDg3EHQCXhA0VXDOI+JJKpx7+e/Xa9fPLPMZVeZeGLeJ3hym0LL5G
	E4WPbqN3MVBN/BDRggpJKiCw06d3XR+KO/kjn1skc/F2B7Qmnv9MED6kbh+1s80ihoFlZaeI0UnqK
	RFpt0A+4BzpifKv+6+L6G1E/34AQofUNSNo6bzmLFa1dUDJAyKj5NNveYP5PlWqETl9D6+5tPDF0J
	PBWQJl9IG5hqcI76blczRiOucC7uz4EL1fIwiT78vHG9rrldxcoKmMNcSiTS9ofhqQS2qnGucuG0D
	WXIDbfQQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1us02d-0000000073O-08kv;
	Fri, 29 Aug 2025 16:25:23 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/5] Fixes (and fallout) from running tests/monitor in JSON mode
Date: Fri, 29 Aug 2025 16:25:08 +0200
Message-ID: <20250829142513.4608-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The reported problem of object deletion notifications with bogus data is
resolved in patch four. It seems only object notifications were
affected. Patch 6 extends test suite coverage for tables and chains a
bit.

Patch one is an unrelated trivial fix, patches two and three cover for
oddities noticed while working on the actual problem.

Phil Sutter (5):
  tools: gitignore nftables.service file
  monitor: Quote device names in chain declarations, too
  mnl: Allow for updating devices on existing inet ingress hook chains
  monitor: Inform JSON printer when reporting an object delete event
  tests: monitor: Extend testcases a bit

 include/json.h                             |  5 +--
 src/evaluate.c                             |  6 ++--
 src/json.c                                 | 18 ++++++----
 src/mnl.c                                  |  2 ++
 src/monitor.c                              |  2 +-
 src/rule.c                                 |  2 +-
 tests/monitor/testcases/chain.t            | 41 ++++++++++++++++++++++
 tests/monitor/testcases/flowtable-simple.t | 12 +++++++
 tests/monitor/testcases/object.t           | 10 +++---
 tests/monitor/testcases/table.t            | 15 ++++++++
 tools/.gitignore                           |  1 +
 11 files changed, 97 insertions(+), 17 deletions(-)
 create mode 100644 tests/monitor/testcases/chain.t
 create mode 100644 tests/monitor/testcases/table.t
 create mode 100644 tools/.gitignore

-- 
2.51.0


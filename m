Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834A15CDEE
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2024 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706795465; cv=none; b=qnbqW1/tx0A89pzja31ISqSA+vBbRW55caRheTf4RWJoef308CrYn/mdpryLhnjeSHHDK1lM6T/2g6jfsM8gk0dn+u6wRTO+tpgZltXVGvBin3ko7CNIxYPzGC+dvzE1RBWFN/zhclcXSs/sH7obpGjzEfF8aN7Oa7G9zxFb5Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706795465; c=relaxed/simple;
	bh=Ge02P53X9VGuAOAwSVY7f6jDW//SalCwZ7emcklSL44=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Csjrvq0GSKEETKrN7+kfYqThzoBqy6mwjG0kOZOSmmFMm+pR8yAQz5oF8U63EXdg4xE1oiBEA5i1UeyAYVwp2l/O6XOymrMQt3GuRtsdEGVMSWYzdMEL6AYeUSLik2JYkEJCWyfFi3sGqg5ZFVltvyRv8xsPDNaaxRBkO6ZSNOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dHXNAPGf; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dHXNAPGf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vNji+uLBtBIe5hgRA0eyhTTdSbn/9lQqmYOGTgMCDOU=; b=dHXNAPGfgCvi7PyAc/mDTzsLDg
	6UizQCnwsh+uqjm+GdIcaOc1liCJCoKNBOhZ7AuuoShEsKEJEVEyCcF/ubNftwPFifMO1nT2hJRki
	dgMN+b9okXNnTG8DEIn2032VjEsgpZoroLOcpfj7Cv+xJr0PFHvcVF2Sp1cOvpyqi388XycxM1QNN
	5wu1ggpdWdeTkxVdZBI1WVf8OLTakTDO3xY3MaOb40j7cRDf5uq0uMoUsdfBGWM4Uqz8E/wwq7W5J
	oFq6IJ4nlzIaKVkklmYEp6MNMEdz78RIPbd2ObXcEotBk/PwUAiufZrmKlpBFcFushNxHecWycrtT
	UvQeD0aQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVXT3-000000001MQ-3WGv;
	Thu, 01 Feb 2024 14:51:01 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 0/7] A number of ASAN-identified fixes
Date: Thu,  1 Feb 2024 14:50:50 +0100
Message-ID: <20240201135057.24828-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Many thanks to Pablo for pointing me at ASAN reporting issues with the
code valgrind had missed so far. This series fixes all reports so make
check passes also when compiled with -fsanitize=address.

Patch 1 is not quite related but rather a shortcoming in
iptables-test.py I decided to fix while being at it.

The remaining patches are actual fixes apart from patch 4 which pulls
out unrelated (but sensible) changes from patch 5.

Phil Sutter (7):
  tests: iptables-test: Increase non-fast mode strictness
  nft: ruleparse: Add missing braces around ternary
  libxtables: Fix memleak of matches' udata
  xtables-eb: Eliminate 'opts' define
  xshared: Fix for memleak in option merging with ebtables
  xshared: Introduce xtables_clear_args()
  ebtables: Fix for memleak with change counters command

 extensions/libxt_NFLOG.t     |  2 +-
 extensions/libxt_TCPMSS.t    |  2 +-
 iptables-test.py             |  6 +++++-
 iptables/ip6tables.c         |  5 +----
 iptables/iptables.c          |  5 +----
 iptables/nft-cmd.c           |  1 +
 iptables/nft-ruleparse.c     |  2 +-
 iptables/xshared.c           | 20 +++++++++++++++++---
 iptables/xshared.h           |  2 ++
 iptables/xtables-eb.c        | 29 +++++++++++++++++------------
 iptables/xtables-translate.c | 12 +-----------
 iptables/xtables.c           |  5 +----
 libxtables/xtables.c         | 10 ++++++----
 13 files changed, 55 insertions(+), 46 deletions(-)

-- 
2.43.0


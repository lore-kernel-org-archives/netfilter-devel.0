Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBD8199237
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2024 12:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721132896; cv=none; b=GAFztnL+l1imVaFQIcGsTptll8hJClS4p+HtaMy7vuXI3CcwnGnzIi2oRCwvPV3bUM6dg2Waq3jG3MN4vQ6QhRoYd4lIH5CNwKhNka0rf8tGBRNGgwUFtidx/+O13NpkFn2ctv9OjwjZLqCciKZ5EnTXhz5M66ym98pssUtwONk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721132896; c=relaxed/simple;
	bh=GELWngyHvgvqa9qAXsjV5WKokrjAPpfj8AuOb6VFqLE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZJnCDJURuvydQOBDPL2L6CJ6RPIe86gIYHgkBz7eZiu+9NGNAOUMEqU8GaANaO5yJOYszdB0C0UWaHYObPZGTMWb4x02gmijGOpNPJbiguEuE6qBmTyY5NG8vuZ6ogMUx49qo2hmHFEU2PuZm99ORx+n2kcidZ0VWdDWh+JnPdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XwtgGEcj; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XwtgGEcj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NrubOwHaHzZJdSGgpvjJPDSdXJEn9YTgcX39Cm2TAkc=; b=XwtgGEcjrs3KK8AyiJrXAH544G
	zooZXF+VWA30hwbadsMtUl83BRFkbxk3ZoWBXsblAp6cmJ9Pc/4B6PHDh+30YyoTjg+ixAU31AxRl
	wNsYrx7Z15mKoLYuIYc1FVHn2+abikPLGVtcyWcNSbZ1dz6ZFqsMa3wZznEW/gyoRCr9eth5r3a8/
	xbDXLwJcK0hEFhXIqUr4SVr5dsJlQPljK+G0MVPZqQfzrvNttbioJElnqhCqyEv87Azfb8NLkMuqF
	NSje/LUkLlWTWy8BikH9TKS0Rs1VmG4Aj+Ryzz1dGBwAPGh9yvEAPM6M51+Ek/3aSrMzDDef+TQZS
	qNZ++54w==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sThHt-000000007sz-2yhw;
	Tue, 16 Jul 2024 14:28:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 0/8] Fix xtables-monitor rule printing, partially RFC
Date: Tue, 16 Jul 2024 14:27:57 +0200
Message-ID: <20240716122805.22331-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The patches in this series progress from fixes to features, and for the
last two I'm not sure they are acceptable as-is: Patch 7 is not entirely
complete, one should follow-up printing ebtables policy rules like
builtin chain policies in traces but it requires quite some code churn.
Patch 8 changes output of both events and traces, thus might break
existing scripts parsing xtables-monitor output.

Phil Sutter (8):
  xtables-monitor: Proper re-init for rule's family
  xtables-monitor: Flush stdout after all lines of output
  xtables-monitor: Align builtin chain and table output
  xtables-monitor: Support arptables chain events
  tests: shell: New xtables-monitor test
  xtables-monitor: Fix for ebtables rule events
  xtables-monitor: Ignore ebtables policy rules unless tracing
  xtables-monitor: Print commands instead of -4/-6/-0 flags

 iptables/nft.c                                |   2 +-
 iptables/nft.h                                |   1 +
 .../testcases/nft-only/0012-xtables-monitor_0 | 139 ++++++++++++++++++
 iptables/xtables-monitor.c                    |  74 ++++++----
 4 files changed, 183 insertions(+), 33 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0

-- 
2.43.0


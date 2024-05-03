Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3962158D86
	for <netfilter-devel@vger.kernel.org>; Fri,  3 May 2024 19:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714765849; cv=none; b=eLwVUyNw+7JLHSTRxr6F8oIUuN6yOrpcuzU938ZcZl6KnERTwxyMrUrNTLl+2Wmn/j/VTyDjs3o9EbjpL0Pznx70+R9GXaum+tUtmjxHtoRW/yBJVScfVaWFMmQbJswZvLd2slPcykkV+67rhwBMulYkk8+Y4VIq7Wdou7OK2dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714765849; c=relaxed/simple;
	bh=+qk7h3PaoPkoYrVsV3SxIjKwvWy4DE0q2Pinlfpi6mA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BGwI3MPDrK+joYKyn/7MsHqKlus4dFljdNjrLpgkjtlIjeIqIezaoI43BCe0JWJUpM6giXBrmrM5QBg6Dkga1z+VAzKRVGSXqc17U0AtqYZW9pIRqdT49/hPNNJjRBABgOC6R9itcIL8QICJfNcfYVgClv9j0tvdjAFixGftCOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=NvjzQqg0; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="NvjzQqg0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=AVqG6EHv5CeIpoDXuoinjYwFyhgrA4PWx0T/EojXtzc=; b=NvjzQqg0NEolRcNFf0Z3mAQZwH
	ADCLm1EEUfQYyH6JmEWMjSJg1Jk0fu5fJ9EkB1Ti16XDFN43KdGToPAf3rWXndcfurx901+wHvq3p
	ScmudJD4jWPCvGuOXvdsWiDvwzbKyXebZic31Rj3KiGj2fUTARmhM78tihlSRchjcW7lfUeSksAF/
	2JJ36CmWNxq8jNA4+TrnkAgIn9X2CM6lQnI/xReLmP7pkD2OYNO+JpLLS31nDKsuSitv0e7xaoyXb
	WD8t81x34yBXy++6lkzQIfBnZXQ595u9Etziq6xNajlVYO3m7+5uEkk525Gy8oKItpf1/+CP//PCf
	oiPW61IA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s2yvb-000000007Dc-3HLC;
	Fri, 03 May 2024 21:50:43 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: [nf-next PATCH 0/5] Dynamic hook interface binding
Date: Fri,  3 May 2024 21:50:40 +0200
Message-ID: <20240503195045.6934-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, netdev-family chains and flowtables expect their interfaces
to exist at creation time. In practice, this bites users of virtual
interfaces if these happen to be created after the nftables service
starts up and loads the stored ruleset.

Vice-versa, if an interface disappears at run-time (via module unloading
or 'ip link del'), it also disappears from the ruleset, along with the
chain and its rules which binds to it. This is at least problematic for
setups which store the running ruleset during system shutdown.

This series attempts to solve these problems by effectively making
netdev hooks name-based: If no matching interface is found at hook
creation time, it will be inactive until a matching interface appears.
If a bound interface is renamed, a matching inactive hook is searched
for it.

Ruleset dumps will stabilize in that regard. To still provide
information about which existing interfaces a chain/flowtable currently
binds to, new netlink attributes *_ACT_DEVS are introduced which are
filled from the active hooks only.

This series is also prep work for a simple ildcard interface binding
similar to the wildcard interface matching in meta expression. It should
suffice to turn struct nft_hook::ops into an array of all matching
interfaces, but the respective code does not exist yet.

Phil Sutter (5):
  netfilter: nf_tables: Store user-defined hook ifname
  netfilter: nf_tables: Relax hook interface binding
  netfilter: nf_tables: Report active interfaces to user space
  netfilter: nf_tables: Dynamic hook interface binding
  netfilter: nf_tables: Correctly handle NETDEV_RENAME events

 include/net/netfilter/nf_tables.h        |   4 +-
 include/uapi/linux/netfilter/nf_tables.h |   6 +-
 net/netfilter/nf_tables_api.c            | 185 +++++++++++++++--------
 net/netfilter/nft_chain_filter.c         |  70 +++++----
 4 files changed, 172 insertions(+), 93 deletions(-)

-- 
2.43.0


Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A6718A6DF
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2025 17:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736443907; cv=none; b=V1zJK2FiFU2HEVyUUyEnHPDw+Fc60OrS0H4ffHQooa5a/X6jRfYjPPr1fJmm1JI9bMVA8LpNvK/QmntQYbiZaWEZR+O1wubmu+2tNVB9sENpRNa56cCkwb0wMSPdepMO0UJqxG0nDwEYvQ0FP0eYKF/H8qVQeW37s5/QHhc+wro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736443907; c=relaxed/simple;
	bh=t6CpprbTMH+SRhT5PLqZa2u94zhnbd4cAepqj2DVp4I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nTcWT82WEKS21YgORgQFwCZRWvqzz6mbOHnVuxIVQo/6hC+k0Dzbm+xZSWnMmQQYugb+UrGjE9N/voosheKZ7FncSNiF6NHl6vKVSLk4laMSScSgiYuHFSjrCUuO1p/8IXO3PXTMjk61gpmpG7B37QyuMRZjS2sVoMQs+PN6y6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fU0HDRdm; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fU0HDRdm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tpH2TNxR1NMTFDXN34D9b6/O2vzTB6MIQGv7XC4YT6M=; b=fU0HDRdm2wCdNFDN5VVjSt2wGE
	S40ucDFJT/iNIbwLlf9Aur2eQs0Kr2qMJvoh+sf913aJnDsW/BRBqbAgz73ij9xM9yeCiNhj5X+by
	8ADtBPIayjWC7pCQ9govDQuueXjwx0OfcqQglqlY2+qvFVmRT2o5uUUQVR9750/6mld7HBY4quKDV
	S7py18yzUhvNi8tRFwjIpfOkMqxnT5sk8DmTU5ylQFjibBnzZw/G9iqOuaz7pyBISwrO2h15E8wMD
	/IPhwQYPiWXZc6OyZbs1E2o9dBzlKIFervA7TrF1+g6I14MWS23236fXCJUl/N6kVqWJfwqV30ZfA
	xNd+uDlw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tVwNh-000000006MY-3HD7;
	Thu, 09 Jan 2025 18:31:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v7 0/6] Dynamic hook interface binding part 1
Date: Thu,  9 Jan 2025 18:31:31 +0100
Message-ID: <20250109173137.17954-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v6:
- Rebase onto "netfilter: nf_tables: imbalance in flowtable binding"
  patch which is in nf-25-01-09 tag but missing in nf-next
- Drop patch 7 which removed __nft_unregister_flowtable_net_hooks(): The
  function is no longer a duplicate of nft_netdev_unregister_hooks()

This series makes netdev hooks store the interface name spec they were
created for and establishes this stored name as the key identifier. The
previous one which is the hook's 'ops.dev' pointer is thereby freed to
vanish, so a vanishing netdev no longer has to drag the hook along with
it. (Patches 2-4)

Furthermore, it aligns behaviour of netdev-family chains with that of
flowtables in situations of vanishing interfaces. When previously a
chain losing its last interface was torn down and deleted, it may now
remain in place (albeit with no remaining interfaces). (Patch 5)

Patch 6 is a cleanup following patch 5, patch 1 is an independent
code simplification.

Phil Sutter (6):
  netfilter: nf_tables: Flowtable hook's pf value never varies
  netfilter: nf_tables: Store user-defined hook ifname
  netfilter: nf_tables: Use stored ifname in netdev hook dumps
  netfilter: nf_tables: Compare netdev hooks based on stored name
  netfilter: nf_tables: Tolerate chains with no remaining hooks
  netfilter: nf_tables: Simplify chain netdev notifier

 include/net/netfilter/nf_tables.h |  4 +-
 net/netfilter/nf_tables_api.c     | 74 ++++++++-----------------------
 net/netfilter/nft_chain_filter.c  | 48 ++++++--------------
 3 files changed, 33 insertions(+), 93 deletions(-)

-- 
2.47.1


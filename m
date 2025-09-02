Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6251DDA0E;
	Tue,  2 Sep 2025 18:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756839548; cv=none; b=cX9a22Tc3YhAJ+Odi/G/+ejqv2FS34TxSQn2qthwvtqy4tl3FtCZE4haQLPIy2DFdee6liHDbxSRLW8A6QP83CMuY5pAkfRP9fouGNHZjf9cSK+OnwM+jHaPs1c0y0V5U5+Bju7OAsqVDE9wHLyA6NWFZ5BDW+DUUVFUEuaFppo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756839548; c=relaxed/simple;
	bh=RkSUgidHIVL6ofmxASsQcKzeZCqp5mGAIYowWucQsRc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ksvk4fLrBlUeq47WrXDOiR2/zpb4TwuxZLF8a93MF31gtENjyXQjCKwEvqNnmgw2iwfN9F/Y627cTh465PFLpkenpOE6ZdADxFGpCB+5R7P1HJlUPY4pWh/n4c1/4LBqDJHIMUS1dqdTHaOzV7zlMCsWMrBI5p3utCNZ4qalJjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BBB3360288; Tue,  2 Sep 2025 20:59:04 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 0/2] netfilter: updates for net
Date: Tue,  2 Sep 2025 20:58:53 +0200
Message-ID: <20250902185855.25919-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net*:

1) Fix a silly bug in conntrack selftest, busyloop may get optimized to
   for (;;), reported by Yi Chen.

2) Introduce new NFTA_DEVICE_PREFIX attribute in nftables netlink api,
   re-using old NFTA_DEVICE_NAME led to confusion with different
   kernel/userspace versions.  This refines the wildcard interface
   support added in 6.16 release.  From Phil Sutter.

Please, pull these changes from:
The following changes since commit a6099f263e1f408bcc7913c9df24b0677164fc5d:

  net: ethernet: ti: am65-cpsw-nuss: Fix null pointer dereference for ndev (2025-09-02 14:51:45 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-09-02

for you to fetch changes up to 745d9ca5317a03b55016cdd810e4d2aac57f45df:

  netfilter: nf_tables: Introduce NFTA_DEVICE_PREFIX (2025-09-02 20:52:28 +0200)

----------------------------------------------------------------
netfilter pull request nf-25-09-02

----------------------------------------------------------------
Florian Westphal (1):
      selftests: netfilter: fix udpclash tool hang

Phil Sutter (1):
      netfilter: nf_tables: Introduce NFTA_DEVICE_PREFIX

 include/uapi/linux/netfilter/nf_tables.h           |  2 ++
 net/netfilter/nf_tables_api.c                      | 42 ++++++++++++++++------
 .../selftests/net/netfilter/conntrack_clash.sh     |  2 +-
 .../selftests/net/netfilter/conntrack_resize.sh    |  5 +--
 tools/testing/selftests/net/netfilter/udpclash.c   |  3 +-
 5 files changed, 39 insertions(+), 15 deletions(-)

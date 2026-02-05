Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA62435CBA4;
	Thu,  5 Feb 2026 07:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770277497; cv=none; b=a2HjYUPcueOa7t52Y/LFKKER6fzJqLifIghwOfXYwfjukjoS5aAxqm1Db1s4YsloM9T/nTp2HRWqdpxeyMvy8oLj/9s6xk2kfmgSdzN2l0st2g9jKAljsdtRNwV2S5xVepylOvnFASD+YH2sXFzB+FZUrbCQTCEEfu+kiEe/qhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770277497; c=relaxed/simple;
	bh=/jkTfzwZ+od9lrq9+34U6g6JorKGDzIX2mk1SC6qlIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q3DTHVHYTQeSlB2yEb+wcG/+bRtsLbTWhJ2OBWkL3anI5wjuF6EbBYyasbQuVdfcEEYfq4DQO09z5fpcJJkLpOUJzCOrpG2ykE9L92qN5WVOYjlO/purZPiX4Gb6Ofm+WVdLmAKa0TYamM3Lf/ppShovIKQcxbkiSFq/imnUmDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A8C5E6033F; Thu, 05 Feb 2026 08:44:54 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 0/1] netfilter: update for net
Date: Thu,  5 Feb 2026 08:44:49 +0100
Message-ID: <20260205074450.3187-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is one last-minute crash fix for nf_tables, from Andrew Fasano:

Logical check is inverted, this makes kernel fail to correctly undo
the transaction, leading to a use-after-free.

Please, pull this change from:
The following changes since commit 7d6ba706ae5ef7d3d00b67140d2873ae1da6d41f:

  Merge tag 'wireless-2026-02-04' of https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless (2026-02-04 20:29:53 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-02-05

for you to fetch changes up to f41c5d151078c5348271ffaf8e7410d96f2d82f8:

  netfilter: nf_tables: fix inverted genmask check in nft_map_catchall_activate() (2026-02-05 08:36:59 +0100)

----------------------------------------------------------------
netfilter pull request nf-26-02-05

----------------------------------------------------------------

Andrew Fasano (1):
  netfilter: nf_tables: fix inverted genmask check in
    nft_map_catchall_activate()

 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.52.0

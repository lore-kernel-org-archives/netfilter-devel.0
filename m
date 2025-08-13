Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B416928F4;
	Wed, 13 Aug 2025 11:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755085094; cv=none; b=MSsC1o4be+zlfc0x5bdtxhU9vSYULg4EOnt9+3fUYb68IZ/2eKgqVo0RWQNxWcslTC0isDZ3CgWbfzBdujrHj3YxSyQKRhG61VFqxVkGFC7ZE5+mx9LbM6fpWMmQEeBOH3GbSNVnEqnVpLrDMYVBb9u51HNp1xGeee4TKOCUV4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755085094; c=relaxed/simple;
	bh=HGX5wJeApRFwDAtPQEALo5mbyoq1QvJX/Kkip4cfAfM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G2RQeIbjoH4AH3mCDRaShu+Fu7jV/q/apzEGg0E8F3DPoSSFhoU3z1LhdDA8uVnFRhD2BJu/wvYi8Condr/7zTfTzafjaWqxgbqL0xPO8YyvdMh/XjUjXZTdHwueia76PSXTc6Po1P97iW56/8EpQYBe5MMAZ7hC7CSA1mVhQM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 77767605CE; Wed, 13 Aug 2025 13:38:04 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 0/3] Netfilter fixes for net
Date: Wed, 13 Aug 2025 13:36:35 +0200
Message-ID: <20250813113800.20775-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following patchset contains Netfilter fixes for *net*:

1) I managed to add a null dereference crash in nft_set_pipapo
   in the current development cycle, was not caught by CI
   because the avx2 implementation is fine, but selftest
   splats when run on non-avx2 host.

2) Fix the ipvs estimater kthread affinity, was incorrect
   since 6.14. From Frederic Weisbecker.

3) nf_tables should not allow to add a device to a flowtable
   or netdev chain more than once -- reject this.
   From Pablo Neira Ayuso.  This has been broken for long time,
   blamed commit dates from v5.8.

Please, pull these changes from:
The following changes since commit d7e82594a45c5cb270940ac469846e8026c7db0f:

  selftests: tls: test TCP stealing data from under the TLS socket (2025-08-12 18:59:06 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-08-13

for you to fetch changes up to cf5fb87fcdaaaafec55dcc0dc5a9e15ead343973:

  netfilter: nf_tables: reject duplicate device on updates (2025-08-13 08:34:55 +0200)

----------------------------------------------------------------
netfilter pull request nf-25-08-13

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nft_set_pipapo: fix null deref for empty set

Frederic Weisbecker (1):
      ipvs: Fix estimator kthreads preferred affinity

Pablo Neira Ayuso (1):
      netfilter: nf_tables: reject duplicate device on updates

 include/net/ip_vs.h            | 13 +++++++++++++
 kernel/kthread.c               |  1 +
 net/netfilter/ipvs/ip_vs_est.c |  3 ++-
 net/netfilter/nf_tables_api.c  | 30 ++++++++++++++++++++++++++++++
 net/netfilter/nft_set_pipapo.c |  5 ++---
 5 files changed, 48 insertions(+), 4 deletions(-)
-- 
2.49.1


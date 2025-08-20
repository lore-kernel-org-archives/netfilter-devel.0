Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEF631CA60;
	Wed, 20 Aug 2025 14:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701272; cv=none; b=SD/2av9J4K6YMk9h91gn26BGH1Iw3u4HnL7XtZwKLeis1hn943fv8JEcCTFEl1SsP6QQWj9ZKF9yHcAEUBRDll5DWdmZ8Ub8I5hEQGYW6a/PkqDGpSra6z8f85fyfcrQvyuhWSVZX5GHi9bqhaEZSU7Icg9vvDS/rz7AkX17LqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701272; c=relaxed/simple;
	bh=gkf+q+kqm8lRsliIlx7604F+uYVRM1JOf5WZEMNWTP4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k+nN1/TSnPScWjOcY7LKQQtnq4m/hvSEksZ8ri5uLaX0BcgXz2hEyLZOgwqsa9AE1739JEMV9PXqZ7DLAO31krgJNP6yqq4VQaDJxaeokO1xl8hTftDZR7xysJc/cDsNg4aa2djiovRYnnRjjM40uh6mlBZUUjPRLO3Mzq2Q6Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B9F52602F8; Wed, 20 Aug 2025 16:47:42 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 0/6] netfilter: updates for net-next
Date: Wed, 20 Aug 2025 16:47:32 +0200
Message-ID: <20250820144738.24250-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter enhancements for *net-next*:

First patch gets rid of refcounting for dying list dumping, use a
cookie value instead of keeping the object around.

Remaining patches extend nftables pipapo (concatenated ranges) set type.

Make the AVX2 optimized version available from the control plane as
well, then use it during insert.  This gives a nice speedup for large
sets. All from myself.

On PREEMPT_RT, we can't rely on local_bh_disable to protect the
access to the percpu scratch maps.  Use nested-BH locking for this,
From Sebastian Siewior.

Please, pull these changes from:
The following changes since commit 5c69e0b395c1ffb37fd6fbdbd428353fc0894005:

  Merge branch 'stmmac-stop-silently-dropping-bad-checksum-packets' (2025-08-19 18:33:09 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-08-20

for you to fetch changes up to 456010c8b99e65231160d4c706122ac5502fbcff:

  netfilter: nft_set_pipapo: Use nested-BH locking for nft_pipapo_scratch (2025-08-20 13:52:37 +0200)

----------------------------------------------------------------
netfilter pull request nf-next-25-08-20

----------------------------------------------------------------
Florian Westphal (3):
  netfilter: ctnetlink: remove refcounting in dying list dumping
  netfilter: nft_set_pipapo_avx2: split lookup function in two parts
  netfilter: nft_set_pipapo: use avx2 algorithm for insertions too

Sebastian Andrzej Siewior (3):
  netfilter: nft_set_pipapo_avx2: Drop the comment regarding protection
  netfilter: nft_set_pipapo: Store real pointer, adjust later.
  netfilter: nft_set_pipapo: Use nested-BH locking for nft_pipapo_scratch

 net/netfilter/nf_conntrack_netlink.c |  39 ++------
 net/netfilter/nft_set_pipapo.c       |  90 ++++++++++-------
 net/netfilter/nft_set_pipapo.h       |   8 +-
 net/netfilter/nft_set_pipapo_avx2.c  | 138 ++++++++++++++++-----------
 net/netfilter/nft_set_pipapo_avx2.h  |   4 +
 5 files changed, 155 insertions(+), 124 deletions(-)

-- 
2.49.1


Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF31204F65;
	Tue, 18 Mar 2025 22:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742335416; cv=none; b=ODSR/N9NQaX3Yag5CAhQNPJqpzuEYSat0Ll0utS9XWjS3BTph7SeSnDSF7OprxJ9U1wI5zzmOO4aRU6hXRswY9oS3FbeIjC3cUsKCAxBjrGOXBOUhNuSZnni3AWvnHYhpuowYNHHk9W9qACSHefCPf3+9+8GE2znqy7xThhlbXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742335416; c=relaxed/simple;
	bh=UQFdtqcCot6EET53vFKlOqKPisUhKz5YcubhDUowkJ8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gVlu5+zZfN+HRwvKDX0t9EOrbr7tH8mVc7dZfbX7s+8EigeUx7gJzIu/YshZKRGecVJxR7w6wVvvXKueMmJhhW7Jb1Mhwn35zBSRz6RN8hGXfUxuM3rQP/hyFBC2umyrU+lNN1KKyIFdkuOXyEUN0M3M66dF0GqsU4A+XIoZ4s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pATAe4tk; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SHWHS/hO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pATAe4tk";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SHWHS/hO"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id F3E7460660; Tue, 18 Mar 2025 23:03:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742335410;
	bh=Gd81ZzRNsdAA5kexKumKPB/wvCCKF+bcxU6e1QqOg9o=;
	h=From:To:Cc:Subject:Date:From;
	b=pATAe4tkgGshN9wBL0chWLLXSf1Z3DUHyzKFO//tcArYCwYP0NVcSvBvxSLkmwFur
	 Ag7ghbCMn4drdcSM0qXSNFQNe9pWaya56L/Gs1kf18IV4DIlQiHlXCEvhlUx4ajjrX
	 hRsQ575H1RpB0n4FBvKzsOU7OVJsF7V7JAiM3B+x1JtbUwKiW4X768h8Xmtt/j+O/y
	 ywlGnsnA0yoNB41a2mb4pyVMwpikp13DDXj8UP2JiHHvmvw0LFrVUYQITaIxvVUbr6
	 sibNrfaQN6BoTJMU2ZpAK/PCGQK/c8/qJsW1XuUZA9AyRf0ZONSlgYQ4IKSXE8u/kt
	 ZOSzwhz9zGUEw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 11F1E605E7;
	Tue, 18 Mar 2025 23:03:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742335408;
	bh=Gd81ZzRNsdAA5kexKumKPB/wvCCKF+bcxU6e1QqOg9o=;
	h=From:To:Cc:Subject:Date:From;
	b=SHWHS/hO4+LQkZJPDuRawN+AMsFciXj4M9uNMFpDlX53IiH0x6co7UrvLMTdTqLhN
	 GXr+rPFZcMMjri9H6m1eASu7DfMRgcHMFEVRVBCKKfV21R7aHijyeIyDG48GkAuahp
	 OsbferEK0vch3pngEfJzuMFTgC8WvgOa/mQXF3jE9wOk5yHRTe2sqqi9rJbOdkULZA
	 Qi2z9YwQx7zuQgQXb4jkwLNUME/e2m2gjXqcaXI4z8ZxXmKdxCTt7SrOWxD8wIU4Qo
	 sUidQwfaTvOmie71OB5wxvP4WITcArXuQf6OZJuJLB9a0/HCv4GlIR5JtaGhUMupbV
	 QEXhh2qhOTMkg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.6 0/2] Netfilter fixes for -stable
Date: Tue, 18 Mar 2025 23:03:03 +0100
Message-Id: <20250318220305.224701-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains a backport fix for 6.6-stable.

The following list shows the backported patches, I am using original commit
IDs for reference:

1) 82cfd785c7b3 ("netfilter: nf_tables: bail out if stateful expression provides no .clone")

   This is a stable dependency for the next patch.

2) 56fac3c36c8f ("netfilter: nf_tables: allow clone callbacks to sleep")

Please, apply,
Thanks

without this fix, the default set expression is silently ignored when
used from dynamic sets.

Florian Westphal (1):
  netfilter: nf_tables: allow clone callbacks to sleep

Pablo Neira Ayuso (1):
  netfilter: nf_tables: use timestamp to check for set element timeout

 include/net/netfilter/nf_tables.h | 20 ++++++++++++++++----
 net/netfilter/nf_tables_api.c     | 12 +++++++-----
 net/netfilter/nft_connlimit.c     |  4 ++--
 net/netfilter/nft_counter.c       |  4 ++--
 net/netfilter/nft_dynset.c        |  2 +-
 net/netfilter/nft_last.c          |  4 ++--
 net/netfilter/nft_limit.c         | 14 ++++++++------
 net/netfilter/nft_quota.c         |  4 ++--
 net/netfilter/nft_set_hash.c      |  8 +++++++-
 net/netfilter/nft_set_pipapo.c    | 18 +++++++++++-------
 net/netfilter/nft_set_rbtree.c    | 11 +++++++----
 11 files changed, 65 insertions(+), 36 deletions(-)

-- 
2.30.2


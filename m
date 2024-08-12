Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3C4B16F282;
	Mon, 12 Aug 2024 10:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723458471; cv=none; b=HciTFooobaQ6iV98eSTqUH8OKmzinPGsImS6bYSjUdV1qHxtYLTk6HHK5yaA9q3QEadS2QGD3BBT9H3SJuPngn0gNKjNSJIbSCJkyW7AIv8+my6jOGAJ3OrNSJhbPJGjYLLP1J4o+gtOjYZESMdbrR4DGcfpaGJPL9OdRHHiC+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723458471; c=relaxed/simple;
	bh=Sdf7iHQflvfUQ/DacvNvePhXswCUaw5UeJuHeOJ1Mz8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=LcG5IpES4b1cdNjPBChHvD+XI9MM9JWUlL55q5Lc63nDODcL2JebxaZZiUd6pdQ4yMHhxUuY5PM3MuWBjsVE1CLXPW3QAwSCd0orfJQSgBpx01ozMKnfgqya/eonrfloS1Q1rrvKsY0mDi+KfkdqeojbQskKFUAhzE8XT92KKJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.10.x 0/4] Netfilter fixes for -stable
Date: Mon, 12 Aug 2024 12:27:38 +0200
Message-Id: <20240812102742.388214-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains a backport for recent fixes already upstream for 5.10.x.

The following list shows the backported patches, I am using original commit
IDs for reference:

1) b53c11664250 ("netfilter: nf_tables: set element extended ACK reporting support")

   This improves error reporting when adding more than one single element to set,
   it is not specifically fixing up a crash.

2) 7395dfacfff6 ("netfilter: nf_tables: use timestamp to check for set element timeout")

3) fa23e0d4b756 ("netfilter: nf_tables: allow clone callbacks to sleep")

4) cff3bd012a95 ("netfilter: nf_tables: prefer nft_chain_validate")

Please, apply,
Thanks

Florian Westphal (1):
  netfilter: nf_tables: prefer nft_chain_validate

Pablo Neira Ayuso (3):
  netfilter: nf_tables: set element extended ACK reporting support
  netfilter: nf_tables: use timestamp to check for set element timeout
  netfilter: nf_tables: allow clone callbacks to sleep

 include/net/netfilter/nf_tables.h |  25 ++++-
 net/netfilter/nf_tables_api.c     | 149 ++++++------------------------
 net/netfilter/nft_connlimit.c     |   2 +-
 net/netfilter/nft_counter.c       |   4 +-
 net/netfilter/nft_dynset.c        |   2 +-
 net/netfilter/nft_set_hash.c      |   8 +-
 net/netfilter/nft_set_pipapo.c    |  18 ++--
 net/netfilter/nft_set_rbtree.c    |   6 +-
 8 files changed, 74 insertions(+), 140 deletions(-)

-- 
2.30.2


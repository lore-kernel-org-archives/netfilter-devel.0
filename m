Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85781A3BD7
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 09:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747820414; cv=none; b=F9I09EMI6tLXCS0jKO+J4SrDho1tBqrpMdlb/MlNdLWCvhb16PB92/jU1HLc+6/oLFn1cBwhqjQ9yHdSZe4eb4PkxFA7Ly+UCbppRuo0d0SamLxi4rxo2ThBrKIHxqhem3LnJ8KqnMQDKzlsMaCRAYINGWcD+uJ4s6fKttHtTkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747820414; c=relaxed/simple;
	bh=sU/GaVUCXDKduEhh+YRVNGq9d6vu0GCWILpNYktIQUA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JJrg4bH2ul4+gN9kTVkwCDzj1xm0i0bRvbwsS9Iy8I5EcTs7Ul9svylq4lJS8e0SbrgfXJ2JNIi6d3hyeNaqD+r/CdD/lV9OuaRQugkRUItRGtWvZjKlKmR0vCXHSL4HuFjJDX9QVIEPbSuz97W7CDaxckF1ttX3tRFfVj4rcdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C55C860140; Wed, 21 May 2025 11:40:03 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 0/5] netfilter: resolve fib+vrf issues
Date: Wed, 21 May 2025 11:38:44 +0200
Message-ID: <20250521093858.1831-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Resent after rebase on latest net-next tree, there are no changes.

V1 cover letter:
This series resolves various issues with the FIB expression
when used with VRFs.

First patch adds 'fib type' tests.
Second patch moves a VRF+fib test to nft_fib.sh where it belongs.

The 3rd patch fixes an inconistency where, in a VRF setup,
ipv4 and ipv6 fib provide different results for the same address
type (locally configured); this changes nft_fib_ipv6 to behave like ipv4.

4th patch fixes l3mdev handling in FIB, especially 'fib type' insist
a locally configured addess in the VRF is not local (result is
'unicast') unless the 'iif' keyword is given because of conditional
initialisation of the .l3mdev member.

Last patch adds more type and oif fib tests for VRFs, both when incoming
interface is part of a VRF and when its not.

I'm targetting nf-next because we're too late in this cycle.

Florian Westphal (5):
  selftests: netfilter: nft_fib.sh: add 'type' mode tests
  selftests: netfilter: move fib vrf test to nft_fib.sh
  netfilter: nf_tables: nft_fib_ipv6: fix VRF ipv4/ipv6 result
    discrepancy
  netfilter: nf_tables: nft_fib: consistent l3mdev handling
  selftests: netfilter: nft_fib.sh: add type and oif tests with and
    without VRFs

 include/net/netfilter/nft_fib.h               |  16 +
 net/ipv4/netfilter/nft_fib_ipv4.c             |  11 +-
 net/ipv6/netfilter/nft_fib_ipv6.c             |  17 +-
 .../selftests/net/netfilter/conntrack_vrf.sh  |  34 -
 .../selftests/net/netfilter/nft_fib.sh        | 612 +++++++++++++++++-
 5 files changed, 637 insertions(+), 53 deletions(-)

-- 
2.49.0


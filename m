Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5801EA7F9
	for <netfilter-devel@vger.kernel.org>; Thu, 15 May 2025 18:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747332495; cv=none; b=tf9WgZonyG1LP/4jfPXm/wxMJXKW9HBgw886DGF5kQX16gPe4+4hNKkjAnqK656zBupzr9cTcjZ+f6HX4R3A00tRLhnC+MOlnbXj6LhLb+nWH8UADhwZmYYftMZtOKYvC9Qzv61KSNL6T4es6KYCt9tlktB+hlujyMR/cAO+Ep8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747332495; c=relaxed/simple;
	bh=4OvS13qQkfb+VABw4e5fqxD5I4H1ivpgOmt5Gl1AU4A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jWhDoo2jvpegG7X05tW2dSKXjBVaITMzVf6pzNQlQukrcbFm9Qz9oANibHoiDRjwtsz/AetzFySwNgNI0nVcyU9VGnzNVInDSGKEQp+KyhzTub+4pkt+55BtgtUoqDyEO6mDshd+9iHR1qBwP+Q5l0Btp/hD3WeBAL02Q1g1b0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E93A460033; Thu, 15 May 2025 20:08:09 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/5] netfilter: resolve fib+vrf issues
Date: Thu, 15 May 2025 20:06:47 +0200
Message-ID: <20250515180657.4037-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 .../selftests/net/netfilter/conntrack_vrf.sh  |  33 -
 .../selftests/net/netfilter/nft_fib.sh        | 612 +++++++++++++++++-
 5 files changed, 637 insertions(+), 52 deletions(-)

-- 
2.49.0


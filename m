Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF02130A54;
	Thu, 10 Apr 2025 10:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744281416; cv=none; b=p5/AFjak5bZxGjKeu/I3E051BQc2HHiAIvSmjSwNR3DWQBbSpBPKsfkVflBD59860I0joeAczLkkT7nyWngj28BJDRDg0roeAotrxp4epR4HqNc627qsiwAHkKEv/ssizUGWM5LhiMoBO5bvzdVCOPwT1ifA4Povtz4PDTX/YJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744281416; c=relaxed/simple;
	bh=rPu1oUOKk4G43gleZgOfQPKJfpvjVm+yvKINedzYDdQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Gt6CAfcMkWBgoMun6zvrPac+h3JaWzC9x5B3Cz7gvqrBtw52jzXd7oRb5FS6rOG0HWfkBoEX7zVl9QDCVn/uKxU2R/bzddYMF1RWyE9jKHqT63B8nie4zjCCdTeL3Txh4xU5Wp+lN8oxxa11TYZYdd9mCGQg3tSZIa0lkxWFW24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RR0Addu9; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EfwkkLle; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RR0Addu9";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EfwkkLle"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 77071606BB; Thu, 10 Apr 2025 12:36:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744281412;
	bh=90y0T0FCbWtNzd5zZzAkqo2vdkAaXdl01/AOpVqGozI=;
	h=From:To:Cc:Subject:Date:From;
	b=RR0Addu9TmyWooMFJSbL/AIyfNuWJ96k89D2qh44xBcg0Tzp3XHljfOwhPFmPro1Z
	 3ga2ZQq47Z9JLoAIEoWpxL8LuNjJMMG1YUmGxzpzYrXWKclvXu/aO6lteyTTj/0NoL
	 8wK7ILMEhMGCrkTuoiIAN6SPQOyqpsZ2fYConv1wMyG4z5E+Zw26jhY5C52foj38LU
	 KcSRQwKMbFEGCi4JrHVdV9Gfe84FUnoT5aRRPuf6S+F++9+TgymKZg5PVfFW5l/8XM
	 MnSYwwcLktAhRpX6eJ4UFvGYUkdYWmehAfw7arR96MaaEWcdDwuV9uvFkjYqlvlge1
	 ZiZkVkEWKIg1A==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9D8986065E;
	Thu, 10 Apr 2025 12:36:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744281410;
	bh=90y0T0FCbWtNzd5zZzAkqo2vdkAaXdl01/AOpVqGozI=;
	h=From:To:Cc:Subject:Date:From;
	b=EfwkkLlemNq7H6SjfD6W3UW0HkI4AOByJUCE7/qQbEoR/6RwSNWZRbhJdIHbl2Yzc
	 lwMx0eLo1y6ugcMke9YFPw/4LiWJLsMgcJ3TCRY7Bfa3qJfmYhwhrC6ocr/iwTUoz1
	 uwv68CNv+saWccIa2HayVDAwCFHnF5qaHkmb43//axM24r+B7+SRTMtbN83MPTJ9Nh
	 y3stTrHVwns17B9k5RmZ8gUwciQ344WpQO/20V5PS7YLAUTkavP8Icp5xW7+vUwWIc
	 O4JQ4LJJvhNCYMi9C0lhq8pBqE1iNsdJXsWNuGRKFlcO7jtqnFi+/KAcTElIAR0QjI
	 00TTbycMjSDoQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 0/2] Netfilter fixes for net
Date: Thu, 10 Apr 2025 12:36:45 +0200
Message-Id: <20250410103647.1030244-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains a Netfilter fix and improved test coverage:

1) Fix AVX2 matching in nft_pipapo, from Florian Westphal.

2) Extend existing test to improve coverage for the aforementioned bug,
   also from Florian.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-04-10

Thanks.

----------------------------------------------------------------

The following changes since commit aabc6596ffb377c4c9c8f335124b92ea282c9821:

  net: ppp: Add bound checking for skb data on ppp_sync_txmung (2025-04-10 11:24:17 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-04-10

for you to fetch changes up to 27eb86e22f1067a39f05e8878fd83f00e3311dc3:

  selftests: netfilter: add test case for recent mismatch bug (2025-04-10 12:33:55 +0200)

----------------------------------------------------------------
netfilter pull request 25-04-10

----------------------------------------------------------------
Florian Westphal (2):
      nft_set_pipapo: fix incorrect avx2 match of 5th field octet
      selftests: netfilter: add test case for recent mismatch bug

 net/netfilter/nft_set_pipapo_avx2.c                |  3 +-
 .../selftests/net/netfilter/nft_concat_range.sh    | 39 +++++++++++++++++++++-
 2 files changed, 40 insertions(+), 2 deletions(-)

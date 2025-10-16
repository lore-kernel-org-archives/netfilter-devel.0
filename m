Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F96213E6A
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 15:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760626805; cv=none; b=u3XLkieW5K9Z1zr2jZGKz3zuSMp9LGl+AyZh1Tc7skwcSvno7b7lCipa8GWP9JATZKRw+4lSKa33M5pePsuuJSkboanqrEnYrNbKKNhYAF1uXiwIjjxQ+VUpVQrL0bRYDozgoodvF2ID3G5cXm1PBrxOAFS+nV1onoaXlglATno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760626805; c=relaxed/simple;
	bh=uOlYxoX00C7PWWUDtPWZ93vJDn/MuVw2rUbV/VPw5qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qS4ueeBXNu1YRMal3byRWCiApKcE81IPrhD86Yi/F+Uqj3I3YG6bFVuyNtUIW511nghFpQIlTdiH//UQFX8Ao+biu+3cmj4M5zUfbCaNOIHV0hI87YCj4j5BtqHFL8u8KVPYXt99e+wzS0v6949+ZEW4X59mDtbslE4xi2rK+k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 87CBB60958; Thu, 16 Oct 2025 17:00:01 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/4] nft tunnel mode parser/eval fixes
Date: Thu, 16 Oct 2025 16:59:32 +0200
Message-ID: <20251016145955.7785-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series addresses a few bugs found with afl fuzzer, see individual
patches for details.

Florian Westphal (4):
  evaluate: tunnel: don't assume src is set
  src: tunnel src/dst must be a symbolic expression
  src: parser_bison: prevent multiple ip daddr/saddr definitions
  evaluate: reject tunnel section if another one is already present

 src/evaluate.c                                | 29 +++++++--
 src/parser_bison.y                            | 63 ++++++++++++++++---
 .../nft-f/empty_geneve_definition_crash       |  4 ++
 .../bogons/nft-f/tunnel_in_tunnel_crash       | 10 +++
 .../bogons/nft-f/tunnel_with_anon_set_assert  |  9 +++
 .../bogons/nft-f/tunnel_with_garbage_dst      |  5 ++
 6 files changed, 104 insertions(+), 16 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/empty_geneve_definition_crash
 create mode 100644 tests/shell/testcases/bogons/nft-f/tunnel_in_tunnel_crash
 create mode 100644 tests/shell/testcases/bogons/nft-f/tunnel_with_anon_set_assert
 create mode 100644 tests/shell/testcases/bogons/nft-f/tunnel_with_garbage_dst

-- 
2.51.0


Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8877F2E62B3
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Apr 2025 06:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743747733; cv=none; b=Kl6xdP4UqLLPut1ZS5+iV3OtRdvo8PTnJjjQ98SfIqE2peUDViW93z+3TOMMVnYykEj0hIS+ECJDo3d3p2IGzdiiygv81wcCNgNWAXLYtpMLBwtyb7cV5+jSSRKt3qTAB8PzCtKscgIHmTKYbLrKiuk/Dn9dCWyKgluLBFqv76k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743747733; c=relaxed/simple;
	bh=5Ni+CcQe/rENomXqNgAU8+INyhws/ARSLTop+iRUsZM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VT26GKvHitaJTL17in8Xo5OjDL1nNV79WMO0QM2ptywlHpGd8bAKok21JgVziZdIYhHqEIDZaGF0gSMg4t/yGKBpVrKH+S3BvLWPk2MzqN0wPAJzE9P0yA57eBc21EbKWZ0dNCtuRGDqk50IYWPFXAdxcH+DQbRPaKgaGpqzX9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u0aRL-0005uO-O4; Fri, 04 Apr 2025 08:22:07 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sontu21@gmail.com,
	sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/3] nft_set_pipapo: fix incorrect avx2 match of 5th field octet
Date: Fri,  4 Apr 2025 08:20:51 +0200
Message-ID: <20250404062105.4285-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sontu Mazumdar reports incorrect matching in the pipapo set type.

First patch adds debug infrastructure (conditional for CONFIG_DEBUG_NET)
to add rudimentary avx register tracking.

Second patch is the actual fix.

Third patch adds a test case.

I checked that selftest passes with all three patches applied,
that the new selftest fails without the fix and that the
register tracking added in patch 1 also produces a WARN splat.

Florian Westphal (3):
  nft_set_pipapo: add avx register usage tracking for NET_DEBUG builds
  nft_set_pipapo: fix incorrect avx2 match of 5th field octet
  selftests: netfilter: add test case for recent mismatch bug

 net/netfilter/nft_set_pipapo_avx2.c           | 139 +++++++++++++++++-
 .../net/netfilter/nft_concat_range.sh         |  39 ++++-
 2 files changed, 171 insertions(+), 7 deletions(-)

-- 
2.49.0


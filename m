Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731AD38F9C
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Apr 2025 17:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744047691; cv=none; b=IPcR+d6XuQe1dTlZ/4QJhZK1U/PUV+o7kyXPkJ+WTXC6eyMmb77Ii4II9GuwY9iJAurSR1HxDOBmHi2CT+GWgd/UCf4Jor9fwWKV9YM6SuqeKh9tYzkHe9lFgXUXq/GoJ8tvCywUhGWxKrKKKk8xMv3M7kMepVoFVfcafy8tEDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744047691; c=relaxed/simple;
	bh=106/+RzDG9qoZfYa6ZzJ4i21QBh93lu64SiK+6DilIY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jxSucQv+hFYrR0cxUgZSgj9EZOX4b2WhgBSNjb1nIkhPXjLlKK1NLEWdZ9XUFs1kD/U2C/0Fl722WKLYnzQ6lPQY675iNbmbnoimfrD3qcTOY3QLSsz92qDYoBy/QLYXMkzcX+OMfQkV3xmc0ZANUt35Esq/W0RlHu50M9FAHhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u1qTO-0008Hp-4V; Mon, 07 Apr 2025 19:41:26 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf 0/3] nft_set_pipapo: fix incorrect avx2 match of 5th field octet
Date: Mon,  7 Apr 2025 19:40:17 +0200
Message-ID: <20250407174048.21272-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sontu Mazumdar reports incorrect matching in the pipapo set type.

1st patch fixes the reported issue.
2nd patch adds a test case.
3rd patch adds debug infrastructure (conditional for CONFIG_DEBUG_NET)
to add avx register tracking.

I checked that selftest passes with all three patches applied, that the
new selftest fails without the fix and that the register tracking added
in patch 1 also produces a WARN splat.

Changes since v2:
- reverse order, fix first, debug infra last
- fix and test are unchanged
- debug patch adds new 'last pass' to check that
  all registers were processed.

Florian Westphal (3):
  nft_set_pipapo: fix incorrect avx2 match of 5th field octet
  selftests: netfilter: add test case for recent mismatch bug
  nft_set_pipapo: add avx register usage tracking for NET_DEBUG builds

 net/netfilter/nft_set_pipapo_avx2.c           | 303 ++++++++++++++++--
 .../net/netfilter/nft_concat_range.sh         |  39 ++-
 2 files changed, 309 insertions(+), 33 deletions(-)
-- 
2.49.0

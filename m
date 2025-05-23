Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D765023535B
	for <netfilter-devel@vger.kernel.org>; Fri, 23 May 2025 12:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748002886; cv=none; b=D05fKayRUawCy+gt0kXCO5GtUK22z937pTQHZZRSzTS9d8oYftFHUGSqQ+MJpYQaeLwrZuLlEIK7DXKQshh+fWjJoAySpWOAnMq+5t09hsyeMWonfWt+CYYdDObHIH7ufbbR+/uV7KKNnyNZxL1Y1R0mZl4lsawro+v8hqesrdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748002886; c=relaxed/simple;
	bh=j9nEuL18CYsXkPIH+rKrpr1HS0KS0JqKuGkJjKyTRqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P5EopuoOnyiNFryqqtOfF+Vc+MMB9wSzbDyH7Vd/uA2dVTI8HQZ/jvEwysR+k7T2NskaT+e9wYLfjyny8vp4odELRUR+rGcE4wqZQII3PUbiJ8/bT4On9nGKZga/kKcQvRhfsU7EZhpND92zACqHW6V4gK0NUFNkhtmbjgMH8nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1420260357; Fri, 23 May 2025 14:21:23 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: nf_set_pipapo_avx2: fix initial map fill
Date: Fri, 23 May 2025 14:20:43 +0200
Message-ID: <20250523122051.20315-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The avx2 implementation suffers from the same bug fixed in the C
implementation with 791a615b7ad2
("netfilter: nf_set_pipapo: fix initial map fill").

If the first field isn't the largest one, there will be mismatches, i.e.
a wrong match will be returned.

First patch fixes this bug.

Because the selftest data path test does:
   .... @test counter name ...

.. and then checks if the counter has been incremented, the selftest
first needs to be reworked to use per-element counters.

Otherwise, we can only differentiate between 'no entry matches' and
'some entry matches', but its imperative we can also validate that
the lookup did return the correct element.

The second patch does reworks the selftest accordingly.

Last patch adds extends the existing regression test for this
bug class by also validating the datapath, rather than just the
control plane.

Florian Westphal (3):
  netfilter: nf_set_pipapo_avx2: fix initial map fill
  selftests: netfilter: nft_concat_range.sh: prefer per element counters
    for testing
  selftests: netfilter: nft_concat_range.sh: add datapath check for map
    fill bug

 net/netfilter/nft_set_pipapo_avx2.c           |  21 +++-
 .../net/netfilter/nft_concat_range.sh         | 102 +++++++++++++++---
 2 files changed, 108 insertions(+), 15 deletions(-)

-- 
2.49.0


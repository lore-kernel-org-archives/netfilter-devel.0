Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D96517C74
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Feb 2024 10:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707733567; cv=none; b=bLahq0T3UIoCsu71fMf9C9SYqnhHOUUd8nA15nZLt+DBjfxe2cvQ1gtrBoeUkI4B9dLrHOLl+CW82nXfGnUIVGzt6Xq2Q++VFkuXkfxLDGxeSAI7kOGZ4yWq1P/IdbvwQ2j7EQxdxCvk/zq1Q4ZVx2fkQhmA9SE3AY5iF5n6+HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707733567; c=relaxed/simple;
	bh=0Yzgtk42W3hnd6o/e0m9oeMkbry+NcVuCkUuTWfZaaY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=da2QcaQrd4R/fbmKEfrkbPFVwsHTKDg5+QlCfdjnCt2MkUAqi2CohgeJZ0ukuhm3PnucNzAcE9ZhcXK5ixn8ZfmxbErJRx1uVvIDVC4MtBo25TtJ6m/StsXTT5lVtUFBQNjGNwEUhvw+bukaXhmfRIh5N0tdr+FKkFOWz8fWrhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rZTVd-0005oz-0N; Mon, 12 Feb 2024 11:25:57 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/4] netfilter: nft_set_pipapo: speed up bulk element insertions
Date: Mon, 12 Feb 2024 11:01:49 +0100
Message-ID: <20240212100202.10116-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bulk insertions into pipapo set type take a very long time, each new
element allocates space for elem+1 elements, then copies all existing
elements and appends the new element.

Alloc extra slack space to reduce the realloc overhead to speed this up.

While at it, shrink a few data structures, in may cases a much smaller
type can be used.

Florian Westphal (4):
  netfilter: nft_set_pipapo: constify lookup fn args where possible
  netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR
  netfilter: nft_set_pipapo: shrink data structures
  netfilter: nft_set_pipapo: speed up bulk element insertions

 net/netfilter/nft_set_pipapo.c      | 174 ++++++++++++++++++++--------
 net/netfilter/nft_set_pipapo.h      |  37 +++---
 net/netfilter/nft_set_pipapo_avx2.c |  26 ++---
 3 files changed, 153 insertions(+), 84 deletions(-)

-- 
2.43.0


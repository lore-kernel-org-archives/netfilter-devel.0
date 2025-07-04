Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537F82C324F
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 12:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751632231; cv=none; b=G9CNORkiI8to1A4ATO2Hl+LjS8t6w/OJQPPcJbyFfQsCy9xsgjDHmg+12WfFJEKT86BdbGn9LHq6QsWvYdhyJ3pelNxfggemyVCFUi/Iks5pjTjHibVJpYYhC1HkJOODL0E/NeC0bCQw38zi4jJaDFuyrFH+iRJgYXSZVqNFF4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751632231; c=relaxed/simple;
	bh=pdho9ks3wJ6OupRRTYmy3dU4bUn2i88igevYmRlTmn0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bBN9sxvKFPYMsbBrOjpeJkqUTWxULmF9Q5d+8b3paJa1zN8t126p30ypBeBLd/DfFHu2NTqyonxcbgd4J/IgyfRK6wbQQ+9wgMpX3DTY66FoUQtyVSmx8fixbHVHcLMg4wRSRUeIJYCSWL4xwfhM/4IeS/UdaFcaREDJwwnDSPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4EFAC61260; Fri,  4 Jul 2025 14:30:27 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [nf-next 0/2] netfilter: nf_tables: make set flush more resistant to memory pressure
Date: Fri,  4 Jul 2025 14:30:16 +0200
Message-ID: <20250704123024.59099-1-fw@strlen.de>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Removal of many set elements, e.g. during set flush or ruleset
deletion, can sometimes fail due to memory pressure.
Reduce likelyhood of this happening and enable sleeping allocations
for this.

Florian Westphal (2):
  netfilter: nf_tables: allow iter callbacks to sleep
  netfilter: nf_tables: all transaction allocations can now sleep

 include/net/netfilter/nf_tables.h |   2 +
 net/netfilter/nf_tables_api.c     |  43 +++++--------
 net/netfilter/nft_set_hash.c      | 102 +++++++++++++++++++++++++++++-
 net/netfilter/nft_set_rbtree.c    |  35 +++++++---
 4 files changed, 144 insertions(+), 38 deletions(-)

-- 
2.50.0


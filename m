Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793163DD84E
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jun 2026 14:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780670660; cv=none; b=gM4kRT/H6naLskLVEis4efjOBiKyKBvLX6TvAFDoOikjUlhl1ISfpP1H7QNCVfXAEpMq01JQbJGnCdkYrI0JDe9KawoDvNGL4pKvtiSQfBO9qP5g2/V7csAOpauftQgl9Z10m4cx4upfrHLxJBAdAdXRCATH+P3de482eBON9Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780670660; c=relaxed/simple;
	bh=Rbdq2yIjEMb2EQ6jgMfojByqUy4+ZJB56W1L/pOZPLY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZfV0lKz0pvt0JgPOCgYSPE+0vQaqOJLez9qqP5VDqBiYirDL7my5DPiwKKKvQgvnX0FzN95UZDz3yfSz+pcXybWTc0WhhHG0WuCjROEckaq1CszFVtZsEQ4iJBi2E9BV0Nxhj2PBTnS05bY76/9dqbNCXcc4vlaO8VTn9tdCYxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BD89660425; Fri, 05 Jun 2026 16:44:12 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/2] netfilter: add restrictions/validations for packet rewrite
Date: Fri,  5 Jun 2026 16:44:03 +0200
Message-ID: <20260605144405.13010-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since RFC:
 - nfqueue: allow ipv6 extension headers, but do not allow add/removal.
   This would need more work.
 - nfqueue: remove PRE_ROUTING exception, always validate ipoptions.
   Else we'd have to start changing skb transport header offset too.

 - nft_payload: allow setting a 0 ttl

1) Restrict nfnetlink_queue writes to the network header. Validate IP/IPv6
   headers and disable IPv6 extension header changes. Ensure total length
   matches skb length.

2) Restrict nft_payload writes to linklayer and network header data. Prevent
   linklayer writes from spilling into network headers. Validate network
   header updates to protect IP version and length fields.

This doesn't remove the userns restriction, yet.
I would like to wait a bit before re-enabling this to make sure there
are no other gaps (e.g. for encapsulated traffic).

Florian Westphal (2):
  netfilter: nfnetlink_queue: restrict writes to network header
  netfilter: nftables: restrict linklayer and network header writes

 net/netfilter/nfnetlink_queue.c | 193 ++++++++++++++++++++++++++++++++
 net/netfilter/nft_payload.c     | 170 ++++++++++++++++++++++++++++
 2 files changed, 363 insertions(+)

-- 
2.53.0


Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529063CD8B8
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2026 15:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780932213; cv=none; b=OPL7R0/4IfWLXK5+k4I8gR2UxRM2BOXJj152uh4Z0BGEHiEObo84Ahwwc4KigG4UcrLqlek+AHAk8GjRwpv1HyTKQ1EykH0sTfaydWmT1aLQbTPCVstefU+cvvGgnyGlrYfnoFpWzPjaBdcvCLU5qKsh+Ns08CmycOnuNRSVWz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780932213; c=relaxed/simple;
	bh=NNZUII/aM5LYLedMd6G8rsaEm7NWYjrF+sHOZtpWXKM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rv1hmF5kQ/zlQKeMsyChVF9vbIhx3jNNZLN+igL2HEWouWamL9UiftUgIKc07apindneyv/s6riGo8fINQ9YvStazlJTB27B/7WoTZAxhvM9Yowm5jcFbwyscZroEAVcNb74mzuhFgfDS+D5aJxR1A/VjZVOWp+uHdpGGKozJAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E141D60491; Mon, 08 Jun 2026 17:23:29 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 0/3] netfilter: add restrictions/validations for packet rewrite
Date: Mon,  8 Jun 2026 17:23:15 +0200
Message-ID: <20260608152324.20700-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v1:
 - add patch 3.  Patches 1 and 2 are unchanged.

1) Restrict nfnetlink_queue writes to the network header. Validate IP/IPv6
   headers and disable IPv6 extension header changes. Ensure total length
   matches skb length.

2) Restrict nft_payload writes to linklayer and network header data. Prevent
   linklayer writes from spilling into network headers. Validate network
   header updates to protect IP version and length fields.

3) add restrictions to the checksum offset, without this patch 2 isn't
   sufficient because an invalid checksum offset can e.g. overwrite iph
   header length field.

This doesn't remove the userns restriction, yet.
I would like to wait a bit before re-enabling this to make sure there
are no other gaps (e.g. for encapsulated traffic).

Florian Westphal (3):
  netfilter: nfnetlink_queue: restrict writes to network header
  netfilter: nftables: restrict linklayer and network header writes
  netfilter: nftables: restrict checkum update offset

 net/netfilter/nfnetlink_queue.c | 192 +++++++++++++++++++++++
 net/netfilter/nft_payload.c     | 270 ++++++++++++++++++++++++++++++++
 2 files changed, 462 insertions(+)

-- 
2.53.0


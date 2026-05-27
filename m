Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DD63D5C1B
	for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2026 12:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779883921; cv=none; b=QUL3kfMuXGjZREpIZAywnjSDc5o5lIPw/9S+R/vgDPISzaF8mXIpnVBBpop9ISiI/o0mbuEYyzKvJdSQFD8LLtCPB9ydYdGq1oH8MlRtnNsvFM4lZIRNkKyPAeCNeSZFUc8aPl/kTNIQhzlYS6A50McMVyyuP0IFROQEuyF3iBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779883921; c=relaxed/simple;
	bh=rRmCUPs/094S6qS8sjb4Oa2qlxe0O6C8230eov2vRos=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cFwuszCX3aPQYHRkpcOjaPmGn+AGxKVs0dXBc/SpWTg4VqQFooh39AxLKMu4UaQivhQgMIiI/azridYg3BhrH20/G41YyV57FDkNPV8tQLba2vKGxx1HWpkIMkYNlvS1a6R2SAVm/VqZjVdncMzB9EWZBBvLz40fgOmRtcZg1RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2023F602AB; Wed, 27 May 2026 14:11:58 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [RFC nf 0/2] netfilter: add restrictions/validations for packet rewrites
Date: Wed, 27 May 2026 14:11:42 +0200
Message-ID: <20260527121147.22076-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a followup to the recent patch that disabled packet manipulation
via nfqueue or nft_payload in user namespaces.

This adds additional *restrictions*.
For nfqueue, do minimal header checks in case userspace provides payload
replacement data.

For nft_payload, restrict the offset/length combinations.

Several of these checks could be done at rule insertion time (i.e.
control plane).
Risk is that this may cause ruleset load failures for existing rulesets.
With this change such writes are silently skipped and packet passes
unchanged.

Restriction is added for link and network bases only.

Open questions:
- target tree: nf or nf-next?
- should there be an immediate followup ('patch 3') that reverts
  the userns restrictions again?
- should nft_payload reject those requests it can validate there from
  the control plane?

I would propose to target nf-next for now and leave the userns
restrictions in place to see what relevant use-cases exist.

Florian Westphal (2):
  netfilter: nfnetlink_queue: restrict writes to network header
  netfilter: nftables: restrict linklayer and network header writes

 net/netfilter/nfnetlink_queue.c | 103 +++++++++++++++++++-
 net/netfilter/nft_payload.c     | 166 ++++++++++++++++++++++++++++++++
 2 files changed, 268 insertions(+), 1 deletion(-)

-- 
2.53.0


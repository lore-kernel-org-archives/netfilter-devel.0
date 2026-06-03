Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A029637418F
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2026 11:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780485927; cv=none; b=hGF4G4UeF7plTCrY+qx0KEqMpwJe9WcvyeqUHAR08Kqh2olHku0yayJ3a9H8gKhCknHIxWY4L/toiOXtohtpMEfyGZ1zIVg4l/Ji+TrLfToxwGotkzR+PTAOPhKzxXcWE0Yb+JHeYHWBfXAwK6eplbP+HyvVLUOcnJmNhKnecOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780485927; c=relaxed/simple;
	bh=8p2N6iItROi9uB5nMBSUe/KuNteRpZ18WI+mw8orMj4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c5d1MuUiSrocPATGjekJlTM8n5R/2YKosdS+wPHYOTWbjecXijPMo9//0vCCF1xMQJ4Of/k3lE3fdcc6qlzK2rIXh6mxlYXc0az42Tpbx+6tTAwbIm9KOickKf8tVa0lM81CFtdcWCVXKjV9UAcT/JO/lIIS5fhBuDDhl0FOQI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7F9C7602F8; Wed, 03 Jun 2026 13:25:23 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: nf_conncount: misc bug fixes
Date: Wed,  3 Jun 2026 13:24:57 +0200
Message-ID: <20260603112513.2263-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This addresses a drive-by AI review of nf_conncount.  See patch 3 for
details.

1) Replace rb_root with a new container structure in nf_conncount to prepare
   for a per-tree sequence counter to detect concurrent modifications.

2) Split nf_conncount rbtree walk into a helper. Add find_tree_node() to
   fetch matching node so folluwp patch can reuse the function.

3) Fix tree_gc_worker wrap-around by updating gc_tree unconditionally. Add
   a sequence count to detect concurrent rbtree modifications. Add
   rcu_barrier before zapping the kmem cache during module exit.

Florian Westphal (3):
  netfilter: nf_conncount: prepare for per-tree seqcount
  netfilter: nf_conncount: split count_tree_node rbtree walk into helper
  netfilter: nf_conncount: gc and rcu fixes

 net/netfilter/nf_conncount.c | 171 ++++++++++++++++++++++++-----------
 1 file changed, 116 insertions(+), 55 deletions(-)

-- 
2.53.0


Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042EB4A1B
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2024 13:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729864469; cv=none; b=jxdd//WPRmg7M60ShuOLMVmjK5rfjBJj83Ue5eOYiB4yS1wbH+uLbPoAuFvQRulUMEqDeX25hafhk7/iGiJXvFKz1KQGdAYur4Sgex57YdIYEJD7qvI2czX4zaYMYvVQWOVmZHXQvBbrth4/DM1HCk3xHK2tT4hVGDSlQZG9zx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729864469; c=relaxed/simple;
	bh=uNOP3QwUlmy4H7S4DXKP++91qDZn6y4PpfDYaZho95A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BVfVoD10Bduic/ZXc9z3dkIFJ1Vd1fa+6qy7IbOPHEgUMkw4mJJsdKyr+XVkEbrjp+p+uJ5mE4Ac3OURoMzU1mivieTyP21PyfzoLXRQyM4JhSvekQv5wpSEJISuHSVjp17Ik4lUC3ZVgE5v+CdZpzl5sztMd/FAkSf4amwO82U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t4Klj-0005xZ-Po; Fri, 25 Oct 2024 15:54:23 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/7] netfilter: nf_tables: avoid PROVE_RCU_LIST splats
Date: Fri, 25 Oct 2024 15:32:17 +0200
Message-ID: <20241025133230.22491-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mathieu reported a lockdep splat on rule deletion with
CONFIG_RCU_LIST=y.

Unfortunately there are many more errors, and not all are false
positives.

First patches pass lockdep_commit_lock_is_held() to the rcu
list traversal macro so that those splats are avoided.

The last two patches are real code change as opposed to
'pass the transaction mutex to relax rcu check':

Those two lists are not protected by transaction mutex so
could be altered in parallel.

Aside from context these patches could be applied in any order.

This targets nf-next because these are long-standing issues so
it seems wrong to fix it this late in the release cycle.

Florian Westphal (7):
  netfilter: nf_tables: avoid false-positive lockdep splat on rule
    deletion
  netfilter: nf_tables: avoid false-positive lockdep splats with sets
  netfilter: nf_tables: avoid false-positive lockdep splats with
    flowtables
  netfilter: nf_tables: avoid false-positive lockdep splats in set
    walker
  netfilter: nf_tables: avoid false-positive lockdep splats with
    basechain hook
  netfilter: nf_tables: must hold rcu read lock while iterating
    expression type list
  netfilter: nf_tables: must hold rcu read lock while iterating object
    type list

 include/net/netfilter/nf_tables.h |   3 +-
 net/netfilter/nf_tables_api.c     | 110 ++++++++++++++++++------------
 net/netfilter/nft_flow_offload.c  |   4 +-
 net/netfilter/nft_set_bitmap.c    |  10 +--
 net/netfilter/nft_set_hash.c      |   3 +-
 5 files changed, 79 insertions(+), 51 deletions(-)

-- 
2.45.2


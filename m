Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D60B1AE00B
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Nov 2024 09:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730713454; cv=none; b=BJGsw0n0dn+I6axw2SHe0BdIIuVXf0wZkQ5F1yIa3qiq/JPzFc82osUSr3VyU3/9F+3EhdfzFwYJpxEjGBbKfPNbpga4RMsfbFGIhHL6qtlitnfee/iS15rutZTHq1T8W5BkA2XUlKPzXQ9aovsNex+LcTPvW7FU78Lna9O6MdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730713454; c=relaxed/simple;
	bh=KA2ck8Ey89ERr8W+puv+an9pumDpG/zNYn5Yopf4er8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rCohk9/txXurNLKNjxDRoJPYmgjosy2lpeVEBAUhgOVHN1B5G6rIol1yTNjtLG5KpxlXSF7cdaJvdJIHYJ8WMWZ8K8A6Bjk3GXDJaG4nfaevoDXEXt/lVmY5mu43OtEat/AJOtS4jIKB2Fddxmxd0Dx44N6KPc+mjUWMC+rBLWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t7td4-0003bv-97; Mon, 04 Nov 2024 10:44:10 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v3 0/7] netfilter: nf_tables: avoid PROVE_RCU_LIST splats
Date: Mon,  4 Nov 2024 10:41:12 +0100
Message-ID: <20241104094126.16917-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3: don't check for type->owner and add comment saying check on
inner_ops is enough.
Use IS_ERR() instead of ptr == NULL in patch 7/7.
No other changes.

Mathieu reported a lockdep splat on rule deletion with
CONFIG_RCU_LIST=y.

Unfortunately there are many more errors, and not all are false positives.

First patches pass lockdep_commit_lock_is_held() to the rcu list traversal
macro so that those splats are avoided.

The last two patches are real code change as opposed to
'pass the transaction mutex to relax rcu check':

Those two lists are not protected by transaction mutex so could be altered
in parallel in case of module load/removal.

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

Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E3D12FF71
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 19:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723059652; cv=none; b=QkGH0rvs4HewwBGix43dSe4gYYOSWMD8IXxMGbyuOyzSP6m6u0hkkxqNH08uvQISgKYfc/L5ILQFo2vCY49zPbzJTWN0tcoApOjaPsV5Wk6TiUh3eLOlxuK1OEL2QNeO7JwzOhur2PL1D5Sl/ZLMw8K9zK2Fp82OS5q2pRw6kEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723059652; c=relaxed/simple;
	bh=OCLo22l6tbHhlA114X3h72DYZZGcwpuxy1lsqItIoRs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=izWtQMssYoymNWaI7TbdkPk3BjsUbW90A4Ii4V8vrYR5mYqnm8Gwr/Tkv0tQN22TMZQlGJ1inQ/c6onzVXl876UhTmDIBVZ6TvdexpNwGsPVnqfi8f7+KNJVY7GrFa+wYzFufJ+SaNqcGRdzXm/yVGw0PYydOu9l+KaxkJ1Tquk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sbmWe-0007eQ-Dt; Wed, 07 Aug 2024 21:40:48 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/2] netfilter: disable support for queueing cloned conntrack entries
Date: Wed,  7 Aug 2024 21:28:40 +0200
Message-ID: <20240807192848.28007-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Conntrack assumes an unconfirmed entry (not yet committed to global hash
table) has a refcount of 1 and is not visible to other cores.

With multicast forwarding this assumption breaks down because such
skbs get cloned after being picked up, i.e.  ct->use refcount is > 1.

Likewise, bridge netfilter will clone broad/mutlicast frames and
all frames in case they need to be flood-forwarded during learning
phase.

For ip multicast forwarding or plain bridge flood-forward this will
"work" because packets don't leave softirq and are implicitly
serialized.

With nfqueue this no longer holds true, the packets get queued
and can be reinjected in arbitrary ways.

Disable this feature.

After this patch, nfqueue cannot queue packets except the last
multicast/broadcast packet.

Alternatives:
- queue, but zap skb->nf_conn .  Problem:
  On reinject, packet would match INVALID state.
- same, but make them untracked. Slightly better, but not
  by much.
- check if NAT was applied or not.
  If not, we could theoretically queue and then
  relookup the conntrack on reinject.

This would create a new entry in established, new or invalid
state (userspace can munge the packet).

ATM I would prefer to go with the minimal solution which is
to disable this feature.

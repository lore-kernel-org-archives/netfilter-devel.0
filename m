Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2943272E46
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Aug 2025 15:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754061934; cv=none; b=XIo8LAyasssvomdwFRejzrkz8j2fC0n/0HDf0OvnJHhJsqr+135gTvJ/+N+E1wHwZ1BdVXg9KeZUn52eDO6CZPenu74LbVYkzUYznytHmZmNT9a5fHVxdR68wqdI+ytSGetG7TxOp3860IMZSMvrAHJ69cRHWtSuS7s7mE9usk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754061934; c=relaxed/simple;
	bh=dtTRVf5RiljSUftJSJBdMCnzyVQVoqfEovE5sNJ7znc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lf187+qsTvJNHxoBRRKhSkRhPmONFzjPz6U8QC6LMujviMTe5XVz3D0IRmAPdHBZ7wFuttQ/NMfakpQxuKHrvhxe+lxDu0GNtRLEFOXioH7ahGkY1RL84fuHor0dpbPJ1Y16mRbc49FGA+7NwXxSoALenZJlKuNu2TCH7iCXBLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CD618602A4; Fri,  1 Aug 2025 17:25:23 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/2] netfilter: ctnetlink: fix memory leak in ctnetlink dump
Date: Fri,  1 Aug 2025 17:25:07 +0200
Message-ID: <20250801152515.20172-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes a memory (refcount) leak in the ctnetlink dump code.
In some cases is possible that the entry being held in cb->args[] (with
refcount raised) fails to be delivered.

If this happens, the reference count is erronously incremented a second
time.

This results in a memory leak and non-recoverable hang in the netns
cleanup worker.

The second patch fixes a similar pattern in the expectation dump code.

In both cases the fix is to not use reference counting at all, the restart
hint is replaced by a cookie value, this has the same guarantees as the
existing code without need for keeping objects alive across partial dumps.

Note that the same pattern is used for dying lists, but as far as I can
see this problem can't happen there.  I will submit a patch for nf-next
that also uses refcount-less cookie values in the dying list dumper.

Florian Westphal (2):
  netfilter: ctnetlink: fix refcount leak on table dump
  netfilter: ctnetlink: remove refcounting in expectation dumpers

 net/netfilter/nf_conntrack_netlink.c | 65 +++++++++++++---------------
 1 file changed, 30 insertions(+), 35 deletions(-)

-- 
2.49.1


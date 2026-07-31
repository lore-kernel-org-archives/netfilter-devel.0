Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844AA430CEE;
	Fri, 31 Jul 2026 15:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512057; cv=none; b=A5bC7NiWBHMTf79O4O1QjDnMIBRSPGrEleI8/vFKC/+qQ4s+8pPoYM/XG/7bCIrfySVZhvS9n7u4T9zi+uC3Xzj1u2fssh9KBOf02BZfVoXjWmKHrITSsPKF5JuM8jHQYZ06xDMoSEN81dKE8IKQGrZUqxyZ4m6vdQkozdjfplI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512057; c=relaxed/simple;
	bh=vvSLv/M4Ma/+P5n8reX4UTBcdWqla/UJ8a+9rY5hQUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkfHGbK/lN2ZhUBk/Hh1x7d8OklFEEEPqK4IUZnnHtYIZ8OQi5gcsWntQ7+0XaVrKDXbnhBg3dhTUa2x8obGXuYQIfhbi1AgyQ2n8VCmLo0vrYKTlpcv9so153sJmOLVQzaOL7OcZBVm2ooiXAB7AIWnyRbmCig4o8cLXZuMDkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Fg/b9WP9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Fg/b9WP9"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E11D9602A7;
	Fri, 31 Jul 2026 17:34:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785512053;
	bh=bcbgSXf/mhXLp2dz0Tup+F/4IeOS+AhHG2brScSCmOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fg/b9WP95swTYRnzFdcqIVvJ5aLRtInp7z3mrfqzV7CyD3VwmxsgbFqBXiC9frX0J
	 0fSTuknM6enjRPILvL660KjQOyOWMOK7/vJZ2D5oF8zJnziTc63tO/SrH3BfuB4Hrc
	 pjT/VsTzeIPBNWlLcMNfNbbAqZrOA5l3O/OfxGbukeP+h84225Wt4k32jfyoZso/P2
	 R4AqLhClscNq6s4cJznHFizOEr0jOHOsMFiFXT10EV9+d8DSm94R/wmsuV1X1rQNhs
	 Z8MCUuqJlHj30Qj+5ZD5py2js+zvTy61wS4rs8McFkXWJzYpTtvUe2ckRGIFRo5rGB
	 LDnlBhoCBB7RA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 1/9] netfilter: conncount: normalize tuple and zone on successful ct lookup
Date: Fri, 31 Jul 2026 17:33:54 +0200
Message-ID: <20260731153402.851224-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260731153402.851224-1-pablo@netfilter.org>
References: <20260731153402.851224-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

When get_ct_or_tuple_from_skb() falls back to looking for a connection
via nf_conntrack_find_get(), a successful lookup sets ct but leaves
tuple and zone unupdated.

If the packet belongs to a reply flow, tuple will remain in the reply
direction. As conncount relies on the original direction tuple to count
the connections consistenly, passing an unnormalized reply tuple could
lead to problems.

Fix this by making sure that tuple and zone are normalized.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index e9ea6d9466e7..85487f92af50 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -158,6 +158,8 @@ static bool get_ct_or_tuple_from_skb(struct net *net,
 		return true;
 
 	found_ct = nf_ct_tuplehash_to_ctrack(h);
+	*tuple = found_ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+	*zone = nf_ct_zone(found_ct);
 	*refcounted = true;
 	*ct = found_ct;
 
-- 
2.47.3


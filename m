Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5A584D03
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Apr 2024 11:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713872978; cv=none; b=TtS8yaIRwQ3aGjNkXrEN+d0PvIUbv1RxuPggpXICMuG4qh31dUgL8uL0U1Yd45Dtn9t6DrwRXgfqXRARrW8VNXS3FSpOG6CA0zql+PT7lWErQdvAtEwWWKlSIq17j8T/0veKxEP0QYp/EJ2MnSyuqtfI01P2n66bIMKNjhzwdf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713872978; c=relaxed/simple;
	bh=9GOHUXZ0L+FTUY227yOCkoejPb3diyGGwxU4gojzM+w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BLewIJZ1ms5LNaxgtHqupgyJDG3Q9z/s5MDclQn9ZuLz/XsRqd9+PslXIWEf7ZvrZRRb1b7vuA4lgdHbtLweB6Knb3CijHdBa/EjTmttWMGvu+zT+NwxGQ+TZ4nLbGQsR68u1ofXxkCirtZLPc9XLehOoscEbraqFsoPR79ygbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzEeT-0007Id-TP; Tue, 23 Apr 2024 13:49:33 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH nf-next] netfilter: conntrack: remove flowtable early-drop test
Date: Tue, 23 Apr 2024 15:44:28 +0200
Message-ID: <20240423134434.8652-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Not sure why this special case exists.  Early drop logic
(which kicks in when conntrack table is full) should be independent
of flowtable offload and only consider assured bit (i.e., two-way
traffic was seen).

flowtable entries hold a reference to the conntrack entry (struct
nf_conn) that has been offloaded. The conntrack use count is not
decremented until after the entry is free'd.

This change therefore will not result in exceeding the conntrack table
limit.  It does allow early-drop of tcp flows even when they've been
offloaded, but only if they have been offloaded before syn-ack was
received or after at least one peer has sent a fin.

Currently 'fin' packet reception already stops offloading, so this
should not impact offloading either.

Cc: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Vlad, do you remember why you added this test?

 For reference, this came in
 df25455e5a48 ("netfilter: nf_conntrack: allow early drop of offloaded UDP conns")
 and maybe was just a 'move-it-around' from the check in
 early_drop_list, which would mean this was there from the
 beginning.  Doesn't change "i don't understand why this test
 exists" though :-)

 net/netfilter/nf_conntrack_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c63868666bd9..43629e79067d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1440,8 +1440,6 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 	const struct nf_conntrack_l4proto *l4proto;
 	u8 protonum = nf_ct_protonum(ct);
 
-	if (test_bit(IPS_OFFLOAD_BIT, &ct->status) && protonum != IPPROTO_UDP)
-		return false;
 	if (!test_bit(IPS_ASSURED_BIT, &ct->status))
 		return true;
 
-- 
2.43.2


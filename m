Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DB7387375
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 14:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786025883; cv=none; b=BWancv4Ep9x7/7Bygxo38Mz3qFo9NZ20+RxsjU1oRgXJedCGr6R/qmk/3YqcG6UXBooz8qgKv7tmYlQpTAMSgCRzlusZnNPVmFOAykSQsRFOKLPpKRvBy/sBUUub429FRd4G312F2CA20AOENoQU+v6rMRo4BnBzSbK+AYFA3iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786025883; c=relaxed/simple;
	bh=9dNfVMUxYE0XW5CWAt86leSPF1yRKV64fNNFXW96N/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LCrO7Ao41PWZI7O3DVB4kFjpq/EZq+fG2P498bPryYq4wi0RbNEJbi6P0IYzCHhJDmO4U0OtWP4wXmoJGmEI/ED765AByflGFc2ouiWTjU58PQHr24Dog6OmBlSiawID/RDgbjdR2uZaCcNblhphenyv2IUGA7BkoujrWO/NiEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 286AC60299; Thu, 06 Aug 2026 16:17:59 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: ipset: let destroy callbacks adjust ext mem size
Date: Thu,  6 Aug 2026 16:17:50 +0200
Message-ID: <20260806141750.10441-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For bitmap this change makes no difference, because destructors are
called synchronously.

List type however calls them via call_rcu() so accounting decrement can
happen after list_set_flush() set ext_size to 0.

'set->elements = 0' can be removed for the same reason in the list type
case, it calls 'set->elements--' for each element.

Fixes: 9e41f26a505c ("netfilter: ipset: Count non-static extension memory for userspace")
Suggested-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 sashiko: list_set_uadd() may call list_set_replace() and
 then erronously increments set->elements, causing a counter
 drift. This bug will be resolved in a different patch.

 net/netfilter/ipset/ip_set_bitmap_gen.h | 2 +-
 net/netfilter/ipset/ip_set_list_set.c   | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 226fdf17b683..d6a7e6604542 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -77,7 +77,7 @@ mtype_flush(struct ip_set *set)
 		mtype_ext_cleanup(set);
 	bitmap_zero(map->members, map->elements);
 	set->elements = 0;
-	atomic64_set(&set->ext_size, 0);
+	DEBUG_NET_WARN_ON_ONCE(atomic64_read(&set->ext_size) > 0);
 }
 
 /* Calculate the actual memory size of the set data */
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 56626f4943a9..b4967a9d82b0 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -423,8 +423,7 @@ list_set_flush(struct ip_set *set)
 
 	list_for_each_entry_safe(e, n, &map->members, list)
 		list_set_del(set, e);
-	set->elements = 0;
-	atomic64_set(&set->ext_size, 0);
+	DEBUG_NET_WARN_ON_ONCE(set->elements > 0);
 }
 
 static void
-- 
2.54.0


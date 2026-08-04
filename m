Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C26548123E
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2026 17:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785862974; cv=none; b=iVLmnp9zfyzipD807AOarXYisoXitKw+dg1WjnVUHhZx302WQA7SIjxnYfBrQFNW8QXt/MWgJa5y1DyY5srdlYcsWWIU5cIFhI4yPMg+Ck/WNIEoKE5KnZvKnAH7WOOl0PBhOUGmLuABD7cbEMxdToy4Da9wECkb+TKbZE3tSn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785862974; c=relaxed/simple;
	bh=MR6hiDmQk4auioLbcCwGaKI1q+z3NSCCQjUeEhec7X0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ejr52sPJrtcezPFkhaxjQHnoEXLeT0IAtzAK/uRBz6dxF/7rL4amGP6wW5CGgSfevSlRtqUneK9eo/t1zHOeKX7W697PVpiLNPYuX6nyI+8jIUlOWWOMSpPOvoM4s1lUOrS3yApI9w1EvvKbecVVXgGXGUR5xsNywdjiw8ZBjUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4A01960636; Tue, 04 Aug 2026 19:02:37 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: ipset: let destroy callbacks adjust ext mem size
Date: Tue,  4 Aug 2026 19:02:28 +0200
Message-ID: <20260804170228.27262-1-fw@strlen.de>
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

sashiko pointed out list type destruction is partially done via call_rcu:
mem accounting could be subtracting after list_set_flush() did reset the
value to 0.  set->elements assignment can be removed for the same reason,
this already walks the entire set and does 'set->elements--' for each
entry synchronously.

Fixes: 9e41f26a505c ("netfilter: ipset: Count non-static extension memory for userspace")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Won't apply, this assumes the pending nf PR is applied.
 In case that PR is rejected, this patch could be
 reworked to logically come before the atomic64 conversion,
 but it doesn't buy mutch.

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
index ca3ef9479e83..024de3bc9fc3 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -420,8 +420,7 @@ list_set_flush(struct ip_set *set)
 
 	list_for_each_entry_safe(e, n, &map->members, list)
 		list_set_del(set, e);
-	set->elements = 0;
-	atomic64_set(&set->ext_size, 0);
+	DEBUG_NET_WARN_ON_ONCE(set->elements > 0);
 }
 
 static void
-- 
2.54.0


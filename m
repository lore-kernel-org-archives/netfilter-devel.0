Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE593DD537
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 10:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786011615; cv=none; b=c6V1Q9a+ebQkBto/wDUfU5r4RTg1xIBW389oEZ7FdssCw8iqXGf4PXBD8NIasSG0H7Nvkk/AnfwaxRfhgSUvRc3Daz/bRtfJtZuVZ7jRnor6fE39jLKXFd5A70Sa5Fxq/5szhNWf9Cv2JMLl6V23LHvvWGZyAMuVPbeoSFn78z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786011615; c=relaxed/simple;
	bh=0ePiPSfLkWWFSva2gEscEr/ZKYoqFdEODFuiY/CgA7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJYmwpASBcuYmnp6uMSYAuxE8RGqVwFGSrRXCWVBl4ue0RCgjhgOROM0nXB7OgrmYgSw3vF3RZsY+fj4iSjGrt/Qski9M+lyteg93IxaGIsYc+3ORhv1E9wdDu9wJQxugss4ZWEv3B7EbTBTqd96IXJx4Xr0+OCHn3A83GsKKro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 291F860240; Thu, 06 Aug 2026 12:20:12 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/7] netfilter: ipset: let destroy callbacks adjust ext mem size
Date: Thu,  6 Aug 2026 12:19:42 +0200
Message-ID: <20260806101947.2802-3-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260806101947.2802-1-fw@strlen.de>
References: <20260806101947.2802-1-fw@strlen.de>
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
 Was not part of earlier RFC series.

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


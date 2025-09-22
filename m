Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5BD18C2C;
	Mon, 22 Sep 2025 19:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570538; cv=none; b=eZJJZg95Tu+U1jmSyWYH25MuZRlXIukgvHZXBwTxLwt5xseGrVOOENzqgPYw6E7Aqv2ZwK/Jj6b0OnUVBP4i5H+7Hat7GdRqWYQkHOCvtlWpXKK3n01IrSf0xecWjx3fzORP9U35dY2OvNTqHBXG9NN4RDwltbvqIB65NwYkIts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570538; c=relaxed/simple;
	bh=Bktxi40ifPO0BVUh+lWCQD2JpGLqdhBXFVRwoXQXalg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UIXgVSCCeQfEpzfSylNKJM57YaDm4NNVgDwFXfIgdvvPq8pb1/ZRQeIl9LuF8Ew78+bBqmv9pEeuIXnO9OajPyPYWzBCJD8DT2USzuHzs4SGSq9beYsXZwKLTlQhTt2bMVeKqT6Uc1osV7jUkm0BUFv/IDToJkpP9OPfzYfVbWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=a9yirU8h; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="a9yirU8h"
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:1621:0:640:12d9:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 4C111C00F5;
	Mon, 22 Sep 2025 22:48:42 +0300 (MSK)
Received: from d-tatianin-lin.yandex-team.ru (unknown [2a02:6bf:8080:c27::1:3a])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id TmcMU33Goa60-qkx2LIvO;
	Mon, 22 Sep 2025 22:48:39 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1758570519;
	bh=qxION9U5wlKwVIBQL5IAbiQNhU5dexT8YZgkvd6NzUw=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=a9yirU8hEev/JyLBw1NbWhSsTrDADJpz3q8ZPGBfZFMHdJKFc2EkUJVMuqr75DGvT
	 Hd+JDtnzmff7m4Np8Q1x4WEGQBGCeDR/xhgoBEErX9EAjtpgv7NydhAB6XQB10aAmO
	 0gVR/00CLy2xzYpQx4Ue8oGPZ8ywwHeedrGx5M3o=
Authentication-Results: mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Daniil Tatianin <d-tatianin@yandex-team.ru>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 0/3] netfilter/x_tables: go back to using vmalloc
Date: Mon, 22 Sep 2025 22:48:16 +0300
Message-Id: <20250922194819.182809-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series aims to replace most calls to kvmalloc whose size directly depends
on user input with vmalloc. This was actually the way xt_table_info was
previously allocated if it ended up being too large back in 2017 before it got
replaced with a call to kvmalloc in the
commit eacd86ca3b036 ("net/netfilter/x_tables.c: use kvmalloc() in xt_alloc_table_info()").

The commit that changed it did so because "xt_alloc_table_info()
basically opencodes kvmalloc()", which is not actually what it was
doing. kvmalloc() does not attempt to go directly to vmalloc if the
order the caller is trying to allocate is "expensive", instead it only
uses vmalloc as a fallback in case the buddy allocator is not able to
fullfill the request.

The difference between the two is actually huge in case the system is
under memory pressure and has no free pages of a large order. Before the
change to kvmalloc we wouldn't even try going to the buddy allocator for
large orders, but now we would force it to try to find a page of the
required order by waking up kswapd/kcompactd and dropping reclaimable memory
for no reason at all to satisfy our huge order allocation that could easily
exist within vmalloc'ed memory instead.

Revert the change to always call vmalloc, since this code doesn't really
benefit from contiguous physical memory, and the size it allocates is
directly dictated by the userspace-passed table buffer thus allowing it to
torture the buddy allocator by carefully crafting a huge table that fits
right at the maximum available memory order on the system.

This series also touches the allocation of entry_offsets, since they suffer
from the same issue.

Daniil Tatianin (3):
  netfilter/x_tables: go back to using vmalloc for xt_table_info
  netfilter/x_tables: introduce a helper for freeing entry offsets
  netfilter/x_tables: allocate entry_offsets with vcalloc

 include/linux/netfilter/x_tables.h |  1 +
 net/ipv4/netfilter/arp_tables.c    |  4 ++--
 net/ipv4/netfilter/ip_tables.c     |  4 ++--
 net/ipv6/netfilter/ip6_tables.c    |  4 ++--
 net/netfilter/x_tables.c           | 12 +++++++++---
 5 files changed, 16 insertions(+), 9 deletions(-)

-- 
2.34.1


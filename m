Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817E63AB5AC;
	Thu,  2 Jul 2026 10:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989436; cv=none; b=dC6CpQzYLNTQyJTmh/76eakL3Zb3/R8KfOAPR2PYdgMzNZel4yiPcIVy6P+J+gg2Xb4jdZzLCxDBZfXDP1N+xYEJV2zzksBnFp3lPA5qbb2Tlk5BBHqGfIGNweEAkzlghqowe0Si7drgnghsqNYb9228wn97MI6xdDVXxOc7nNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989436; c=relaxed/simple;
	bh=dTDjrvIfo7+8YIXgBFlyOQ/x2V3fLiTdwptc6YGwTcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LY/ltN2bssftHeNaL/ia8ehRrjs4DH6AXWqxZCNOJHPObhZ1YQ41SCuVI2YtNWzprkx/n9IXl8AG7LyhcQ3gcry9vhIpumVp1prDrwHFex/DhjmlTV3zFdV70BLppsqgXkc7CHfJVn0ez9e/LktyBSXnRj+vbQ+6JkP7KRXQzAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ECF2D601F0; Thu, 02 Jul 2026 12:50:33 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 05/12] netfilter: remove redundant null check before kvfree()
Date: Thu,  2 Jul 2026 12:49:56 +0200
Message-ID: <20260702105003.13550-6-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260702105003.13550-1-fw@strlen.de>
References: <20260702105003.13550-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Subasri S <subasris1210@gmail.com>

kvfree() internally performs NULL check on the pointer
handed to it and takes no action if it indeed is NULL.
Hence there is no need for a pre-check of the memory
pointer before handing it to kvfree().

Issue reported by ifnullfree.cocci Coccinelle semantic
patch script.

Signed-off-by: Subasri S <subasris1210@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_rbtree.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 018bbb6df4ce..efc25e788a1c 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -544,8 +544,7 @@ static int nft_array_intervals_alloc(struct nft_array *array, u32 max_intervals)
 	if (!intervals)
 		return -ENOMEM;
 
-	if (array->intervals)
-		kvfree(array->intervals);
+	kvfree(array->intervals);
 
 	array->intervals = intervals;
 	array->max_intervals = max_intervals;
-- 
2.54.0


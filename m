Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E32D154454;
	Mon, 29 Jan 2024 15:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706542292; cv=none; b=Rkw7B815SAQ6zYbP1L8CdfVmPf3zyU4fYw50LgYGAnJijzkZ9FfcwOFVOra7Yb3JuLSyRKRgOOBZPM/12DFXCv0vRKNxqon3e2Xor0r8lQPxuFMi/BzbL3UTiMR/OqC0D1Gacq3oSBS10DWJRsWxkzeSPA6nE7B6IH8yLnD35pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706542292; c=relaxed/simple;
	bh=OAU/058iGlP+OZhLqZ8NsOJERDWs9M9YpXuxlAXHd5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6992bSPlaTg6jZLd0MYB2qA619AwtA+Wc2LDppIUkAcmXKAoLJKaWjhILzbucjCDpuDc0mAOhns8RacbueuZfcgaU8in/TasQeG87ai8KNgzi9zzkgGFqQwT1ZfpnvOQfi/SMapafKxJK5Yrr/HhX6nzW8dREQTV4pu7AX0IDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rUTbb-00021h-8O; Mon, 29 Jan 2024 16:31:27 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Kunwu Chan <chentao@kylinos.cn>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH nf-next 6/9] ipvs: Simplify the allocation of ip_vs_conn slab caches
Date: Mon, 29 Jan 2024 15:57:56 +0100
Message-ID: <20240129145807.8773-7-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129145807.8773-1-fw@strlen.de>
References: <20240129145807.8773-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kunwu Chan <chentao@kylinos.cn>

Use the new KMEM_CACHE() macro instead of direct kmem_cache_create
to simplify the creation of SLAB caches.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Acked-by: Simon Horman <horms@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipvs/ip_vs_conn.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index a743db073887..98d7dbe3d787 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1511,9 +1511,7 @@ int __init ip_vs_conn_init(void)
 		return -ENOMEM;
 
 	/* Allocate ip_vs_conn slab cache */
-	ip_vs_conn_cachep = kmem_cache_create("ip_vs_conn",
-					      sizeof(struct ip_vs_conn), 0,
-					      SLAB_HWCACHE_ALIGN, NULL);
+	ip_vs_conn_cachep = KMEM_CACHE(ip_vs_conn, SLAB_HWCACHE_ALIGN);
 	if (!ip_vs_conn_cachep) {
 		kvfree(ip_vs_conn_tab);
 		return -ENOMEM;
-- 
2.43.0


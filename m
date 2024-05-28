Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E8DC13E05F;
	Tue, 28 May 2024 22:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716936930; cv=none; b=FxHVdzlNBWOrNzRrh+XhvR3zKEmLb36HnoiPPX0Y6ckN5Mbo4ZsBXkbF3h942ooPCb+z/P9CrqFPyHo0dnxNtZJDhQ4I70hHiWUE6EpbH7WETMDooA4/1X0T6HA8s2qPB/M0qHNTr311o+hTGdyu0jrpTJP/0dPN55ILmQR9t7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716936930; c=relaxed/simple;
	bh=GZugc6t/TGMb0kkCWihZjQHCum1izVwaDyo4kbG/SYc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lyfuZfEaA7UyQvgPYJ/fSELgsiGsx1bhCRLmMsI1c3dMY79ydVpryC4h2MiHqf8+iOReZT1i0ckUFfWXAMgOeA69i5Ol5qtiw5XZ1ROYuqA3vaAtLbZX2jxFvgjC8I6WiaIe9YJNBDh9m4Y922oY3sgHjsriUCi8MKNDDwTinyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	kadlec@netfilter.org
Subject: [PATCH net 2/6] netfilter: ipset: Add list flush to cancel_gc
Date: Wed, 29 May 2024 00:55:15 +0200
Message-Id: <20240528225519.1155786-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240528225519.1155786-1-pablo@netfilter.org>
References: <20240528225519.1155786-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexander Maltsev <keltar.gw@gmail.com>

Flushing list in cancel_gc drops references to other lists right away,
without waiting for RCU to destroy list. Fixes race when referenced
ipsets can't be destroyed while referring list is scheduled for destroy.

Fixes: 97f7cf1cd80e ("netfilter: ipset: fix performance regression in swap operation")
Signed-off-by: Alexander Maltsev <keltar.gw@gmail.com>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_list_set.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 6c3f28bc59b3..54e2a1dd7f5f 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -549,6 +549,9 @@ list_set_cancel_gc(struct ip_set *set)
 
 	if (SET_WITH_TIMEOUT(set))
 		timer_shutdown_sync(&map->gc);
+
+	/* Flush list to drop references to other ipsets */
+	list_set_flush(set);
 }
 
 static const struct ip_set_type_variant set_variant = {
-- 
2.30.2


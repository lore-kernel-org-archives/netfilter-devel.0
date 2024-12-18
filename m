Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4D211FAC55;
	Wed, 18 Dec 2024 23:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734565313; cv=none; b=U2fcP8mknqeEcU5ecb8dNpVpNtawmcD2Tr4QDA7qsRQcYEOq9LE2QTCfLkDKjKURVYQsHx77pyKRCH8XsQW9caopGrtTAZpqYf+LqZhhdRo5bAozhLYsZnxefW+tar/Pob/m1JZo+/4w9aLtkWAODvbuz2rtU78sClC0MwwVN4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734565313; c=relaxed/simple;
	bh=hlTUwRtcm8X5JqChNop5tLa5z5lb/W4oTXOG4zmP21s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hAMGojv4rRNyNeGj7CApysukSeoyiFTZv/InOfAdLz3zuoETzT/prtXxiBevZlTfCe8SJjVGYRNJuTD63TvKIKk938d5ovtQ8j20xUXjA3wonWqsy4Blggth44WCIdhie4Vyhpxxawci5dHg/1gQiH34UrKziAYFx4uLaGm2kFQ=
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
	fw@strlen.de
Subject: [PATCH net 1/2] ipvs: Fix clamp() of ip_vs_conn_tab on small memory systems
Date: Thu, 19 Dec 2024 00:41:36 +0100
Message-Id: <20241218234137.1687288-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241218234137.1687288-1-pablo@netfilter.org>
References: <20241218234137.1687288-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <David.Laight@ACULAB.COM>

The 'max_avail' value is calculated from the system memory
size using order_base_2().
order_base_2(x) is defined as '(x) ? fn(x) : 0'.
The compiler generates two copies of the code that follows
and then expands clamp(max, min, PAGE_SHIFT - 12) (11 on 32bit).
This triggers a compile-time assert since min is 5.

In reality a system would have to have less than 512MB memory
for the bounds passed to clamp to be reversed.

Swap the order of the arguments to clamp() to avoid the warning.

Replace the clamp_val() on the line below with clamp().
clamp_val() is just 'an accident waiting to happen' and not needed here.

Detected by compile time checks added to clamp(), specifically:
minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/all/CA+G9fYsT34UkGFKxus63H6UVpYi5GRZkezT9MRLfAbM3f6ke0g@mail.gmail.com/
Fixes: 4f325e26277b ("ipvs: dynamically limit the connection hash table")
Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: David Laight <david.laight@aculab.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 98d7dbe3d787..c0289f83f96d 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1495,8 +1495,8 @@ int __init ip_vs_conn_init(void)
 	max_avail -= 2;		/* ~4 in hash row */
 	max_avail -= 1;		/* IPVS up to 1/2 of mem */
 	max_avail -= order_base_2(sizeof(struct ip_vs_conn));
-	max = clamp(max, min, max_avail);
-	ip_vs_conn_tab_bits = clamp_val(ip_vs_conn_tab_bits, min, max);
+	max = clamp(max_avail, min, max);
+	ip_vs_conn_tab_bits = clamp(ip_vs_conn_tab_bits, min, max);
 	ip_vs_conn_tab_size = 1 << ip_vs_conn_tab_bits;
 	ip_vs_conn_tab_mask = ip_vs_conn_tab_size - 1;
 
-- 
2.30.2


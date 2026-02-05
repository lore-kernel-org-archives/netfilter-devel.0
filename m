Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71853ACA6C;
	Thu,  5 Feb 2026 11:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770289804; cv=none; b=Dlr3hB8X0t+RjRaXIW8lPelYOFFZHsYTps2GPkSlEVKAjaG2pz6V7FFztj7uiw9zoj5+xfrlenF3vuFKGhC8gZ7xsCQVUWx2d8hFweoHZle9CjwLiX0tjxE9UTI2AX3Q/3QbrkSRVMAnYKE43Uo3Iv/67mUiKlxLgXe1st/4bOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770289804; c=relaxed/simple;
	bh=eOwPMXuSN3Uvd0pghwDe/+QshT9FsZzUGwrs9iN0ikU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmFudFoLijeInv6ciz06xjTg2qvSYBvCG9G/2ubyLTvNDpoPvVLm1rq31Wesh6r0LzcbxwI+gPuWmhDTtd879T8/Wt2FzKxHgEaq4nM9hVCYltVZ1DnmWdywnDo8bgxbeYQlj3TO6/yO9jgRWOMGnv/ZNACcXMzNj+1Gofxt6Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 918376092F; Thu, 05 Feb 2026 12:10:02 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 11/11] netfilter: nft_counter: fix reset of counters on 32bit archs
Date: Thu,  5 Feb 2026 12:09:05 +0100
Message-ID: <20260205110905.26629-12-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260205110905.26629-1-fw@strlen.de>
References: <20260205110905.26629-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Anders Grahn <anders.grahn@gmail.com>

nft_counter_reset() calls u64_stats_add() with a negative value to reset
the counter. This will work on 64bit archs, hence the negative value
added will wrap as a 64bit value which then can wrap the stat counter as
well.

On 32bit archs, the added negative value will wrap as a 32bit value and
_not_ wrapping the stat counter properly. In most cases, this would just
lead to a very large 32bit value being added to the stat counter.

Fix by introducing u64_stats_sub().

Fixes: 4a1d3acd6ea8 ("netfilter: nft_counter: Use u64_stats_t for statistic.")
Signed-off-by: Anders Grahn <anders.grahn@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/u64_stats_sync.h | 10 ++++++++++
 net/netfilter/nft_counter.c    |  4 ++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index 849ff6e159c6..f47cf4d78ad7 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -97,6 +97,11 @@ static inline void u64_stats_add(u64_stats_t *p, unsigned long val)
 	local64_add(val, &p->v);
 }
 
+static inline void u64_stats_sub(u64_stats_t *p, s64 val)
+{
+	local64_sub(val, &p->v);
+}
+
 static inline void u64_stats_inc(u64_stats_t *p)
 {
 	local64_inc(&p->v);
@@ -145,6 +150,11 @@ static inline void u64_stats_add(u64_stats_t *p, unsigned long val)
 	p->v += val;
 }
 
+static inline void u64_stats_sub(u64_stats_t *p, s64 val)
+{
+	p->v -= val;
+}
+
 static inline void u64_stats_inc(u64_stats_t *p)
 {
 	p->v++;
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index cc7325329496..0d70325280cc 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -117,8 +117,8 @@ static void nft_counter_reset(struct nft_counter_percpu_priv *priv,
 	nft_sync = this_cpu_ptr(&nft_counter_sync);
 
 	u64_stats_update_begin(nft_sync);
-	u64_stats_add(&this_cpu->packets, -total->packets);
-	u64_stats_add(&this_cpu->bytes, -total->bytes);
+	u64_stats_sub(&this_cpu->packets, total->packets);
+	u64_stats_sub(&this_cpu->bytes, total->bytes);
 	u64_stats_update_end(nft_sync);
 
 	local_bh_enable();
-- 
2.52.0


Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09CB14EC5E;
	Thu, 22 Aug 2024 10:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724321932; cv=none; b=CGhAerYllrUUjfs7jd9eP71FNNtlRGGIdmU+zsIlnkijotHHKgzp1fx02KHKIGH+OL/vS0GU8e+4+eN1Suxh9QMqG4W6CsqOUQZRrW4oQdetI/+fbnpgKof9q87+qmxUZFmQGr4gv3yU+UGdrMaWs9LPhan12qD4W+4XyxpicaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724321932; c=relaxed/simple;
	bh=NTD6YLYA7x1bgFibKVrKX+RosNGeZde4qslPUCQBcsc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=es9fn3kA/v4WdRqNuyxqxC40eFn+HBpgLN50pjtrRvni0bwlUCIHTl2mE7CZ95nupzcIChERfrlH8zVsKtNRd1lGgoXv0al9hnytwC+BkFkH8DskS4wT1vr+6weEPDZo8CSa+a0D5Vs8gxlYfUso+fEEnD/l4CzpBbl8o8YtR1M=
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
Subject: [PATCH net 1/3] netfilter: nft_counter: Disable BH in nft_counter_offload_stats().
Date: Thu, 22 Aug 2024 12:18:40 +0200
Message-Id: <20240822101842.4234-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240822101842.4234-1-pablo@netfilter.org>
References: <20240822101842.4234-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The sequence counter nft_counter_seq is a per-CPU counter. There is no
lock associated with it. nft_counter_do_eval() is using the same counter
and disables BH which suggest that it can be invoked from a softirq.
This in turn means that nft_counter_offload_stats(), which disables only
preemption, can be interrupted by nft_counter_do_eval() leading to two
writer for one seqcount_t.
This can lead to loosing stats or reading statistics while they are
updated.

Disable BH during stats update in nft_counter_offload_stats() to ensure
one writer at a time.

Fixes: b72920f6e4a9d ("netfilter: nftables: counter hardware offload support")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_counter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 291ed2026367..16f40b503d37 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -265,7 +265,7 @@ static void nft_counter_offload_stats(struct nft_expr *expr,
 	struct nft_counter *this_cpu;
 	seqcount_t *myseq;
 
-	preempt_disable();
+	local_bh_disable();
 	this_cpu = this_cpu_ptr(priv->counter);
 	myseq = this_cpu_ptr(&nft_counter_seq);
 
@@ -273,7 +273,7 @@ static void nft_counter_offload_stats(struct nft_expr *expr,
 	this_cpu->packets += stats->pkts;
 	this_cpu->bytes += stats->bytes;
 	write_seqcount_end(myseq);
-	preempt_enable();
+	local_bh_enable();
 }
 
 void nft_counter_init_seqcount(void)
-- 
2.30.2


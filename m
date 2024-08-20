Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178FD1C6A1
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 08:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724141214; cv=none; b=tcWjZ0gp8jPhWwzxCEQSUawKDYaZkLfQD2uKArOFnCoEixHaL5lgqvoI/efV+UrT6nqDi2l5nc1zIBkg6zohbdDnZyvmkt+8ycUJovk89zdNxvPKTpbCnMGhk5x4S+pUuP0YH6H5X1+CRfGv7POnAXcRh3UiqHIPZZKqYWp1LWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724141214; c=relaxed/simple;
	bh=Ef4CBip1JtOYX+Gy5irzHNZ9foL9y8R9Np44rEZQvz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoLsDd6ULaPLnmXh8WrMRONwLCJyGT0ixIbMf9mdWdeX1R7of3h2vBF8XZ+zJ8KGvbzu1mrqjxhZ4ouyh4CLRix4KCaINPOIDS+3pHJ+W5tJCNcfrC/YxRf0Ev5Fb3MSw4lLLutTp7WXBl6SfzPHsjNOycMXmU8lYTb4nxG6TzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=lOBYelxE; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=FbVopfhF; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="lOBYelxE";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="FbVopfhF"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1724141211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OLnGeNvWwQg9Zl3fXaXKnU+a07YVrEpb8t4nsy5w3pQ=;
	b=lOBYelxEnZ6y+wbeKD/Y/agbQ7Iyc7+P2UfyHCyUR517r81xtrwSwpcJ/j2CE45F+WqB14
	q0r5sscw95kcvaDhJl13UfzYuaXWTmTX5kaVCyKqxNIjwFFm5CpOBpETSjDuBIneHO+yEJ
	A+K3XzyqYacc2BkMw4cflui3nn1cksLK1sadaaj0gbP3JQLU0VrylgDgN+6gm9YgvKwGxm
	pkX17ntcU3HuQpb0n8IVfJ/aUuV/GoQ7rS1FV+Iu1zXSfoXI4XqhuLL+WLIU75Dff6uK7t
	jpekcx6oEwPzNf1QE0uE+iUmqSSLKKj4CkSnkM/kFPxFBvRpwB4exp+h9OalkQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1724141211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OLnGeNvWwQg9Zl3fXaXKnU+a07YVrEpb8t4nsy5w3pQ=;
	b=FbVopfhFBrpAvYhUJucgVQqRpW6ANxQQoLfJCCXZcFSfQuCNSczf1smlQ5dK6jqXHvn/Z2
	D/pEXFGcp6V8r9CQ==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net 1/3] netfilter: nft_counter: Disable BH in nft_counter_offload_stats().
Date: Tue, 20 Aug 2024 09:54:30 +0200
Message-ID: <20240820080644.2642759-2-bigeasy@linutronix.de>
In-Reply-To: <20240820080644.2642759-1-bigeasy@linutronix.de>
References: <20240820080644.2642759-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

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

Fixes: b72920f6e4a9d ("netfilter: nftables: counter hardware offload suppor=
t")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/netfilter/nft_counter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 291ed2026367e..16f40b503d379 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -265,7 +265,7 @@ static void nft_counter_offload_stats(struct nft_expr *=
expr,
 	struct nft_counter *this_cpu;
 	seqcount_t *myseq;
=20
-	preempt_disable();
+	local_bh_disable();
 	this_cpu =3D this_cpu_ptr(priv->counter);
 	myseq =3D this_cpu_ptr(&nft_counter_seq);
=20
@@ -273,7 +273,7 @@ static void nft_counter_offload_stats(struct nft_expr *=
expr,
 	this_cpu->packets +=3D stats->pkts;
 	this_cpu->bytes +=3D stats->bytes;
 	write_seqcount_end(myseq);
-	preempt_enable();
+	local_bh_enable();
 }
=20
 void nft_counter_init_seqcount(void)
--=20
2.45.2


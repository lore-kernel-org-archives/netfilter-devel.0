Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954F5143C5B;
	Thu, 13 Jun 2024 11:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279098; cv=none; b=HDgOuqmN78wPc+gsAgzxKT1jHeSFVIZbdSj80+9fypPMj3AeQlvr7RkjR6bH2TAyvgwQB91lxr/JP+sFLp44OuxaKMfswGHTA83IvNdw0K3b8clxcF9+4ZxVYRJLbSTj6mCRPCc1tj+3rRq6KdkmOI907Sec8YpIdt+03ZGkPOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279098; c=relaxed/simple;
	bh=vuUGKXyo3cBW47MCyZgNii3Dq2fDB+TLJdslECmExfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwh6zTSc9aD5kJ/6SOExn+qCuqJl5U0Kz8yBg1cIpI7UF5LHxjSa6ULO2MUv/KFAkLvFOevXAWbc9tHJQB95GA9PbKN554Ug6+ZLRatH6zkMvIO2z3PBbaIyAt9Uge/IjDfUKqZXMlbzn+RiS/+Si5rlzYMWyhR+9p+7qDb8Qqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDJCKGVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDJCKGVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC10C2BBFC;
	Thu, 13 Jun 2024 11:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279098;
	bh=vuUGKXyo3cBW47MCyZgNii3Dq2fDB+TLJdslECmExfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDJCKGVZ0ElpXZ6cLsxFYJsDG1KnI6rM0NUYxo4nghDeS+BUt3hvG5h/vRs1ssvJ7
	 yeLu1HEDqCO3UOfTpZYzm9rIJZ/t5WyD1iG7+UHOFpUGG5sfxR5++BGF+/Y+9RQP5A
	 r0OgG0E5sq/gcQZ1/Fcx9qCG6hgzOiFpeWhP4DEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 4.19 174/213] netfilter: nf_tables: defer gc run if previous batch is still pending
Date: Thu, 13 Jun 2024 13:33:42 +0200
Message-ID: <20240613113234.694621487@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 8e51830e29e12670b4c10df070a4ea4c9593e961 upstream.

Don't queue more gc work, else we may queue the same elements multiple
times.

If an element is flagged as dead, this can mean that either the previous
gc request was invalidated/discarded by a transaction or that the previous
request is still pending in the system work queue.

The latter will happen if the gc interval is set to a very low value,
e.g. 1ms, and system work queue is backlogged.

The sets refcount is 1 if no previous gc requeusts are queued, so add
a helper for this and skip gc run if old requests are pending.

Add a helper for this and skip the gc run in this case.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    5 +++++
 net/netfilter/nft_set_hash.c      |    3 +++
 net/netfilter/nft_set_rbtree.c    |    3 +++
 3 files changed, 11 insertions(+)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -445,6 +445,11 @@ static inline void *nft_set_priv(const s
 	return (void *)set->data;
 }
 
+static inline bool nft_set_gc_is_pending(const struct nft_set *s)
+{
+	return refcount_read(&s->refs) != 1;
+}
+
 static inline struct nft_set *nft_set_container_of(const void *priv)
 {
 	return (void *)priv - offsetof(struct nft_set, data);
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -304,6 +304,9 @@ static void nft_rhash_gc(struct work_str
 	nft_net = net_generic(net, nf_tables_net_id);
 	gc_seq = READ_ONCE(nft_net->gc_seq);
 
+	if (nft_set_gc_is_pending(set))
+		goto done;
+
 	gc = nft_trans_gc_alloc(set, gc_seq, GFP_KERNEL);
 	if (!gc)
 		goto done;
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -618,6 +618,9 @@ static void nft_rbtree_gc(struct work_st
 	nft_net = net_generic(net, nf_tables_net_id);
 	gc_seq  = READ_ONCE(nft_net->gc_seq);
 
+	if (nft_set_gc_is_pending(set))
+		goto done;
+
 	gc = nft_trans_gc_alloc(set, gc_seq, GFP_KERNEL);
 	if (!gc)
 		goto done;



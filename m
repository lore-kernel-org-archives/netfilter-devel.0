Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1223A8C6;
	Fri, 24 Nov 2023 19:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n22cgpCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B36C433C8;
	Fri, 24 Nov 2023 19:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700854114;
	bh=U0l+BXV6oGtyPOhnKbMedkA1DDA/YtlrHAjKQ0zbMVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n22cgpCauTKow0XfwT2yo7t3+4UDic/fP5dLjo2UbdRJuLpWsFshYPeg9KntLNRth
	 Qhdlp9XgU9g4vzULzAaJmepG9fBhtxp/qWq6N1EgGhb+lnFHhbHtw+RfdeEVrAxFLf
	 1Iw/QBbemfEJfMAYqQnT5Q7eGJXdwkkejSj6zmN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.4 149/159] netfilter: nf_tables: defer gc run if previous batch is still pending
Date: Fri, 24 Nov 2023 17:56:06 +0000
Message-ID: <20231124171947.995026410@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -467,6 +467,11 @@ static inline void *nft_set_priv(const s
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
@@ -312,6 +312,9 @@ static void nft_rhash_gc(struct work_str
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
@@ -615,6 +615,9 @@ static void nft_rbtree_gc(struct work_st
 	nft_net = net_generic(net, nf_tables_net_id);
 	gc_seq  = READ_ONCE(nft_net->gc_seq);
 
+	if (nft_set_gc_is_pending(set))
+		goto done;
+
 	gc = nft_trans_gc_alloc(set, gc_seq, GFP_KERNEL);
 	if (!gc)
 		goto done;



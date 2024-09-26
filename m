Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CACB1AE856;
	Thu, 26 Sep 2024 11:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727348858; cv=none; b=tDv3z+ocLz1SFTQ6eXWfXRVtePmoq2P4yHBUchUzGQbgQI19+xZa01XvMkCrsQE6HtlLYT76CcNkEYvLKzl6F4aW/PtJ43b3WWNV7nZCgSM7HHicmFqWJdtADVRY1cxIRAHV52fc4c7m22msEf1acAvVptvxgcMMFGzhB64ZO1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727348858; c=relaxed/simple;
	bh=DldtpoddQ31OJ50MLYMrl2nPFunvsEu8IolvO7djYBw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nH05itWmHjt2OVNIUK4Wyxw2LMFTELvGx1vb9K18urRg9gPsckI8T4i/7YH/70NjhbuYJqVj7L2gTxcmq5eG2zkNYUhwSNxrcMqTXWEAgiYemfsxR9foi3gDEFqqFuvI8sx2m4VFlLKohKjQ4fq4K2ur4698s+WnVNMXLaRbvl0=
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
Subject: [PATCH net 09/14] netfilter: ctnetlink: compile ctnetlink_label_size with CONFIG_NF_CONNTRACK_EVENTS
Date: Thu, 26 Sep 2024 13:07:12 +0200
Message-Id: <20240926110717.102194-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240926110717.102194-1-pablo@netfilter.org>
References: <20240926110717.102194-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Simon Horman <horms@kernel.org>

Only provide ctnetlink_label_size when it is used,
which is when CONFIG_NF_CONNTRACK_EVENTS is configured.

Flagged by clang-18 W=1 builds as:

.../nf_conntrack_netlink.c:385:19: warning: unused function 'ctnetlink_label_size' [-Wunused-function]
  385 | static inline int ctnetlink_label_size(const struct nf_conn *ct)
      |                   ^~~~~~~~~~~~~~~~~~~~

The condition on CONFIG_NF_CONNTRACK_LABELS being removed by
this patch guards compilation of non-trivial implementations
of ctnetlink_dump_labels() and ctnetlink_label_size().

However, this is not necessary as each of these functions
will always return 0 if CONFIG_NF_CONNTRACK_LABELS is not defined
as each function starts with the equivalent of:

	struct nf_conn_labels *labels = nf_ct_labels_find(ct);

	if (!labels)
		return 0;

And nf_ct_labels_find always returns NULL if CONFIG_NF_CONNTRACK_LABELS
is not enabled.  So I believe that the compiler optimises the code away
in such cases anyway.

Found by inspection.
Compile tested only.

Originally splitted in two patches, Pablo Neira Ayuso collapsed them and
added Fixes: tag.

Fixes: 0ceabd83875b ("netfilter: ctnetlink: deliver labels to userspace")
Link: https://lore.kernel.org/netfilter-devel/20240909151712.GZ2097826@kernel.org/
Signed-off-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 8fd2b9e392a7..6a1239433830 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -382,7 +382,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 #define ctnetlink_dump_secctx(a, b) (0)
 #endif
 
-#ifdef CONFIG_NF_CONNTRACK_LABELS
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 static inline int ctnetlink_label_size(const struct nf_conn *ct)
 {
 	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
@@ -391,6 +391,7 @@ static inline int ctnetlink_label_size(const struct nf_conn *ct)
 		return 0;
 	return nla_total_size(sizeof(labels->bits));
 }
+#endif
 
 static int
 ctnetlink_dump_labels(struct sk_buff *skb, const struct nf_conn *ct)
@@ -411,10 +412,6 @@ ctnetlink_dump_labels(struct sk_buff *skb, const struct nf_conn *ct)
 
 	return 0;
 }
-#else
-#define ctnetlink_dump_labels(a, b) (0)
-#define ctnetlink_label_size(a)	(0)
-#endif
 
 #define master_tuple(ct) &(ct->master->tuplehash[IP_CT_DIR_ORIGINAL].tuple)
 
-- 
2.30.2


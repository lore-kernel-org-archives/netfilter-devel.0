Received: from mail-oo1-f100.google.com (mail-oo1-f100.google.com [209.85.161.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9501E369972
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2026 09:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781863093; cv=none; b=fgCAdZ8iou5+S1ofQjO9zvUr8keXh0AiIYGhDTWO5URN0QPjUvCzhJjWi5DJyN/RxFX1ied2MYFzlWrD+J7uFIZeuGN7UbJOS1vdfowPV+B5Bj1VVAgHCeKbQN+LzpDqCezPOPkjmJVe7/De2bAAik4cVELia9rgrPbo/aUEmrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781863093; c=relaxed/simple;
	bh=IEn6N3iU6QjaodYk5qDEpFHlgrN2QjMwqgISplwfHP4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yqb0IQY/vIrCpzCVJ4oZNoud0Fo385xHAfq9E3/mjVN3uaLf13QdPqJ9BmsFPwPJaLmjcOc2EwMarA4xTfc3VuGVlQK652nLcnZ6v98HlCEw+2paPBvsZbvI3ulgXXJyio6xDa9ns/kyAC6Kkp5km2SBfg4GjWhAbEA6H6VgSfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=iO7vLZGs; arc=none smtp.client-ip=209.85.161.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="iO7vLZGs"
Received: by mail-oo1-f100.google.com with SMTP id 006d021491bc7-69e1eae4eb4so1681980eaf.2
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2026 02:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781863086; x=1782467886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0w1vsxUJI0JQJt2Tz8nUeF9KKHPDE+aPNVG7KYxhUoA=;
        b=c/6AEiu0I90NGDL1kV1DpayLOmku7H3haYpDG7dQ5Ml3LdW+8h3nPSkx5IP4OWzquC
         R6/im5VehCk5sZuMzfiu9yTjzRy5dGOGqVqGD4FpliQPCv1IcKFPnAPcnQWvtyR0iCcY
         XCgTQsLN/4Vz3pCNNvUXbd5iI/sZChHi5HFK63cNsUdKvn7QslhoLn4RxuQ7RMj8DBP4
         71eX5Xe+B7Nov96sTI+D9yk2H34bPoEVH1SvdgSmAB63r7oahFnAN61eaY/BQicwkZuE
         J5GEvgEybYc3GcF5G5kWGh5+grZhVSQwCDr0wHqTcdSxSC8vHWqqcWZJHhC6i9Ea/eqf
         uihQ==
X-Forwarded-Encrypted: i=1; AFNElJ/hG1fUmCzXC41SzagyxWAJshDUWN8ROWyov01nRptdAKRBBCTOiKrvlyWVBENN9czXqs/94pRmQQsf4kWSauk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6iZlgKnvPySPSb3khr+jVy9/FM7VSBUyTQqziR1wJlJvI/0p/
	TMcsqShS/QqPgBmZERCldCMOtjtQAZYss0p/D7INn+P6wvmHrr/WbXU+ixzyzsm+GoDPgARr2yb
	gQeddCeYJdO5UAgaY/iIL74aRlM4cVE1W6Zhlic95Bju2e9FKdo7xOyeW380KOjyEHAZWIPhCbV
	WPRXVfgp29mPhrkCBOnRyhoTZ4jbB4oMQfZPT9+S9VT7VftqHBXqpEze+9Lq1WuDKupnTyB0ezA
	NhnMDK7tWb1f9AmTprZSLa+lfn/7g==
X-Gm-Gg: AfdE7cmMSn2cyxRnErr1B33rZGROuukvKVOurJHz+LxdaSql4/ecFjlKN5vftC3PXTz
	5ayDrdOoQN5hU8fkBt/NPKF+CgIRwlqbNz8k93ghG2Z1R7uGPP7g9iwBOHwEKWM9SHlz9rR0CxN
	4BCui/I5VWNWVlpOkTVQJqlNL8yxZlb4Fq5SR2PLsgOMbAHKX2YhSbwpOcJHBL5Y6+MBpxGFk+Y
	S8Vxx47XpvXC2/AcLxNQRshVTyVpetyJoH32990cmrmcbcyp2e/K4MDxqLDA4KbJl/JZ311xeCc
	0YWeGcsw0NeQn3f8Pr6z0uGDZe5qxsCcPkmv+BBCXPOuRQuMqIykOTMaotraMFCYufJXlyznRO+
	KKsixTyndsj6i6DC8QieIft2dy6XAC9KuHN0JgEDq3iLg5cYVulmwaiUdoflosbBZ2XxaXn/IR6
	RShDYiDP5yxcnLfuDxRbIo10HG1zD++QVsHQf+0Eb9tJJ/Fhx2XA==
X-Received: by 2002:a05:6820:c86:b0:68a:f494:e8fc with SMTP id 006d021491bc7-6a0de08c9admr1256577eaf.33.1781863086214;
        Fri, 19 Jun 2026 02:58:06 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-23.dlp.protect.broadcom.com. [144.49.247.23])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-6a0e09e3962sm40221eaf.5.2026.06.19.02.58.05
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jun 2026 02:58:06 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30bc5f826f2so3635435eec.1
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2026 02:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1781863084; x=1782467884; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0w1vsxUJI0JQJt2Tz8nUeF9KKHPDE+aPNVG7KYxhUoA=;
        b=iO7vLZGsqBmIVTW+0pGPaSRRyUP+dpNZEw7S/eShSb6pHeSLVi+tJjCdWGaoN9xK+v
         L2h9loLIDatlYzUNDzHY8mSShqyJVnmssLWSYrztxv3h0Ruk22di6NIPRZ/2e54+2+uI
         fd75CLXiGO6rxWGpqiM1J7urB34kAFjJ/uT2k=
X-Forwarded-Encrypted: i=1; AFNElJ/1RQT6UHKxnTa+jhhSbrzgwXxOlnC9uVHXjvbxqZzhTeA4RgWrfPcf1mlqp3S7k7iwHuV6h3NnK7lnOYIp3fw=@vger.kernel.org
X-Received: by 2002:a05:7300:7fa7:b0:2fc:9d97:d59a with SMTP id 5a478bee46e88-30c0d17fb0emr888587eec.32.1781863084404;
        Fri, 19 Jun 2026 02:58:04 -0700 (PDT)
X-Received: by 2002:a05:7300:7fa7:b0:2fc:9d97:d59a with SMTP id 5a478bee46e88-30c0d17fb0emr888572eec.32.1781863083755;
        Fri, 19 Jun 2026 02:58:03 -0700 (PDT)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c06d5bec5sm1851910eec.26.2026.06.19.02.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 02:58:03 -0700 (PDT)
From: Shivani Agarwal <shivani.agarwal@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	yin.ding@broadcom.com,
	tapas.kundu@broadcom.com,
	Sasha Levin <sashal@kernel.org>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH v6.1 2/3] netfilter: nf_tables: fix set size with rbtree backend
Date: Fri, 19 Jun 2026 02:28:49 -0700
Message-Id: <20260619092850.1274076-3-shivani.agarwal@broadcom.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260619092850.1274076-1-shivani.agarwal@broadcom.com>
References: <20260619092850.1274076-1-shivani.agarwal@broadcom.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 8d738c1869f611955d91d8d0fd0012d9ef207201 ]

The existing rbtree implementation uses singleton elements to represent
ranges, however, userspace provides a set size according to the number
of ranges in the set.

Adjust provided userspace set size to the number of singleton elements
in the kernel by multiplying the range by two.

Check if the no-match all-zero element is already in the set, in such
case release one slot in the set size.

Fixes: 0ed6389c483d ("netfilter: nf_tables: rename set implementations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[ Shivani: Modified to apply on 6.1.y ]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
---
 include/net/netfilter/nf_tables.h |  6 ++++
 net/netfilter/nf_tables_api.c     | 49 +++++++++++++++++++++++++++++--
 net/netfilter/nft_set_rbtree.c    | 43 +++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index dafa0a32e..3329c2eae 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -422,6 +422,9 @@ struct nft_set_ext;
  *	@remove: remove element from set
  *	@walk: iterate over all set elements
  *	@get: get set elements
+ *	@ksize: kernel set size
+ *	@usize: userspace set size
+ *	@adjust_maxsize: delta to adjust maximum set size
  *	@privsize: function to return size of set private data
  *	@init: initialize private data of new set instance
  *	@destroy: destroy private data of set instance
@@ -470,6 +473,9 @@ struct nft_set_ops {
 					       const struct nft_set *set,
 					       const struct nft_set_elem *elem,
 					       unsigned int flags);
+	u32				(*ksize)(u32 size);
+	u32				(*usize)(u32 size);
+	u32				(*adjust_maxsize)(const struct nft_set *set);
 	void				(*commit)(struct nft_set *set);
 	void				(*abort)(const struct nft_set *set);
 	u64				(*privsize)(const struct nlattr * const nla[],
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ec4bfe53b..15bfdf07c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4264,6 +4264,14 @@ static int nf_tables_fill_set_concat(struct sk_buff *skb,
 	return 0;
 }
 
+static u32 nft_set_userspace_size(const struct nft_set_ops *ops, u32 size)
+{
+	if (ops->usize)
+		return ops->usize(size);
+
+	return size;
+}
+
 static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			      const struct nft_set *set, u16 event, u16 flags)
 {
@@ -4328,7 +4336,8 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	if (!nest)
 		goto nla_put_failure;
 	if (set->size &&
-	    nla_put_be32(skb, NFTA_SET_DESC_SIZE, htonl(set->size)))
+	    nla_put_be32(skb, NFTA_SET_DESC_SIZE,
+			 htonl(nft_set_userspace_size(set->ops, set->size))))
 		goto nla_put_failure;
 
 	if (set->field_count > 1 &&
@@ -4698,6 +4707,15 @@ static bool nft_set_is_same(const struct nft_set *set,
 	return true;
 }
 
+static u32 nft_set_kernel_size(const struct nft_set_ops *ops,
+			       const struct nft_set_desc *desc)
+{
+	if (ops->ksize)
+		return ops->ksize(desc->size);
+
+	return desc->size;
+}
+
 static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
@@ -4880,6 +4898,9 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (err < 0)
 			return err;
 
+		if (desc.size)
+			desc.size = nft_set_kernel_size(set->ops, &desc);
+
 		err = 0;
 		if (!nft_set_is_same(set, &desc, exprs, num_exprs, flags)) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_NAME]);
@@ -4902,6 +4923,9 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (IS_ERR(ops))
 		return PTR_ERR(ops);
 
+	if (desc.size)
+		desc.size = nft_set_kernel_size(ops, &desc);
+
 	udlen = 0;
 	if (nla[NFTA_SET_USERDATA])
 		udlen = nla_len(nla[NFTA_SET_USERDATA]);
@@ -6327,6 +6351,27 @@ static bool nft_setelem_valid_key_end(const struct nft_set *set,
 	return true;
 }
 
+static u32 nft_set_maxsize(const struct nft_set *set)
+{
+	u32 maxsize, delta;
+
+	if (!set->size)
+		return UINT_MAX;
+
+	if (set->ops->adjust_maxsize)
+		delta = set->ops->adjust_maxsize(set);
+	else
+		delta = 0;
+
+	if (check_add_overflow(set->size, set->ndeact, &maxsize))
+		return UINT_MAX;
+
+	if (check_add_overflow(maxsize, delta, &maxsize))
+		return UINT_MAX;
+
+	return maxsize;
+}
+
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr, u32 nlmsg_flags)
 {
@@ -6671,7 +6716,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
-		unsigned int max = set->size ? set->size + set->ndeact : UINT_MAX;
+		unsigned int max = nft_set_maxsize(set);
 
 		if (!atomic_add_unless(&set->nelems, 1, max)) {
 			err = -ENFILE;
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 426becaad..26e1d994f 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -775,6 +775,46 @@ static bool nft_rbtree_estimate(const struct nft_set_desc *desc, u32 features,
 	return true;
 }
 
+/* rbtree stores ranges as singleton elements, each range is composed of two
+ * elements ...
+ */
+static u32 nft_rbtree_ksize(u32 size)
+{
+	return size * 2;
+}
+
+/* ... hide this detail to userspace. */
+static u32 nft_rbtree_usize(u32 size)
+{
+	if (!size)
+		return 0;
+
+	return size / 2;
+}
+
+static u32 nft_rbtree_adjust_maxsize(const struct nft_set *set)
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+	struct nft_rbtree_elem *rbe;
+	struct rb_node *node;
+	const void *key;
+
+	node = rb_last(&priv->root);
+	if (!node)
+		return 0;
+
+	rbe = rb_entry(node, struct nft_rbtree_elem, node);
+	if (!nft_rbtree_interval_end(rbe))
+		return 0;
+
+	key = nft_set_ext_key(&rbe->ext);
+	if (memchr(key, 1, set->klen))
+		return 0;
+
+	/* this is the all-zero no-match element. */
+	return 1;
+}
+
 const struct nft_set_type nft_set_rbtree_type = {
 	.features	= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_OBJECT | NFT_SET_TIMEOUT,
 	.ops		= {
@@ -791,5 +831,8 @@ const struct nft_set_type nft_set_rbtree_type = {
 		.lookup		= nft_rbtree_lookup,
 		.walk		= nft_rbtree_walk,
 		.get		= nft_rbtree_get,
+		.ksize		= nft_rbtree_ksize,
+		.usize		= nft_rbtree_usize,
+		.adjust_maxsize = nft_rbtree_adjust_maxsize,
 	},
 };
-- 
2.53.0


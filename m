Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F31330EF80
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Feb 2026 21:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770067603; cv=none; b=DSnXgm5iWsrznFR4OOpOOKxdt3ysHhbTXERjJkwnlGuxFf7812jYOEBSlXoFsq/H2E4WhwTdqbKaVI8mZvSCoTjpAZvpfClr2kLLGFPaArxUG7Iqi2VfAaIVN3bRjq7u3sUW25aQy0fAcJ8FCW0Q5v14gSnzLAVcM5Yeb/AIKYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770067603; c=relaxed/simple;
	bh=1ziz7Wc4bfFdOxa66/ktbC/Hb/IpAV3WM1PA4bB+Lu4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBKp1vQtkn/HwQRHUm6mbKgSlwsBbqUyg5aU5KYRNeinK9fqCsLr0MR3QQC40ZHn0iXTmOC6xAKxHOs21EXxJEuyK/9dWUbswoo/Oj68f2JhcWGb4jPr/JJWWekamP5lcx1E8F4EWSPYvLZuIAu6iYgao7+wh8hqkAV1sSpOYdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=S0MO3aZO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="S0MO3aZO"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 081FD605BF
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Feb 2026 22:26:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770067593;
	bh=t4EjRceNpcr2eIuJnakuL9jpxQoaHOTUiSY3xma+KNc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=S0MO3aZO+598Rbv4F5v7c1Kqcn5ydgjKL+pJad8idhS/9pniKmD1mrBftooCJyOwR
	 jCc3AktSF4oQx9LzI/wl3bMtQFo13eTSiWKQLqpkRCL6T+2usOCL/oslySethlaj5e
	 8tQaEXi2AvLrgKOU0V9cbik/7FInqMWIp+BJgBEqk5TZ2J00kyFMhKOLveiqomRn3y
	 TgwbhbfR7tULJQ1YT+MpmbJzWMC/UtbVsejrMqAEAGpsK0MZyfy2YVhS7WwWak9CS1
	 yqAA3NAIzhsg5xewpVQlB1nG3IoAgxGgPeKnq95nn2ut7wwjh5LDctIh2CWIohuDvE
	 nN9YtaxQnL2kw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 1/4] netfilter: nft_set_rbtree: fix bogus EEXIST with NLM_F_CREATE with null interval
Date: Mon,  2 Feb 2026 22:26:24 +0100
Message-ID: <20260202212627.946625-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202212627.946625-1-pablo@netfilter.org>
References: <20260202212627.946625-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Userspace adds a non-matching null element to the kernel for historical
reasons. This null element is added when the set is populated with
elements. Inclusion of this element is conditional, therefore,
userspace needs to dump the set content to check for its presence.

If the NLM_F_CREATE flag is turned on, this becomes an issue because
kernel bogusly reports EEXIST.

Add special case to ignore NLM_F_CREATE in this case, therefore,
re-adding the nul-element never fails.

Fixes: c016c7e45ddf netfilter: nf_tables: honor NLM_F_EXCL flag in set element insertion
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 net/netfilter/nf_tables_api.c  |  5 +++++
 net/netfilter/nft_set_rbtree.c | 13 +++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2750336b6f28..a3649d88ac64 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7635,6 +7635,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			 * and an existing one.
 			 */
 			err = -EEXIST;
+		} else if (err == -ECANCELED) {
+			/* ECANCELED reports an existing nul-element in
+			 * interval sets.
+			 */
+			err = 0;
 		}
 		goto err_element_clash;
 	}
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 7598c368c4e5..345d51dc4a89 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -53,6 +53,13 @@ static bool nft_rbtree_interval_start(const struct nft_rbtree_elem *rbe)
 	return !nft_rbtree_interval_end(rbe);
 }
 
+static bool nft_rbtree_interval_null(const struct nft_set *set,
+				     const struct nft_rbtree_elem *rbe)
+{
+	return (!memchr_inv(nft_set_ext_key(&rbe->ext), 0, set->klen) &&
+		nft_rbtree_interval_end(rbe));
+}
+
 static int nft_rbtree_cmp(const struct nft_set *set,
 			  const struct nft_rbtree_elem *e1,
 			  const struct nft_rbtree_elem *e2)
@@ -389,6 +396,12 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	 */
 	if (rbe_le && !nft_rbtree_cmp(set, new, rbe_le) &&
 	    nft_rbtree_interval_end(rbe_le) == nft_rbtree_interval_end(new)) {
+		/* - ignore null interval, otherwise NLM_F_CREATE bogusly
+		 *   reports EEXIST.
+		 */
+		if (nft_rbtree_interval_null(set, new))
+			return -ECANCELED;
+
 		*elem_priv = &rbe_le->priv;
 		return -EEXIST;
 	}
-- 
2.47.3


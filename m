Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD631251793
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 01:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564583; cv=none; b=FrbuqGO7IBFZ8HVF81paepw+gPj7XekK0DbxRYk5eE8geKms1ytmamazPAoQ35GvQFoSJUT/xgxzvpV+yjQoPImvafMDxXHHRoOGveu86Z0yWY8bJnBoY/Yqq0iwRwaKS7m/7lPyuC47Kt17vpJsVPUQCdvfatL2ZqXFtRF3dBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564583; c=relaxed/simple;
	bh=SCt7LbXi9vZqHDvPGbOYBT1sN45qK9mqSU/bZVAHqHw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5BCq7T4XHXauWuF5HELGQa0LrtxLm1x2wxHd5fy0m8+cT9kJugY9+ERIdJRiP8ULjHCP8uxQHj7OXr9JYvlU20g1km8rmWZuNWWk2p1cdORfu/kmbQH0xGh3w44Vx8tfnZYHRG60xYy6+uKuPk6JAb+QvwNEOCQIHJAN1GrREo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FpJXrkDi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FpJXrkDi"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1710260181
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 02:43:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1769564580;
	bh=fd7rG6nvgP01RhIoVJNKvHhffkxsX7U3LsViOsnawvw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FpJXrkDi+5gHhcsmLYYdr3tt148J4p1cjWnhL8wOUicCTe/cmhdx6eurlURVqZJ+R
	 lO4uodOtZPztVp7Sv412VOvpifMZgHeoWj3Ko+jGHmkfHSC0fiyFDn3uyh/bCrCi3c
	 KsKZUy2ycl8et7DCxRKLY9Svfklo5eAsOdb3j6xG8wyLkri8gMWUfPPr8pZYwgmbyy
	 O/inYMN0FkJv+FrYwfiKMTJFBi8yJdJo5ayDfEjNP38xbr/6kHEni4lxzJoMF55GYw
	 tOoh7IUzW89xIbpv2VSDTo8wBzjHmzWdJF5Ukyq4aoRY5Rq4rxcaI1Oe7B3QZkedEL
	 DEmlUpgRGrm1w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/4] netfilter: nft_set_rbtree: fix bogus EEXIST with NLM_F_CREATE with null interval
Date: Wed, 28 Jan 2026 02:42:48 +0100
Message-ID: <20260128014251.754512-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260128014251.754512-1-pablo@netfilter.org>
References: <20260128014251.754512-1-pablo@netfilter.org>
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


Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B0747D93C
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jul 2026 12:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782995604; cv=none; b=JilyHbo2PB8I13fDazljQr+/+mAgWzDnDouHJ5KkzoVl3qAEfkFk3wJstUHPtZRHILGTLWVru9Mca2qJwE8wOCf6S3ik81uxSrA/No1B2mk/grNcnk+fX5Xc1BBgMTEBVdRH/9tf0jI0axDm0MVApo5OCr/uea1LUL6UDGL5lG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782995604; c=relaxed/simple;
	bh=L/9RjfMSoGGczuCmSsc1TZhkWQ2jSiEzF+jSOPgI1Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S9HO9SmkZN+nxSzEPkz/zget1E1hN6RUklUOq7+BM1Vgt9jLWJEBQjU+82dl6SRL+UX8hIepMyOPmf1A8i1R8eIMSkhgnTl2FeSwwUoidMPO32vMzoB8L6427z/QtLvmZ7NPjKO/5YcXd0ng2J9rVSRQjXFaQCoiZSlBXhO0lqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=X+sGuk3T; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="X+sGuk3T"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8F31C6057B;
	Thu,  2 Jul 2026 14:33:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782995593;
	bh=IrIqCy7gQz9HZUk89Auf+MlsOdvCQDv7uR7EjyKu5kQ=;
	h=From:To:Cc:Subject:Date:From;
	b=X+sGuk3TUYB+XdhZs9DNOsIlPu0eckcgrUUZbOvhNceQexKFuccUFlwDISAPgTzal
	 n63ZpMbWTj4bhGnE96JA7RhbYsVoO2fcTNlE5GO7Q9wqIFnE4ltQ2ebMK9xfvPm6Gx
	 79AlK+cqbsvuQbhlJqFbJpNWc2omS36HB9XevgK8KO47/eHiwmcFeCjnOmQwncNE/J
	 RONinwiJ1dymBrpxDyicTJhaDDEILjhj+8bassy6jYJGcG+eCMVfIB7zdpOA39JJUx
	 Ki93tlb7JM9LV8HgUVxWJR/dVLpS8uVf3rA6ti/wnxLe2HisIGT9X0XrGTlJu4NbEt
	 6hfi8yRBbnotw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] netfilter: nft_set_rbtree: get command skips end element with open interval
Date: Thu,  2 Jul 2026 14:33:09 +0200
Message-ID: <20260702123309.349594-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The get command on intervals provide partial matches such as subranges
for usability reasons. However, an open interval has no closing end
element. If the closing element matches within the range of the open
internal, ie. its closest match is the start element of the open range,
then, return 0 but offer no matching element to userspace through
netlink as a special case. Userspace provides at least a matching start
element in this case and the closing end element matching the open
interal is ignored.

Another possibility is to report the matching start element of the open
interval for this end interval. However, this results in duplicated
matching being listed in userspace because userspace does not expect a
start element as response to a end element.

Fixes: 2aa34191f06f ("netfilter: nft_set_rbtree: use binary search array in get command")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c  | 3 +++
 net/netfilter/nft_set_rbtree.c | 8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4884f7f7aaee..a9eaf9455c77 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6563,6 +6563,9 @@ static int nft_get_set_elem(struct nft_ctx *ctx, const struct nft_set *set,
 	if (err < 0)
 		return err;
 
+	if (!elem.priv)
+		return 0;
+
 	err = -ENOMEM;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (skb == NULL)
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 018bbb6df4ce..6222e9bb57bc 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -184,10 +184,14 @@ nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	if (!interval || nft_set_elem_expired(interval->from))
 		return ERR_PTR(-ENOENT);
 
-	if (flags & NFT_SET_ELEM_INTERVAL_END)
+	if (flags & NFT_SET_ELEM_INTERVAL_END) {
+		if (!interval->to)
+			return NULL;
+
 		rbe = container_of(interval->to, struct nft_rbtree_elem, ext);
-	else
+	} else {
 		rbe = container_of(interval->from, struct nft_rbtree_elem, ext);
+	}
 
 	return &rbe->priv;
 }
-- 
2.47.3


Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03F92980D3
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Apr 2025 19:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745351594; cv=none; b=WWX5EwyRsfgMnvt/yuvAhPzWVCzWIujnbyu2SZH2Em7BSonCncf2mPetqRgU9BSCof4zmrQ1DIhcyQjga43A1CwW0MNs9HkvTCxFRdZlRh//6FEp/5+YlEwbFe7enonV9HOYwU15bCTOCm9dbKsIEQ/OUMqVE0ZPYpwe4f8FtZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745351594; c=relaxed/simple;
	bh=HHBWUoqLwLfzbiD/G5qb6Ve89T5kcVj3f34yReTGNtg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dw2H7lzV1wTxENjk5yPwcfJB/a489T8EUgx4ZVYdas9vFLI1cZU0GjugiHYBGpv08d+Gb5iXqLve4+7w/B/8EGhFZeOE3e1bsw07HYCciU2Qtg68rO/1c9IvEPhsvkFtpZVdjsOUKhFjYKxJHMjgUg+/qXXMv5qOZSH7kookP6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=u3/UwnWJ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JzluCHEx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="u3/UwnWJ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JzluCHEx"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2A76860926; Tue, 22 Apr 2025 21:53:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745351582;
	bh=IBit/rYpegMxa+gLX0mMx4udsePlNTGidd00wy3tdJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3/UwnWJglxeOH3iJnArSR21V1eeNEmAYppH/m9J3x8I7rToCgviRfe4O9jW970e7
	 OiipBWnz8sxGWpSP0by9RZ8+7AfxRSSD6Ln8WeiL5CPLuo4KJhyDNvNWTQjB+8O0PR
	 M+VdKgVexUKv2PKWACyLrlXG/MeEuH4piXT04WRtpljYoSRW7+eyf5KFzc/p/KCloh
	 ogPmUuIeS6p91djV7Tzzbk2MzHNNeJlq1u9OOzPhlbu+KItM3UkB1J8nhe2CAnsohO
	 2Q57AzHbhg8V8S5HWBwbQkp1fWIYzPhyf6k4F+xIhUjx6uF26734efL0qJULMJs28F
	 2msDQTlkHr4/g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 85D4960915;
	Tue, 22 Apr 2025 21:53:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745351581;
	bh=IBit/rYpegMxa+gLX0mMx4udsePlNTGidd00wy3tdJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JzluCHExF0qQM/qCPPYEIuxz32euvI9+2rLNu3p3KEVlDYAzaELzluO60Gf8CLn5A
	 hiIHXK00kv8YQ/gsTpE1HVwaXhyTnMJfRBOHLViYoXPzfvSaS33JfCeKn5WPuEl0/N
	 Tjf5KUheiJYCJk8aN2FS3sD+OvP2MuRv5CVgyZWar+zD/rJ8Faia4JBCyt6sfZbFpi
	 nCprXVDyAiJ8iLTjgBBym7ox/8H9TDn8bgluv/IsmOjdnHP5qAn+iXlNzXbKDhO7qk
	 RsLgpJyf3yY6TmcwVa1QXHm+prVc4h1uhE2Xu6y3hspz1ES/XPbCbYIWIVoWMYhcRH
	 4LybGJ9dFrSOA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: sbrivio@redhat.com
Subject: [PATCH nf-next,v2 2/2] netfilter: nft_set_pipapo: clamp maximum map bucket size to INT_MAX
Date: Tue, 22 Apr 2025 21:52:44 +0200
Message-Id: <20250422195244.269803-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250422195244.269803-1-pablo@netfilter.org>
References: <20250422195244.269803-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise, it is possible to hit WARN_ON_ONCE in __kvmalloc_node_noprof()
when resizing hashtable because __GFP_NOWARN is unset.

Similar to:

  b541ba7d1f5a ("netfilter: conntrack: clamp maximum hashtable size to INT_MAX")

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 net/netfilter/nft_set_pipapo.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 0529e4ef7520..c5855069bdab 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -663,6 +663,9 @@ static int pipapo_realloc_mt(struct nft_pipapo_field *f,
 	    check_add_overflow(rules, extra, &rules_alloc))
 		return -EOVERFLOW;
 
+	if (rules_alloc > (INT_MAX / sizeof(*new_mt)))
+		return -ENOMEM;
+
 	new_mt = kvmalloc_array(rules_alloc, sizeof(*new_mt), GFP_KERNEL_ACCOUNT);
 	if (!new_mt)
 		return -ENOMEM;
@@ -1499,6 +1502,9 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
 		if (src->rules > 0) {
+			if (src->rules_alloc > (INT_MAX / sizeof(*src->mt)))
+				goto out_mt;
+
 			dst->mt = kvmalloc_array(src->rules_alloc,
 						 sizeof(*src->mt),
 						 GFP_KERNEL_ACCOUNT);
-- 
2.30.2


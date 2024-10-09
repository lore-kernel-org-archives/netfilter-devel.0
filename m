Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA4E1A2630
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 17:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728494870; cv=none; b=NgEGYsDNOGiFA8dQGdhno8tJUk+2aH3GosLmNnHnaCGxpZdi6BozeyV1Nwl/Yx3yslpnhmlhi1T6YQsfbWLSFYqBf1ORICnR7lq4GmeXi+D0HUvRvCBdYXQeKhSphAd/rUgd5Fh4Yx9YPSZLYqpLDmnBbBNhF0hyOlV8Q6brG18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728494870; c=relaxed/simple;
	bh=vC7AOMKOHttk1F27577Klr3Y9W1nRwD+fGnZarVQF8o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjIag+EkJFu06YoMyiVbcMmqpPcXITrmLvkOx1v6C4H+WoGailOpFDuwnnnfCH8lTUXup4ngFlKQyYxw6DSiIqMfuy1zMRHWsC/WeSmgZIlef2ELIU0o/lMZnxWazFGg07zAuwlRNd/rpP754OGVUl3sylumSTXxAlfnzYguPAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LlN0t9QT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LlN0t9QT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9yAlKDM//vOD9HnGD7gwM0gALWp1+AwLdSS/yhigpyc=; b=LlN0t9QTxVnO/iwad08719OQrF
	9raJRx5oMDpNhEV7YebtVHlFJnVvTBd3If784Mm7ef2+5lJHdbzIza5jyOW+cTGE9ecEQukBqi3KT
	8z/WprMPJttuoB3V1A/kmiwZEe+Ix1hDmiw+cZVb99PYUXYNPB55EwSsKQkgE7J2gdinHLb5EUTlM
	WwQtelWboYQEG8XIz+ABkYElOd0Q0I2iCqmFUeBdJOpDOriT/6ZW9u12S+GNXZZcthd/HDKIZFKHy
	GFzvzlZG9K5R4CH5/6RsWGCuxMFwBWrS1GpOG9XLKKFJZEuYlXqlqrqyWHDECTD8jKEYiCpwVUH2H
	6URTUcSA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syaTR-000000007Cu-3mLA
	for netfilter-devel@vger.kernel.org;
	Wed, 09 Oct 2024 19:27:45 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/3] nft: Fix for -Z with bogus rule number
Date: Wed,  9 Oct 2024 19:27:39 +0200
Message-ID: <20241009172740.2369-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241009172740.2369-1-phil@nwl.cc>
References: <20241009172740.2369-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The command is supposed to fail if no rule at given index is found.
While at it, drop the goto and label which are unused since commit
9b896224e0bfc ("xtables: rework rule cache logic").

Fixes: a69cc575295ee ("xtables: allow to reset the counters of an existing rule")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index d563a011bec5d..908f544319b74 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2994,7 +2994,6 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
 		.command = NFT_COMPAT_RULE_APPEND,
 	};
 	struct nft_chain *c;
-	int ret = 0;
 
 	nft_fn = nft_rule_delete;
 
@@ -3007,8 +3006,7 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
 	r = nft_rule_find(h, c, NULL, rulenum);
 	if (r == NULL) {
 		errno = ENOENT;
-		ret = 1;
-		goto error;
+		return 0;
 	}
 
 	if (h->ops->init_cs)
@@ -3021,10 +3019,7 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
 	if (!new_rule)
 		return 1;
 
-	ret = nft_rule_append(h, chain, table, new_rule, r, false);
-
-error:
-	return ret;
+	return nft_rule_append(h, chain, table, new_rule, r, false);
 }
 
 static void nft_table_print_debug(struct nft_handle *h,
-- 
2.43.0


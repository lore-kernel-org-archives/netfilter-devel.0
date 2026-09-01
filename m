Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBDD39021C
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 21:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788298528; cv=none; b=EjcRS6ZhPi4P1OfvkzQWmlv8J0phMPDAgRHYwItRyUCKoXRHEQELN1G2VnkzjZpYvlLcgagxC/MPKqfc11EwvCeYnt+CJ6K7gW78JWZwFNrjh5k3nlN31qQHA8AM6nA8NgreAPNHenroWEthEcgZuUMJAraWLKn2Mn6jp14piwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788298528; c=relaxed/simple;
	bh=FSKeNrek7O2cZLTij/LYOY6H33ZdePrVjNzDaFOtaMA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cl1KBFN5INBthPdmJW1I5bnY2iHGPuIDuS0pWklrIbQqnKT6TiNilGu2nrwoigS0XRrDpagNlqbUgT8WQdID9nhQ/v7cGP6X34kcTUxbqCRLIWY7ueU9UbTjmoHMANnj0ltsf1xyVnD1/uJhIkE3lSuGsJaR+F64/84CeuVVa2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KAcQVmHQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KAcQVmHQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788298523;
	bh=hvFschykeMlj3QsO10x96zBe0X+2cVvQXLheEMmqLD4=;
	h=From:To:Cc:Subject:Date:From;
	b=KAcQVmHQcUjOez+LvKbHD+A98v5pm7gRbCyQG1K3SVUzp24D9Q50geFnyhZGv/L9R
	 h5ErF9DFUlDHQGy+zs1ISCulyqGWxlUu7VJBQ32xHTso8SseTMHwr3l3TAXhYvD1Bq
	 lXAP1ba5shJYqNPK/4SfWCilKP7xjoHPIw/RhCG9GsTO/rHvNEu2cwsSyjRVYNpOg/
	 29OMqKGbE+U24lTSAydqyCJQ8qS2vWBhRS6s/mIWlCOeWaZR8GEsu+R1AlIAw8Y+UG
	 CWyQFbFnoog+zm9ZNJiZKGtIrihmHu0IZWjvA7A5mgN5Gmd1bFS0QHsJaHvU9y5iHW
	 +PLv6cODMQwRw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1260E6076C;
	Tue,  1 Sep 2026 23:35:22 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] netfilter: nf_nat: unregister and release hooks on error
Date: Tue,  1 Sep 2026 23:35:19 +0200
Message-ID: <20260901213519.945074-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After the base nat hooks are registered, the first nested nat hook is
added through nf_hook_entries_insert_raw() and ->users is bumped.

However, sashiko reports that nf_hook_entries_insert_raw() fails, then
->users count remains at zero and nf_nat_unregister_fn() could hit
WARN_ON() since base nat hooks with no users is unexpected in the
unregistration path.

Fixes: 1cd472bf036c ("netfilter: nf_nat: add nat hook register functions to nf_nat")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_core.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 8ac326e1eb5b..71027754b5ab 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1240,15 +1240,25 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 	nat_ops = nat_proto_net->nat_hook_ops;
 	priv = nat_ops[hooknum].priv;
 	if (WARN_ON_ONCE(!priv)) {
-		mutex_unlock(&nf_nat_proto_mutex);
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto err_out;
 	}
 
 	ret = nf_hook_entries_insert_raw(&priv->entries, ops);
-	if (ret == 0)
-		nat_proto_net->users++;
+	if (ret)
+		goto err_out;
 
+	nat_proto_net->users++;
 	mutex_unlock(&nf_nat_proto_mutex);
+
+	return 0;
+err_out:
+	if (nat_proto_net->users == 0) {
+		nf_unregister_net_hooks(net, nat_ops, ops_count);
+		mutex_unlock(&nf_nat_proto_mutex);
+		kfree_rcu(nat_ops, rcu);
+	}
+
 	return ret;
 }
 
-- 
2.47.3


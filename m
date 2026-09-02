Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57924456DFD
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 23:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788391744; cv=none; b=DMP9BoD4F96hsDYMydt/Sr1JGglXa1R+0NrfQv9L7vryC7mdFBEl8iPbhFH3KgpudlEkRcl0afLe1z5BRK/firbcslYCEgqRFe1JYy7CebILf1imxwacB/UvFOY4U2CZ1ls5P/eiO0RTq3aTgYoJxWnql+Mkr1OeGCCN32Oe4XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788391744; c=relaxed/simple;
	bh=LL8pbPdrWbhhlH+5ffJWUChV53Z+3Rw3I0onLUflIE8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=uJqSCHf+rjNOtDeBBt6JOPfO8nT2mpMYn8DT3z/Ekn0NThwGtd2WTjuVXdQ53Ewg4H+dGFmR6M/d6NYx0zhCs8MreAzfTXX0EblHjeIrkD6OJ6YCRSsGHvZlFPAq7W1B9JJhtalcoTu7sZlPYkWT1vl2rHNViea3WejHMIkshqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ox73vmJJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ox73vmJJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788391739;
	bh=neY56JQMPcLC3MCc9wXvRxN37SAej1AxhR+6MkKn7ZU=;
	h=From:To:Subject:Date:From;
	b=ox73vmJJc+1OT8Hmjuf3pLKOJhnD4rGfhEhk1c9IlBnTwpmj0EN0UYxzph2qJVexc
	 s5NCCqBhZ8nzLGyySRgHgBp9jwQl1dnrXziJYljvduOCkliFqFHqVomw1LgRD3affs
	 ro+8N47+KSVWRdmEnuHVThHaXQEVNR/U1GqX3BEeZaoTg5HhuGdoKMh0W2Q/mNRLQ7
	 8qJajYwKoNHbXTZzJiT6WiL/r2DSXDvKmtzCW0rHmOxXKfRPblEjE1MTI6tNO6pz0Y
	 a2etWQmNmXN8N3of/nfYlKiQyRs/1usQJuKOqV8cd1tKZf4DPmoZjvjLmpkfokSWFn
	 LWH2ssVk4/bLg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 80612607A7
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 01:28:59 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3] netfilter: nf_nat: unregister and release hooks on error
Date: Thu,  3 Sep 2026 01:28:56 +0200
Message-ID: <20260902232856.1024959-1-pablo@netfilter.org>
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

Postpone setting nat_proto_net->nat_hook_ops when the hooks are
registered to simplify the error path to decide whether the nat hooks
need unwinding.

Fixes: 1cd472bf036c ("netfilter: nf_nat: add nat hook register functions to nf_nat")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: missing else to nat_ops = nat_proto_net->nat_hook_ops conditionally.

 net/netfilter/nf_nat_core.c | 46 ++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 8ac326e1eb5b..a4858c2b2d65 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1224,31 +1224,45 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		}
 
 		ret = nf_register_net_hooks(net, nat_ops, ops_count);
-		if (ret < 0) {
-			mutex_unlock(&nf_nat_proto_mutex);
-			for (i = 0; i < ops_count; i++) {
-				priv = nat_ops[i].priv;
-				kfree_rcu(priv, rcu_head);
-			}
-			kfree_rcu(nat_ops, rcu);
-			return ret;
-		}
-
-		nat_proto_net->nat_hook_ops = nat_ops;
+		if (ret < 0)
+			goto err_free_hooks;
+	} else {
+		nat_ops = nat_proto_net->nat_hook_ops;
 	}
 
-	nat_ops = nat_proto_net->nat_hook_ops;
 	priv = nat_ops[hooknum].priv;
 	if (WARN_ON_ONCE(!priv)) {
-		mutex_unlock(&nf_nat_proto_mutex);
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto err_unregister_hooks;
 	}
 
 	ret = nf_hook_entries_insert_raw(&priv->entries, ops);
-	if (ret == 0)
-		nat_proto_net->users++;
+	if (ret)
+		goto err_unregister_hooks;
+
+	if (!nat_proto_net->nat_hook_ops)
+		nat_proto_net->nat_hook_ops = nat_ops;
+
+	nat_proto_net->users++;
 
 	mutex_unlock(&nf_nat_proto_mutex);
+
+	return 0;
+
+err_unregister_hooks:
+	if (nat_proto_net->nat_hook_ops) {
+		mutex_unlock(&nf_nat_proto_mutex);
+		return ret;
+	}
+	nf_unregister_net_hooks(net, nat_ops, ops_count);
+err_free_hooks:
+	mutex_unlock(&nf_nat_proto_mutex);
+	for (i = 0; i < ops_count; i++) {
+		priv = nat_ops[i].priv;
+		kfree_rcu(priv, rcu_head);
+	}
+	kfree_rcu(nat_ops, rcu);
+
 	return ret;
 }
 
-- 
2.47.3


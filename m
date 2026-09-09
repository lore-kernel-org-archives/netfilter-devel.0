Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956B564A91
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Sep 2026 00:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788912920; cv=none; b=Pnw0wkUpAAzqPkioNeSB2dyvFUBZ0DEGDdPeae2eyRnHXIW+wZRr8ErpxThJUDoA/Y/VUQbwrP/5PRfrKYnAxMJ/3btmFxeJVCkMmqBkYaXe42wcjcsircoHXN3fyNk5Xxk3LEeGQA8kDc1cdKq6BplB1lYUCuJ73Zbq2xm1odc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788912920; c=relaxed/simple;
	bh=3DiW6FoeFy5qR//OUnZK0MGe0nExpSmN/toS8q+s7O4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=K8wlcTp7y0UDGl2SP7TP25ET+AxWDCfIuFoYUXbgwE29xwm5u1AaBDmmEROebQ9qD8741dhL0ur5ltzsUZYjRF8q7juekOjlPDXfKrWG8uRSU5MjJkMtTlGJ4HoVVn47W1U4+3EGJOsAJ5AKu8bjcUnkVvUb6UnnU9zJnVqI9m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FHUh9bCv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FHUh9bCv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788912916;
	bh=ouIJQOSc5BNEvc3iGJ3YGwNxhIJx/+G8rx2Gold9Zi0=;
	h=From:To:Subject:Date:From;
	b=FHUh9bCvaO7/Zu8ThvSuEHW2a5lKfmkuupG+G3lEaLw8YLRFdSMYfG+GcGzlxAs6D
	 pTrhUv7pM4E05u8Tu0lh+WTBZIfR0Zoe/Cf/UwStsMJlRuRSl/fjaKFQVmCm8+/NRw
	 HXLRUcJ1Qr0PicuHVFh/AQ4MlPwz8z2RZOFqc5ZF2/jHvU44DSFigabdjhIJBBt4iY
	 O5e/z4ulqW6rsKVYVcmDkcFy9F+S14H/cVB8b+59AWAbdjnyURUbyxDliSucNReCj4
	 VPqCeHG8Ccd04UpA+pNapAG9wsNrg6e18sEYYkuS4E7Q8YCegXNl/6TPACfJR/MByt
	 RZWcNoW86D6zA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 52AE1607C7
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Sep 2026 02:15:16 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3 RESEND 1/2] netfilter: nf_nat: unregister and release hooks on error
Date: Wed,  9 Sep 2026 02:14:57 +0200
Message-ID: <20260909001458.1533328-1-pablo@netfilter.org>
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
v3: no changes, just put it together with Phil's work so Sashiko gets
    a chance to review it.

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


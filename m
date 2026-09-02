Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D95B420479
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 23:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788390411; cv=none; b=MXpPb8rbO+yJEKExLBaw3kI3zlkWD2/uZopJvuXDXX3W0X7K5FE3SELe0LNSZALC0nRuI5GmHL7GimwZfopVQ1MeTBNpuUdGfsAhSCPypjOFy1waAhlS/W8CJqxJBqc7IR0t3f+h1Qkq5kl3DBwAg8B1nsxO/814pgG1fQOvL5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788390411; c=relaxed/simple;
	bh=uQ9BqwG75WrewC2P1qBCZIrNDe3U5Eo+jdbqf59Gx5I=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=X+k+TuORgITax6OXPqAbRB0HNjLzavaHRZhT6A0kXVWWzfaWQzQd9orTKlr6ssYXb8nODR79IujHVYaaWd8FEa6fyW2sJlNOWik6JKfm19aWYrrNHcJDjEzJ8NgAOzPXMB8V8ZWJ1arw1edVhVik/HDrMToV4Hd1BXvJ4PWuDno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uPo5/0sM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uPo5/0sM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788390397;
	bh=7ceelJ4rVhwMztm01TGLWnPXz33hwAMgu0UcfEKaHVM=;
	h=From:To:Subject:Date:From;
	b=uPo5/0sMFwNrk9U3InBNbJypYcCecN2+OJPQQku7Q/tbCzM3kVpJOZOqcWYF9tp2S
	 boAqRlgPfk31t1ibSxwmUAZYKudDgyzyZ0VtLr8BskIrROcSJCkTEVEqJdnLQZHwyE
	 4tRKBQPXbXZkKsXKlpxXzsakXtGJOo8a8JdPzHaE7vLniF2plR0PHRspD5PsHlg4jz
	 0UWJdrc/kGXGsxq/jov8nhgiOnyHQOcvSTXTs3KVZphIbLz/rsNCqb5+T/39q5jPQP
	 I3cl8vFkOcZLsV9d40EDWV5Vtz+XiQsMTl3VgEFBJ/GkyWbBAr1z29XE8LXOV3uMe2
	 hk0JXClJXsc+w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 31E756085E
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 01:06:37 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2] netfilter: nf_nat: unregister and release hooks on error
Date: Thu,  3 Sep 2026 01:06:33 +0200
Message-ID: <20260902230633.1021250-1-pablo@netfilter.org>
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
v2: - move common error path handling under goto label
    - postpone setting nat_proto_net->nat_hook_ops to decide what to
      do in the error path.

 net/netfilter/nf_nat_core.c | 43 ++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 8ac326e1eb5b..de1fa53912c2 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1224,31 +1224,44 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
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
 	}
 
 	nat_ops = nat_proto_net->nat_hook_ops;
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


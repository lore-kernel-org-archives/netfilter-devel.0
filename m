Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B90742DA33
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 16:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783527597; cv=none; b=Ss8CWvcj46uIjZqO7rlIQkF9F04AiwJWS7vlcJ8tZ5A1Si9wX8fHCfQlaqY8Fn7jNq1HPALklOsxCvjxqq/PRiFLLpnPSgc1UsivtXaKEeN5dTF59HD2+kA7pDkoq22Yf8WaeT2N5mhV5s8BO+ReuKG3zEbXmlHLyIR7Chpr0Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783527597; c=relaxed/simple;
	bh=vVqALW3UOWLqQT3aB/1wlsy/02V1qPxydiwMJgH+1vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPjg/gsaBUDMtywDpufLaPiq2NNKdovPyD7wQec9HAxK+fwrNt8lZBXXy8/yN0yXyW+6ZFG69yQJcVZzRmmGa5ktvU+VhHFG7tm50xEdiA6ZaatfXWj7fxIz3qww5z/64OlZlGZueCfHMrLojNFZNDLDqlkXpm53S8M9znUxEQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=F/wojgzd; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="F/wojgzd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/0QIOGDEunG8y8W8K1aGDqo9RMhZzi1LsgAUrk/80tE=; b=F/wojgzd2s98u2MbT6AMS1sF/P
	bNIwO+wpcURAYXYBoo6CSZVGopnAbywTMyxkW0eXl1NatszF6SGaWf4bZxwTiEaHzOl0w4iCzUPlb
	dgkFEB9iSG4IcapWanS5LW0no4YwObJrD0Egu8N2KFJTPB7DpoqiM+rmZ2LUaBhLvQ1rcXjOwisbn
	wtWggYjOlp8hGqop7sfTlPdBxrdwW6LK1fFcIcEb5nShmXz8jH4/0FbyJpouX4C+KoMVoqOM/BXwO
	CvTXVMA1SCX+4nPxwDRcACgu6m7D698bJS/gVAbNHjqguubNBlRtrXn943KcupEB2Ex3W3MVaoYph
	QVfSJSKQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1whV00-000000001sQ-29L9;
	Wed, 08 Jul 2026 18:19:48 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: [nf-next PATCH 3/4] netfilter: nfnetlink_hook: Handle multipart NAT hook dumps
Date: Wed,  8 Jul 2026 18:19:39 +0200
Message-ID: <20260708161940.1477671-4-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708161940.1477671-1-phil@nwl.cc>
References: <20260708161940.1477671-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the number of hooks exceeds available sk_buff space, the function is
called again for the remaining data. Make use of the second
netlink_callback::args field to store the current index between
invocations. Since this is an inner dump loop, it may run multiple times
(for different hook types) with the same context buffer, so manually
zero the stored value if complete array dump was possible.

Fixes: b010e2a4a9ac ("netfilter: nfnetlink_hook: Dump nat type chains")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nfnetlink_hook.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index efc674fc5adf..0657fbb3e605 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -345,21 +345,26 @@ static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
 	struct nf_hook_entries *e = rcu_dereference(priv->entries);
 	struct nfnl_dump_hook_data *ctx = cb->data;
 	struct nf_hook_ops **nat_ops;
-	int i, err;
+	unsigned int i = cb->args[1];
+	int err = 0;
 
 	if (!e)
 		return 0;
 
 	nat_ops = nf_hook_entries_get_hook_ops(e);
 
-	for (i = 0; i < e->num_hook_entries; i++) {
+	for (; i < e->num_hook_entries; i++) {
 		err = nfnl_hook_dump_one(nlskb, ctx, nat_ops[i],
 					 ops->priority, family,
 					 cb->nlh->nlmsg_seq);
 		if (err)
-			return err;
+			break;
 	}
-	return 0;
+
+	if (!err)
+		i = 0;
+	cb->args[1] = i;
+	return err;
 }
 
 static int nfnl_hook_dump(struct sk_buff *nlskb,
-- 
2.54.0


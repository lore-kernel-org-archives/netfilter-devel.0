Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6F8378825
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 16:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783527597; cv=none; b=tLbPXxqUdMmcV+MK9ByjsjxEEwZeBmPwK1JpYWg3lL6YyYZGt8xGNculaq1v7kAer2bBbOb9Nt93OjOB7mf6uDKvstw6hP7+olA3FWSqkRBjrXkc/LZ0g1qjW3u1ZOmCg383r1Mn0f5uU7xbzpl2B/WwB1dyZu4GuDYH16KuwyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783527597; c=relaxed/simple;
	bh=HizqugCXKEwa1hJDadXAjjr8DJgzmKO688eeX0wfQXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktboODoHXlB68YgVYqchRIkOxQ30m+GecY7+hdQGDWmxz53O5Nxxm7wPzFdylR18H63ewu7l/XlGc1MPxSjilXEEqyQwBmf27rzcuWrD3XFJyEMpmkJMj93YyBKf3H8JehjaWeZFnyixuFSs5ANFxEhtMbzP5xsHoiiAqg0KlQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DiBu6GJy; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DiBu6GJy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2STQtbLqkqH+DQrIE1hagzYIJ3FQlr+yIQGc2Vnj54A=; b=DiBu6GJyHLZTpsrf4evzJT+ADV
	c+NCQdFIgiq6kCGCnccBcn5xsvJWkXEJh9U6OiPsZYHzAh8y4DqHTsK3yLs8ZfKt76ZBnUSlP15b4
	Dw1Cn2ADcVZGZFb1koUxeLWd2QsbIl7EQ4c1ns6hJn41J4NpRvud90QM3xUAzqxp1g9FP+6I4yoh8
	0KGzgj0nFlSdi2MjrJkg/TQu+HOgW7BgEhlnfWeBQnf4pcLkQOjtxiHLC+gE0jBCELbjO65n/9eQP
	MBtz/sMr0TXFmKxF75iAyJdQ+yllLHCtejhqoO8jmbe7Y16gEdFqJKHGYg5EcReup6WN9ozaxrYF9
	/vPdZDig==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1whUzy-000000001s7-3lEw;
	Wed, 08 Jul 2026 18:19:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: [nf-next PATCH 2/4] netfilter: nfnetlink_hook: Deref hook entry using READ_ONCE()
Date: Wed,  8 Jul 2026 18:19:38 +0200
Message-ID: <20260708161940.1477671-3-phil@nwl.cc>
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

Writer (nf_remove_net_hook) assigns to the field value using
WRITE_ONCE(), appropriately call READ_ONCE() to make sure reader
(nfnl_hook_dump) sees either the old or new value, not both.

Fixes: b010e2a4a9ac ("netfilter: nfnetlink_hook: Dump nat type chains")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nfnetlink_hook.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index e47a2add4d5b..efc674fc5adf 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -390,10 +390,12 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
 	ops = nf_hook_entries_get_hook_ops(e);
 
 	for (; i < e->num_hook_entries; i++) {
-		if (ops[i]->hook_ops_type == NF_HOOK_OP_NAT)
-			err = nfnl_hook_dump_nat(nlskb, cb, ops[i], family);
+		struct nf_hook_ops *cur = READ_ONCE(ops[i]);
+
+		if (cur->hook_ops_type == NF_HOOK_OP_NAT)
+			err = nfnl_hook_dump_nat(nlskb, cb, cur, family);
 		else
-			err = nfnl_hook_dump_one(nlskb, ctx, ops[i],
+			err = nfnl_hook_dump_one(nlskb, ctx, cur,
 						 ops[i]->priority, family,
 						 cb->nlh->nlmsg_seq);
 		if (err)
-- 
2.54.0


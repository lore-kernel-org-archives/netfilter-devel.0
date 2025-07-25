Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6F07080D;
	Fri, 25 Jul 2025 17:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463034; cv=none; b=a8Qs8OZDEjvFJ3+TOacqDistuzahbBdzBb8ehLGQh1A/3D5swgjPlU/kC64jUeQon7rbXyAM6847Uo2GR1oq5phZ7ccW27sl4qctYIjoqEDr4MmRuOoN7lMmf+lYs2346DI+9rdSY09g4c/pk85yMVGTqPNdNpVfqSJ7EbxDzVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463034; c=relaxed/simple;
	bh=yos74KlocB92KBhlCyy03oB79c7lZtaAoprSB84y0Jk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pteNulDfzoor30fPMHrjf1DL2KfJLxS5l0cvN5mEZo0pUUREBVxoFCHovF9jB4pDFyKcrID4Y4pnESdfTdHvQ5MnzZQAtOLzsaRyFjk7JScO2oJuhPGh8vnAVTNh05IHsfypjCDz7o5+TwX8vkCN1XhfMEATCJwei0dxSU2MEuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sGW3MN8P; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cdlLzUE+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sGW3MN8P";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cdlLzUE+"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 94B5F6027B; Fri, 25 Jul 2025 19:03:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463030;
	bh=sXHNZ0zIdanGJ08glHzciIcTqLULlIZAA2HCHWm+mwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGW3MN8P/QidertFQEYgC3yuH0ySCFuNIj6NAm8dY8gaVzuloIOaF0h4OcPoRKNga
	 cXyqqXuyHfG8etsxsNZjFfvaebxD5m0iUNi/jMfXv4ZtxsN7Ag2bhF+lbdfjgcoiQS
	 SmqZEVK9pHVIYUDXcucpZj40l/RUFnuewxUTxXrqeohbQfEstAME9d9FFng9lENQZ6
	 Ctya0IjK7zD1jn8b8l/stx5vwsYTsmZsCsLrF22ZSFqz4LLhZTH4kLLPKBjD1DbGXt
	 QyKM3P6uwaMRA/PsBwUJd8mp8vVPpfhaw3cFZBBDRZWA8zQVckSQzvARNyWNz6oUE2
	 lvT45N7EglnZw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 41C656026F;
	Fri, 25 Jul 2025 19:03:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463029;
	bh=sXHNZ0zIdanGJ08glHzciIcTqLULlIZAA2HCHWm+mwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdlLzUE+tk9G5cbY6YHtlElCWkTaQtTNj/MsaiPxhX5xu76n9IoVWoVUbEkfTjDrc
	 3RvbAeCOj1VeFsc4p9s+/yifgHtEUo5M0mfduqHEGC8p2cRRptjd8NgOecyyjHEIlO
	 XGgFu5YizQNv3xr1HyEWjYix9i+iVOb8sFQb0GAKM2MnVzlid9u+VrouQZwUO4/cbj
	 GI6v8YnLdzo/Mcd50Tz0cbCFdAhHO/aH+0TDzq7/CVFcyehNEjbRfLPsbqiXig0Whc
	 0GwY8S661N+AaL0GOIAeJRVoE9eahCAIB+xNY5bOZcWU/LZPmFwGcPFH8HkflqfI5j
	 xPN/D8cTlrixg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 01/19] netfilter: conntrack: table full detailed log
Date: Fri, 25 Jul 2025 19:03:22 +0200
Message-Id: <20250725170340.21327-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: lvxiafei <lvxiafei@sensetime.com>

Add the netns field in the "nf_conntrack: table full, dropping packet"
log to help locate the specific netns when the table is full.

Signed-off-by: lvxiafei <lvxiafei@sensetime.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2a90945aef89..fbd901b3b7ce 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1673,7 +1673,11 @@ __nf_conntrack_alloc(struct net *net,
 			if (!conntrack_gc_work.early_drop)
 				conntrack_gc_work.early_drop = true;
 			atomic_dec(&cnet->count);
-			net_warn_ratelimited("nf_conntrack: table full, dropping packet\n");
+			if (net == &init_net)
+				net_warn_ratelimited("nf_conntrack: table full, dropping packet\n");
+			else
+				net_warn_ratelimited("nf_conntrack: table full in netns %u, dropping packet\n",
+						     net->ns.inum);
 			return ERR_PTR(-ENOMEM);
 		}
 	}
-- 
2.30.2


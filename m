Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792763916;
	b=HOxbEdzxbbRN/Rg2aONO64UcC0qeCWW4c3ql3QrVX5z+tW78HtYaz5XvE7LUBjZftw42
	 rp6VxWbV6NT0HXMNinbey5F6XTwfQlVWX7ERKWyoXesmr0EY/5PATKm55r2a4AYo5Vb/q
	 Zp6yFSOpCMj1kBffHrRrn1n7Wyklo8L4HYCNVCXnEJGo/7NUrMdvvuaWKTO8bcvIJTiNE
	 Tdr8qmekMBYryjvBLQDIzwqtnABrgCsdnYg9TJWptR5+7b4K9ZJHvMtU4MZZnZcENv0RK
	 JLhiCF7t12weiC2VhacU+YmqMRiZalXK9bATA45UoIA3b07OxtpQgpy5cNe6McK36jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792763916;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=V6NcFdsZ1HTj18KZxvDxUjbHxsyD5/NlHODCX95urm8=;
	b=IQQ8cIh+2llWU7aNJ2677DU4J6sbzhQVpaKRm1hlHzrdzqkcZARTgDmR1oAkAmr5rYbx
	 iRn8lGh/0tJ8/ApOr8J7hQUCUDTNg9sUopA8rkaQxspWQUfE1vgDEwz6bt3PmoP959/YG
	 cabWeswt4HWfm4DJH7lZqiRMT44EcZ6h0Q/QFmC48/xg+VZj1g7u8XNd9mOZqdJFZRWha
	 y5ERPsNhzaVRWY/S23qf/jg+UPrzkq8CyTHOyAl9veSi3FCefnmgHhAJZksFQkmKyI6qO
	 2HxkWiKKhlOsHqI5WAgl5r9LOj7PWDYtO6pJN+GVgRYFElNb6TAXpCuZpuIuX3z+lnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA8F606A327
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 13:58:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFA8F606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 16E4660796; Fri, 23 Oct 2026 15:58:34 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 4/7] expr: nftnl_expr_parse: use nftnl_expr_free on error unwind
Date: Fri, 23 Oct 2026 15:58:03 +0200
Message-ID: <20261023135806.7259-5-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261023135806.7259-1-fw@strlen.de>
References: <20261023135806.7259-1-fw@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nftnl_expr_alloc already ran ->init(expr) and ->parse may have allocating sub-objects
in the data[] region, those allocations leak.

Example is dynset.c: parser might have allocated the set_name, then
encountered a pars error when handling the embedded expressions.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr.c b/src/expr.c
index 0fec358e7480..6462119e3eb2 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -284,7 +284,7 @@ struct nftnl_expr *nftnl_expr_parse(struct nlattr *attr)
 	return expr;
 
 err2:
-	xfree(expr);
+	nftnl_expr_free(expr);
 err1:
 	return NULL;
 }
-- 
2.55.0


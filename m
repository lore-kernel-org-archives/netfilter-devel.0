Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1410E377ED4
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Jun 2026 12:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781268256; cv=pass; b=ebGWBrvxQieyJH8hK7him+p6hMUqqjyg0D6x7Dl5c0kY88lucaXMagLL9A3pp8YXFIMMBQZ4+QjjKFg6prM1yhBHu2uVwQYepOmKc0T+ybwxKw/JeZ4tEq8iywPaQ20VBVHbfGd3Jr0KLbvEQYwPGi5YOEwecZ1304I/sKpZZoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781268256; c=relaxed/simple;
	bh=SuQyivReN4ocUF/994/ReylbThxSvI5liDScR7gvfDs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OILjh2xtxwOD2XN2+ezyV91okQWjRLShl8J/p8EQ9HXQa0C9op0wLGxv3xn5oUgFkokjVy6kS0M8gMHTVEH/nE3T8PCezE5TXBrzheZhGWlQXWg87rXYtzfaA9vdk+xwhHjGA4MthEmSX4SmJjiRuZIoNHjatiTfzmveeDlfOvQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=EYf02m8/; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="EYf02m8/"
ARC-Seal: i=1; a=rsa-sha256; t=1781268112; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=WHPDLLFqmxWkb79s8k8z5r9X0OslKKdlLGpzkXRijYTrmIDr9tfeRNzhPwdR/WRTwnXshHwdiUkCTb6AH/RuL6F6yFMjNulOv9pTOl9D8HE4JVT39BV4F0RvpDPHn29izU7ghfuy1Zh3NRuqIQ0fJAOIt5gqruRnBuNadaX6snM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1781268112; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ryJDbbNZacr2Ip6NOvPoZRwXuX5NnvBxcXY+HY5Yl6k=; 
	b=RSQ1VIxGDsKTMfz9JLFBA0uh2aHkoEuTrVJRUhzCGcOFCxgUEVhVn1FscvxglMFKCXqUP2pXyHgxCSmM9cEH1L8x1sOXWX4PZi+NJVBGVFq4uu+C21SEYoHVUweQn92YSKqTDiNvAYgIntI8e50s0gs48U0bD/zYcNYpaVabRV4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781268112;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=ryJDbbNZacr2Ip6NOvPoZRwXuX5NnvBxcXY+HY5Yl6k=;
	b=EYf02m8/SayDiqCudCRjZzl7jkzV7swZjDTOxVNgEheBbWy1mQKJMEOBpOPqsmQH
	vBFHcFJQNpX7ynGw+d6Ukh+M8mQ+zNIZUlXRD25GCHkIdcXKLnvxX/XucuBW0kT5wxQ
	oW/Ltp7pUdB6sd3I/PFDmLCA2AQVq8jtreprTVOI=
Received: by mx.zoho.eu with SMTPS id 1781268109853150.40384991165456;
	Fri, 12 Jun 2026 14:41:49 +0200 (CEST)
From: Carlos Grillet <carlos@carlosgrillet.me>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org (open list:NETFILTER),
	coreteam@netfilter.org (open list:NETFILTER),
	netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
	linux-kernel@vger.kernel.org (open list)
Cc: Carlos Grillet <carlos@carlosgrillet.me>
Subject: [PATCH nf-next 1/6] netfilter: nf_nat_ftp: replace u_int16_t with u16
Date: Fri, 12 Jun 2026 14:40:21 +0200
Message-ID: <20260612124027.71673-2-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Use preferred kernel integer type u16 instead of the POSIX u_int16_t
variant.

No functional change.

Signed-off-by: Carlos Grillet <carlos@carlosgrillet.me>
---
 net/netfilter/nf_nat_ftp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index c92a436d9c48..ab714629e2b1 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -69,7 +69,7 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 			       struct nf_conntrack_expect *exp)
 {
 	union nf_inet_addr newaddr;
-	u_int16_t port;
+	u16 port;
 	int dir = CTINFO2DIR(ctinfo);
 	struct nf_conn *ct = exp->master;
 	char buffer[sizeof("|1||65535|") + INET6_ADDRSTRLEN];
-- 
2.54.0


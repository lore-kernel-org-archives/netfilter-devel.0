Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7482F3F1AA8;
	Mon, 15 Jun 2026 13:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781530774; cv=pass; b=HHhMsNmy4AzIRI/gSwJlJSPHExBhqsQ9P9XUniZUffNc8yBgbTaaxjQ7fnSs7L0MLr9n+hltRLlocAH1udYiB2UxulIZfxE9A0j1m88X7iWbSXbcsHhJwAWlv4sBmw+thOLZXBVWm2XoNYIomU4DOyNAXiSJVKhTOrIthxMZSRM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781530774; c=relaxed/simple;
	bh=SuQyivReN4ocUF/994/ReylbThxSvI5liDScR7gvfDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjWD5K9fPWhoHOWriKxkcCyKhNkcRqMXzFdbaj2W2/Q+YF0cFAyTczgci69W7nW/QlGOjLOS/+wPhuYno3AhWsFvVUyocYLyzavDE4hqxjDv42e+DmHlsgpkvlUoTAlEOp1SVd7kLMzPkmnDrad7cMyp8lE45BnTSYmA8uJcPNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=eL1dVGdN; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="eL1dVGdN"
ARC-Seal: i=1; a=rsa-sha256; t=1781530745; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=TDVUTn1IEIzKJ6uZ5Siuws4KCQbVYa2lhqyinbEQaZEJ6/nZHMsih8dZNN0LzbLpCkvy7LzEz04jH3FCN+tSSLmuGahXvjJGev/JRxTX/gGfWgZJUtlce6tmEBItHJqcKuKcdIdi5xi8z7NfyZqbd5A+WyJ3KLtJ1Z6E0sWl+n4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1781530745; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ryJDbbNZacr2Ip6NOvPoZRwXuX5NnvBxcXY+HY5Yl6k=; 
	b=e7SWD0phw/+E3lpARWVDZin5NhC7964BM2/AeU4IeCtKaTVrkiqOR/c2WsjMdhDCI1xQ4wYM6gCHbVbxmqdO8oVOi+KglaOH9uUfgQQQsUuL9viJNZGYTIKGz9CChfy0Alu1dIrd14vqNxUt+MRbBIGNWMVHrou4nXBxLc/1L94=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781530744;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=ryJDbbNZacr2Ip6NOvPoZRwXuX5NnvBxcXY+HY5Yl6k=;
	b=eL1dVGdNGqmsMRuf+4TE7c4ZuZc+tvbdFSxFo1Zq/bMp8ux403vFH3YOvWH0G9nI
	f73e5ATggiy8e98rTmjh21R7iWttMCBVyolXN1EBYGEDEcmNmbcSLPbYvx7shFr5euF
	1AzB7S7mg8R+M+X0iwyqFfc1UbZO1BhnD6RM2XxQ=
Received: by mx.zoho.eu with SMTPS id 1781530743157261.9563368175641;
	Mon, 15 Jun 2026 15:39:03 +0200 (CEST)
From: Carlos Grillet <carlos@carlosgrillet.me>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v2 1/6] netfilter: nf_nat_ftp: replace u_int16_t with u16
Date: Mon, 15 Jun 2026 15:38:26 +0200
Message-ID: <20260615133835.51273-2-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615133835.51273-1-carlos@carlosgrillet.me>
References: <20260615133835.51273-1-carlos@carlosgrillet.me>
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


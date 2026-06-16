Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8120838C437;
	Tue, 16 Jun 2026 18:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634656; cv=pass; b=inLHIrgAb+Qt990L+aSpNQewz++8cCXMfHujkbtthdBXra/pbOcka2IX0sDd932H39bwUEFlT4uyrIXRfSyLBN5pnmJgWBTB+BH3tI3C/mQmDwJOBYczLKhMXpUv/UFqhqcJOtYlmZjuEjRW15mcRMYYZHPU5K7qOxEVVkWDnQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634656; c=relaxed/simple;
	bh=SuQyivReN4ocUF/994/ReylbThxSvI5liDScR7gvfDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+1CfFIUIqsSfetIer4hxU43fYrc6kwgjz1JAThf3Jmxu0EX1Kemd8WaNCCpxAOac2t8G7tB227UieUrjMuBieWxnltaVDf0hHBfarOUVensZXJStVEdPx95dcKzdXFz51ry8cLGHVVRt1vEhVnzxWxJSxJ2hbCk8X2EiIsI0qI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=AHBckOCY; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="AHBckOCY"
ARC-Seal: i=1; a=rsa-sha256; t=1781634624; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=K++0HtuG27VwDtF7zip+SsBl23t9FjWuDvfh/m9cJT1RGsV7S/EMR9Ie9fdxgqnJK8VZjcnmZIsPIxlOq8rpKmCloImS7VTq1+YZC/DvtF0hoxgzC+VOWEXdVyh7wCifRum4tJrJGWPUKBhjuaCWpr2CvxyEK/PWDg7pZ3Oz4nM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1781634624; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ryJDbbNZacr2Ip6NOvPoZRwXuX5NnvBxcXY+HY5Yl6k=; 
	b=IqC2Q5CMM7TTx3W2zQUoZMNSnAEJrf8XzL4/n4GAPXOcIGE/4oL8iRB7L4yuTeh2rlpmLg5M8Q6NT9jLphEVQkwpzlRvmuFhnH1fSJ35DXTXihkIsZHtgjcfXhQPFvZeP6a6jiARUMcCUOi0y4JRWPwlJNGO6XUSOrGeDHpooIY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781634624;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=ryJDbbNZacr2Ip6NOvPoZRwXuX5NnvBxcXY+HY5Yl6k=;
	b=AHBckOCYMmXnvb+/iohdnzPkGZhz65BGCxeEd5i+dAl/m6Y4v5K3gi+bTfYZBIap
	4fPKsU6FW8mBO+cGkxHjkuFZCfETorikSMWpnb4ZKk+DwtZd00tgsoxWHYo+llkryKr
	YjoUFOYUy6vn7qY7ZX7UzWSokSayHpFSurzH9TVw=
Received: by mx.zoho.eu with SMTPS id 1781634623811184.8858614746389;
	Tue, 16 Jun 2026 20:30:23 +0200 (CEST)
From: Carlos Grillet <carlos@carlosgrillet.me>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v3 1/4] netfilter: nf_nat_ftp: replace u_int16_t with u16
Date: Tue, 16 Jun 2026 20:29:43 +0200
Message-ID: <20260616182948.96865-2-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616182948.96865-1-carlos@carlosgrillet.me>
References: <20260616182948.96865-1-carlos@carlosgrillet.me>
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


Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B283AC0DE
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jul 2026 19:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783453945; cv=pass; b=ScxhUGcgi8ARkmnB2P73CfeQgTIyYA6JmNuhF/O7ZtsJLcjBBMscSmMLUoguyOiy/jMCoz2xKLK8Dsp+dyrUA1p/6dxnHoBCrrMlzMGAbldyRz+9bFg49VoltmYrgJa/C41lHDtidmhF+bvw/v0pV/LgTjqZ+aMMyChNuF/bcGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783453945; c=relaxed/simple;
	bh=L08bsm8XXmPH7G0Ve7Tn6fWr9+qBIorZ4c5Bmows0Ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzMorVxD17dvvhIcj20zCqh+tonvSJfqfzTknSptmT0fFFoZxyzJ/+OfoaX/5dBMKQzHwoq7a/dDkjMJvBw+FGi6kL7nn+K3K7hIIzss5aniAyWcJzUHEhInuTZxF+qxzCJ/6uV8kpY0Rvea/oZSnhpbCp0/PowRpwKPxh+gC0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=bEO3tGF8; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="bEO3tGF8"
ARC-Seal: i=1; a=rsa-sha256; t=1783453892; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=a5y0T83gMIZoRu6Ho3c5YlFgoWlcxWZZFoeo71O+ib59SeTzKLiePC2AKnZkj31aKsv547jwQV+T9IRdDmfQDob1JWau5HFvs7PWWHlo6xz6Nn8bGF99wHs4ch5ByiPBmcij78H8X2XTHdnsmMSteO72XqBTK/AiaoYa998xyEs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1783453892; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=TBWqEQWfiAqvoT8aTW1ERvSVrP1Ppq0qP5bOELHKZ4o=; 
	b=WohBGcYEODzRL9rL+h6Y1f7HWuH37vvVMk3BT7sYF6ZwLQVvFb2tqO4BINlgcZR8qrTJgCcmgnSbODF+UYWFdXXBcK8KwmG+h1jOeYNauByULQDpn23Knqj8aD7wkl1pp3clQ4rGR8A47LT4EaL4YAK7s4bAIW8ElAMQSfkYVjs=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1783453892;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=TBWqEQWfiAqvoT8aTW1ERvSVrP1Ppq0qP5bOELHKZ4o=;
	b=bEO3tGF8Ka6pllLZB7gJLYyuZgWUKjOVSuLeu9WYNgrZHZxZ6kq9MGiBC1+1xzP/
	7mM12L5DLw1C3Xtz0aOmIue6jqtLZSHCYeDpoF1WLKob597FzmZNX5lt8j7mn6O0ru/
	e5r7AWGpnwmD88YrX8ZS8lhiioKcBG8WCKy48EiU=
Received: by mx.zoho.eu with SMTPS id 1783453890368827.8531741917685;
	Tue, 7 Jul 2026 21:51:30 +0200 (CEST)
From: Carlos Grillet <carlos@carlosgrillet.me>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next 3/4] netfilter: nf_nat_amanda: replace u_int16_t with u16
Date: Tue,  7 Jul 2026 21:51:08 +0200
Message-ID: <20260707195111.34899-4-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260707195111.34899-1-carlos@carlosgrillet.me>
References: <20260707195111.34899-1-carlos@carlosgrillet.me>
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
 net/netfilter/nf_nat_amanda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index 8f1054920a85..fe054cb4fc0b 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -33,7 +33,7 @@ static unsigned int help(struct sk_buff *skb,
 			 struct nf_conntrack_expect *exp)
 {
 	char buffer[sizeof("65535")];
-	u_int16_t port;
+	u16 port;
 
 	/* Connection comes from client. */
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
-- 
2.55.0


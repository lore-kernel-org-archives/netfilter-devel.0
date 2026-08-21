Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154EC4749CD;
	Fri, 21 Aug 2026 09:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787305914; cv=none; b=ce5ti+CgwvqcVoRUFMAE3v87iEsYl77dA9iwP4/MJ1I//TyHBJO+R9LHPGQi1A5MPOIfaRpOWeN5vlau6Obdm8xNikOyYKscBxS0I7mqG6OWmetWWTel+mmWVOiMNi8MKuHMgZhAmY3rcHiizAUEsTGrUIraiQInuawjQFvirqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787305914; c=relaxed/simple;
	bh=2pVwjUqx+IveGMzVgdwgDXQbSuubeuT3qv9tszBplOA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=gnpq7qZ/KCFwm1ZZrrl/jjaUuxEWeV9ldj4xx68Qf7DSb1sJL4Z+uB+J4z1TF6y2Rbod4OHixeOOoTvM4stXA0WNXdZVKnWtsWyBb7+PiFO2adwF+mF6EUC5zQP2RHHOtXIpaqyt6rED/fd9FoMAAyNc7eZBaRWvY8ujFUxWu44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=oEKbtrw0; arc=none smtp.client-ip=117.135.210.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="oEKbtrw0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=EUX5tuvO1QIsolJsTeox0cl4Lc+AjyHBd38zguMcdJE=;
	b=oEKbtrw08UnYcGWRe3L9ChDoIqARWTW3vh6QLLwOVSES4epvwISc0L0781YXR1
	f/ie1nhc3BS40UjKHKlLHBCT026MUbADk9BpYpYR2pbQ/L6hg422zSDXbnuUXilZ
	HMI7xt//T2FY3vrz6eQToINLSojGEYWjoAQRmiq7WJumo=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnv61YH4hq5BOpFg--.48845S2;
	Fri, 21 Aug 2026 17:50:17 +0800 (CST)
From: Linkui Xiao <xiaolinkui@126.com>
To: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: [PATCH nf-next v2] netfilter: osf: remove unreachable break in nf_osf_ttl()
Date: Fri, 21 Aug 2026 17:50:14 +0800
Message-Id: <20260821095014.408388-1-xiaolinkui@126.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnv61YH4hq5BOpFg--.48845S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr4rJr1rJF45XrWkCr1DAwb_yoWfXwb_ur
	y7XrZ2qFs8ZrZxAw1furW3Aasayw18WF97Xr9rXw47Z34DW3yjkaykWFZ0vry7Xw4kWa4Y
	kas3tryjy34fGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbCtC3UUUUU==
X-CM-SenderInfo: p0ld0z5lqn3xa6rslhhfrp/xtbBqBmacWqIH1nTBwAA3q

From: Linkui Xiao <xiaolinkui@kylinos.cn>

In nf_osf_ttl(), the break statement after return in NF_OSF_TTL_TRUE
case is unreachable dead‑code. The return statement exits the function
immediately, so break will never execute.

Remove the useless break, no functional change.

Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
---
v2: Rebase onto nf-next.

 net/netfilter/nfnetlink_osf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 92002079f8ea..a3f855905d52 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -36,7 +36,6 @@ static inline int nf_osf_ttl(const struct sk_buff *skb,
 	switch (ttl_check) {
 	case NF_OSF_TTL_TRUE:
 		return ip->ttl == f_ttl;
-		break;
 	case NF_OSF_TTL_NOCHECK:
 		return 1;
 	case NF_OSF_TTL_LESS:
-- 
2.25.1


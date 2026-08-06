Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B49A37F311
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 13:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786024431; cv=none; b=fcuXXaLz3Z88ua8LY5MmUkIkurDmQXpLeXsIIaCHoPxxGQr4lPdCvlcHdkpTcEgKFiirZZTl6J2O+FcjxID+7JRrFEgoFPvUdFzetSe7sO49GnpcFVBNNfjJm897G74JfKBSoMaF0SFxwXDHXIBK095k4hW7gJvN4pLOgZBydHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786024431; c=relaxed/simple;
	bh=zy49kYVdhUqG+9xPOrkJrswr1CQovbnK6KjChxiDsVY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OSF4hyMpjSOOZG8Rx4/w0rI2ki3CDPmxYg0IbR7p3wAM09PC5Qv/NbLpDYtyO9mad1w6D7CdyuzgTv2ly9Y/Kp8OpSDt5bSZ71U6qUELhCVyEECFEhJnro6x9MlsAHp3lDZJLx90RtpfUPUviiBC0CK7XfW94DhnZgJAbH+RZEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BCFFD60203; Thu, 06 Aug 2026 15:53:47 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: ipset: fix list type element drift bug
Date: Thu,  6 Aug 2026 15:53:41 +0200
Message-ID: <20260806135341.8896-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If list_set_uadd() calls list_set_replace() to swap an expired entry,
the element count remains the same, therefore the increment must be elided.

Fixes: 702b71e7c666 ("netfilter: ipset: Add element count to all set types header")
Link: https://sashiko.dev/#/patchset/20260806101947.2802-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_list_set.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index ca3ef9479e83..56626f4943a9 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -301,8 +301,11 @@ list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	e->set = set;
 	INIT_LIST_HEAD(&e->list);
 	list_set_init_extensions(set, ext, e);
-	if (n)
+	if (n) {
 		list_set_replace(set, e, n);
+		return 0;
+	}
+
 	else if (next)
 		list_add_tail_rcu(&e->list, &next->list);
 	else if (prev)
-- 
2.54.0


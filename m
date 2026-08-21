Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC083DDAF4;
	Fri, 21 Aug 2026 15:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326731; cv=none; b=FzAGi+TNDFgbTb9W3T1VOUcdJUIh0f+tAtsqgwrnKUl9tQOjalYlf3ujDVH8PcyTrogH7x4FOOnZEJJWwVJFe0P47/ZPjHeB5YzRrz2YWnFazYZrp+CMrJm98ooZpa1J8zW4Nnw85GEUuRVwR0b7tKhvmTG6eLobt8FZ0AMF69I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326731; c=relaxed/simple;
	bh=T8bM4HQ95BX3xprgC4vGRfG1bi9SmwTfhRVEP1jauCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gB60ViU/2Ha8SF4m6i7RRoudOnbBHMXVMPpJ3YmzN8Fl7aaSPdxxCkV/g/S51M++dFUs/dgoWiNoOkhJOa7sNYIQfxCU4Lss+YvAo4A3dYnYjMho+L/3d94rcW2LYehThIDVISzs6bzzu76+2J/VclOBho+uuWnABCdjVZ5gKSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=M04D/hGs; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="M04D/hGs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787326726;
	bh=6a4SMX45FUp/eYu0m0MKSwkwq2xDCf0eQzlTqw/9AL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M04D/hGs8up83PYUSQ5OIA/5xrmm62YmIRLWmVqET/biDm0v4i4pWO3YiY/821h/g
	 +C2gsohZmPcfpqB2M1Vm6dv2fns8ejjVHLKM5RmM/Rh4BMZQzdd/ehuC46MgpaxEGS
	 0a8qSZSZCpJDqa86sNEa+T7QBTo3NBnDqIpY/p3pLlVabR0uQ090MJp3Nejf5NTJV6
	 ah36aJqZ5GZXTjPiDoY4pxVwJ6o4TQS+zAwMSvCFAKR10BI+4h7wtVhs6VLSOe1vlu
	 IOGf9Dv7z/3MzuT+VCdV2ifZ2WZMHAjPCkkwWFHCNIrgh8jS5qw9HyxqElF/mlJQf/
	 JTStJFIHtof2g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 74D056008D;
	Fri, 21 Aug 2026 17:38:45 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 02/10] netfilter: conncount: use DEBUG_NET_WARN_ON_ONCE on reaching count limit
Date: Fri, 21 Aug 2026 17:38:25 +0200
Message-ID: <20260821153833.245589-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821153833.245589-1-pablo@netfilter.org>
References: <20260821153833.245589-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

Replace WARN_ON_ONCE with DEBUG_NET_WARN_ON_ONCE in __nf_conncount_add.
The function handles count limit breaches safely by returning
-EOVERFLOW, so a production backtrace is not needed. This prevents
unnecessary system panics when panic_on_warn=1 is enabled in production
systems.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 85487f92af50..4292c3d9addd 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -251,7 +251,8 @@ static int __nf_conncount_add(struct net *net,
 	list->last_gc_count = list->count;
 
 add_new_node:
-	if (WARN_ON_ONCE(list->count > INT_MAX)) {
+	if (unlikely(list->count > INT_MAX)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		err = -EOVERFLOW;
 		goto out_put;
 	}
-- 
2.47.3


Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06D418BBB9
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2025 17:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736443906; cv=none; b=J0FqJoOcN8LVapdDSSsXNJxB+pJtDnglaD3lwKJKNNJ8vflB6EpuMjC5L6ucIvs4nfosPkUwI5Nw4S1oNLvT366YuxTN2auaUgHwE1cFl2Rpn2tCwIs6W00weu/60lV3Oanv2PVa8PES1NOlVE54s21m6gPDykzVPzpxieMAOEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736443906; c=relaxed/simple;
	bh=3fokOOolEhT1seYdI6W3DM5DhMwkOF1kRqjuFyoj8EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaQeybROHMN+BGS1oieXnO83asFq6Wbu9frBKzsE2ABmRa1eyzEkj7evo9iEB5bBmG7X827+nogPHE3ZVTh7/cTYdzLuXt7R10FTb0EifFH4CN8Wuw02+xcVgRGy8AOBvQvcLXZF1LmmM7s7Q8BNexTcsab7vX6nOnFrKPXfjRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZUqJWwJW; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZUqJWwJW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bL0FjL3vuFV56LY1TbOkAyqfK/3GoJyfuG609Zejlpc=; b=ZUqJWwJW8LnczKbGkIgq15BN+N
	4CHSP+FDZhnnuJIUqRisRY2gi58fGlwnvRmtZBKhmphvQ448p59v4de1JGD8LnClEm3voLyImY9Ar
	QD/ToP3wEvPc/ELplIk325cuQ5WnSieHW64ue8CpCZ6WQLpXAWcr2DUPtwC9kKgRNRoUh4G0rdQk5
	1hwyVPMfCY5y6jRjkUa13n1wZUwg7JZNihzio1AsDViOCNvhQLNPMNiC7p9k1Z/JfaBE143D8m1rf
	kyB2aKfTnfmLl2LiVsjB/7i0Im4PhjpmKuGQATsHQFzpc2yh5b/QSVNFlC4AXdxxD77KYid1JMJcS
	Lo7Hiy+A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tVwNi-000000006Mm-3r3P;
	Thu, 09 Jan 2025 18:31:42 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v7 4/6] netfilter: nf_tables: Compare netdev hooks based on stored name
Date: Thu,  9 Jan 2025 18:31:35 +0100
Message-ID: <20250109173137.17954-5-phil@nwl.cc>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250109173137.17954-1-phil@nwl.cc>
References: <20250109173137.17954-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The 1:1 relationship between nft_hook and nf_hook_ops is about to break,
so choose the stored ifname to uniquely identify hooks.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 900b6c7d5fd6..9a14f0e542f3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2317,7 +2317,7 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, hook_list, list) {
-		if (this->ops.dev == hook->ops.dev)
+		if (!strcmp(hook->ifname, this->ifname))
 			return hook;
 	}
 
-- 
2.47.1


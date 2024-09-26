Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A521ACE19
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344618; cv=none; b=l0Ap7SRVdQ/8dmZifYqiEqx8Ctp4RTMEz79WZwKb78+pd/T+nsaazV+n/ZCuFzhnCxnZRHv+gNKjB30ZoEaf0lJ8ylBTaLrCMJivqROjwhvXYA+kDPr5TxDOFPXFPRmrI9xqkmnE/LCG99peJecqbdMswZ7jolU7L1WbUU/h8d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344618; c=relaxed/simple;
	bh=Kspm+z/jd1+laWBTH9r/G7GOSgcVd7uBEdiX+psk1XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7RFgOubmBjkqJvVB1/ekopxXhqRgh85wf9pR7CkfNnbRp3qtWOzQzIE7iVtVxN75HC0Ck0NS76rfXVJq1Sa9I14UXML/b5PhVw06NiwERuVybKLspbE/bCy1UH8xnQqlK+kxKOFtFEmKQ6u7hal+84ecLBNswlMJoH5lwYPxLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Qsyyr4Uq; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Qsyyr4Uq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=egBCYQe73KTa1fNKjCZpUX7sYNqrtb+QIvLPIbNh+dM=; b=Qsyyr4Uq4hWAGlqBpGBiRur2A2
	beazYn82qb7gGHpj0TwNC4Tjv+gwUyNVimgVd79q+Rv0UyadFfinLTVRG4RwM8EQUQajtNb6fs1mT
	SkqIZSc3CMAJwPqtWwCRsZALvJz8XOsfwTCeVS2NoFW2aSF5fjd+ySvPfzDSqkFsfm0pNMyUPNSxW
	9xXmZbK2Cm7ZU9fjMl21hZ7bgu2KkTvKbLQ37bv4316KiNlGiAz3WMGowVciuyvOzCjWqJKWYR7y1
	yZ6+R1pwJ1mQTAuFFZZo1G+u7mrSrLYtaW0pm7R1Wd2RGZVH2FuMP9+1GwtAQfV0msZ7vYBnLmt/S
	Cc+7Dezg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stlF1-000000006GZ-3xY0;
	Thu, 26 Sep 2024 11:56:55 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v5 04/18] netfilter: nf_tables: Compare netdev hooks based on stored name
Date: Thu, 26 Sep 2024 11:56:29 +0200
Message-ID: <20240926095643.8801-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240926095643.8801-1-phil@nwl.cc>
References: <20240926095643.8801-1-phil@nwl.cc>
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
index c53afdecef24..f6e28a6ac9b0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2214,7 +2214,7 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, hook_list, list) {
-		if (this->ops.dev == hook->ops.dev)
+		if (!strcmp(hook->ifname, this->ifname))
 			return hook;
 	}
 
-- 
2.43.0


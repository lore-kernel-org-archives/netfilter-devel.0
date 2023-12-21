Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2C37690C
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2023 13:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iGE2eSpH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iF7v0SpoebUSf123iVutvILfy6lnYB+JXLKE4gOc1Hg=; b=iGE2eSpHgv2tuy+qkkyC6QWk/x
	e2y3MgpYn2F6NFOJm/Xog/+/2FJ3ZuZv4m1PHp/wNIP0s0I6I9mjzicjyuWqWusvbI6dF1JUuxaZz
	9JuQ5es3RaemM6bynfh90RSHPwGV9cZcMO/QtBUTGcrFDyPLMf/MsMBWi+Vbb6IqJMa7TXeslUrpT
	n5BDuRT08lOi3qNIHN09vrUb1NiHk8Vii1isG1BjJX8AwKVABQm5pLvbi9sHN2lpijTxu3QdyWN8Y
	XNNlPio9I9jVU1W6enm//pNB3wsy/wlOkInvIrYrONtXaRbbxTke2UHQyVtGRHHkJaR1ervkiU2Sx
	L4ACXccw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rGJ9f-0004Tn-Qp; Thu, 21 Dec 2023 14:32:03 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v2 0/3] netfilter: nf_tables: Introduce NFT_TABLE_F_PERSIST
Date: Thu, 21 Dec 2023 14:31:56 +0100
Message-ID: <20231221133159.31198-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v1:
- Split changes into separate patches to clarify which chunks belong
  together
- Do not support persist flag toggling as suggested
- Make transaction aware of ongoing table adoption, reverse it during
  rollback.

Phil Sutter (3):
  netfilter: uapi: Document NFT_TABLE_F_OWNER flag
  netfilter: nf_tables: Introduce NFT_TABLE_F_PERSIST
  netfilter: nf_tables: Implement table adoption support

 include/net/netfilter/nf_tables.h        |  6 ++++++
 include/uapi/linux/netfilter/nf_tables.h |  6 +++++-
 net/netfilter/nf_tables_api.c            | 26 +++++++++++++++++++++---
 3 files changed, 34 insertions(+), 4 deletions(-)

-- 
2.43.0


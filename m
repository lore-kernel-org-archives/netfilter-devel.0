Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD9F1AB6F1
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 12:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726145115; cv=none; b=G7WfwsnKsyZEVhqmc3MU3lhfmAl0whLr0erMiHO8yQ/iH2ay7qGMV/6ShJ/gAaECOAESBz0rHky9FAwlAnG+z5hLzNLSwd2+LY/6ysMFuAdfHizTq9QL27SOzH4ZzZ/IHc9lvVlZSzxBCWhSWnRF14X8QxTQR7Yc4jGYOL40T/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726145115; c=relaxed/simple;
	bh=8uPB9P6eBwvT20Y8b98hCkrA7UAFc1OnTcz/x+zC+d8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVeRdpgMFX18GeBsF6q1fZvokuNCQeZp4eTqEp+nJcLmOOZSPoxhy2ZojfES9GFN08Q7poNkkx6rP6vIyf2OBoZ/0YhbXLvlIh2TwnnEK9cDbHuvSx9lomTDj4bVW3TsnmhMtB9xri2Csw0199A6q6GkFubyeKSrU3XwwitYNbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WgNdMmRg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WgNdMmRg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yfJMHa0h1XWBwCoMRQ4pVotEzX9M24TwcHafwOVt+4g=; b=WgNdMmRg1+HhzT0OY51G7ehICN
	9xgJn1eKzQtXDecYJXI8pMz/lKLZ39B/MtKM8wW5BMBT5MKrl98Fc8YV6JFXwmRDps8DNbK0KzNF8
	Dpt2kP1l0LCF/zxtM5Te7z6bI4qFAE0/l5AUyXExGBIp0Z9r5K2kjoeR5Q1IBxq4aJpdiuMFYuo1x
	h9FlhBQqGLvCJFnPOJ81WSqvyQ2rdiJAYFLyu9RpFDnMc2krB84oizB6hFrtA1OdnD/pCI2JEuk/F
	Vk2WCg9NJpzQ3w+KD5CYlf8hhs1o3pBYyrdmGvOkMa1BBoC9lX1PlxsHum5W3TgYwXtbCCzt3Cmte
	Tu34JTsw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1soiph-000000004E3-0vqC;
	Thu, 12 Sep 2024 14:21:57 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v3 01/16] netfilter: nf_tables: Keep deleted flowtable hooks until after RCU
Date: Thu, 12 Sep 2024 14:21:33 +0200
Message-ID: <20240912122148.12159-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240912122148.12159-1-phil@nwl.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Documentation of list_del_rcu() warns callers to not immediately free
the deleted list item. While it seems not necessary to use the
RCU-variant of list_del() here in the first place, doing so seems to
require calling kfree_rcu() on the deleted item as well.

Fixes: 3f0465a9ef02 ("netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b6547fe22bd8..2982f49b6d55 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9180,7 +9180,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
 					    FLOW_BLOCK_UNBIND);
 		list_del_rcu(&hook->list);
-		kfree(hook);
+		kfree_rcu(hook, rcu);
 	}
 	kfree(flowtable->name);
 	module_put(flowtable->data.type->owner);
-- 
2.43.0


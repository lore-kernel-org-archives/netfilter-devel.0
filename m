Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12607641E
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 15:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720625610; cv=none; b=Vf76ymouAcUFw1KJj8/2LY8a91v9Ts+nf5Xo5+hR/0+JgpR5FmJ9dYsonUqbmPOz98BiZA2Ev2eADpFCaCVcGWb1EvAXy8OQkho6dwb3VsC13KeCVLY5Rfk8QhoVx8vP+8BWhhpze/O9QnKxHfovYys8mYg5ez/yJbaimliyaCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720625610; c=relaxed/simple;
	bh=hNxemCaxoIo3Qe7A/SMplpjLhItcd5xPrI+p/nlWSTU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H6hZWJ7dRyA6p06igIrWTLmUyDH2RqO0+hjeDJjLmmdtl8dGzu/k6q37iCzKcaAPUaMJCFDvIoFEKQZCuMVAGFIi7FktGzf6lXGVnH8ffmVqc94BI77UFCOudZXhmtydMtssMInIGrmgilYOc3xUZnEzHbyCKSLqoEcZLs1LwGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=h/1rbdlr; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="h/1rbdlr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+GqGum9x7kBOnx3fd/0jtR0GV/4hZGAdbM098v72/AU=; b=h/1rbdlrOI6UxnZL2wqc90oufP
	XF5nckzTRu9ynaKeuFqSp4WZ9zYPW79BZ24HJ8wzkOPyKm0nGyKTnWt6yIYwhAIW0SP9nyYxbNf4d
	EoJW2rUxNqJgM5qITOy9SHXKd+XkyzZGsFrEPSDTBeuX8OP/ISS9rvkgnUNDiAzWdF3x7RJJbNFs+
	ULS9sWBD7TUSYdx9PMZnk11snbDox/4DYh9H8IIkXa2TIj4WzeRRv61u4A/Z8OSgIUvVBLM0I11vh
	M4VgWgDMEFj+xxUHkY7Rk5tabKU8CcgRDlMEEtL4y/BdwXFFvK+ooaRhn8B/syGutH4hPkFeQLf+L
	OPoCaRhA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sRZJu-000000001Mp-43D7;
	Wed, 10 Jul 2024 17:33:27 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 1/2] chain: Support unsetting NFTNL_CHAIN_USERDATA attribute
Date: Wed, 10 Jul 2024 17:33:21 +0200
Message-ID: <20240710153322.18574-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cosmetics, but support unsetting anything that may be set.

Fixes: 76b82c425818e ("chain: add userdata and comment support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/chain.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/chain.c b/src/chain.c
index c7026f486b104..0b68939fe21a7 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -185,6 +185,9 @@ void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 			xfree(c->dev_array[i]);
 		xfree(c->dev_array);
 		break;
+	case NFTNL_CHAIN_USERDATA:
+		xfree(c->user.data);
+		break;
 	default:
 		return;
 	}
-- 
2.43.0


Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1B320335
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868356; cv=none; b=MJu6VZ+okUkzAstO0EE8EWz4Nv0uKjNEt7+9f5rvXT7FixotF5pPnEGHZGnIzcDcjYnNo7Bjjrs693jf78JfZ003ypzX5aaggwMV79TOtHK1ZQx7qMZK1iL+9a0qFqPjo8t3UzlG80p9x1yNR9BNV56zzIad3MFVtmX/6cyOFoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868356; c=relaxed/simple;
	bh=XQdsYRKuSp4qnDUi7dZG4pVClGVxupRP5iGEfLmxSHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkYC4tQ1xvA+gkGrEv5s1ri0Ks1t3RInoe4IBmayK1gSl7IKL2gAbxzH+5yOqpRpDPzf38IfR3smhBWwuS0jpM4/BeBrNz4UF7Z4ytDC62ab9lg/C8/qCeA8s/3RMajkRJJFZeQygfGqr6GzskV7je5N+oxXip5mzMt38tHEI5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZIDD5nh+; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZIDD5nh+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZiKnSj5/U2zyBFtyeHOcQGK+Yw2iSRafzzmkNmtsPR0=; b=ZIDD5nh+hpYdZPaCerIuqUyKhL
	3g8Vj+A1PGRe8dbE08yHPI1fb03lx3KimEfGeU2YC/816uzn1eioN+pOX5fnHj2zY4zy0IIq5SuS0
	8ZXv8CsQs+MneA02CAjUfwisstf9NNKGF6uQle+G1qt/NpoQiq+1lHpJ8x9LhtbDK3MPHxrGeB80Z
	DBDszs4pMKuxF/pdlWjDyqkYs8Gl89NwwIgoeuodRhWrQtxGlcyRw5x0XwYEz1vYIrVVt3uUqk5dp
	tr0Bqy6/udQX0X2J6ely6XZ5Vkzo97UDF19+47lT8BRVt44KXJ2nAE7uwR5eSHhcgcAXHCwKKNHgA
	92qGJ8UQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0r-000000007gE-2rJC;
	Tue, 19 Mar 2024 18:12:33 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 08/17] obj: synproxy: Use memcpy() to handle potentially unaligned data
Date: Tue, 19 Mar 2024 18:12:15 +0100
Message-ID: <20240319171224.18064-9-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240319171224.18064-1-phil@nwl.cc>
References: <20240319171224.18064-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Analogous to commit dc240913458d5 ("src: Use memcpy() to handle
potentially unaligned data").

Fixes: 609a13fc2999e ("src: synproxy stateful object support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/obj/synproxy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/obj/synproxy.c b/src/obj/synproxy.c
index baef5c201e83c..4ef97ece9306d 100644
--- a/src/obj/synproxy.c
+++ b/src/obj/synproxy.c
@@ -19,13 +19,13 @@ static int nftnl_obj_synproxy_set(struct nftnl_obj *e, uint16_t type,
 
 	switch (type) {
 	case NFTNL_OBJ_SYNPROXY_MSS:
-		synproxy->mss = *((uint16_t *)data);
+		memcpy(&synproxy->mss, data, data_len);
 		break;
 	case NFTNL_OBJ_SYNPROXY_WSCALE:
-		synproxy->wscale = *((uint8_t *)data);
+		memcpy(&synproxy->wscale, data, data_len);
 		break;
 	case NFTNL_OBJ_SYNPROXY_FLAGS:
-		synproxy->flags = *((uint32_t *)data);
+		memcpy(&synproxy->flags, data, data_len);
 		break;
 	default:
 		return -1;
-- 
2.43.0


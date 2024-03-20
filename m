Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22585466C
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 16:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710951185; cv=none; b=rjtpiM5pMUgLvCE5LCZWc3vIu1CRrjlQZ/sB+Gz6A9n9Yc+0y/Fwo6ukFsvb0tzm67slHfrJnFeopf4vkfopHljVyLPGj7Mi2aKIOY1/oeoEfqZk05YfDKmEeBRSjeqHJE+yjuqezsCU8PIkNTZAs1HBYknWk5RFkSEnovxzML4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710951185; c=relaxed/simple;
	bh=MnDIdqhEz90o7M9XNuxczOXoGrUI2tvc/YFfDF4D3Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P32a2JhHOG5VR3L5ah3FPJz/8O+e/gG37PkNh8tktS0nQ/5KUtUyATc1Ng6doShE9hFy5td37eVm0uQD7GebRD4MMfgRUen4J0/tXY4An7qOBpDTzf5SiZVBWrZIbCWGFuUFi7dvI1uYp/12xYALQ90+VZmaQmIl3HHdOuHvogg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HMvZ1FTd; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HMvZ1FTd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qUlR2IPiXF+QHhmhqgXDAuRjcXPDZ8zdJCCqBjBmTHg=; b=HMvZ1FTdMOGvvYFg9B/HbU5Dqn
	e/0Uql96sVjauEDcYclw9mvyKpYXfimVhDa7PoWuqJFiOeNd7Iu6lI/eKoiNeaJGfKK39ABwkQw8N
	Yl9uCtWyoqcLn/gOwagfVyYvDQiAX+oPF/vPivNmbj+XcWHFbETK4rOXvfrjxtoOGCI/svhA//t+S
	CjmtuIIA2/U1Ya6qMsVwmsts9/strpG3r4AP+bfLLKngh+2o4tiKUoBKtcwM/wbc/k++MqNROLTn4
	//ngk0DVoY2Vx34pnOTvaFEEYpzLWBEV+dU4Jp9KdzgXZ05A6W6A+9JHF7d9Tn4eVdgPyhh+p66Ap
	dGB9mlpQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmyYk-000000004Kc-33pk;
	Wed, 20 Mar 2024 17:12:58 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] doc: libnftables-json: Drop invalid ops from match expression
Date: Wed, 20 Mar 2024 17:12:55 +0100
Message-ID: <20240320161255.24129-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These make no sense there and are listed again in BINARY OPERATION.

Fixes: 872f373dc50f7 ("doc: Add JSON schema documentation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/libnftables-json.adoc | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index 582b09db7d103..e3b24cc4ed60d 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -686,11 +686,6 @@ processing continues with the next rule in the same chain.
 ==== OPERATORS
 
 [horizontal]
-*&*:: Binary AND
-*|*:: Binary OR
-*^*:: Binary XOR
-*<<*:: Left shift
-*>>*:: Right shift
 *==*:: Equal
 *!=*:: Not equal
 *<*:: Less than
-- 
2.43.0


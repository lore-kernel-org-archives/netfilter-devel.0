Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53D34B155
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2023 21:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YfEJlqiX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hE+fOrCZWQJickZSHvkUt6uT5thFrYX6h31Gf6BpHWA=; b=YfEJlqiXofXCEHGr3fx1n0cSRK
	bycRRXQ1iHgmF0i4txZ6Zu+mDYwUtkzjWQX+ZYyuXZ8HlBFhc346yajXry0KHPsiCtMC1RCwW4DHP
	Xb/IUQZPtqZ3aZxfVWDasFRbl3mUcS2pDVw6YpC3SZNYHgfI3kcGD4r4x06OqbFS75dEzSCziz2j2
	jXdvsPKS0oK9WocHE1pumJodh7zVUCfHTGoePX+cSm50bob9t0zZMp+Y0fSYfDHP82FDYX1swQ8Gv
	LD3wr8l2Ip6lfqy/eOJN8+YG12ByWhE4i+cXM039RpOhj8y32T9J7n4fMRFvTv/mU1vIJWoFrFBw6
	lB4c//Dg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rEG82-0001Za-Ue; Fri, 15 Dec 2023 22:53:54 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [libnftnl PATCH 1/6] tests: Fix objref test case
Date: Fri, 15 Dec 2023 22:53:45 +0100
Message-ID: <20231215215350.17691-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231215215350.17691-1-phil@nwl.cc>
References: <20231215215350.17691-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Probably a c'n'p bug, the test would allocate a lookup expression
instead of the objref one to be tested.

Fixes: b4edb4fc558ac ("expr: add stateful object reference expression")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/nft-expr_objref-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/nft-expr_objref-test.c b/tests/nft-expr_objref-test.c
index 08e27ce49d72a..9e698df38e255 100644
--- a/tests/nft-expr_objref-test.c
+++ b/tests/nft-expr_objref-test.c
@@ -52,7 +52,7 @@ int main(int argc, char *argv[])
 	b = nftnl_rule_alloc();
 	if (a == NULL || b == NULL)
 		print_err("OOM");
-	ex = nftnl_expr_alloc("lookup");
+	ex = nftnl_expr_alloc("objref");
 	if (ex == NULL)
 		print_err("OOM");
 
-- 
2.43.0


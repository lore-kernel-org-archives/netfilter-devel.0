Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BA332A3C8;
	Tue, 16 Dec 2025 19:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765912166; cv=none; b=pNYtXjl69rYXrR9DWOSg984LfYrSYgXlfBiWryqcAyUCSWznk7XdLp1AqFL2lqTNXmSZOeleS+qqjrAlWkXXnLBdTzmG2biFZBLNbHSEzJQsZVOx8f/4I9B0g9R5lXEmJD719inQ4h2wwBiifipxIktre92xftqr/L+krpW/tbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765912166; c=relaxed/simple;
	bh=RPM/zKSBsso1la4mBAFGbRJA7/yuYbBcRl/R72Qxkc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fP4QJVBFqpDnzLM4I9acBOvOxg20QOIw03o30nBA7ek6KLZS9UoaZMhShw+9bk+exLqqAECGvF9ZJ1OtkADuOsdWVN6EGyfAJMsY2di3Tz6t1JKoFJHYOIaIhvucMla6dilhCSRLFXJE/d9suYZfuTO2W/BWW3jvX7PrLgHfM8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E0B4D6024F; Tue, 16 Dec 2025 20:09:21 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 3/6] netfilter: nf_tables: remove redundant chain validation on register store
Date: Tue, 16 Dec 2025 20:09:01 +0100
Message-ID: <20251216190904.14507-4-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251216190904.14507-1-fw@strlen.de>
References: <20251216190904.14507-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

This validation predates the introduction of the state machine that
determines when to enter slow path validation for error reporting.

Currently, table validation is perform when:

- new rule contains expressions that need validation.
- new set element with jump/goto verdict.

Validation on register store skips most checks with no basechains, still
this walks the graph searching for loops and ensuring expressions are
called from the right hook. Remove this.

Fixes: a654de8fdc18 ("netfilter: nf_tables: fix chain dependency validation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f3de2f9bbebf..c46b1bb0efe0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11676,21 +11676,10 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 				       enum nft_data_types type,
 				       unsigned int len)
 {
-	int err;
-
 	switch (reg) {
 	case NFT_REG_VERDICT:
 		if (type != NFT_DATA_VERDICT)
 			return -EINVAL;
-
-		if (data != NULL &&
-		    (data->verdict.code == NFT_GOTO ||
-		     data->verdict.code == NFT_JUMP)) {
-			err = nft_chain_validate(ctx, data->verdict.chain);
-			if (err < 0)
-				return err;
-		}
-
 		break;
 	default:
 		if (type != NFT_DATA_VALUE)
-- 
2.51.2


Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F107A15AABD
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Feb 2024 19:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707159843; cv=none; b=Dn0PoDMexEv3adx+B8pPSjnya0vS2Qb8wepImhRIUoR4+1buIWyxHs0OWZYVw/4LQPSyO17CeqKEmBpC0GIjMPyUhtSQ7HHEUUlb2wtrN9I6C0cQ7ZDoL7SeguBfs2RE74eBz5jAMn7Db7K30yCpRrNJL1qS7dbpTIiIjj0GikU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707159843; c=relaxed/simple;
	bh=Iju1WJ9Ap8eJGChNGn1Xu+0Td4lpNM4WNCJCL29T/Ws=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=tSTHmEjPN75qeo2Bhi1bYk1SihCZokDPQvvGRDl3KoJq33Xz/QRRVluZsQcX5wmUzns88y3zy4bmom6JCIRR5U9Tq0AVEZ5a+49Bc7X7rKq7rFySOQk+Ff3WFMAJLCJS3KuNpbx9XckunhSC6XapZ8qjtE/K4Tc9hZ0+yCV120k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_ct: reject direction for ct id
Date: Mon,  5 Feb 2024 20:03:48 +0100
Message-Id: <20240205190348.10673-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Direction attribute is ignored, reject it in case this ever needs to be
supported

Fixes: 3087c3f7c23b ("netfilter: nft_ct: Add ct id support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index aac98a3c966e..bfd3e5a14dab 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -476,6 +476,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		break;
 #endif
 	case NFT_CT_ID:
+		if (tb[NFTA_CT_DIRECTION])
+			return -EINVAL;
+
 		len = sizeof(u32);
 		break;
 	default:
-- 
2.30.2


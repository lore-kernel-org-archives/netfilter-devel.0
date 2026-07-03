Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8D73BB113;
	Fri,  3 Jul 2026 12:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783083462; cv=none; b=lBJqFH7QId2c1EfWLl2nCVz+yA4JPxFS6Lnv4uCndyJL4oCt6b8WQ13sUJSzcgM7oLtWVh8zePHVer5CPq4jv3ueZkoQzPOOGPc1/iaeGdsic94OKxHRa868UTxzk8Pa4w2RUfC6M7L3/5jPY6p3DXkqY6dKLyggxRSxVHcX7z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783083462; c=relaxed/simple;
	bh=OazYaIgqg20Pd34m4pR2dAdp9E8xR/vq+QB2wp0wvzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnO7yYK+utEdZnfwNpx2d4DL/AlVhNHtNE8I6z+4Wsgi3u6Mjafkk2IOX4X+1ucRp6C/vqSzCeKuTTp89Hj0Tk5Kdfv8CHNU9BLs6reseJrBDNN7myK2O2IoNMvJa/uQbbMCr4pCzSc5JSzEo30NEN11ohHslSW721O/liMdfPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E858760687; Fri, 03 Jul 2026 14:57:39 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 6/9] netfilter: nft_set_rbtree: get command skips end element with open interval
Date: Fri,  3 Jul 2026 14:57:06 +0200
Message-ID: <20260703125709.16493-7-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260703125709.16493-1-fw@strlen.de>
References: <20260703125709.16493-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

The get command on intervals provide partial matches such as subranges
for usability reasons. However, an open interval has no closing end
element. If the closing element matches within the range of the open
internal, ie. its closest match is the start element of the open range,
then, return 0 but offer no matching element to userspace through
netlink as a special case. Userspace provides at least a matching start
element in this case and the closing end element matching the open
interal is ignored.

Another possibility is to report the matching start element of the open
interval for this end interval. However, this results in duplicated
matching being listed in userspace because userspace does not expect a
start element as response to a end element.

Fixes: 2aa34191f06f ("netfilter: nft_set_rbtree: use binary search array in get command")
Reported-by: Melbin K Mathew <mlbnkm1@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c  | 3 +++
 net/netfilter/nft_set_rbtree.c | 8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4884f7f7aaee..a9eaf9455c77 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6563,6 +6563,9 @@ static int nft_get_set_elem(struct nft_ctx *ctx, const struct nft_set *set,
 	if (err < 0)
 		return err;
 
+	if (!elem.priv)
+		return 0;
+
 	err = -ENOMEM;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (skb == NULL)
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 018bbb6df4ce..6222e9bb57bc 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -184,10 +184,14 @@ nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	if (!interval || nft_set_elem_expired(interval->from))
 		return ERR_PTR(-ENOENT);
 
-	if (flags & NFT_SET_ELEM_INTERVAL_END)
+	if (flags & NFT_SET_ELEM_INTERVAL_END) {
+		if (!interval->to)
+			return NULL;
+
 		rbe = container_of(interval->to, struct nft_rbtree_elem, ext);
-	else
+	} else {
 		rbe = container_of(interval->from, struct nft_rbtree_elem, ext);
+	}
 
 	return &rbe->priv;
 }
-- 
2.54.0


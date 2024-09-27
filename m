Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2712D18A95D;
	Fri, 27 Sep 2024 12:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440414; cv=none; b=G8/G1l1WKW2eJSxsKZU1oHSb+mXaJb8Rdhbegxgd9xP3/0TrBHmO7UsqzX5LYr+QSycRfJVGyPbm8leihneL8MhTe+qPbpVUr5SpFWc/LqEIaBifFrfvLOJMUo2Sx1MdBRiQiYjbj4/ZWBuoNklcXnuXGnHy8Amz9rHC/A7VL9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440414; c=relaxed/simple;
	bh=fdH3+ko3784gDVdBlyQFs0j5GZd0sXXkYa3etqYxTtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzcr4H3ZTfQjnzwrNVISxaaylbZjmEzq54ND6F25BGw8YTcs+LVXkDMYQDnIn3DDtv7hjPDKiMpkf1QlKxbXyxnkv+5dWaOVjP9HslxeL4OCdUTdaK2b2uAQ0Mx7XEJNd2aYVhagWNDhJ6WbeR6USXz1BrzByqpwSNdl5uDeeuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpZ0iw4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpZ0iw4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA757C4CEC6;
	Fri, 27 Sep 2024 12:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440414;
	bh=fdH3+ko3784gDVdBlyQFs0j5GZd0sXXkYa3etqYxTtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpZ0iw4VO+XxWDq6kZlK3sqvNeyBBPCk3e57K1TBCjc1HD8sKHJOrItc1JfeoTmEh
	 SrocQRAQqJ7rqC2m3rxsF6CYEIZT4ci5uqhQqT2KP0Z7yNy6P9GPU6pe//vlZNuOA9
	 oVRq9liR4hVuhsZ0xD12dRf50HZ0xS4Lgh+BqR+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 62/73] netfilter: nf_tables: missing iterator type in lookup walk
Date: Fri, 27 Sep 2024 14:24:13 +0200
Message-ID: <20240927121722.408052007@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit efefd4f00c967d00ad7abe092554ffbb70c1a793 upstream.

Add missing decorator type to lookup expression and tighten WARN_ON_ONCE
check in pipapo to spot earlier that this is unset.

Fixes: 29b359cf6d95 ("netfilter: nft_set_pipapo: walk over current view on netlink dump")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_lookup.c     |    1 +
 net/netfilter/nft_set_pipapo.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -211,6 +211,7 @@ static int nft_lookup_validate(const str
 		return 0;
 
 	iter.genmask	= nft_genmask_next(ctx->net);
+	iter.type	= NFT_ITER_UPDATE;
 	iter.skip	= 0;
 	iter.count	= 0;
 	iter.err	= 0;
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2046,7 +2046,8 @@ static void nft_pipapo_walk(const struct
 	const struct nft_pipapo_field *f;
 	int i, r;
 
-	WARN_ON_ONCE(iter->type == NFT_ITER_UNSPEC);
+	WARN_ON_ONCE(iter->type != NFT_ITER_READ &&
+		     iter->type != NFT_ITER_UPDATE);
 
 	rcu_read_lock();
 	if (iter->type == NFT_ITER_READ)



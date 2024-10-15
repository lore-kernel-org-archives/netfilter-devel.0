Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B6A1EBA11;
	Tue, 15 Oct 2024 11:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992427; cv=none; b=e38T/tK6brgWK9iygPk5IoocBlw5f6c/SVtk5VGHjOUuAEuraOpMvI4dGhHwch04hVjFeFbk7lUw0A0uewyBqxFmnmhBkPqqRU9SlWlsIqt+zTIX2fNlo8Hdb2u5cfUAessQghs/vaDzHsxHdx8twvRcpU8MjxsHUoX7j05JCBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992427; c=relaxed/simple;
	bh=iinXM+Q4iaDhLmj1jvOEwU9NcCUcHfIsUfQDHq2cD7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsBO9cUrCY8ioZDSAWeyX+vgystas52cnGnY/Ys8YmLOlxh267l8/6rfFlKsH4RglhmRxbX+WAVBa61i6WFW2vZOFxUSsSEPGCFnj+vEzG55j2cCUN1taJ5IU7v7FQZD54gl1pXGVchYNnc5kTpGZJBY7fXO+8yiuNrJCfeEYJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlEgfOfQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlEgfOfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFEDC4CECE;
	Tue, 15 Oct 2024 11:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992426;
	bh=iinXM+Q4iaDhLmj1jvOEwU9NcCUcHfIsUfQDHq2cD7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlEgfOfQjr00JErf47LXNDB9NXNQ7DEHlNFhGxESH0jzgBbrwXlufO0UyeC1ow+AM
	 Nmv2ro0AsR55AoTis9u+Rx5UNzsmmYFazXJybuceA8VxaQWof3G0MlMsMmxjANT/gV
	 PcGBn5Rv8fPoZh999soHDA4J3SBYyhVpiNA5WGtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 082/691] netfilter: nf_tables: missing iterator type in lookup walk
Date: Tue, 15 Oct 2024 13:20:30 +0200
Message-ID: <20241015112443.611482657@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



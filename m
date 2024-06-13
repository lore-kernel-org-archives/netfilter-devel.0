Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AB16AFAE;
	Thu, 13 Jun 2024 11:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279222; cv=none; b=NKTXMLLCdPqEhJUQpRIwyOhE8jsllYFQCNU/CeYMoTdIzY0YV6gRAqUeCH0UM3BdrFnbfG50HlyHT6aThlIBdwzqwVN7I5cw6lUtATgv1hzORBZd83nTV6WI8t3jt+QajgiaGUEKggnNeqtxIUSSQ56Qdi3mzt/BLDk3CWvQeKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279222; c=relaxed/simple;
	bh=CyDRE8fYOiRZgTz+RFSRMboGu+rAMr6FifRoFT28hiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOas3Uz012HO0+OVS6gSZd47/1GZJ0H4NC5eaVNwoqz+UAM9L7U6cpWwtNhAm7D/8JOr8jYgJ8HwlupfTQMnZBV2l3WYFQbhtFbPlV5J3Va67o+MPh4aDpP7RavzGswkVzZ6yAfHqkPx1N3MdilglnPZUkyr+ocZsPedEKPRPS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FczdF1zR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FczdF1zR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1D0C2BBFC;
	Thu, 13 Jun 2024 11:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279222;
	bh=CyDRE8fYOiRZgTz+RFSRMboGu+rAMr6FifRoFT28hiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FczdF1zRESzB2g1LEHAOAOSQnJwgq26Ebz/5LT+plMb3OW3sxaUzJ4xdUELY+fNHf
	 hcgpB60MlHI9Qj7a5ZOxlxz0e8Jnn05yCuEP7YbbFlUSiKjwTPqvAeZ+/T/f6ag92Y
	 5nq3CQimk3TD5TNa+/cRPla37ayuGQ53abt8XnLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 185/213] netfilter: nft_dynset: fix timeouts later than 23 days
Date: Thu, 13 Jun 2024 13:33:53 +0200
Message-ID: <20240613113235.118284636@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 917d80d376ffbaa9725fde9e3c0282f63643f278 upstream.

Use nf_msecs_to_jiffies64 and nf_jiffies64_to_msecs as provided by
8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23
days"), otherwise ruleset listing breaks.

Fixes: a8b1e36d0d1d ("netfilter: nft_dynset: fix element timeout for HZ != 1000")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    3 +++
 net/netfilter/nf_tables_api.c     |    4 ++--
 net/netfilter/nft_dynset.c        |    8 +++++---
 3 files changed, 10 insertions(+), 5 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1423,4 +1423,7 @@ struct nftables_pernet {
 	unsigned int		gc_seq;
 };
 
+int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result);
+__be64 nf_jiffies64_to_msecs(u64 input);
+
 #endif /* _NET_NF_TABLES_H */
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3294,7 +3294,7 @@ cont:
 	return 0;
 }
 
-static int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
+int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 {
 	u64 ms = be64_to_cpu(nla_get_be64(nla));
 	u64 max = (u64)(~((u64)0));
@@ -3308,7 +3308,7 @@ static int nf_msecs_to_jiffies64(const s
 	return 0;
 }
 
-static __be64 nf_jiffies64_to_msecs(u64 input)
+__be64 nf_jiffies64_to_msecs(u64 input)
 {
 	u64 ms = jiffies64_to_nsecs(input);
 
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -169,8 +169,10 @@ static int nft_dynset_init(const struct
 	if (tb[NFTA_DYNSET_TIMEOUT] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
-		timeout = msecs_to_jiffies(be64_to_cpu(nla_get_be64(
-						tb[NFTA_DYNSET_TIMEOUT])));
+
+		err = nf_msecs_to_jiffies64(tb[NFTA_DYNSET_TIMEOUT], &timeout);
+		if (err)
+			return err;
 	}
 
 	err = nft_parse_register_load(tb[NFTA_DYNSET_SREG_KEY], &priv->sreg_key,
@@ -284,7 +286,7 @@ static int nft_dynset_dump(struct sk_buf
 	if (nla_put_string(skb, NFTA_DYNSET_SET_NAME, priv->set->name))
 		goto nla_put_failure;
 	if (nla_put_be64(skb, NFTA_DYNSET_TIMEOUT,
-			 cpu_to_be64(jiffies_to_msecs(priv->timeout)),
+			 nf_jiffies64_to_msecs(priv->timeout),
 			 NFTA_DYNSET_PAD))
 		goto nla_put_failure;
 	if (priv->expr && nft_expr_dump(skb, NFTA_DYNSET_EXPR, priv->expr))



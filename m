Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F7723BCFE
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Apr 2025 11:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744888928; cv=none; b=kI71v93Ats7BFA62zwUgr8Mrp0K7Q6uUvgQ+voizmtYVqXbveXYgL/rS8m9IzjbyCKKUdxtXiIui/pSaRkyuvQ7bcKCjc96S12KQy0jt0waQXCbfZN48oZptBajcUHH8Vq+ViBFjNJ7STzJAp/FF2fhlMhmlJfDEr4rCN8R6dfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744888928; c=relaxed/simple;
	bh=RPFnzjcTJHMLv0kZ8C836K11zibbjkW2jxYbsW5RjwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mYh0Vjy2AkETI2fcwErQVujQLzPrrg5yoi4Qlx1H5LEDIs3iOJ9MrZVXGPEoGcqtRouitYRaPNu/wHNjAUqKbzahYKEHyk5asbWBQuoxKZ2WULmqf8qZgrsDuAnVHMESbGUltv9ey0hEgeSqJfP543Dc3tX86V2w1eX5NghtwiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IzY0449V; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Wxp22HuV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IzY0449V";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Wxp22HuV"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3627D608CE; Thu, 17 Apr 2025 13:22:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744888924;
	bh=ZjduUcucBiUrK3F68j5fMJ+y9yd3zjV4+r76BdLZza0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IzY0449VRXdGuMbOa6r2mJbIShxDmulR6FXkltDCv6ubh/XsDAG5Qidilwb66wLBp
	 C30jWsiphbJ7AWLUwkb0RVpRim3HTW+NOZkzbXo32tRR1V5SlbzsR4mQciztVu8pQV
	 csR/eWesSK5pkC+fGk1O9jzf805BttTTwqr6MMtZgG75MCxZaiLYdztUree9qHMxQB
	 Pgj7n+KbdokpIV2y6ZZVCPzleiYU+oqFEZ2XcT4cEPjV5YFNFimWhRDbC2iK8x5R+v
	 Nd8jGex0EZv9SCbIJoW+H5GY3MM7tc2LC+4CwpL9l2GuQLLxeG9oMdn8BHczSTOG0x
	 1rSfolcTHilMw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9E77E60881;
	Thu, 17 Apr 2025 13:22:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744888921;
	bh=ZjduUcucBiUrK3F68j5fMJ+y9yd3zjV4+r76BdLZza0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wxp22HuVjNsai2YJUP5HXX1hvHY5N+ggZTRzI6T0HyA4Y+2vmQbkSOGnd0Q4uwOYu
	 36qYf9qL/4IhommLAAtlbQBwTQ7VxwV7/3sbn5MzV4ypryUz4Jpezar0iiNyU52Owg
	 a+huDMiSfFwXcefLQrDn4E+yAT4m88cxb+C09Ap1XGRo/gnN3bym1kZYWkx4QjMd5W
	 F8KkcGKnSkMa5yoBwqtYDE2JYNwBmT/2/k2Bj89rA6xS9Uo/HvQBlewxtmAfELqRRl
	 wUumH1eUq5QKwJzg834pbON6O11Ankv68juy1E99vMdGeDOExeuFFfIA7vO492iXxd
	 DnITiKYwgwDoQ==
Date: Thu, 17 Apr 2025 13:21:58 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH nf] netfilter: nft_quota: make nft_overquota() really
 over the quota
Message-ID: <aADkVkvVHlCpw061@calendula>
References: <20250410071748.248027-1-dzq.aishenghu0@gmail.com>
 <Z_2EYV1JiDkgf3gm@calendula>
 <20250415140401.264659-1-dzq.aishenghu0@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6K4ezYY4YihRbOnz"
Content-Disposition: inline
In-Reply-To: <20250415140401.264659-1-dzq.aishenghu0@gmail.com>


--6K4ezYY4YihRbOnz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

On Tue, Apr 15, 2025 at 02:03:59PM +0000, Zhongqiu Duan wrote:
[...]
> They behave differently in the case of consumed bytes equal to quota.
> 
> From nft_quota:
> 
> 	overquota = nft_overquota(priv, pkt->skb);
> 	if (overquota ^ nft_quota_invert(priv))
> 		regs->verdict.code = NFT_BREAK;
> 
> The xt_quota compares skb length with remaining quota, but the nft_quota
> compares it with consumed bytes.
> 
> The xt_quota can match consumed bytes up to quota at maximum. But the
> nft_quota break match when consumed bytes equal to quota.
> 
> i.e., nft_quota match consumed bytes in [0, quota - 1], not [0, quota].

Thanks for explaining.

> Also note that after applying this patch, nft_quota obj will report when
> consumed bytes exceed the quota, but nfacct can report when consumed
> bytes are greater than or equal to the quota.
> 
> From nft_quota:
> 
> 	if (overquota &&
> 	    !test_and_set_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags))
> 		nft_obj_notify(...);
> 
> From nfacct:
> 
> 	if (now >= *quota &&
> 	    !test_and_set_bit(NFACCT_OVERQUOTA_BIT, &nfacct->flags)) {
> 		nfnl_overquota_report(net, nfacct);
> 	}
> 
> Should we report when quota is exhausted but not exceeded?

I think it is good if nfacct and nft_quota behave in the same way.

I'd suggest you collapse this patch.

Please, route this patch v2 through the nf-next tree.

Thanks.

--6K4ezYY4YihRbOnz
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 0bb43c723061..9fd6985f54c5 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -51,13 +51,15 @@ static void nft_quota_obj_eval(struct nft_object *obj,
 			       const struct nft_pktinfo *pkt)
 {
 	struct nft_quota *priv = nft_obj_data(obj);
+	u64 consumed = atomic64_add_return(pkt->skb->len, priv->consumed);
+	u64 quota = atomic64_read(&priv->quota);
 	bool overquota;
 
-	overquota = nft_overquota(priv, pkt->skb);
+	overquota = (consumed > quota);
 	if (overquota ^ nft_quota_invert(priv))
 		regs->verdict.code = NFT_BREAK;
 
-	if (overquota &&
+	if (consumed >= quota &&
 	    !test_and_set_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags))
 		nft_obj_notify(nft_net(pkt), obj->key.table, obj, 0, 0,
 			       NFT_MSG_NEWOBJ, 0, nft_pf(pkt), 0, GFP_ATOMIC);

--6K4ezYY4YihRbOnz--

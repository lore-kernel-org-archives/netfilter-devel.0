Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048AE254B14
	for <netfilter-devel@vger.kernel.org>; Fri,  9 May 2025 22:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746829673; cv=none; b=f4xSXPhHPQ/MwbJqI54U5t1bDnIsbWZS9tgRVo9YdhgA2IfyYvOExoC1MLkD5KztmsYQEJ2ahNdElQ2wFCuif/eKjYroHqRxs3PNCxhJiplYyufOr6uAlpvLXtpOdCiNLjo8Rs7bqXQAgFscTWiazHCL5quvNKWT+bbyOEOgPZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746829673; c=relaxed/simple;
	bh=1z26PuzvOuO920EUTXl1VqwDrZ01cZk7532QxKp6WFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DJzjDIS/6buIhhjDRvMWznsJBjYJhB4nsuQBwCY3FTT0W8d9htm5LD8TQbJD75M2EVHhSMnSIe/4sAvAOXpMDH8S4/7v+TtP+DkD5m9CDBzUGc7y//mio7FkV/hmDXEtlffaA2PZN6QC3FEXVA2aL05S9rY73q6ZASdoDHVZ7LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HeX7NyIE; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Sg1MT6D0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HeX7NyIE";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Sg1MT6D0"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 24D0460277; Sat, 10 May 2025 00:27:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746829661;
	bh=qLZH6xZlFOZCzcwvuIFLTMDvINkBIJ+FCLGi8Jv0Z4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HeX7NyIEiQvZVH0Vw/JVhnV6o7vCAERJqTd8EcGeok5Ci9urWybVgbXsuaotFmbEu
	 hAhrbYy6o0twjakVeVwJRSsmZOhAoiWoGIPfQqtjYQs+mZmMeGdYwVMbqzPZPG58no
	 ZgRvSAJVIF7OIOWxoQBjeg9MudkJYZ0grZh4sgl42S/0hJD+4Geb6rCN7uGudBuiRy
	 Cc/kOAUKj6qrhFQrF8tAdKI9GcMgcy4Wmdm/1Y06Qnw0tCn6EZ5g+agdug5S3AIw0z
	 Ynzll0mt4+Opg/FJbkcvRzoWed/g0g5WqsgcYLW821xzht3rP8ZbrOVYRJ57wNKW1Q
	 2+/ZGaPOxAa/Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 77D8A6026E;
	Sat, 10 May 2025 00:27:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746829660;
	bh=qLZH6xZlFOZCzcwvuIFLTMDvINkBIJ+FCLGi8Jv0Z4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sg1MT6D0iNEm6BGF57vOkG+rByfsI0JhvFEtREwQdsHhluTAoMd2K1N2g0tQit2tT
	 O2uWZMwMGhMEMZ672tqEzaqx8ctmsiz0ABcvlRKMJggzFqAZuHuPA3g5VIMiBJcGzG
	 APgnreppfDCp3O3PLmXivZKkhdZInG32dVd2IoVpyQhCNLTEhzLFgYgMb2JBkjakli
	 6im+lt5qTNdqS0xZmDe3NN2e5sk613OJj/GOdhF30LtS82/WAlSIGnZ1WMeJrDU69M
	 5OFibAfGkAXpwW5uz1hm5d5LP5nGd1MdVg9YQ/LgNE0pZBwrD75DnF9WtMLoSkjo6q
	 pC4pA0idvLvZQ==
Date: Sat, 10 May 2025 00:27:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: netlink: fix crash when ops doesn't support
 udata
Message-ID: <aB6BWUCRyp2NlyjI@calendula>
References: <20250508142907.4871-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250508142907.4871-1-fw@strlen.de>

On Thu, May 08, 2025 at 04:29:04PM +0200, Florian Westphal wrote:
> Whenever a new version adds udata support to an expression, then old
> versions of nft will crash when trying to list such a ruleset generated
> by a more recent version of nftables.
> 
> Fix this by falling back to 'type' format.

Fixes: 6e48df5329ea ('src: add "typeof" build/parse/print support')

> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.

> ---
>  src/netlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/netlink.c b/src/netlink.c
> index 25ee3419772b..5825a68d03bc 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -913,7 +913,7 @@ static struct expr *set_make_key(const struct nftnl_udata *attr)
>  
>  	etype = nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_TYPEOF_EXPR]);
>  	ops = expr_ops_by_type_u32(etype);
> -	if (!ops)
> +	if (!ops || !ops->parse_udata)
>  		return NULL;
>  
>  	expr = ops->parse_udata(ud[NFTNL_UDATA_SET_TYPEOF_DATA]);
> -- 
> 2.49.0
> 
> 

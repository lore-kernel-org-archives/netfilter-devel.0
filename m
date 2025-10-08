Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9298F63CB
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 15:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759937004; cv=none; b=BveNWRNPFgNiGqt5MZS5CqTChvsHsybtkG/5+4Px5JO+pNS/wA3uIut5TQz91HBL6UbKxxECV1O/wBZzlMbCNvwTYihC8WFSQyyrV07BsEm6sokvDnr0+Mn5R5s93q1n5tymfKEqjm6Q6Uu+3lIRccCEjR/qcEj8lRSTRxlQwWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759937004; c=relaxed/simple;
	bh=0QVGYky4+usomuSUY88djbDh2CNLsEDq7fhzvsnIi3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mX6aqROwemiEMo8g65f0X2eA7w5P0tLmj2YQFNtXFzLXMqMlESAx5PfeL8tzeczMjjtUWI8ft0vI7lIbCllRDbAv7DQu+aNfQVNnl4OXdAUEVma/I+e5QCpBhiCj4Vn0jvyNtSPiep+TLZVFBrM7dJ2DPxtsM9NhmmU1e3CV+XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Dl0qpmA+; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Dl0qpmA+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Dl0qpmA+";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Dl0qpmA+"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 82EDC60275; Wed,  8 Oct 2025 17:23:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759936995;
	bh=27qmLB6+7rv3arKAubboelDf1KVY4df7Mp5grPagBfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dl0qpmA+7012K/jbv3zwjo00sX+f9WpazRIdZK4ZF6lJpN0Al6v7apslYuK2bsifY
	 4RO19Qtyec2PAFajf8SloYUI0X9BMiWQXH025ikPFvJIMwqcbxbHKPCiRuXkxf9I7T
	 8GDI2V4c6psVsxTAbopTakXKPQ6sgg+IGDo0p6PnY3qs5pB8cMtPyFs4tP05N2UoeB
	 dQ0IM862WuA+Hm+falU4bXF5s2ARlpxa848O48G8v4NEnWRUJ2WKtTgq0lv2BnUMjv
	 YOSioHrxDlR414g3sP51qzW0SMknbiBNdmDY4mTfkXzzD82VRZW5HseGGsT9bEyl+F
	 GWt39HKkOXFww==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E91B56026F;
	Wed,  8 Oct 2025 17:23:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759936995;
	bh=27qmLB6+7rv3arKAubboelDf1KVY4df7Mp5grPagBfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dl0qpmA+7012K/jbv3zwjo00sX+f9WpazRIdZK4ZF6lJpN0Al6v7apslYuK2bsifY
	 4RO19Qtyec2PAFajf8SloYUI0X9BMiWQXH025ikPFvJIMwqcbxbHKPCiRuXkxf9I7T
	 8GDI2V4c6psVsxTAbopTakXKPQ6sgg+IGDo0p6PnY3qs5pB8cMtPyFs4tP05N2UoeB
	 dQ0IM862WuA+Hm+falU4bXF5s2ARlpxa848O48G8v4NEnWRUJ2WKtTgq0lv2BnUMjv
	 YOSioHrxDlR414g3sP51qzW0SMknbiBNdmDY4mTfkXzzD82VRZW5HseGGsT9bEyl+F
	 GWt39HKkOXFww==
Date: Wed, 8 Oct 2025 17:23:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools] conntrack: --id argument is mandatory
Message-ID: <aOaB4Gwca99LKqmU@calendula>
References: <20251008121820.28391-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251008121820.28391-1-fw@strlen.de>

Hi Florian,

On Wed, Oct 08, 2025 at 02:18:15PM +0200, Florian Westphal wrote:
> conntrack -i
> conntrack v1.4.8 (conntrack-tools): option `-i' requires an argument
> conntrack --id
> Segmentation fault (core dumped)
>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Please, run tests with this applied, I think this is fine.

> ---
>  src/conntrack.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/conntrack.c b/src/conntrack.c
> index b7d260f8e55d..940469ddcf74 100644
> --- a/src/conntrack.c
> +++ b/src/conntrack.c
> @@ -331,7 +331,7 @@ static struct option original_opts[] = {
>  	{"nat-range", 1, 0, 'a'},	/* deprecated */
>  	{"mark", 1, 0, 'm'},
>  	{"secmark", 1, 0, 'c'},
> -	{"id", 2, 0, 'i'},		/* deprecated */
> +	{"id", 1, 0, 'i'},		/* deprecated */
>  	{"family", 1, 0, 'f'},
>  	{"src-nat", 2, 0, 'n'},
>  	{"dst-nat", 2, 0, 'g'},
> -- 
> 2.49.1
> 
> 

Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B189F2E1C63
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 22:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756333675; cv=none; b=UwxnrRJ/jpothJPQV7ketILBBw8CBLkHgj005JcRqiw2CMcaQ9Xa/7SqvW0Khpw4ukeVuTRebmK3oFcddkwe8YMlWd7pHKVgZ5KCCXcuXfHz7WEIcEFOSf7JrjNxr1lUERiVsZBwmt6L3v6OX37npzlbaC9XtYfetfftMMLGY1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756333675; c=relaxed/simple;
	bh=vnH6U9DwerIXSp4Go+bMv8kGVbe4xDWlleuxrE8CVvg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h8bdnWgPBw77dE4aRCLTX3Ihz+O+pPCTPH36pen8GlBY4w6xpzDAjUhWWidhyR1vLLTE35Y8Cwe1wO11oTnvi+j6FSjWFHDHkv5vgzdpCHcjD7Y/riwAvuhBtzhsthtWBnqhjWAu+aAdYdlvl+CJVdRhc+DqRHcapZWHu+yMnZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UaY7lx/V; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RZ+rgAvt; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UaY7lx/V";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RZ+rgAvt"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 330AB607AA; Thu, 28 Aug 2025 00:27:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756333672;
	bh=jDE3qV/Df3rH+CMkJuYsGDNcmQ5jhy3/PQWlc7yjhFQ=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=UaY7lx/V7P1/yfCIpK/BXmGPv2uGOsqh72/JwcaVRIjP+Ku6s6rH75MkEHP5izk/X
	 HYmB2ESMXahoJt2axBfgOEK7t8xbfuCDc/8+JJ9LagHP7159CVvGMOOZYGSwCuwPIu
	 pP6lX7mM9f5xtXie7Mdh3CF79ehgihcXtUYpZqWPo62YXzNFKSOyWbjg+iei02r/Gj
	 Z47il3YnGunYuoJ/RjUJONgH8hTtZpNtB9BGc7Fdxg60NFwknk0WUSmTSdtqwHGyam
	 Ww2tQKTOldQEqoRLIJKu6FWa/WTgGO75YB3+9gXF3OMFgaMa3ybsVUrrjn9AE8xcbl
	 FPvpzWiusBSIA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C9157607A6
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 00:27:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756333671;
	bh=jDE3qV/Df3rH+CMkJuYsGDNcmQ5jhy3/PQWlc7yjhFQ=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=RZ+rgAvtOTTO1KpWBJSIcO2dym5wmmtnjKv58KDtkaC/eu/4/hFa2HGvOR1svcu7F
	 aexTF8aLZgTQvzcXzT+5rNOccjcNG9/tIHjNf81L+Sguc5zqCHshurJMnva42A6XgS
	 WYlmh+dYy3V85RLOK6m2MfkdfnDSJDsRQNqZUaVz5gWRzhQmFtB1hj70GLzzfW/ugE
	 fJcx3h+xNPi3aIz45k8Ihic5C0l7EAAkVRq9mvBE/O5On7JptUvt8JiZeeF7uzZAh/
	 tuvqOhelW9ZOhq4+3hUTGBxvE2ODZELxLFmrNZf0otn3+mVm6zfCfDYwEmqA6mJCLp
	 NXKPAT3Af2gjQ==
Date: Thu, 28 Aug 2025 00:27:48 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/2] evaluate: simplify set to list normalisation for
 device expressions
Message-ID: <aK-GZBnHa6xhtmIt@calendula>
References: <20250821091741.2739718-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250821091741.2739718-1-pablo@netfilter.org>

On Thu, Aug 21, 2025 at 11:17:40AM +0200, Pablo Neira Ayuso wrote:
> When evaluating the list of devices, two expressions are possible:
> 
> - EXPR_LIST, which is the expected expression type to store the list of
>   chain/flowtable devices.
> 
> - EXPR_SET, in case that a variable is used to express the device list.
>   This is because it is not possible to know if the variable defines
>   set elements or devices. Since sets are more common, EXPR_SET is used.
> 
> In the latter case, this list expressed as EXPR_SET gets translated to
> EXPR_LIST. Before such translation, the EXPR_VARIABLE is evaluated,
> therefore all variables are gone and only EXPR_SET_ELEM are possible in
> expr_set_to_list().
> 
> Remove the EXPR_VALUE and EXPR_VARIABLE cases in expr_set_to_list()
> since those are never seen. Add BUG() in case any other expressions than
> EXPR_SET_ELEM is seen.

Applied this series too.

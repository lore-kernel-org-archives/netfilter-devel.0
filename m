Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600EF304BA0
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 14:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756823875; cv=none; b=jMWhuWDb9fCK2KblM0CDn+iqBAsP3m9G5zYjP/Ahn/7W9ggtRAmMBh7arS2qSaWYvXabL9rgKapHPN5mJXOrGGfV0Pf3wEpPx+38QXfNfuDAJZ5eD2QWc9/11vOWk2F6mEqg94dSIkL85TX42tuJfDfQLfvO6qRpO7Ky9NsTiqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756823875; c=relaxed/simple;
	bh=3ZKLs5lNQAAnA1ovHMHVbgua37RXyYhGLCd1SGojITQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WpiM26qYu4FWeuTRO3EqTnVfLIcpofXh6Bwa02WqurjDP4VXL4Vux8bUHN9sJA4jGtYRHAwrFpzSS2ym9ENQVTSu+MZu80injojq4JQ7m934pDNJT/etT3YlzlDFyksr/Bil7jjF6h1tO/ulN6bHuYj61Kez9PJmZpHpc7SFlIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YeJrrqkz; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Nkpdrq5h; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YeJrrqkz";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Nkpdrq5h"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0903A606F0; Tue,  2 Sep 2025 16:37:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756823870;
	bh=RG9mm+5z8h0X2xgAdwuhYjpGwOndHea6cOzGsu/UCg8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YeJrrqkz7YYq3q5gYYKWY87aJ0PFSaeuqDX0XzcyZxbqP5SnemC4A5FWk2zo5xVJ6
	 p99yRHkPrwHAyJCBPvPAdYXaa7pKqHNEjKCscYxtYtfu5taA+6Ode1OJZt+f7DSTRL
	 8d3C8eFg1CQ04nfcW4Cdfx0xcL08jdeSPeTfRj48yrZD7ou6CuHo3lIu0e1aZSHp4u
	 qXybAtUp4T4xdFRW/MFGexcvn7jLSxKLUyhV/kawaElChyD1NMs8MdXp5FxJJK4tOg
	 pa5He7T/RiX5BAgX1NzhJSkhrK6k1c3DHI8W9QXMxtp0c3DKhTulSJMIv2iR++z8A1
	 9ni6BkdIUg3pA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 95E63606F0;
	Tue,  2 Sep 2025 16:37:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756823868;
	bh=RG9mm+5z8h0X2xgAdwuhYjpGwOndHea6cOzGsu/UCg8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nkpdrq5hqJsY7C7DBrqTwnBuCdButnXGy4Zkf5kK3+EW3gX5/So1x8V035zztGiyz
	 a2yhNN3mETmoMkGlPeBu8qaFyNzQCAuaKjM52sKHeQesmEJheLB8+Mp3OGgEch0heq
	 xtfzcsDLzTBA+DZS2qdujmhMFxLSVP57SZPs8kliBKam0CuhCBI4XrLlM47jl0oL3w
	 rwsZdxzGTo91VTUAwCOq+J9nfgDdZbfTS1WZUH//kalMupXRDIJTNoi2EGaTf99VDf
	 honmyNDrr+9HICkRAV4U834f/I8iZT8C6UkA1R/ZHwthVoxSk3SRG72nPi0OnoXUU1
	 ixPqoH9YxM5zw==
Date: Tue, 2 Sep 2025 16:37:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nf-next] netfilter: nft_meta_bridge: introduce
 NFT_META_BRI_IIFHWADDR support
Message-ID: <aLcBOhmSNhXrCLIh@calendula>
References: <20250902112808.5139-1-fmancera@suse.de>
 <aLbeVpmjrPCPUiYH@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aLbeVpmjrPCPUiYH@strlen.de>

On Tue, Sep 02, 2025 at 02:08:54PM +0200, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> > Expose the input bridge interface ethernet address so it can be used to
> > redirect the packet to the receiving physical device for processing.
> > 
> > Tested with nft command line tool.
> > 
> > table bridge nat {
> > 	chain PREROUTING {
> > 		type filter hook prerouting priority 0; policy accept;
> > 		ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr accept
> > 	}
> > }
> > 
> > Joint work with Pablo Neira.
> 
> Sorry for crashing the party.
> 
> Can you check if its enough to use the mac address of the port (rather
> than the bridge address)?
> 
> i.e. add veth0,1 to br0 like this:
> 
>         br0
> a -> [ veth0|veth1 ] -> b
> 
> Then check br0 address.
> If br0 has address of veth1, then try to redirect
> redirect by setting a rule like 'ether daddr set <*veth0 address*>
> 
> AFAICS the bridge FDB should treat this as local, just as if one would
> have used the bridges mac address.

That sounds more generic if it works, yes.

This patch was just mocking the existing behaviour in
net/bridge/netfilter/ebt_redirect.c for this case.

> If it works i think it would be better to place a 'fetch device mac
> address' in nft_meta rather than this ibrhwdr in bridge meta, because
> the former is more generic, even though I don't have a use case other
> than bridge-to-local redirects.
>
> That said, if it doesn't work or the ibrhwdr has another advantage
> I'm missing then I'm fine with this patch.

Unknown to me, but I am fine with reviewing the existing approach and
understand why this bridge redirect was done like this back in 1999.

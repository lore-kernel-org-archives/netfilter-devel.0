Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B00DEEAB
	for <netfilter-devel@vger.kernel.org>; Sun, 10 Mar 2024 22:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710109931; cv=none; b=Vnmm8FBkB0TFZlnFTAdHLUZrXykSpUZ/v9AGY6gum0Fh7/C24s97MXEHthTkgpT/68z9YaZTZ/M7CBEfkiFAB3/DeFQX0rt9V3ejtoIFpnI08l4DF01l6WPke8ogFt1Zw+7zVxryGavyK6E1c4iDR+ypNENSfHU4nVra8IujtxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710109931; c=relaxed/simple;
	bh=AJpgpbX9ywk3BONtCPwzGoaOA0HJ9jyYRJwrN6QPQkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nz+2CwtiN9mE+zWUr2PsIKk2QP+/fM1B+jlIosxkiHZzpCbYpcoINRzxeoIb5SWyxcL9tIEdHuuyoVTk0+b1wd0E7C/8cLh2ZRd/UBggLYlWVR5OgPEXh74yRkgvAe3U8cO/ZcEUAOSH4ZXHteqrOrHXkfYcZAOyxUZVvDGAu1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.33.11] (port=51934 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rjRi1-0054XW-3Z; Sun, 10 Mar 2024 23:31:59 +0100
Date: Sun, 10 Mar 2024 23:31:56 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: fix updating/deleting devices
 in an existing netdev chain
Message-ID: <Ze403GkKKZ9IhQd9@calendula>
References: <20240310205008.117707-1-pablo@netfilter.org>
 <20240310220340.GC16724@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240310220340.GC16724@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Sun, Mar 10, 2024 at 11:03:40PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Updating netdev basechain is broken in many ways.
> > 
> > Keeping a list of pending hooks to be added/deleted in the transaction
> > object does not mix well with table flag updates (ie. setting dormant
> > flag in table) which operate on the existing basechain hook list.
> > Instead, add/delete hook to/from the basechain hook list and allocate
> > one transaction object per new device to refers to the hook to
> > add/delete.
> > 
> > Add an 'inactive' flag that is set on to identify devices that has been
> > already deleted, so double deletion in one batch is not possible.
> 
> Do you think it makes sense to remove dormant flag support
> for the netdev family?
> 
> It would avoid the register/unregister entanglements and might
> reduce headaches down the road.
> 
> IOW, do you think dormant flag toggling is useful for netdev family?

I would disable it for the netdev family, yes.

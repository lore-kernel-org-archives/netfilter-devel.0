Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E58A1DB124
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 12:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741781261; cv=none; b=Kxn6e+AYFhL7OdD41c15zESnLcWzqrVI079BpjBJQck6A4FHfBJgVn7/83LMgpsxEA/Fk04J+7InYYC0/QA08bQpX0c7NGekbbF0kaTI+KnDDKMAcLWmAOBqKS/uabV1+1Z3td20UjWzhdbBCTA8PKWVZnL2sPWiPOh2/ZHroz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741781261; c=relaxed/simple;
	bh=G8WBgeHIjpKIb7+tAj4X0moXUg+mY3aQ8faKv2WXBEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FZR/Wug/7lSzoVe8tfltLU5nc/F6trnflNB/UKCDGq4Jy7xaztAE2cveV8cYnYAvzwBVNgudB2DBDqbaBlLjWpJgHK6Pwnoq750C2rTVZbQBcP+T5kmlb7lrHvagFdOEKskg0K/NwG/8inol9OavKpRZW1+K1u8B9ofPkwSPgOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jJrzQORS; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jJrzQORS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jJrzQORS";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jJrzQORS"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 80EEE6027F; Wed, 12 Mar 2025 13:07:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741781255;
	bh=28W9MFdgXEWLsuXZMH9bYWiYtaVi0/G0aGaS2cM1at4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jJrzQORShKdds4jqiU7GzwMQ/X1OK4mBJ2sKzDS9l/53Wq1ZGmUaQ7+fn3INQKtnP
	 6bL+8ILCrUBZNsrrDTRYxr2S0OhgnbPYMzsRMUgLlhlbdfaCCmqsLUOYnwWpXsOUyU
	 MZOTRKKqPy3wl1pMcd0n+NQm+gxPsfa3volGsnZwAJ3YHsYmOpOpWITUyn0Ulj47hc
	 o9/N2ER/XcWAEbVHAXjIg+IQYP2XT/ItTLVSRbn4pv4eJezQUyOQ9stSCC7ofW/K5v
	 npqeXsSIanG/S3aMqMxb6jlO8hd3mrl4SyIg9It4vsIewWYcij6jHrSU5NInrUvnYV
	 gOOOxDsyhgubw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D57F76027F;
	Wed, 12 Mar 2025 13:07:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741781255;
	bh=28W9MFdgXEWLsuXZMH9bYWiYtaVi0/G0aGaS2cM1at4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jJrzQORShKdds4jqiU7GzwMQ/X1OK4mBJ2sKzDS9l/53Wq1ZGmUaQ7+fn3INQKtnP
	 6bL+8ILCrUBZNsrrDTRYxr2S0OhgnbPYMzsRMUgLlhlbdfaCCmqsLUOYnwWpXsOUyU
	 MZOTRKKqPy3wl1pMcd0n+NQm+gxPsfa3volGsnZwAJ3YHsYmOpOpWITUyn0Ulj47hc
	 o9/N2ER/XcWAEbVHAXjIg+IQYP2XT/ItTLVSRbn4pv4eJezQUyOQ9stSCC7ofW/K5v
	 npqeXsSIanG/S3aMqMxb6jlO8hd3mrl4SyIg9It4vsIewWYcij6jHrSU5NInrUvnYV
	 gOOOxDsyhgubw==
Date: Wed, 12 Mar 2025 13:07:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Guido Trentalancia <guido@trentalancia.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Signature for newly released iptables-1.8.11 package
Message-ID: <Z9F5BA6nx35fIYHW@calendula>
References: <1741365601.5380.19.camel@trentalancia.com>
 <20250307164948.GB255870@celephais.dreamlands>
 <Z865US_MvJslQ9fW@calendula>
 <1741780160.5386.23.camel@trentalancia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1741780160.5386.23.camel@trentalancia.com>

Hi,

On Wed, Mar 12, 2025 at 12:49:20PM +0100, Guido Trentalancia wrote:
> Hello Pablo this is off-list.
> 
> By the way, there is a patch that seems to be stuck on the basis of the
> fact that an existing feature such as hostname-based iptables rules are
> presumably unsafe.
> 
> I am referring to the following patch:
> 
> https://lore.kernel.org/netfilter-devel/1741369231.5380.37.camel@trenta
> lancia.com/T/#m5e68fc86c299f9d7d372813397253dcda1086170
> 
> The comments have just been looping on the assumption that hostname-
> based filtering is unsafe and should not be used, while circumstances
> might vary, the feature is not necessarily unsafe and in any case the
> real problem of possible DNS failures, which might cause the dropping
> of all rules (leaving the system in a truly unsafe state), is not being
> addressed.
> 
> I hope this helps.

Thanks for your feedback.

I agree with what has been said on this already on the mailing list,
you should not rely on filter by name

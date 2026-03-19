Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B39F2F0C62
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 16:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939565; cv=none; b=kuGl2oYfiWppMjHyWEA6R+GtpxAeqv7j7lYGvo/r8fhRFK5qnG0J+aI9i5L27PYOCCGgLxFuo8yXKDR4J+H8Od6+fpaSVkclTuu6tLaWbO2a6OkZpCVPj0O/7xuRdZabjS3Ttr4SGQnhtHHARaVWilfYKD/Tqejf3n6Qi6JqFAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939565; c=relaxed/simple;
	bh=1IKD/W+/MoaCwaMbpxOlcCZw4LcVYjXwcn8Jx6i9qQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f7lA/DzajQCpVjRubJ/PwCIlaxcXRn+GiRHcl9Jb6tyothC7sWt8Un2Pq9DBvD0luK6AxdGyvS2oez2FMUUn1+M6uz5OeFr/D28GsK1bMFgVQe+tjIVJE98nRMZDelcvN/RpFw1DzB6bJ+smwXaAUVAkWCtuGIXyzu+FBPLuxbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=VZAr0Mzy; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VZAr0Mzy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gKX1Sk/rx5dAPz+x8S3q9XloNQcTT+ADSrBM8c0MQ+o=; b=VZAr0MzyCOMrQ/7tWFt/RBwWTO
	6bj/nEBlBxIzkUipx4lB5el/QzTX8p3oTZKZTRVbQqu4rPL2HNM4xWCF9LNNhO4OPnqY3z8mWDiZf
	lhAn/HfWmc1UCR/+4aDVgNDXgcTVmXXCEmOqDGBmOlNRP1o0hF/X56+IQxYjFHsUy8FL2JJIuhWUT
	4xRLcfdxQOR5huj6KadEPMN7PSfr2bwhiwx+Da1a/6mMCUmn8xRkTpv/NIY5H8x3j/qQADQ28ZvbS
	00BmjnIGe0FeM7hhvlvUoVxrvpC/vaPm6MQ3/kqjN1r7NlUHnKXdKqq01s+3yiCr36fZWlyDQgWQ6
	ZnW6/BlQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w3GiO-000000007NE-0ikv;
	Thu, 19 Mar 2026 17:59:20 +0100
Date: Thu, 19 Mar 2026 17:59:20 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nfnetlink_hook: Dump nat type chains
Message-ID: <abwraHUuxizN4krg@orbyte.nwl.cc>
References: <20260313153220.19662-1-phil@nwl.cc>
 <abwegj2TijkaQVLz@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abwegj2TijkaQVLz@strlen.de>

On Thu, Mar 19, 2026 at 05:04:18PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > These chains are indirectly attached to the hook since they are
> > not called for packets belonging to an established connection.
> > 
> > Introduce NF_HOOK_OP_NAT to identify the container and dump attached
> > entries instead of the container itself.
> 
> Please lets not do this.
> 
> Before:
> 
>         hook postrouting {
>                 +0000000100 nf_nat_ipv6_out [nf_nat]
>                 +2147483647 nf_confirm [nf_conntrack]
>         }
> 
> After:
>         hook postrouting {
>                 +0000200000 chain inet nat postrouting [nft_chain_nat]
>                 +2147483647 nf_confirm [nf_conntrack]
>         }
> 
> ... and thats not true.  The nat chain isn't hooked at 200000.
> 
> It hooks at +100, this is a dispatcher.
> Concealing the actual hook location and then unrolling the embedded
> nat hooks gives a wrong impression and will mislead users wrt. the
> actual ordering.

Ah, so the nat-type chain's priority value orders it inside the
dispatcher's list.

Maybe I should print them below the dispatcher hook with extra
indentation? Maybe extra braces could further clarify, e.g.:

| hook postrouting {
|         +0000000100 nf_nat_ipv6_out [nf_nat] {
|                 +0000200000 chain inet nat postrouting [nft_chain_nat]
|         }
|         +2147483647 nf_confirm [nf_conntrack]
| }

> If we really want the ability to list the nat hooks, I think this
> needs a new command to dump them.

We may change 'nft list hooks' output arbitrarily, right? Or should we
fear braking some third-party parsers when doing too fancy stuff?

Thanks, Phil

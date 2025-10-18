Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD8B354ADF
	for <netfilter-devel@vger.kernel.org>; Sat, 18 Oct 2025 13:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760794329; cv=none; b=lISK5bxZGqwgPPI7tqQuOUTeSGBHCqFdUgDXd7ZDed6Jc4wfu7pNangLPdpWy0UOsjX5HACa4lkyHKUj3bMfz4uRDYlzAfW+IJLPkqRhOKXBonH0oS0rZPAjNluVtJxJPSgZhWOQiCEVjlMUeNqL3NAjgesBQkT2xCXF7CRHYOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760794329; c=relaxed/simple;
	bh=Jf0hWUqW/cMt1TongucElVt3lL4igYEUpL/uhkJkkik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W1bquGeNAi2oEXGUSSaBAdyZD6h5JhmdG3BD8Fqwt9hWcSPDy6mKA1bfoBbRPwbUtPWFCfrh2nLRhX5ezFUgpKz+Uh+yFzMmhRbPlit3wfoGLvDeZs5aNlYGkWBAVMW1ISP4sXqcq9l3AR5LcKayv70M5gwwgM7ijvIQl1Dtfgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 21B0C60329; Sat, 18 Oct 2025 15:32:01 +0200 (CEST)
Date: Sat, 18 Oct 2025 15:32:00 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v2 5/7] doc: add some more documentation on bitmasks
Message-ID: <aPOW0GaNACeKqTgX@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
 <20251011002928.262644-6-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251011002928.262644-6-mail@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
> ---
>  doc/data-types.txt | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/doc/data-types.txt b/doc/data-types.txt
> index 18af266a..47a0d25a 100644
> --- a/doc/data-types.txt
> +++ b/doc/data-types.txt
> @@ -26,6 +26,22 @@ integer
>  
>  The bitmask type (*bitmask*) is used for bitmasks.
>  
> +In expressions the bits of a bitmask may be specified as *'bit'[,'bit']...* with
> +'bit' being the value of the bit or a pre-defined symbolic constant, if any (for
> +example *ct state*’s bit 0x1 has the symbolic constant `new`).

[..]

> +The syntax *'expression' 'value' / 'mask'* is identical to
> +*'expression' and 'mask' == 'value'*.
> +For example `tcp flags syn,ack / syn,ack,fin,rst` is the same as
> +`tcp flags and (syn|ack|fin|rst) == syn|ack`.
> +
> +It should further be noted that *'expression' 'bit'[,'bit']...* is not the same
> +as *'expression' {'bit'[,'bit']...}*.

Maybe add another sentence, something like:
Note that *'expression' 'bit'[,'bit']...* is not the same
as *'expression' {'bit'[,'bit']...}*.  The latter constitutes
a lookup in an anonymous set and will match only if the set
contains an exact match.

And/or maybe also include an example involving tcp flags to make it clear.

Do you  think a reference to "nft describe tcp flags" should be made?
There is normally no reason to muck with the raw values (or even a need
to know that new is 0x1).

This patch LGTM otherwise.

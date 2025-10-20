Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3BE2ED168
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 09:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760951216; cv=none; b=jcUw88xBT+mM13qbKF8Rb2t6w+H7F1e6JWxPxXZYuklaQ4+18M4h/oWSSVNI1QnO2GfrNM2u4lgSY/44R42BSRvq7juROVrsDQU5QYKBNcVcexCmOCA47GS6B6Cd9JSwDeMK2C5mlWc7LJAgBrk9H6nSaRNU2jird5vn+jeYxO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760951216; c=relaxed/simple;
	bh=xVmSNYnT8df2/7cIdPY8dEr1ZUISBIJB3LebGSZv6q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XnsqnWT37z0RcttJSw1rWeNTOy3bSRdcBBEXl1WxFcYcT8QD4VtfU1Bg6xtELdxy6uyZsdR+tQ3T595eiCLHkSznJBQ8EJPII2eOmNYj0QHqTCmJqFmuKcRAgI23kn4t3WLzkcCKg5QCWbX8GU4C6OEbE9grZUUA1FoSIuWnO2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 55780602B6; Mon, 20 Oct 2025 11:06:48 +0200 (CEST)
Date: Mon, 20 Oct 2025 11:06:48 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v3 4/6] doc: add more documentation on bitmasks and sets
Message-ID: <aPX7qH9nCZ5VfxEJ@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251019014000.49891-1-mail@christoph.anton.mitterer.name>
 <20251019014000.49891-5-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251019014000.49891-5-mail@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
> ---
>  doc/data-types.txt | 26 ++++++++++++++++++++++++++
>  doc/nft.txt        | 10 ++++++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/doc/data-types.txt b/doc/data-types.txt
> index 18af266a..8a86060d 100644
> --- a/doc/data-types.txt
> +++ b/doc/data-types.txt
> @@ -26,6 +26,32 @@ integer
>  
>  The bitmask type (*bitmask*) is used for bitmasks.
>  
> +In expressions the bits of a bitmask may be specified as *'bit'[,'bit']...* with
> +'bit' being the value of the bit or a pre-defined symbolic constant, if any (for
> +example *ct state*’s bit 0x1 has the symbolic constant `new`).
> +
> +Equality of a value with such bitmask is given, if the value has any of the
> +bitmask’s bits set (and optionally others).
> +
> +The syntax *'expression' 'value' / 'mask'* is identical to
> +*'expression' and 'mask' == 'value'*.
> +For example `tcp flags syn,ack / syn,ack,fin,rst` is the same as
> +`tcp flags and (syn|ack|fin|rst) == syn|ack`.
> +
> +Note that *'expression' 'bit'[,'bit']...* is not the same as *'expression'
> +{'bit'[,'bit']...}* and analogously with a named set.
> +The latter constitute a lookup in a set and will match only if the set contains
> +exactly one value that matches.
> +For example: *tcp flags syn,ack* matches packets that have at least the flag SYN
> +, the flag ACK or the flags SYN and ACK set (regardless of whether or not any
> +other flags are set), whereas *tcp flags { syn, ack }* matches only packets that
> +have either only the flag SYN or only the flag ACK set (with all other flags
> +having to be not set).
> +See also <<SETS>> above.
> +
> +As usual, the the *nft describe* command may be used to get details on a data
> +type, which for bitmasks shows the symbolic names and values of the bits.
> +
>  STRING TYPE
>  ~~~~~~~~~~~~
>  [options="header"]
> diff --git a/doc/nft.txt b/doc/nft.txt
> index 363c67ba..09da6f28 100644
> --- a/doc/nft.txt
> +++ b/doc/nft.txt
> @@ -776,6 +776,16 @@ Example: When the set contains range *1.2.3.1-1.2.3.4*, then adding element *1.2
>  effect.  Adding *1.2.3.5* changes the existing range to cover *1.2.3.1-1.2.3.5*.
>  Without this flag, *1.2.3.2* can not be added and *1.2.3.5* is inserted as a new entry.
>  
> +Equality of a value with a set is given if the value matches exactly one value
> +in the set.

That contradicts whats right above, which describes range handling.

> +It shall be noted that for bitmask values this means, that
> +*'expression' 'bit'[,'bit']...* (which yields true if *any* of the bits are set)
> +is not the same as *'expression' {'bit'[,'bit']...}* (which yields true if
> +exactly one of the bits are set).
> +It may however be (effectively) the same, in cases like
> +`ct state established,related` and `ct state {established,related}`, where these
> +states are mutually exclusive.

Would you object if I apply this patch but onlt rhe first part?

I think the above just duplicates what is explained in the new
bitmask part above it.

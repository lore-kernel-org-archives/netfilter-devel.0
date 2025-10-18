Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6341476026
	for <netfilter-devel@vger.kernel.org>; Sat, 18 Oct 2025 13:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760795517; cv=none; b=O7ck8d6jn0Or72lP10wq3h5SewUj0h360+rELhTJq30nhBSvj5SafMky2ysjMP9HYOjfHLLw2xGN1O8qBs4DzJ3HHNf11NMUW2/KLWE8w4QMvHk51m4poVP3Yq4CCmXLLRj9WC+/l+iAwB5l82ektxr310Y+58Jp8P57uDlWJe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760795517; c=relaxed/simple;
	bh=cRMXG8ibY0XwAthVqvUkuzMXAUkqkPlzZ923WWeFi1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OXlr0SO73wI2ovt5hLzD/8WjLUhrxgo2E4sE5RB8RyiZxakia7qwnpynQ+9NNu6EFjIdPXh8T7KKErawa3zcv6tllxGhrGX8wO2khVuY8Z20IeJbUVH19bAGHKW6iQhvW+9+0kB2IqW93aL0CekWDfp/jfEIGnlpLOpmj3umxDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 98B0D6031F; Sat, 18 Oct 2025 15:51:49 +0200 (CEST)
Date: Sat, 18 Oct 2025 15:51:49 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v2 7/7] doc: describe how values match sets
Message-ID: <aPObdWdH3N9jBWkB@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
 <20251011002928.262644-8-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20251011002928.262644-8-mail@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> diff --git a/doc/nft.txt b/doc/nft.txt
> index 3fef1882..4d1daf5c 100644
> --- a/doc/nft.txt
> +++ b/doc/nft.txt
> @@ -764,6 +764,16 @@ Example: When the set contains range *1.2.3.1-1.2.3.=
4*, then adding element *1.2
>  effect.  Adding *1.2.3.5* changes the existing range to cover *1.2.3.1-1=
=2E2.3.5*.
>  Without this flag, *1.2.3.2* can not be added and *1.2.3.5* is inserted =
as a new entry.
> =20
> +Equality of a value with a set is given if the value matches exactly one=
 value
> +in the set.

Yes, or if its contained in the range (for ranged sets).  E.g.

1.2.3.4 will match a set containing 1.2.3.0/24 or 1.2.3.2-1.2.3.5 for
example.

> +It shall be noted that for bitmask values this means, that
> +*'expression' 'bit'[,'bit']...* (which yields true if *any* of the bits =
are set)
> +is not the same as *'expression' {'bit'[,'bit']...}* (which yields true =
if
> +exactly one of the bits are set).
> +It may however be (effectively) the same, in cases like
> +`ct state established,related` and `ct state {established,related}`, whe=
re these
> +states are mutually exclusive.

Thanks, thats very similar to what I had in mind.  You could merge this wit=
h the
previous patch.

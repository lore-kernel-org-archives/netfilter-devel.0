Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EDA3D3CFA;
	Fri, 15 May 2026 04:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778818853; cv=none; b=A9yg2rAYl2EfT6k9778CjM8hrUZynbi/xQuRkLFtjBssvqcU8ZeHTmDiEgFpxRNy947IJZpJQZsi2Y7Eprps/cbW0OnFM5qK3OL1WAclczVVhk/VjDSxIi+bjvTt1sKo8dWPoTLBUqKQoQuGyBenq6YbvfL0mEjRx+QzfQHp3EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778818853; c=relaxed/simple;
	bh=9Ca+GE5zHL3u+0IEX2+Z0VOeZdy7Fkv0nnGmh9y3hh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2SWQ5FP4fvAgObAWoUipPfW/51iqV9lP+eufNed56TH79T/NeYzpKAqh+gqGK3szzf6O1nHMIQm3O4q5LyhbktXnuV/qNLGThNpGZhvuOQaV4fhvsPj5jl2RZ5n1XeGldIEjI9BI+vsTzQQ592bEh3l0TbUIrSNTRywwS5LyaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=h5m3za1z; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="h5m3za1z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ZDReuVCfVZrcHmYVCMEAb8W+xlZArwf954j9YhHTfKY=; 
	b=h5m3za1ztUh188CtdD/j9MIh+F29FStkNcn71OEplUF/eVnbFTAAVJgXo3FoAXlrFe/nbnqiYAL
	o0t4OSHRrByMAzFgem4OSHqVl2xqV0ZUbrjqi7WI0MBe4dgo+m94/ttJ+2tbjvkkgYFX93kNsVung
	75dbLbFnSq2a8C36hlJWfWDGy+3ZX8hTMRfp0sfOzj0XfmQjA+9hTkykMgOjTY2FgghD060tvAwhw
	wQiDAqisdcHXb4mtsBVRGhxfxP+toc0JzyTqWbfRxhv9W3frkOvufAqhLXhXxZvFVlD8ToplHTiuB
	0L46OW/nHaSjzJHMhry+k/Mh1rUYVQHX7mhQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNk1u-00EIoB-28;
	Fri, 15 May 2026 12:20:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 12:20:06 +0800
Date: Fri, 15 May 2026 12:20:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Maciej Zenczykowski <maze@google.com>, Kees Cook <kees@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net 2/2] ipv4: ah: harden ah_output options-copy guard
 against ihl < 5
Message-ID: <agae9ph6pzaQJv3E@gondor.apana.org.au>
References: <cover.1778614451.git.michael.bommarito@gmail.com>
 <423b9ce3b45782c09a2fd9c65ad6674a9abb7c72.1778614451.git.michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <423b9ce3b45782c09a2fd9c65ad6674a9abb7c72.1778614451.git.michael.bommarito@gmail.com>

On Tue, May 12, 2026 at 04:51:15PM -0400, Michael Bommarito wrote:
> 
> diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
> index 4366cbac3f06..8fa31bdf9792 100644
> --- a/net/ipv4/ah4.c
> +++ b/net/ipv4/ah4.c
> @@ -137,7 +137,7 @@ static void ah_output_done(void *data, int err)
>  	top_iph->tos = iph->tos;
>  	top_iph->ttl = iph->ttl;
>  	top_iph->frag_off = iph->frag_off;
> -	if (top_iph->ihl != 5) {
> +	if (top_iph->ihl > 5) {

As I have said before, if ihl is less than 5, then it's invalid to
access any fields from the IP header (in fact you can't even access
ihl itself if it's that short).

So if these packets are getting this far into our stack, then things
are very wrong indeed.

Now I understand that this is already happening so we have to accept
it.  But we should try to fix each and one of these issues as other
places in our IP stack can very much break if you bombard them with
these bogus packets.

To further that end, I suggest that you add a WARN_ON_ONCE for the
case (top_iph->ihl < 5) and put that at the very start of the AH
input function so that i can bail out straight away.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

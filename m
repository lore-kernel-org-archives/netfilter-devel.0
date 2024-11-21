Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CE01CB9E1
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2024 12:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732190567; cv=none; b=fuKwGRYcsW3MNSKk3ns+wxBAg+0NkHDpKOB3JB1udDIVPWyTXTlugVhpdwf2ZuPtxwrdJx/flgYt5Ktmlw+72jbg0RkJrn7nh5dhpOMWYJpy4NEyPwgKuwKh84hTBwzwlBm+js1hZ7x5g+bIsZax0RlXPZuJcVA8it7oEgiiVKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732190567; c=relaxed/simple;
	bh=jEmdvz/T3NJ0HHlnhLH/72+uYa09psLBAOiqF7SKznA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l7nvWDwB6kPoBZlCnFHLLq3V/oQaYGY4/BC6KW+1N26xl4lAf0fZVO5tr68Xbo1XYFpzNIddNG8zMh5722vuvMM/J2jmFR8xJt5MxOP4bovaR/opIZkN/3dWwMTS24J5bIajOt1nlvFgzfvMld4EtUVEmRJDThTIwOk2s0T2hvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tE5tS-0004e3-80; Thu, 21 Nov 2024 13:02:42 +0100
Date: Thu, 21 Nov 2024 13:02:42 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] debug: include kernel set information on cache
 fill
Message-ID: <20241121120242.GB12619@breakpoint.cc>
References: <20241120100221.11001-1-fw@strlen.de>
 <20241120100221.11001-2-fw@strlen.de>
 <Zz5w6NPQ2XsJrpHG@calendula>
 <20241120233854.GB31921@breakpoint.cc>
 <20241121092427.GA12619@breakpoint.cc>
 <Zz8EzBW2kzaq4jXr@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zz8EzBW2kzaq4jXr@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Only options I see is to add a feature test file for this support,
> > and then either disabling dump validation if it failed or adding
> > additonal/alternative dump file.
> 
> Oh right, tests!
> 
> Probably tests/shell can be workaround to remove # count X before
> comparing output.
> 
> It won't look nice, but I think tests/shell can carry on this burden.
> This means # count N will not be checked in old and new kernels.
> 
> To validate # count N, we can still rely on tests/py and the debug
> output as you propose.
> 
> Not great, but does this sound sensible to you?

1. Add new feature test
2. Update dump files to include "# count xxx"
3. when diff -u fails, do postprocess on recorded
   dump file, i.e. sed s/# count.*//g 
4. repeat diff with postprocessed recorded dump
   if ok -> ok, else dump failure

Does that sound ok?
AFAICS we only need to update < 10 dump files,
so churn is not too bad.

Alternative is to always store postprocessed
dumps and then always run sed before diff, but I think
its better to do the extra mile.

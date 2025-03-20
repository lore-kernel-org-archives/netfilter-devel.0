Received: from Chamillionaire.breakpoint.cc (unknown [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8F820AF69
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 08:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742458860; cv=none; b=PHzJpuz4YjBrJsg0xo4S0AToMHyo5pTREt8Dj9XoErV+hW3TSnTfAzAP9ne76D5rREfN9GP+N1bRS9YHApcyl3u0Gb4eQVV+x/LEzjaRMWJLJSyO51zudDfpTeRLhCaMG2ApCQvUpD0vcjm7t321NjxYZa5X024HN9lG4SfFwH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742458860; c=relaxed/simple;
	bh=d109DXzp+T/1lYQaVFR9UnaomLugcCmx+Hr9WI8PW4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=igV3+xks+cfUJ2NimRs18kQDxKs/Po3sGQ/EJQi0xJMGvse5LMMGkbNl2JI21mzrA0GQhImFewwOcHf/GOzqzRQGVL5XMwfOVyasV5ko+laEiEolLvd7Kuq3GsQNi6WVygQHaLY3N4SupQAUKokv7WF1tNpJBvqXVDMpX/A5/Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tvB95-0000RD-Dl; Thu, 20 Mar 2025 09:20:55 +0100
Date: Thu, 20 Mar 2025 09:20:55 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] parser_bison: reject non-serializeable typeof
 expressions
Message-ID: <20250320082055.GA1543@breakpoint.cc>
References: <20250319162244.884-1-fw@strlen.de>
 <Z9tYRHnNO6SvjMQK@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9tYRHnNO6SvjMQK@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > After fix, parser rejects this with:
> > Error: primary expression type 'symbol' lacks typeof serialization
> 
> Maybe... otherwise, please correct me.
> 
> Fixes: 4ab1e5e60779 ("src: allow use of 'verdict' in typeof definitions")

I wasn't sure.  I'll add

Fixes: 6e48df5329ea ("src: add "typeof" build/parse/print support")

which added the 'no udata -> error' test (but only for the first
part of a concatenation instead of all subtypes).

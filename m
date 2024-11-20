Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9D11AF0A1
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2024 23:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145938; cv=none; b=WtgOlZjs60jYJDcWAVOxe7OB9osR1P+77UsIHmPMrA4zOgxyESS8J5L6YLLyIW7q416W5bTKI98IH+/UOIl8gT8mSZxexvf03xXFkPU9NfRAXPbvk8G11qScjuue1eNdAbE/6TZbcxnZk5tFo6Jnbpwi1Ns1QnGHVZfUdH3T4x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145938; c=relaxed/simple;
	bh=NtbhP+wNk7n5OWzJlHfGkFtQgnOIA+Z3MkDLBwQVzAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M50uX//BHgwU6qzFB2/jRwtXcJfB+LPEC6DTam7AMouznfGyls5lE00juG7oCT8c/tm5v1JzD4QuvCDNRTRyiz9rHekiPoh8oQ9rt4GLCkwSX4E3CuIa2o4Bl2Hg2+AtiYs+q/gKcP55MPFd7AZ1kgvr1y9DwcJHiME10btqD+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tDuHe-0000Mu-8u; Thu, 21 Nov 2024 00:38:54 +0100
Date: Thu, 21 Nov 2024 00:38:54 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] debug: include kernel set information on cache
 fill
Message-ID: <20241120233854.GB31921@breakpoint.cc>
References: <20241120100221.11001-1-fw@strlen.de>
 <20241120100221.11001-2-fw@strlen.de>
 <Zz5w6NPQ2XsJrpHG@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zz5w6NPQ2XsJrpHG@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> On Wed, Nov 20, 2024 at 11:02:16AM +0100, Florian Westphal wrote:
> > Honor --debug=netlink flag also when doing initial set dump
> > from the kernel.
> > 
> > With recent libnftnl update this will include the chosen
> > set backend name that is used by the kernel.
> > 
> > Because set names are scoped by table and protocol family,
> > also include the family protocol number.
> > 
> > Dumping this information breaks tests/py as the recorded
> > debug output no longer matches, this is fixed in previous
> > change.
> 
> table ip x {
>         set y {
>                 type ipv4_addr
>                 size 256        # count 128
>                 ...
> 
> We have to exposed the number of elements counter. I think this can be
> exposed if set declaration provides size (or default size is used).

OK,  I will update libnftl then because this means it will need
proper getter for nft sake.

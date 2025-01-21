Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01E51B6D15
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2025 21:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737495198; cv=none; b=iagAf0w9VSRx0/OXncrNOxnqNv3MZA/T2E1L0SacyKiC5VMTJpQ10QBi6r1lhAtsN0niTryNSgG3AkkRK+/R1CWfBzZ77qezTInVUrLhHIuu5MTVHJqBpJsuILQMLcgTLeRiCtTntPE+JTXis38O94hrt0WgDYYWqKUWKxzaFkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737495198; c=relaxed/simple;
	bh=2u1xsLWiXRWgoalyjiLqJ0daxAp5HEDm/nKhuSBsB0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NJVNKHRdeHenW5eeMTUgGNRq5ODvlim04m+yBSDOPj1bPsKJHKrmXqBjBraFAOXRb5t06SrDK693lQ8Is3gl+0G7t9my0NAdXYW/bbfhmrPy/b65dhnaMC3NbYgqq/+JN0LfSNKZOHkJaNCNadUmgb84Mfrz8DYKarX4Jx/7sQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1taLs0-0004d0-MS; Tue, 21 Jan 2025 22:33:12 +0100
Date: Tue, 21 Jan 2025 22:33:12 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nft meter add behavior change post translate-to-sets change
Message-ID: <20250121213312.GA16069@breakpoint.cc>
References: <20250121140011.GA393@breakpoint.cc>
 <Z5APh27viio--M6o@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5APh27viio--M6o@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > ip netns del N
> > EOF
> > 
> > This is caused by:
> > b8f8ddff ("evaluate: translate meter into dynamic set")
> > 
> > Should the last rule in above example work or not?
> > If it should I will turn the above into a formal test case and will
> > work on a fix, from a quick glance it should be possible to
> > handle the collision if the existing set has matching key length.
> 
> I think it should be possible to address this case by allowing the
> meter statement to pick up an existing 'http1' set with the same key,
> this requires to extend b8f8ddff to deal with this.

I'll have a look.

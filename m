Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E062F1A0BC9
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2025 10:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745405539; cv=none; b=s7fEFXU38EZpKXveBar5Q8Ze8jGNlGgx0MFNjDdsLlfRGF1ZDWXy1/qls05BM1e384LZjclhQMyZBtrwcMY34Cu5/IhVSryoB010/2boAU/Ni6YVN8XzWJl2/uK5Nu+UsrBPEqzyjmeVovblLDBY0zVEB5RIuJuW6DZn1eb0W9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745405539; c=relaxed/simple;
	bh=ZpGiiVafPXe2Q65dNhhBNpIYJyEjecPtS7Px5HKaN5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IjV6v5ZugwV5fX0MelXl0dO2jpyNxjr7xsuZ5W3ydp8gFyhy031/k3PRAfy4WfVEbZFrPCSD2jxsD044EDwlMRoq3QmmoCQxK4hhGbEXmJniQ5RkaYIsG/KlcAMeiPxRiKAFJ8wOaa1KhYrMdeOzM/qQSf9MjQVrRJIoI6rWUk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u7XiA-0001qB-Gs; Wed, 23 Apr 2025 12:52:14 +0200
Date: Wed, 23 Apr 2025 12:52:14 +0200
From: Florian Westphal <fw@strlen.de>
To: Shaun Brady <brady.1345@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	ppwaskie@kernel.org
Subject: Re: [PATCH] netfilter: nf_tables: Implement jump limit for
 nft_table_validate
Message-ID: <20250423105214.GA6910@breakpoint.cc>
References: <20250422001643.113149-1-brady.1345@gmail.com>
 <20250422054410.GA25299@breakpoint.cc>
 <CAKwNus-LzHUdN91umsmm6f0PNUr1jYaSR3BSdcSvYsydk7HygA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwNus-LzHUdN91umsmm6f0PNUr1jYaSR3BSdcSvYsydk7HygA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Shaun Brady <brady.1345@gmail.com> wrote:
> > Furthermore, the largest ruleset I have archived here (iptables-save
> > kubernetes ruleset dump) has 27k jumps (many who are mutually exclusive
> > and user-defined chains that are always terminal), but nf_tables_api.c
> > lacks the ability to detect either of these cases).
> >
> > With the proposed change, the ruleset won't load anymore.
> 
> Much of my testing was omitted from the commit message.  8192 was
> chosen as to what seemed significantly above normal usage; I was way
> off.

8k is brain damaged^W^W very high for nftables thanks to the existence of
verdict maps.  The problem is iptables(-nft) and its linear rules.

> What I did observe was that machines (both big and small) start
> to act up around 16M.  Would it ease minds to simply increase this to
> something like 4M or 8M?

What about going with 64k and NOT applying that limit in the init_netns?

The rationale would be that if you have the priviliges to ramp up the
limitation threshold that limit doesn't exist in practice anyway.

> > Possible solutions to soften the impact/breakage potential:
> > - make the sysctl only affect non-init-net namespaces.
> > - make the sysctl only affect non-init-user-ns owned namespaces.
> 
> I may be misunderstanding how limiting control to (only) non-init-*
> namespaces would help. It certainly would keep a namespace from taking
> the whole system down, but it would leave the original problem of
> being able to create the deadly jump configuration purely in the
> init-net.

Sure, but why do you need to protect init_net?

> Maybe protecting from a namespace is more fruitful than an
> operator making mistakes (the initial revisions intent).

I don't see how you can make such rulesets on accident.

> > - Add the obseved total jump count to the table structure
> > Then, when validating, do not start from 0 but from the sum
> >  of the total jump count of all registered tables in the same family.
> > netdev family will need to be counted unconditionally.
> 
> I had not considered one could spread the problem across multiple
> tables (even if you can't jump between them).  This is a good insight,
> and I will account for this.

Thanks!

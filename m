Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EBE18DB03
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 10:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748428801; cv=none; b=OJXhKTSY73SqAI53qkjaod/hagyh8pbOYvMJdSwrRd67mhZYHiaRUOe0w06eQQ3jjYOXiwUHP6oSIbM1IQ014chCc+nsddaIWiBQN4HAwvB9ey4GRxf2Ro020Y1lHHcFLmwkP+9JDmazR+LF+j3d7banycgbkSN3aAZlVV2Z/H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748428801; c=relaxed/simple;
	bh=BEGhBgfSVlrHSzht0ONAE3Z2i86EY5wewO9MXys6Kbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g+yhTvfkarEGEWO3eVUZ4uJlZevMOZvU7XJjFYTdrc8sTEebHt2hKjsaNHaQBGQTBCzH+kxFPEhAUohQW8A7DnCO6x92/y6G7vH89vzo2HokOhaqgCA1m3mtBpdDZghpL2FXu/BTsmptZ2qXtpOAyHY2KChbWYWjvII/dIthuvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AE692603EF; Wed, 28 May 2025 12:39:56 +0200 (CEST)
Date: Wed, 28 May 2025 12:39:18 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/7 nft] tunnel: add erspan support
Message-ID: <aDbn1jGWtzM2989n@strlen.de>
References: <cover.1748374810.git.fmancera@suse.de>
 <ae88d3525c46a523e1b8a0b97450225804033014.1748374810.git.fmancera@suse.de>
 <aDZcyv8zZJh-fpzB@strlen.de>
 <26ea02a2-d1b1-451f-9b1c-f1d27c591b4c@riseup.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26ea02a2-d1b1-451f-9b1c-f1d27c591b4c@riseup.net>

Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
> > tunnel erspan y {
> >                   id 10
> >                   ip saddr 192.168.2.10
> >                   ip daddr 192.168.2.11
> >                   sport 10
> >                   dport 20
> >                   ttl 10
> >                   version 1
> >                   index 2
> > }
> > 
> > Or was the sub-section intentional to cleanly separate the common parts
> > from the tunnel specific knobs?
> > 
> 
> The sub-section was to cleanly separate it and easily understand what 
> are the tunnel specific options configured.

Makes sense to me, thanks.

> > In that case, maybe 'tunnel y {
> > 	...
> > 	type erspan { ... '?
> > 
> > Or do you think its unecessarily verbose?
> > 
> > I think it might be good to make it clear that this is an either-or thing
> > and multiple 'type' declarations aren't permitted.
> > 
> 
> IMHO, adding "type erspan {" won't hurt but I thought it was clear 
> enough. If you think adding the "type" keyword makes it clearer, I can 
> do it for sure.

I think its fine as long as we never add additional, common subsections.
Else it will be confusing, e.g. if this is illegal:

tunnel y {
 id 10
 ip saddr 192.168.2.10
 ip daddr 192.168.2.11
 sport 10
 dport 20
 ttl 10
 erspan {
  version 1
  index 2
 }
 vxlan { ..
}

thats fine.  But if we also allow something like this in the future:
tunnel y {
 id 10
 ip saddr 192.168.2.10
 ip daddr 192.168.2.11
 sport 10
 dport 20
 ttl 10
 erspan {
  version 1
  index 2
 }
 extraops {
   ...
 }
}

Then I think it would be confusing as to what kind of 'nested { bla }'
are allowed to co-exist and whioch ones are mutually exclusive.

Thats why I mentioned the extra keyword.  But I admit that as-is its
not necessary.

> Please, notice that if more than one specific sub-section is set, the 
> bison parser will complain.

Good, thanks for explaining.

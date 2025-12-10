Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23BF1B423B
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Dec 2025 22:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765404900; cv=none; b=RrHVPmqYDOAVRglPISvtuWRatOhBaqF8UilwmCrdipgFe+hpEbkax0sNX5eeWfdL7NucTMkhzEUCtVDJ+o+Ga/4ZcvgrcolL8f38m4GXxOOhKcEJm95LEDBb3S7fdCpxIhUZggN/KagYYrGtOOJxr+LY5XglasozxR0mocpJSdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765404900; c=relaxed/simple;
	bh=y2hMr5H7OJ56pwhEZel7I9w4K3MAr4dRqoPtonyk70Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JBW8WfUIIM5o5XExLVq+oyWZmHjEne31ww5UgBmZU1kmdF6ZqYMfrIai+MZa7qjNNnT3IjkoHdXxt8Pxahw7Uin3OyMsIoUCq6VjZrj8MCyOggE7XJKLN50zfTeAD829kRwl6Mz4vyaxh2x7aAjHWe9OWgnzwt6DSFIJFhcBOkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 978C260291; Wed, 10 Dec 2025 23:08:29 +0100 (CET)
Date: Wed, 10 Dec 2025 23:08:30 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nft PATCH] datatype: Accept IPv4 addresses for ip6addr_type
Message-ID: <aTnvXiYTlQtqVvug@strlen.de>
References: <20251210214945.31389-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210214945.31389-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Complement on-demand ip {s,d}addr expression conversion to IPv4-mapped
> IPv6 by accepting IPv4 addresses in places where an IPv6 one is
> expected. This way users don't have to use IPv4-mapped notation when
> populating sets.
> 
> In order to avoid chaos and breakage, prevent host names (temporarily)
> resolving to IPv4 addresses only from being accepted as IPv6 address.
> Map IPv4 addresses only if users explicitly specified them.

There is a usability issue here that I did not consider.

> -dnat ip6 to 1.2.3.4;fail
> +dnat ip6 to 1.2.3.4;ok;dnat ip6 to ::ffff:1.2.3.4

Pablo, what do you think about this?

I think nft should always return an error here.
I don't see how this makes sense (implicit dnat to a
mapped address).

Phil/Pablo, do you see a way to limit the 1.2.3.4 -> ::ffff:1.2.3.4
expansion to 'add element' ?

Alternatively we could just force users to manually expand the address
when adding ipv4 addresses to ip6_addr sets, but I think its cumbersome.

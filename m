Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973783A75A2
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 12:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774009657; cv=none; b=rpfe8gkef3cvERlFth7gLiN+Oorkj6t3dV5+I3laZuFs6PkXNJptSXcRyvlJqkUQD7xIfHAE7kOrxzaYiK9qovwSxPAPm/SBLXs+lMg4wI0ikgoMKQQ/OrIKfdh/10xnucjYveLkjD536+tkUmMp4DG9GAdHUchxqv/6RivTp7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774009657; c=relaxed/simple;
	bh=uY+2s+g/1PQonWFg4RRGICQyhvReNspGyXspjob+s9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ioJr4vibJDeczEVSIKi8ObUEFlZSHOySX7z3UCG+oAM9r5tI4Wc9snExQNptQIjJuo9ziNNla9TiuvbXCRGim3YWkLsZKa/vVFfNOsYfbD3IA5KINkjreyalEcBbllz9YOIorJpf7RcYDJ7VW1Co4cfRIudPKA3WFdFsAnv42fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cWPd4okc; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cWPd4okc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PdkFdKewePI3YAe37CuZQ6fGU81jZ4GnMhWD2I9NRkE=; b=cWPd4okcEbdIgZIKhJoNZX/E/B
	A0Yu6XFVFBiMy3e84dfqWxRCaOj1Y91jsy8kSDsIO0dLoDoQ+WFQowQbRpgF5Z16AN3zDgAnMZ7g0
	seOdbHh2fun2CP580W5DDPw8cDgksJAqx2n/faYqkc8CGOEYVRM9U5J5yZale0m57GzqRr1Eq//AW
	52fuD8arYIYurZUojhb4SegG7ZMQn+FygWvdUvNAeK9GwqzVKsJLrGxaIvNjozTLgQXkQrfKJ16Uh
	jJh4mJGYrczPcp6w8lNgkA2LPUNT4KH7sCLiPLoo0QQb8nU17YfAvuJCqgfqMUK0cMQIZpYxADnbr
	ACKsWJwQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w3Ywv-000000007sg-16gQ;
	Fri, 20 Mar 2026 13:27:33 +0100
Date: Fri, 20 Mar 2026 13:27:33 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nfnetlink_hook: Dump nat type chains
Message-ID: <ab09NRykeKil5ih9@orbyte.nwl.cc>
References: <abwtAkSF8-SmH684@strlen.de>
 <abxlzn7lymOxWUFa@orbyte.nwl.cc>
 <abyTyJBv47f3v9gd@chamomile>
 <ab0enMtOAFiG0mSN@orbyte.nwl.cc>
 <ab0rbTfE7LWIk7f-@orbyte.nwl.cc>
 <ab0tB2o90FukwQxU@strlen.de>
 <ab0u4JS4Z7THrP6B@orbyte.nwl.cc>
 <ab0xNu8tKdWigNQ1@orbyte.nwl.cc>
 <ab0zy4fOLraYqVPJ@strlen.de>
 <ab047FS3MijyN_Ik@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab047FS3MijyN_Ik@chamomile>

On Fri, Mar 20, 2026 at 01:09:16PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Mar 20, 2026 at 12:47:23PM +0100, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > > Sure, but <=nftables-1.1.6 will still get it wrong. Can we tolerate
> > > > that?
> > > 
> > > The kernel could dump them in reverse. :D
> > 
> > WTF, no no no.
> > 
> > The kernel is fine, this is a userspace bug.
> 
> I think so too.
> 
> One of the main use-cases for 'list hooks' is to display the order in
> which hooks are run.

Guys, you're obviously right! Took me a while to realize this behaviour
is not isolated to newly dumped nat-type chains with same prio, but
other chains may have same prio values as well. So: Fix for user space,
continue as planned in kernel space.

Thanks!

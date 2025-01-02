Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7629DBA3F;
	Thu,  2 Jan 2025 20:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735849377; cv=none; b=CRfQs+prIF8wa47fs4y7OukdIL2xRr0MPEyOsmXXMa8oCUC0dXlptg/CdBKdZIi0Jqt4xPhqKM2uiYUdNc6zGavpCpowY1DQflIV3GS7yzyL55/oSIZxdP1V/OLB3nvi0ymgKQLOLrWcjaEahB9bVf2cgsqlv8b3ICzR0uEXE4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735849377; c=relaxed/simple;
	bh=ojcTt5fJCV6SoZNl+Fa5IUb2QcDR8+cfZ2lmRqYsep0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yt7zaj2BuhbBpSh8FiwX3uESCl9QOw2e30VOWvI1Rc798V8uVnfJSkURC1lqxjbKuLxwaQEdZWyu9uVjSkvFY7YAei2ol3L2ixve5w4tOOtatzS+8BqPJXbQIJz6jLCdQ8jvvpal/BiqU4beT3kafV+EJqgKwgsoX5ugu7Fod/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=i0375h3w; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="i0375h3w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=5D8bYBBPFdzLKKCivcl0oXCDtAPlg07m4t75xRJ+CZo=; b=i0
	375h3wNs3zigUyzwpZdfPwojmG6w0TdVEPnkyENdiRlVEaxJahyQpXApVfOnHsInpO0g/e5MuMzRe
	2Dm+tGwHHqTaCNJaRCaumyW5C9oPHbs4N8vp9cABx2WT2SMXUjI96YhvJgzePjmyqG4d7kkiq+iqw
	cf3zVQmzKAAjvl8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1tTRiE-000qBT-TP; Thu, 02 Jan 2025 21:22:34 +0100
Date: Thu, 2 Jan 2025 21:22:34 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: =?utf-8?B?U3rFkWtl?= Benjamin <egyszeregy@freemail.hu>
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
	daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
	kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: uapi: Merge xt_*.h/c and ipt_*.h which has
 same name.
Message-ID: <31331e58-bc0a-427b-8528-52448764a91e@lunn.ch>
References: <20250102172115.41626-1-egyszeregy@freemail.hu>
 <6eab8f06-3f65-42cb-b42e-6ba13f209660@lunn.ch>
 <90b238e6-65d8-4a1d-b59b-e10445e4c61c@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <90b238e6-65d8-4a1d-b59b-e10445e4c61c@freemail.hu>

On Thu, Jan 02, 2025 at 07:53:36PM +0100, Szőke Benjamin wrote:
> 2025. 01. 02. 18:39 keltezéssel, Andrew Lunn írta:
> > On Thu, Jan 02, 2025 at 06:21:15PM +0100, egyszeregy@freemail.hu wrote:
> > > From: Benjamin Szőke <egyszeregy@freemail.hu>
> > > 
> > > Merge and refactoring xt_*.h, xt_*.c and ipt_*.h files which has the same
> > > name in upper and lower case format. Combining these modules should provide
> > > some decent memory savings.
> > 
> > Numbers please. We don't normally accept optimisations without some
> > form of benchmark showing there is an improvement.
> 
> Some of you mentioned in a reply e-mail, that is a good benefits in merging
> the codes. I do not have test result about it and i will no provide it.

Try looking at the man page of size(1).

> > > The goal is to fix Linux repository for case-insensitive filesystem,
> > > to able to clone it and editable on any operating systems.
> > 
> > This needs a much stronger argument, since as i already pointed out,
> > how many case-insenstive file systems are still in use? Please give
> > real world examples of why this matters.
> > 
> 
> All of MacOS and Windows platform are case-insensitive.

Windows is generally case magic, not case insensitive. When opening a
file it will first try to be case sensitive, if that fails, it tries
case insensitive, in order to be backwards compatible with FAT.

> > >   delete mode 100644 include/uapi/linux/netfilter/xt_CONNMARK.h
> > >   delete mode 100644 include/uapi/linux/netfilter/xt_DSCP.h
> > >   delete mode 100644 include/uapi/linux/netfilter/xt_MARK.h
> > >   delete mode 100644 include/uapi/linux/netfilter/xt_RATEEST.h
> > >   delete mode 100644 include/uapi/linux/netfilter/xt_TCPMSS.h
> > >   delete mode 100644 include/uapi/linux/netfilter_ipv4/ipt_ECN.h
> > >   delete mode 100644 include/uapi/linux/netfilter_ipv4/ipt_TTL.h
> > >   delete mode 100644 include/uapi/linux/netfilter_ipv6/ip6t_HL.h
> > 
> > How did you verify that there is no user space code using these
> > includes?
> > 
> > We take ABI very seriously. You cannot break user space code.
> > 
> >      Andrew
> 
> This is a minimal ABI change, which have to use lower case filenames for
> example: xt_DSCP.h -> xt_dscp.h

You are not listening.

You cannot break user space code.

That is the end of it. No exceptions. It does not matter how bad the
API is. You cannot break it.

    Andrew

Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3713525A322
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 10:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761820468; cv=none; b=DSshGewWyNjt/5lOwoOE/wRRtkRH4+4IaqLJDlm9G8P/Xh9fNmfb6oAI4OGKLyOZ0cKtXi2rUNNqO4dRan1h/3Onci9KXLwUj8+uVPKAP6BaAvoo6G/Nr8C5QV/5jaOZeoxH5jnyAjHnKVgQcRtLY3Xj6Kzgdy4ELGE8doF3Sdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761820468; c=relaxed/simple;
	bh=mYSe+rxO3KYFw+U3nYRe+HWzyKbYT26JAV+JBRsF3ZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ei1ev+P7de+IuSE/OVYDa+MJe2xfYGNt8aL3Qa+yb2mVP20Wk2r1fpQk2Pz2MoJ3/uDlN21dwA1yy6pblAicFCLaQ4MxEB1p4eZc7YLzoi7bRHDCyX206LltgmK50i4QBLFlRFlk8FIO5J3J2vB5Ldxkk4Fz6AfduaKQc4msMbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D567F6020C; Thu, 30 Oct 2025 11:34:17 +0100 (CET)
Date: Thu, 30 Oct 2025 11:34:17 +0100
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v6 0/3] doc: miscellaneous improvements
Message-ID: <aQM_Kc5sk7qmmKDP@strlen.de>
References: <20251028145436.29415-1-fw@strlen.de>
 <0e0112a16c881a1072c3d9dcba4d323b608674b0.camel@christoph.anton.mitterer.name>
 <aQH6T6M-r561jvQ7@strlen.de>
 <80a6e18535c94b60a226c89b9de06070cd154214.camel@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <80a6e18535c94b60a226c89b9de06070cd154214.camel@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> On Wed, 2025-10-29 at 12:28 +0100, Florian Westphal wrote:
> > 
> > What about this:
> >   Thus, if any base chain uses drop as its policy, the same base
> > chain (or a
> >   regular chain directly or indirectly called by it) must contain at
> > least one
> >   *accept* rule to avoid all traffic from getting dropped.
> 
> Isn't that still effectively the same?

?

> I mean the whole summary chapter explains things from the view of a
> single packet, as was also the case for my last version of this
> sentence:
> > +  Thus, if any base chain uses drop as its policy, the same base chain (or any
> > +  regular chain directly or indirectly called by it) must accept a packet or it
> > +  is ensured to be ultimately dropped by it.

Whats that supposed to convey?

I will take your version (because I tire to iterate this again and again
but I think my version is better.

drop policy and no accept rule -> thats NOT what you want.
And thats what the 'all traffic' in my version intends to say.

> Your wording changes this now to refer to "all traffic", which I think
> make an unnecessary specialised case, namely that, where all packets
> would be dropped, unless there's at least one accept rule.

Isn't that a rather important point?

> The typical firewalling case is however that for most packets (that
> might end up on the system) there actually is no single rule that would
> accept them and only some of them get accept.

I would say most are accepted.

> > > IMO it doesn't make things easier for a beginner, if one basically
> > > has to read through everything to find all information.
> > 
> > I added a reference.  Also keep in mind that nftables will already
> > tell
> > you about terminal statement not at end.
> > 
> > nft add rule ip f c drop counter
> > Error: Statement after terminal statement has no effect
> 
> Sure. I know.
> 
> Is it still mentioned somewhere that "comment" is an exception to the
> rule?

Its not an exception, comment is not a statement.  Its isn't
executed/evaluated.

Its no different than

.... accept # do this

... except that "# do this" won't be sent to kernel and not included
when running 'list ruleset' and so on.

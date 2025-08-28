Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D982E5B32
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 09:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373359; cv=none; b=T347MMX9KlU55q4Id29qLfQAt2MTQc1mjPQgg9R/DBbe++EOKaJvQ4umQhhB2H8io2+AUW0kp/Dh+Nyalax7moPeKVt0+sf0atkWAErITAO0SaNRfYbuUl4PLAFXpTIQqUuZxBilITHQuTcXNrauPRa9AbUz8GsXlsZYCLqDAfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373359; c=relaxed/simple;
	bh=9vP1xiWCwQ/QMicgxn0RB4xtl8RVI1c8hM94Z33ExtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oZcGu6i0bLo+T5J1DSU3pU+2QJLzS/IXdXT4fk9fkr2tqw3TgbErlcScioaxIUO7mYJRcDikG1Im7TAmy40ZZhoH1QsVJOJDqLiHjaHFiEsxjfN0j8VF9TP9jlLdOT4V4FkROWLuVlQuUs15c9ItrBlA6alv036fx1qX8PJuIzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A34E6606B7; Thu, 28 Aug 2025 11:29:14 +0200 (CEST)
Date: Thu, 28 Aug 2025 11:29:14 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nftables monitor json mode is broken
Message-ID: <aLAhaqBWKt5wyWZ6@strlen.de>
References: <aK88hFryFONk4a6P@strlen.de>
 <aK9MRw-hiudD_tEK@calendula>
 <aK9QXz16DjYjEWkH@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK9QXz16DjYjEWkH@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Why? Is unfixable to consider this?

I'm not sure.

It depends on several factors:
1. Do we have users of the json monitor mode?
2. Can they cope with *partial* info?
   For non-json, the user will be a human and they
   can the delete messages will have enough info to
   correlate it with the corresponding add messages.

   But for automated robots consuming json? Dunno.
3. Is the burden of correlating the delete info
   with the full information about the deleted object
   on the nft monitor -j side or the consumer of the
   (Then incomplete) json info?

> this is a relatively large rework, I started some code but is
> incomplete, including rule caching to deal with runtime incremental
> updates.

Thanks Pablo.

> I think it should be better to fix what we have then look pick back on
> the rework at some point.

I also prefer repair to "nuke it".
But I dislike the idea of spending time on something that is not
used in practice.

I refuse to believe there are people that prefer to
stare at "nft monitor -j"...

And if there a scripts that consume it, I don't understand
the use case.

Sorry if I was too terse in my initial complaint.

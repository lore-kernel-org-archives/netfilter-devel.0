Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2736F32F774
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 11:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761737304; cv=none; b=OOsKWBnWphPOgtqIOmpuDQTkvhEWzmsRPCIWwPQWwwDj6E/vUdZvxHs+6E1RWNfTGoJ0+iJZbbcw9e8BGRDWWzxYaDags5HTPdYE3l+o6GecYficG1wfgxRGLdricqhD4XPbl77H35hRERfuIw4bl791GwzpWik8eteb2YLppR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761737304; c=relaxed/simple;
	bh=edOrlLoH+uuAlFhn0Eusu3el3MSGfqqoGDr26ePkvuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4cUkTiVW4AMzQ/XNcKJgVyYPQiLN4sHXwuCbTjSBFAd6kCQwOgka6/diCF0Qe7W5slO3X1gvjJDbNu35JQ5K1zdiuVpp51jajt8cNTc+f7itL9dxA76sjL1Obm3Pl2CThFgtwZALUwYEkCnIiIVCcUIlAILSLsZNa/85mMVEpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 91824602E2; Wed, 29 Oct 2025 12:28:15 +0100 (CET)
Date: Wed, 29 Oct 2025 12:28:15 +0100
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v6 0/3] doc: miscellaneous improvements
Message-ID: <aQH6T6M-r561jvQ7@strlen.de>
References: <20251028145436.29415-1-fw@strlen.de>
 <0e0112a16c881a1072c3d9dcba4d323b608674b0.camel@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e0112a16c881a1072c3d9dcba4d323b608674b0.camel@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> IMO that makes things a bit more convoluted, first explaining who can
> call who, then where evaluation continues, then again explaining who
> can call who.

I swapped the two sentences.

> I would however suggest to reconsider in prarticular "all traffic will
> be blocked".
> "all traffic" is... well "all traffic"... but the decision is just
> about one packet, ain't it?
> Also "blocked" is IMO a bit fuzzy. Is the term used before? I'd rather
> interpret it as some generic term that could be either drop or reject
> or similar, but here the example was particularly about when any chain
> uses drop as policy.

What about this:
  Thus, if any base chain uses drop as its policy, the same base chain (or a
  regular chain directly or indirectly called by it) must contain at least one
  *accept* rule to avoid all traffic from getting dropped.

> IMO it doesn't make things easier for a beginner, if one basically
> has to read through everything to find all information.

I added a reference.  Also keep in mind that nftables will already tell
you about terminal statement not at end.

nft add rule ip f c drop counter
Error: Statement after terminal statement has no effect

> Als, "or a user-defined", ain't the base chains user-defined,
> too?

Thanks, user-defined is iptables-legacy lingo (base chains always
exist), old habit.

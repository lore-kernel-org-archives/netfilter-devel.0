Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D326C253B59
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Nov 2025 18:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764353482; cv=none; b=Q+jdbm5zy6Ei972xMNhIDSq/ZydVpImBKQLgxJT6Q+2oriAk9vcPDbJ2K1YqrdVGlDtP++KJKuhqOp0DVop9+XddjA2gP0aMNoxfPkCHToK8rRfJQm4LBVAc5Y6owrgP84g0QKqBPY1rTNidT1fZD6m6GT5x5aIqnNSitN5aXlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764353482; c=relaxed/simple;
	bh=c12nTuDVmy6Y/NsI5rophuDgPVEv2TgT+SQuFO3jQrs=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Apbe61OMRIlNzWcCph1jD78nuaCY1P18ExYT3UE9/lqDznjGrnvUFRE8zMliMIiXnAHHaqMxeWOQ9PWz6YAeHVbuWqOP55V4wfyaq0ZeuopQm0bBS/l3Ogn2Eb1T3mc0J8Hl8KSvNqw/QtnuiyNpeOT0p4MqXhuB/U+prTZ8zw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7D379604DD; Fri, 28 Nov 2025 19:11:17 +0100 (CET)
Date: Fri, 28 Nov 2025 19:11:18 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH RFC 6/6] scanner: Introduce SCANSTATE_RATE
Message-ID: <aSnlxiILhVZn9u8S@strlen.de>
References: <20251126151346.1132-1-phil@nwl.cc>
 <20251126151346.1132-7-phil@nwl.cc>
 <aSnecCkmj1FPGFHk@strlen.de>
 <aSnk1YtMPIhkSK9e@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <aSnk1YtMPIhkSK9e@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> > this might allow to scope this to meta+rate first before adding
> > the exclusive start condition change.
>=20
> Sadly, not. Unless you want to get rid of meta_key_unqualified as well:
> Since nft accepts rules like "hour 10 accept", we have to keep "hour"
> and "day" in global scope.

Sigh, yes, I forgot about unqualified :-(

Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41CC4071E2;
	Fri,  4 Sep 2026 10:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519588; cv=none; b=E+O1J0Pa11P8idA//8SMwsTqU0K+ftM/Lu6u+zlyJ5McySKsXp0shcAP6PVFDXoaKxxdnxTm9xbq87agHK08dIz/iywfZjAeQ5iZ8raXHKoEvD5WUgSh158pLsSGd+xq88HyIDKPhjPz45QJfMCKGWKeZNs0cEJtDSer94yUduk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519588; c=relaxed/simple;
	bh=8YIB2OxX4asYpvEkqAbGeHIPkopNjM9HbG2ToS9a0Vc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ApyJCl4B6AwyFhsss5U/uO01on8liOiGoMO537aCwDhSaq3kHKyUyGz+7CR9+/rk2z/70tyyGdZc+eCiY55w1gR4bROdbjDidIOQ7SpbzdYoxtB73teS5hgo3aV9X9x2Sz6XoMDh9zLnu1cfKx1fJ+ZWI6BfMOgFG4sxbDxeCa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 113196035B; Fri, 04 Sep 2026 12:59:43 +0200 (CEST)
Date: Fri, 4 Sep 2026 12:59:42 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net 00/12] Netfilter/IPVS fixes for net
Message-ID: <apqknmDjAyMpHxY9@strlen.de>
References: <20260903004149.1037028-1-pablo@netfilter.org>
 <20260903190425.332cd930@kernel.org>
 <appds8dn7fuqOvHw@strlen.de>
 <apqjmkrJm94S4ayw@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apqjmkrJm94S4ayw@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Sep 04, 2026 at 07:57:07AM +0200, Florian Westphal wrote:
> > Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Thu,  3 Sep 2026 02:41:37 +0200 Pablo Neira Ayuso wrote:
> > > > netfilter pull request 26-09-03
> > > 
> > > I think the AI is now going too far claiming the patches don't fully
> > > close the issue and/or the commit message isn't 100% accurate.
> > > But we missed the net PR today, already, so why not confirm..
> > 
> > Pablo, I suggest you drop all my patches from this batch and resend.
> 
> I can skip, then pick them up for you to address the issues and
> resubmit.

You can replace the cchecksum restriction patch with the v2 I sent
a few minutes ago, if you feel lucky.  Don't know what else AI
will complain about next time.

As for the nfnetlink patch, I will not send a new version, I don't
know what LLM is telling me, nor what the consequence is or why I
should bend over backwards and add refcounting or whatever in this
patch.

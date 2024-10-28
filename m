Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C31188CDC
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Oct 2024 23:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730156738; cv=none; b=tHVQNP4jO/cAGRZEYhMN7xYNfrMHj86M9ybjmExurUEbWYLyIYaSAXzDuS9XrvmES7R/o0mfi0hPDYR75NEX/rnnqL95GCWhdFi1yDKdrW+VlYpkfRMtnuQoZtZ6RY+5Ei1G4Y54biycSjZsysXw99DSZrfvZPsY2hHfRMRCWC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730156738; c=relaxed/simple;
	bh=tbaEkHS/bs4iBtPlsIQHCGiRJB8Yg7r68t6WE2Tj814=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VfTJB9NOs0dsDGQ8uPy0zfX3mDjosf0TBoXPcqkKUzUrLOJDghQg/NTgkBS3y/c9E3Cd6EuxrakJYvSw5BRzQu8WHXb/NzcHe7PJ24mJVqOE+9amsijXeGZCZdUWaCaGwicfE7O4DG+wBxx7y52ggpeBE9JsKNzzD1eL8ym5bYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=47492 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t5Ynk-004qt9-DE; Tue, 29 Oct 2024 00:05:34 +0100
Date: Tue, 29 Oct 2024 00:05:31 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] doc: extend description of fib expression
Message-ID: <ZyAYu3rHBhCgwO0I@calendula>
References: <20241010133745.28765-1-fw@strlen.de>
 <ZwqlbhdH4Fw__daA@calendula>
 <20241018120825.GC28324@breakpoint.cc>
 <ZxeNzTZLxw1NdgL2@calendula>
 <20241024104103.GA25923@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241024104103.GA25923@breakpoint.cc>
X-Spam-Score: -1.8 (-)

On Thu, Oct 24, 2024 at 12:41:03PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote> > since _OIF and _OIFNAME was restricted to prerouting, nf hookfn has NULL
> > > output interface, so there is nothing we could compare against.
> > > 
> > > Now its available in forward too so it could be selectively relaxed for
> > > this, but, what is the use case?
> > > 
> > > Do a RPF in forward, then we need to compare vs. incoming interface.
> > 
> > This is for an esoteric scenario: Policy-based routing using input
> > interface as key. The fib rule for RPF does not work from prerouting
> > because iif cannot be inferred, there is no way to know if route in
> > the reverse direction exists until the route lookup for this direction
> > is done.
> 
> Yes, that internally sets fibs iif to the oif.

Yes, oif is used for the reverse lookup as iif.

> > > But for outgoing interface, we'd do a normal route lookup, but the stack
> > > already did that for us (as packet is already being forwarded).
> > >
> > > So what would be the desired outcome for a 'fib daddr . oif' check?
> > 
> > Hm, this always evaluates true from forward and any later hook.
> > 
> > I missing now, what is the point of . oif in general?
> 
> Its for use with the 'type' output, i.e. consult fib to determine
> the type of the daddr (multicast, broadcast etc).

Is it possible to use skb_dst for this case to safe the fib lookup?
This is not possible because it depends on the fib tuple, correct?

> I don't see an application for the fib case, with exception
> of the 'rpf lookup in forward' case.

OK.

New patch round to address my silly nitpicks?

Thanks

Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8652130E4A
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2024 08:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726475911; cv=none; b=sW2LdRbSXWQWG8jXlyXjHztkh+Rel48t9dKuZuWVGv2Qu0BrOM7B7ClUuR5vJOisIx6UAAZjiSudO4L0aw9ahO3BPwioNbjWAcEOQWlJyIrJuBrw6CNAV5DgZz+VHcIeJ6t4AxDeVafbLJUZ6L6BlUFKUpDf9XzZ/w7kDXlop+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726475911; c=relaxed/simple;
	bh=MG0P+KS/mNeSagvpvkGxsGZ7//uyUnm6U3v2CPKO+I8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d9fxpMzTKLlAryMF1yFnmMgLzFZ9RAN8jZMqV47uS1TE3E6KvObYTee9Te2mjl1y6ZL/fWtstYj11p0GE2qhuVInSqi6aHQ2HVSe5uMHO/TwjNqr0gAcOUlYgM0nkK4ppMGpdvhpRXRH7hLqfaBPEdiEJyATMOHvjBA6j+RdgQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sq7FU-0003ql-R1; Mon, 16 Sep 2024 10:38:20 +0200
Date: Mon, 16 Sep 2024 10:38:20 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/3] netfilter: conntrack: clash resolution for
 reverse collisions
Message-ID: <20240916083820.GA14728@breakpoint.cc>
References: <20240910093821.4871-1-fw@strlen.de>
 <ZudNn7T7bKcJNTh9@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZudNn7T7bKcJNTh9@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Sep 10, 2024 at 11:38:13AM +0200, Florian Westphal wrote:
> > This series resolves an esoteric scenario.
> > 
> > Given two tasks sending UDP packets to one another, NAT engine
> > can falsely detect a port collision if it happens to pick up
> > a reply packet as 'new' rather than 'reply'.
> > 
> > First patch adds extra code to detect this and suppress port
> > reallocation in this case.
> > 
> > Second patch extends clash resolution logic to detect such
> > a reverse clash (clashing conntrack is reply to existing entry).
> > 
> > Patch 3 adds a test case.
> > 
> > Since this has existed forever and hasn't been reported in two
> > decades I'm submitting this for -next.
> 
> -next is now closed, my plan is to place this series in nf.git for the
> next PR.

Thats fine, I placed this in -next because I thought it was not a real
bug that warrents a change this close to release.

> nf-next will remain open in this cycle so hopefully we can merge your
> updates to reduce memory footprint in the next -rc.

Great, that works for me.

> I cannot go any faster.

Its fine, don't worry.

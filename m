Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D579120FAA9
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Jun 2025 06:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749535306; cv=none; b=qLEzRVpvwVYrq45feTmETj2wlib/HuBd0pYSNp46sV+wbIReZvISxOg6ljBdkdy+WdE1Ro+O0tJY6bIqKVx2B1z6M07vDukrZ80ZhTa5E3MRufDjNzNswOXIDuHQBJWDUB+Ww6uxKWXUUwVkf7S3dVGOYM24AboLqmf3xeAKu0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749535306; c=relaxed/simple;
	bh=0P9aYL2cTbxIZYqAluAPTU0Uq1rexyPf923NCeyDdhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eKoHtgoWEfKnJBJ8ccvndvv1OXVOCy/nrxYZgldHaPaxPlN1R5v2fIiDpWzU5vh0BV0tAh1nxR91lDKqkUi76CtF5pr2P6vhuDlLc/NXES3vzHTXOsnhtOg7GFszRci0F0r5AQ8Y/RNZA9qS+qKz1avdyDvzOXZ2dwCjxx+XOLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6E9EB61151; Tue, 10 Jun 2025 08:01:41 +0200 (CEST)
Date: Tue, 10 Jun 2025 08:01:41 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 2/2 libnftnl v2] tunnel: add support to geneve options
Message-ID: <aEfKRbJehyaq1p8S@strlen.de>
References: <20250527193420.9860-1-fmancera@suse.de>
 <20250527193420.9860-2-fmancera@suse.de>
 <aDZaAl1r0iWkAePn@strlen.de>
 <aEd8Nfv5Zce1p0FD@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEd8Nfv5Zce1p0FD@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hmm, this looks like the API leaks internal data layout from nftables to
> > libnftnl and vice versa?  IMO thats a non-starter, sorry.
> > 
> > I see that options are essentially unlimited values, so perhaps nftables
> > should build the netlink blob(s) directly, similar to nftnl_udata()?
> > 
> > Pablo, any better idea?
> 
> Maybe this API for tunnel options are proposed in this patch?

Looks good, thanks Pablo!

> Consider this a sketch/proposal, this is compiled tested only.
> 
> struct obj_ops also needs a .free interface to release the tunnel
> options object.

nftnl_tunnel_opts_set() seems to be useable for erspan and vxlan.

Do you have a suggestion for the geneve case where 'infinite' options
get added?

Maybe add nftnl_tunnel_opts_append() ? Or nftnl_tunnel_opts_add(), so
api user can push multiple option objects to a tunnel, similar to how
rules get added to chains?

Would probably require a few more api calls including iterators.

Fernando, do you spot anything else thats missing for your use cases?

Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC8312E61
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2024 10:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718361933; cv=none; b=Mj/UyGfGK7FEh52slVBJtILOwrYdhCjmrVN5YNohd0K6H62ntRVNWJ+/vdxAzE/2I4ADG8SrKjdlMk+SW3Kh4KRh70dEjr9rDMMQTAAD6DuO9ZMIiOlnvYYoC+yk/kGTf8RCg4av+FS0kNOPy83C4Jk6H/tjHKGXOngVd2Jvi5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718361933; c=relaxed/simple;
	bh=ZnmUkX2OmA+2x18cgKsXNDOLGh8GFc21J9/kmVGjdy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZP7dh0WDYaJYs9fr33q2uPFDy3+6eNOT2akkXk7q8veg/D16+sI7Vjgw0zUjHdwxLYAFT+jzOQG9C0QEEVJw7iCOOvmIl5tBe5NiVA2pASG0g+1A1r2eMlkjh/r43Oahgarz/LyRq2YJbCxrZV6GDb1dttzveiefkm91bezghT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=IEVfRfnS; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="IEVfRfnS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=009qP3PQJDiDbKnDdcFVOe7ZDK9oFlBxihiWkXs4Tis=; b=IEVfRfnSF2zGEr93VKJAJEmpUB
	bcqJjgDWOgdAs4wggH+ODdymYBzOXBSDNvoIDbC+uMtYr8a1X3OWR2GVpBdGusuccJkC6uzo/Gu9j
	Hxc3OOdc7ng1wBKXcYa2YLgZA8wbpBR13/QmwaqaB4BZhqeQ9HnlsFvYNr2yuU5SZ212Y4wnCx36M
	QL7o1I6v3CBsf/NhHB6fSlM548K+asMh014huCuZElVL1SE+tT5TP3z2x6BmSOYZPOIwuqIKxk79e
	+2CUVnQYtAf0r46IqgT0gK7go5g4TabAkXdtpeWs4l8vwx4RbxkQ54pH/TxBE+rRjiik1EkmiJWwM
	/awAxOrw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sI4Qx-000000001OQ-3yps;
	Fri, 14 Jun 2024 12:45:28 +0200
Date: Fri, 14 Jun 2024 12:45:27 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Fabio <pedretti.fabio@gmail.com>
Subject: Re: [nf-next PATCH 2/2] netfilter: xt_recent: Largely lift
 restrictions on max hitcount value
Message-ID: <ZmwfRzlY1xUbJCmR@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Fabio <pedretti.fabio@gmail.com>
References: <20240613143254.26622-1-phil@nwl.cc>
 <20240613143254.26622-3-phil@nwl.cc>
 <20240613144105.GA27366@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613144105.GA27366@breakpoint.cc>

On Thu, Jun 13, 2024 at 04:41:05PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Support tracking of up to 2^32-1 packets per table. Since users provide
> > the hitcount value in a __u32 variable, they can't exceed the max value
> > anymore.
> > 
> > Requested-by: Fabio <pedretti.fabio@gmail.com>
> > Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1745
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  net/netfilter/xt_recent.c | 15 +++++----------
> >  1 file changed, 5 insertions(+), 10 deletions(-)
> > 
> > diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
> > index 60259280b2d5..77ac4964e2dc 100644
> > --- a/net/netfilter/xt_recent.c
> > +++ b/net/netfilter/xt_recent.c
> > @@ -59,9 +59,9 @@ MODULE_PARM_DESC(ip_list_gid, "default owning group of /proc/net/xt_recent/* fil
> >  /* retained for backwards compatibility */
> >  static unsigned int ip_pkt_list_tot __read_mostly;
> >  module_param(ip_pkt_list_tot, uint, 0400);
> > -MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP address to remember (max. 255)");
> > +MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP address to remember (max. 2^32 - 1)");
> >  
> > -#define XT_RECENT_MAX_NSTAMPS	256
> > +#define XT_RECENT_MAX_NSTAMPS	(1ULL << 32)
> 
> Won't that allow massive mem hog?

You're right, struct recent_entry may become ~32GB in size.

> Actually I think this is already a mem hog, unbounded
> allocations from time where we had no untrusted netns :-(

With the current max of 255 stamps, entries are at max 1KB in size. Is
this bad already? Given unrestricted rule counts, there are various ways
to cause large memory allocation, no?

How about restricting MAX_NSTAMPS to 1<<16? Max entry size is 568B, a
little less insane than th 32GB I thoughtlessly proposed above. :)

Cheers, Phil

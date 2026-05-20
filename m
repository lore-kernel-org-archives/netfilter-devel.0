Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B766B3D9DB8
	for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2026 10:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779274140; cv=none; b=t6SpYZ8pQj3+F0GCCFMuzeOFortcUhPLQXq2ijeiaa1O7T4xToVBCJ0xO7Ix4X/a88HaVYdWVLvYmb44ep45VhXZbbKG2zNP6+8FcJSH7sxbNWfyDnDqUqnSKpFIR/J/i/kuvDwk2yPq5aRsdM0+vtZPr9kBvsmaesRUjf6nsh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779274140; c=relaxed/simple;
	bh=plZ2dEqs3UHLzrtZGwTny7KGNv4cM5L/Xws71S1G0HE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZ3DebVgM2wxb4RwJkUY082/hAYhcZUXnogmdp1hoWHNfnPgamxgkMc5gUNfZAZCSS8sv0PbT9BHX2mzs4Wujh9ZOIaw/IRVHpT3FMEpC21HS6ijEEN+nZFsR0C9RqwWY0ck09a+ZiqcV2Vds/4VNyQlzs3In7mUe0NBPlO9m84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=g59B03A3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="g59B03A3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=X2LmAGDnnRFEpp8RzotzT58tI4zAOf8RP6Cg1jv0T3w=; b=g59B03A3xKErFGGdunInnsqa1L
	C3Ck0yPFI+HBq3xFOYI8JRNS+TfLaoV8oFnvLex8Zubg55mVjUhIufRf4EWva6ZEqcZOcQbbWsvDn
	Eiuq3nNezmpQgbtpwOEaHotAEFSkP1zKwhhfsQSu7ijufbSr5JdrpL8qQfK65CRSOO03lzEnO8ePn
	92eG/XA5unTck1OWJOrltISckBC9QGuJ2rL03QIVPGtOut3kD+YzgN3zVTG8rj1bYZG5rOs1YqVkK
	2Nw/owfat5/iWi8NRL5OPf5sr9LTEhS8jIWc0AA2p87CjlBFrUXkCbTuSFSBVbzeNU2j9TL6q/rVL
	CXH8seGg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wPeTn-000000007jA-0de3;
	Wed, 20 May 2026 12:48:47 +0200
Date: Wed, 20 May 2026 12:48:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
	coreteam@netfilter.org
Subject: Re: [PATCH nf v2 0/3] netfilter: nft_fib_ipv6: handle routes via
 external nexthop
Message-ID: <ag2Rj3Qdz8axaCr4@orbyte.nwl.cc>
References: <20260520023411.391233-1-jiayuan.chen@linux.dev>
 <ag1-KRkLjQXHa6aJ@orbyte.nwl.cc>
 <ccfd7143-0f0a-4578-a195-65b84ec00cfb@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccfd7143-0f0a-4578-a195-65b84ec00cfb@linux.dev>

On Wed, May 20, 2026 at 05:39:48PM +0800, Jiayuan Chen wrote:
> 
> On 5/20/26 5:26 PM, Phil Sutter wrote:
> > Hi,
> >
> > On Wed, May 20, 2026 at 10:34:08AM +0800, Jiayuan Chen wrote:
> >> Patch 1 switches the fib6_siblings walk in nft_fib6_info_nh_uses_dev()
> >> to list_for_each_entry_rcu().
> >>
> >> Patch 2 fixes the slab-out-of-bounds when the matched route uses an
> >> external nexthop object.
> >>
> >> Patch 3 adds a selftest covering single nh, nh group and old-style
> >> multipath.
> >>
> >> v1: https://lore.kernel.org/netfilter-devel/20260519041431.396218-1-jiayuan.chen@linux.dev/
> >>
> >> Changes since v1:
> >>    - new patch 1: list_for_each_entry_rcu() conversion split out
> >>      (Suggested-by: Phil Sutter)
> >>    - patch 2:
> >>      * drop redundant ternary in nft_fib6_nh_match_dev_cb (Phil)
> >>      * drop redundant "!= 0" on nexthop_for_each_fib6_nh return (Phil)
> >>      * use READ_ONCE() for rt->fib6_nsiblings (Phil)
> > Will you send a v3 addressing Florian's concerns regarding the test case
> > in patch 3?
> 
> 
> In the current version, the selftest has already incorporated Florian's 
> suggestion,that is,
> 
> to verify functionality rather than just serving as a bug reproducer 
> (using nf_ok/nf_bad counter).
> 
> 
> Sorry for not making this clear in the changelog : ).

Oh, I missed that. :)

Test looks good, so for the series:

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil

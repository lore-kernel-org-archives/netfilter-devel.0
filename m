Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EAD2F272B
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 10:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752660484; cv=none; b=BsAZKEiKNhEOs63ltHztTDUGV2KmywzFQpv5zb0He9XN3xcSSzuDgz1m7lG0aDNYxSpz8tcEoabrvou4HqOL4Ag6a5SNeRgkTjRDd21PTLkdO0RxfS1cPicvR3FlSixW4ATosgcU133TtXw9nUiLRYzg/ys8112Z380Gb2QFdyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752660484; c=relaxed/simple;
	bh=4tFTc1X36kiWwu9TCTMuPqZ3G8ePlI2PTIdElChLWmI=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bf3fBDoZN8Z5YO2TI3pMrjGD+bg+LZyRjBCe1SiiclucYozMLNj/wua+QH2O5co5ebwi8CgJV+EQ+BYc4+vXdwFzv6wEmSAmMjXKHjLHxZG5vo0OH7frdyF7v39Eo0WA+eSVysm4FV4KeQS6mGgqXc7X7VAD14dPr3Odxmtpn/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CDBBB60637; Wed, 16 Jul 2025 12:07:59 +0200 (CEST)
Date: Wed, 16 Jul 2025 12:07:59 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH v2] utils: Add helpers for interface name
 wildcards
Message-ID: <aHd5_6m4WgC6--0T@strlen.de>
References: <20250715151526.14573-1-phil@nwl.cc>
 <aHd0mxVSp_cFcn16@strlen.de>
 <aHd4k3kkCfI2o4NV@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHd4k3kkCfI2o4NV@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> On Wed, Jul 16, 2025 at 11:44:59AM +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > >  #include <string.h>
> > >  #include <stdlib.h>
> > > +#include <libmnl/libmnl.h>
> > 
> > Why is this include needed?
> 
> Because of:
> 
> | In file included from udata.c:9:
> | ../include/utils.h:88:40: warning: 'struct nlattr' declared inside parameter list will not be visible outside of this definition or declaration
> |    88 | const char *mnl_attr_get_ifname(struct nlattr *attr);
> |       |                                        ^~~~~~

That struct is defined in linux/netlink.h.

But you can add a foward declaration for this, i.e.:

struct nlattr;

As the layout isn't needed for the function declaration.

Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86823274B30
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 16:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752682341; cv=none; b=HgdVe4AWUFBMesoZBgabN/qY5UTafTy551MY58mu5/y2cf1Qo9PnoWBNTLn5y+FeejG4VJxg61JmLqSDUO0lstgNCg4k/Sp4xcgHNb8/hdit6n4hqsU7hGMKkREnlUfSoAqaeK8ywyurYXyd/lohYL3+1JjE/bF1yvQC9wwgNA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752682341; c=relaxed/simple;
	bh=MsfGiGAmQfQGVXK0Jru7l8IQMoWtft7n2+rv04cju7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mFl7v0E0hl7Pd8Ucv+GkZ33q94+A5ge5M87SJPpVOzr2Yq/YBNsGv6bdiSuNUm7tSsbZtRypnfS+KPsA85Bsa6yh8P+Osf6oQpNm07HtALOB4pb7QbfA+KlmyzyBGjM/kkVwXoghDEOSjhldzGdYcnNeyMIF6DoXJGDgl2hHfGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=la7GR5lD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="la7GR5lD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+8YbASDGy4O8K8UUks7Q3H44wO3ZoJ1yGXypnRRF/hg=; b=la7GR5lDo/+2BWLPt/Y+Vk4Fq5
	n0XZeSwfA+8UeZjbqucCr5cXgwf6mc2qtgFulKe2SVgb79f31C/xjnXcPDNWvBoblr/yDBqjsth17
	NT/DP5hKpQMlqxRtcvxErn5OgoLwXC958pVK1bv9TgwniCTHsrm12y7QBKnpW5C2iH3lkS4LYmnVD
	65PMIMKhCeF9b3NIdbEmXEWaqZ7t0hKttcSJ7uibJl5wT/fjj0ueO2z/Qzg8/5E/mk3o+zh3WGvoj
	M2s20u5oSqKJ/z6E2zUOis910lvxzEcDlnJCVfAiGTo4lynmZjHzfYSyBAe3YDi2qzQSkeHOdXpA3
	ZpCaKJvw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uc4jo-0000000013V-3rFe;
	Wed, 16 Jul 2025 18:12:08 +0200
Date: Wed, 16 Jul 2025 18:12:08 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH v2] utils: Add helpers for interface name
 wildcards
Message-ID: <aHfPWDRFey2444T-@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20250715151526.14573-1-phil@nwl.cc>
 <aHd0mxVSp_cFcn16@strlen.de>
 <aHd4k3kkCfI2o4NV@orbyte.nwl.cc>
 <aHe5t9kb7fUWjAyQ@calendula>
 <aHe6cteE7g9zjBii@calendula>
 <aHe69yUQ3X_j--K6@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHe69yUQ3X_j--K6@calendula>

On Wed, Jul 16, 2025 at 04:45:11PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 16, 2025 at 04:43:02PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Jul 16, 2025 at 04:39:54PM +0200, Pablo Neira Ayuso wrote:
> > > On Wed, Jul 16, 2025 at 12:01:55PM +0200, Phil Sutter wrote:
> > > > Hi,
> > > > 
> > > > On Wed, Jul 16, 2025 at 11:44:59AM +0200, Florian Westphal wrote:
> > > > > Phil Sutter <phil@nwl.cc> wrote:
> > > > > >  #include <string.h>
> > > > > >  #include <stdlib.h>
> > > > > > +#include <libmnl/libmnl.h>
> > > > > 
> > > > > Why is this include needed?
> > > > 
> > > > Because of:
> > > > 
> > > > | In file included from udata.c:9:
> > > > | ../include/utils.h:88:40: warning: 'struct nlattr' declared inside parameter list will not be visible outside of this definition or declaration
> > > > |    88 | const char *mnl_attr_get_ifname(struct nlattr *attr);
> > > > |       |                                        ^~~~~~
> > > 
> > > I think this helper belongs to src/netlink.c

This was about libnftnl, I put the helpers into src/utils.c there with
nftnl_ prefix.

> > Not a deal breaker, Florian's proposal is also fine.
> 
> Actually, my suggestion would be to add it to nftables/src/mnl.c with
> mnl_nft_ prefix (not to src/netlink.c), if it turns out this is useful
> to other projects, it could be moved there to libnftnl.

I also added it to nftables' src/mnl.c with mnl_ prefix, will change
that to mnl_nft_ as suggested.

Just realized nft.8 needs an update, too. Luckily, documentation is
pretty forgiving when it comes to typos and other goofs. ;)

Cheers, Phil

Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D906A21C9E3
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 14:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752676799; cv=none; b=jQlI8hGqlSb/JaKSzCQ7d/fLZNMZSwt/qFkaq6nsAdlQ9O9G+B9pyy5a4W3elkbApVRAsdacgb2rHErOyUtXhkDRHAY/BwWEK2wiWF+4b3CbNaNoEkJrtt7DMXbqL6sx/qAlBHzF8HcTAlzB+BtE08iHreZA9g2BRdtvrMjx/ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752676799; c=relaxed/simple;
	bh=+0mx5g6gvixQbAjnFLM873pEU/KigDgOh0L/kDcR2Sg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qZh7OuVbYLJwNagBg89HxYHWdMBh2r+V653wpiFr0jcOH/XV53DN9jelHN0t1YMD4+4qlh8hn++xH3cpOZLBOs78Vf0LNKY1XIFKrU4VCmj40R7brrHydpBFJFRt4zt3ENxk1lyZwUT1ugW1KNyb/8rcM8PZz4Q9KWDV9aMSjdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=psXtG07i; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=psXtG07i; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="psXtG07i";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="psXtG07i"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D13A060264; Wed, 16 Jul 2025 16:39:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752676794;
	bh=kkZetd+rXpX80LDKT0KKW2QGoGHwkihkvdmQ9ZrOyi4=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=psXtG07i/R5x/3M/7fuL8LQHJ2Ifu7+Ql45zmO6Wbkk28gHaTq8PCAe0H6M8CiGDL
	 IX9mmMsiLauaNKyfziyXy8owxB/YRu3wAjG/HlAAH1uDmSGrhKmzA3qiTudOb7+ISX
	 zy4AFGECh0dXaoDoLDF+SrFy718p+42vuhBaKJOSQLatdFLVSinvF/AL40EbBcybCx
	 t85dD7NJZWMdIJLUMFMQWPQYKZT099uxucIzNXIzpOK7u/H6gl14OYe32iIDsIWSGo
	 z6XiFVp7lKuJZef6BLFeZWK10SG7Cphjku+Q88WoRIWlP341KCHBuCzhZ50xnsSnyo
	 bobyk1w0JTFCg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3D0BA60254;
	Wed, 16 Jul 2025 16:39:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752676794;
	bh=kkZetd+rXpX80LDKT0KKW2QGoGHwkihkvdmQ9ZrOyi4=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=psXtG07i/R5x/3M/7fuL8LQHJ2Ifu7+Ql45zmO6Wbkk28gHaTq8PCAe0H6M8CiGDL
	 IX9mmMsiLauaNKyfziyXy8owxB/YRu3wAjG/HlAAH1uDmSGrhKmzA3qiTudOb7+ISX
	 zy4AFGECh0dXaoDoLDF+SrFy718p+42vuhBaKJOSQLatdFLVSinvF/AL40EbBcybCx
	 t85dD7NJZWMdIJLUMFMQWPQYKZT099uxucIzNXIzpOK7u/H6gl14OYe32iIDsIWSGo
	 z6XiFVp7lKuJZef6BLFeZWK10SG7Cphjku+Q88WoRIWlP341KCHBuCzhZ50xnsSnyo
	 bobyk1w0JTFCg==
Date: Wed, 16 Jul 2025 16:39:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH v2] utils: Add helpers for interface name
 wildcards
Message-ID: <aHe5t9kb7fUWjAyQ@calendula>
References: <20250715151526.14573-1-phil@nwl.cc>
 <aHd0mxVSp_cFcn16@strlen.de>
 <aHd4k3kkCfI2o4NV@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aHd4k3kkCfI2o4NV@orbyte.nwl.cc>

On Wed, Jul 16, 2025 at 12:01:55PM +0200, Phil Sutter wrote:
> Hi,
> 
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

I think this helper belongs to src/netlink.c

> 
> > >  #include <libnftnl/common.h>
> > >  
> > >  #include "config.h"
> > > @@ -83,4 +84,7 @@ int nftnl_fprintf(FILE *fpconst, const void *obj, uint32_t cmd, uint32_t type,
> > >  int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
> > >  		       uint16_t attr, const void *data, uint32_t data_len);
> > >  
> > > +void mnl_attr_put_ifname(struct nlmsghdr *nlh, int attr, const char *ifname);
> > > +const char *mnl_attr_get_ifname(struct nlattr *attr);
> > > +
> > 
> > nftnl_attr_put_ifname, nftnl_attr_get_ifname?
> > Using mnl_ prefix seems wrong, that should be reserved for libmnl.
> 
> I chose the prefix since they 1:1 replace calls to mnl_attr_put_strz() and
> mnl_attr_get_str(). You're right, since they are implemented by libnftnl the
> prefix is wrong. I was a bit undecided whether to put them into libmnl, but
> they are a bit too specific for that. Will fix the prefix and respin!

I think they are fine in nftables only.

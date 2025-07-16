Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361C82494FF
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 14:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752676989; cv=none; b=GITSDCAzl6NMG0/A1XeZBwhZEsuaS+Rd41dKKMNDGIVNAiLYG6UNyRpBZ2TLX9AtmggTh2JrgAQ4nR+Q9idPo4eUZUoiu4eOv9Ih75nElnnnCJFJLhR9xYN7s/X41p3CxXrO2VVfzMbmt6l5vYLhrpBc/rlP/HfsGEZH0A9ZAoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752676989; c=relaxed/simple;
	bh=4CEUAYAuQNnzUzPT/s5Jh7FguWu9ilmxJ9ZeALlOkEE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=drI7gGoPf+NcyulLpKxQB9lX6Y9gO3DYnzWjOopm9P93b1zEEBhTbE2w/y1GOMAntapqCd1XyMQ5EwUDTlNHqMagcl3iZXgG8y8A7IeP5HTC7FHuKxpzWUjfgKhXbjR7Q6KP7rNcd9/9MXnS7pDETSjA2eDU2ESLYnW9oM3Wack=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=caUlMQRA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cAGYnxcf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="caUlMQRA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cAGYnxcf"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 98D726026F; Wed, 16 Jul 2025 16:43:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752676982;
	bh=v1e3N8NFIGCBl8wFO39MrJt3Yj6w9cc7J6yrZ1cTxKs=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=caUlMQRAyHU9iJE3fuvpnTdR/T682H+TI58JYwkRdj40/M/owewsSBg2PXizUFKbe
	 cwcTllkfJel8Nw9n2O/RgIcqEoMhn8waiIgbPl+RhRrmPo4ChRzs30mJRptUDAx1y/
	 sLzB72gpgcXUiKFsnKAfqTQO6nSNYwkWZPbUHTLNZ8Et8GtmybRxhI0S4vaLpMATCN
	 f2xbnKs4fo0l8xONOjC7ovvVHjA4D/o33YbS8DeKDWUUmRVuVBf48cTx2c4rwTV6mX
	 IVL+Mgpfg/eJPExP7lYamRd+dT0vz3j1UUM6RWCV4KAr7FeUzNVv3C2ggmL2g1Ss/j
	 oLQOdHmccZYdw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9843E6026B;
	Wed, 16 Jul 2025 16:43:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752676981;
	bh=v1e3N8NFIGCBl8wFO39MrJt3Yj6w9cc7J6yrZ1cTxKs=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=cAGYnxcfr5nIuMeAhwSVBpnSI+67PiLDhDu6sBbpMinYo7ldlK5TD94r9bagiOK9A
	 OPdrVNOMlW6HAE35bkUJBEHtsUde3AnOvOjNCQojIPQ/TXymWpZC/dBcJzHbK27zsc
	 VCkRS0U5BnVioOm+164L1fgSrYPV/M+9MvYduVa4A0p29gR4cqBuW1qAeC/oXQLnQ9
	 58zh3bcs0Pwj9x3njYwOwpwE1XNN7bTe5VQ+g7N0VqDQS816QzcAYUexnOVts7vUn3
	 Do1urnDBsQhwQd4oS9AHCckaAx56mL4XDvVEPTA4bf4N6HP+mIjhBlSxDu+5NkP94C
	 WUEGGrCRWysEg==
Date: Wed, 16 Jul 2025 16:42:58 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH v2] utils: Add helpers for interface name
 wildcards
Message-ID: <aHe6cteE7g9zjBii@calendula>
References: <20250715151526.14573-1-phil@nwl.cc>
 <aHd0mxVSp_cFcn16@strlen.de>
 <aHd4k3kkCfI2o4NV@orbyte.nwl.cc>
 <aHe5t9kb7fUWjAyQ@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aHe5t9kb7fUWjAyQ@calendula>

On Wed, Jul 16, 2025 at 04:39:54PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 16, 2025 at 12:01:55PM +0200, Phil Sutter wrote:
> > Hi,
> > 
> > On Wed, Jul 16, 2025 at 11:44:59AM +0200, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > >  #include <string.h>
> > > >  #include <stdlib.h>
> > > > +#include <libmnl/libmnl.h>
> > > 
> > > Why is this include needed?
> > 
> > Because of:
> > 
> > | In file included from udata.c:9:
> > | ../include/utils.h:88:40: warning: 'struct nlattr' declared inside parameter list will not be visible outside of this definition or declaration
> > |    88 | const char *mnl_attr_get_ifname(struct nlattr *attr);
> > |       |                                        ^~~~~~
> 
> I think this helper belongs to src/netlink.c

Not a deal breaker, Florian's proposal is also fine.

Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB0222D7B6
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 14:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752676703; cv=none; b=Kk4s/4lAe44ZFEyVKqNBUarmQD2honmvnWASqYcKX/52xbM90GZWuUgSZjHCBUh4y3TtXeEyhlgZGZ+E3CqwWjGR1KQFafVL/kga1qitPIfzs7jDq37pHiUSc6xT5RVpNlg4DnIQO4MfG7njX87UImLmi+6KGlL5/d15wGng0c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752676703; c=relaxed/simple;
	bh=gZMzAKNhTyNJWLZ+3hPtE3zlA5SDocmoOEYRIziOml4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6JQZdn+Jzsc0Cht04FnCOY8OP07hG+/u8nloDFHPpB3MPcts3xrb13R6mRHdlrJkP8EfPiepN1GBcYd6Dw7mnlgdOGshAvgr6BsQHdFnpdsbdwOKvuIW/8REijTrewQhgsug9W3IfUHTt1aYdNd+FGQ+LCpUC4kqruiOkg4SMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VL5coz84; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OJP8Ait8; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VL5coz84";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OJP8Ait8"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2F0CD60342; Wed, 16 Jul 2025 16:38:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752676697;
	bh=hvsUJwAtLg8Bry0SBuoTXewoMG1V0Fz4PtLJSYGJmsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VL5coz84yi9RiXb6GFcIxUKbyY26F2KVWPPhh/ymaXF+k9LN4C5Lnb63NiU06J9eb
	 wvesa/vLktlW4hzR67Uvw9rxQASKGPqpnZN+bojvftsbi3V+dY7ugZetauEZNhPh1/
	 3DRLEoo6LsKKfG6GwsaOSNXzrygcDsiGeHZpejfTttawQmHvvhX0MkBg/Cy5RZqXpe
	 1grB3eSMqU3qRwF3bD8zuqe2o/CxtXhXPIjowPxbrllvhBDDxPugJifZjJgIAtQRdf
	 Sksgv2s9WvnnMwWAWz7KQtnA3idvUqxm9EF54fLQp/S/sPX6DvgvQISbFoy2ovyyPk
	 1pdlh9htihzlA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5EB596033D;
	Wed, 16 Jul 2025 16:38:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752676696;
	bh=hvsUJwAtLg8Bry0SBuoTXewoMG1V0Fz4PtLJSYGJmsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OJP8Ait8xRs/oiI1h7QPqkJQPcxNcT7CrtQRUJZlwsBktVw2VcxqPIy88/eJtWJ0x
	 dvshOmvGjVS74+TsaLFVCyQgahIE88MClTNrJHiv1UTAaly15CAe3y7cYsDXykHIYb
	 v4q7hGRpa4BDSXm13nVHKrDGCqmpFhnu+BevN2XfIy6EoVSVaNSVJgH+yLtgOV16D7
	 i3nVbpEfRgH+3k10Avh/G5QAyrNKQZzaFALh0vYVCUJhqYyRBmcNHkbw05aTBbYhhk
	 I5DjBmQfuYOtg150m+g7Wi4xrgn02oQj+xQ8K6kAmqlPYj7ATRHtq0Ney5KRddJuaK
	 MoGFL6c8lA+ZQ==
Date: Wed, 16 Jul 2025 16:38:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH v2] utils: Add helpers for interface name
 wildcards
Message-ID: <aHe5VtQ3-xq5ghmJ@calendula>
References: <20250715151526.14573-1-phil@nwl.cc>
 <aHd0mxVSp_cFcn16@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aHd0mxVSp_cFcn16@strlen.de>

On Wed, Jul 16, 2025 at 11:44:59AM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> >  #include <string.h>
> >  #include <stdlib.h>
> > +#include <libmnl/libmnl.h>
> 
> Why is this include needed?
> 
> >  #include <libnftnl/common.h>
> >  
> >  #include "config.h"
> > @@ -83,4 +84,7 @@ int nftnl_fprintf(FILE *fpconst, const void *obj, uint32_t cmd, uint32_t type,
> >  int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
> >  		       uint16_t attr, const void *data, uint32_t data_len);
> >  
> > +void mnl_attr_put_ifname(struct nlmsghdr *nlh, int attr, const char *ifname);
> > +const char *mnl_attr_get_ifname(struct nlattr *attr);
> > +
> 
> nftnl_attr_put_ifname, nftnl_attr_get_ifname?
> Using mnl_ prefix seems wrong, that should be reserved for libmnl.

Agreed, mnl_nft_put_ifname, I would suggest, for consistency.

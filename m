Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3983624C8
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 11:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782212500; cv=none; b=sC5WzpVfApKdqW5ylKBVvdPlW6fxrGFixKrDhzi79CGZ+YaGoSsE2a0/Xf0teNI6DGqOqMguPAvo36Dna+WWShlVnxG6Egjw4mjRRsFspkxLsh2eoOKq29fhSDnCiO4Z1YtrC9Ep8T6iY8pZOnUSGhcMAy48TSNRi8zfosSXJuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782212500; c=relaxed/simple;
	bh=gIFJIp6tIZyamHUmwSELMuBQt9gOkj4j47gv1zzBdjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gxThVI3/UkFZA0FytAiwNg0qsMxz0EKwfAAgrJM9ZEOVnIk8FGUtCkj9Qt5Gj1PNOvorJ6ng3NtsEam0xLUCU0Qg8fLOHU1TYtKwOpgAsdnHbDpn2N2SRxyMTLmFGaU1I0rH9gm8qTNp1Drm6JQIylDuiTglrC+vYj6Fbmtr63s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gWQjwxpg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gWQjwxpg"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3C5AA60193;
	Tue, 23 Jun 2026 13:01:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782212496;
	bh=5x7ufIi5DZXb0SxoJtYETQi9+t2mwEP8whsnZRNZ/2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gWQjwxpg2u8t5cUdW/K1lNww9vMqeQUkMi9ErbI4RCT9O2z28jZh8yV5dp40wxtEX
	 Qsj6yzDrl/0vaJnHTLxDrS0RSkIJIUYiuzDxdfpehrgZsS1asClOyXU1IfNU5NG99d
	 kL54w5BuMS+YnpoGzCJ4rDEYc+o/objwBUM643Pkzp39fLQ3aKHl7uwo42aBU3FMsy
	 FqyreW4rgVe9Fgkyd2ewWLSUh8pruv/n+w/HDbcIAZLFXcn4Femz/BoHpGTL+Wwnzv
	 8CdPWnjTIDFTKXw4QO5AuXq65S+m6iwrSkNZ36b043/6kYAGmhbIHieP3v5FxJI/cC
	 f0jXKrIlcJgOw==
Date: Tue, 23 Jun 2026 13:01:33 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ratheesh Kannoth <rkannoth@marvell.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: : Re: [PATCH] libmnl: add MNL_TYPE_UARR for devlink u64 array
 attributes
Message-ID: <ajpnjXPm4ccxQOmc@chamomile>
References: <20260623043755.2435685-1-rkannoth@marvell.com>
 <ajpWYAQ1Od2ilpAk@chamomile>
 <MN0PR18MB58472CDD42C11ADA73EB5AA6D3EE2@MN0PR18MB5847.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <MN0PR18MB58472CDD42C11ADA73EB5AA6D3EE2@MN0PR18MB5847.namprd18.prod.outlook.com>

On Tue, Jun 23, 2026 at 10:33:50AM +0000, Ratheesh Kannoth wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org> 
> Subject: [EXTERNAL] Re: [PATCH] libmnl: add MNL_TYPE_UARR for devlink u64 array attributes
> >  include/libmnl/libmnl.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
> > index 0331da7..078d517 100644
> > --- a/include/libmnl/libmnl.h
> > +++ b/include/libmnl/libmnl.h
> > @@ -133,6 +133,7 @@ enum mnl_attr_data_type {
> >  	MNL_TYPE_NESTED_COMPAT,
> >  	MNL_TYPE_NUL_STRING,
> >  	MNL_TYPE_BINARY,
> > +	MNL_TYPE_UARR = 129,
> 
> Why 129?
> 
> >  	MNL_TYPE_MAX,
> >  };
> 
> I would like to merge https://patchwork.kernel.org/project/netdevbpf/patch/20260615041042.549715-1-rkannoth@marvell.com/
> But this has a hard coded value 129. I believe, I need to use a macro here instead of 129.  
> 
> 
> The value 129 is based on __DEVLINK_VAR_ATTR_TYPE_CUSTOM_BASE = 0x80 (i.e., 128) defined in the kernel, with custom types starting at that offset. The relevant kernel-side definition is:
>   @@ -406,6 +406,7 @@ enum devlink_var_attr_type {
>           DEVLINK_VAR_ATTR_TYPE_BINARY,
>           _DEVLINK_VAR_ATTR_TYPE_CUSTOM_BASE = 0x80,
>           /* Any possible custom types, unrelated to NLA* values go below */
>            DEVLINK_VAR_ATTR_TYPE_U64_ARRAY,
>    };
> So DEVLINK_VAR_ATTR_TYPE_U64_ARRAY resolves to 0x81 = 129.
> Please see the kernel patch for full context:
> https://lore.kernel.org/all/20260609040453.711932-5-rkannoth@marvell.com/
> 
> Once this libmnl patch is merged, I will update the hardcoded 129 to use
> MNL_TYPE_UARR in:
> https://patchwork.kernel.org/project/netdevbpf/patch/20260615041042.549715-1-rkannoth@marvell.com/

This value is only internal for __mnl_attr_validate(), this validates
the attribute type.

I think this is not what you're searching for...

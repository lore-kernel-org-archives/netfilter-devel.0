Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2741EE012
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Oct 2024 22:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730156370; cv=none; b=mzQNWo+MswtFy17De9BfE81rJ4qrt/pWFQ6jXGD44bsrJna0lGskQjxblq4/KUNr8nwKywf7kKayvPGlvcf9v4WMActTjHbkcCgAmkh2/cxGAO+H3i1r+NK06lwaeupSGUGwmZCVrK9Y2MtWVVubqVQedTgdkIZEjvJHOLmk684=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730156370; c=relaxed/simple;
	bh=lB9GUg+Gvuc6tlJgEyBNmO3RxxEVqbIl+Se4eRAoqu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tTnM6EHY9oBsmzEl8PrvccuAzVzEYLVyRZdBh9nZsLaD014BeAopOVJNWfS2ui/knk5DVut+ET/piqr+HUsgsPkcBPYduuC11s215eSyGkAyafMkUS+sQbg1vWmCJCk62OqTtDr7SRtflTCSW1AUNTa0MfkfEPQMeS32/RQrups=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=36396 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t5Yho-004qYN-6Y; Mon, 28 Oct 2024 23:59:26 +0100
Date: Mon, 28 Oct 2024 23:59:23 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [libnftnl PATCH v2] Introduce struct nftnl_str_array
Message-ID: <ZyAXS49_WEHaXBRa@calendula>
References: <20241023202119.27681-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241023202119.27681-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Wed, Oct 23, 2024 at 10:21:04PM +0200, Phil Sutter wrote:
[...]
> @@ -325,12 +295,11 @@ void nftnl_flowtable_nlmsg_build_payload(struct nlmsghdr *nlh,
>  
>  	if (c->flags & (1 << NFTNL_FLOWTABLE_DEVICES)) {
>  		struct nlattr *nest_dev;
> +		const char *dev;
>  
>  		nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
> -		for (i = 0; i < c->dev_array_len; i++) {
> -			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME,
> -					  c->dev_array[i]);
> -		}
> +		nftnl_str_array_foreach(dev, &c->dev_array, i)

Where is this nftnl_str_array_foreach defined? I don't find it in this
patch.

[...]
> +void nftnl_str_array_clear(struct nftnl_str_array *sa)
> +{
> +	while (sa->len > 0)
> +		free(sa->array[--sa->len]);
> +	free(sa->array);
> +	sa->array = NULL;

This is new, I'm fine with this, but it is only defensive, right?
This stale reference would not be reached because attribute flag is
cleared.

> +}
[...]
> diff --git a/src/utils.c b/src/utils.c
> index 2f1ffd6227583..157b15f7afe8d 100644
> --- a/src/utils.c
> +++ b/src/utils.c
> @@ -19,6 +19,7 @@
>  
>  #include <libnftnl/common.h>
>  
> +#include <libmnl/libmnl.h>
>  #include <linux/netfilter.h>
>  #include <linux/netfilter/nf_tables.h>

Remove this chunk? It looks unrelated.

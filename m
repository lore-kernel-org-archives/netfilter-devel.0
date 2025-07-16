Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC182F002E
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 09:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752659105; cv=none; b=Y6qXa16Zj6xc7fUZg7hryGVNOTOGjRmr0Av3Mmrey/OzNOHjbGnuK5d+Ko07JipinXo7Lm+mzT7H9hNsmqiF0YLVLurZHaus4WxULJ55wCkCHYMm9Vmj6MgzlgwJif6Vc7AEKZR7Pw8zpM0bmHm2JaQfZq2hRTQRgyqUxDgvAgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752659105; c=relaxed/simple;
	bh=rnGZwhEduB0zF3V64V4nHr3flIdFNqQs05Id26ahfy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hxdAJApvmskqE++Isw3+LrE7kOjDbNXUicX477TwreAWyjNbDhBAybw5RYzwZ5Z9YWk32sWNwlLHrDmV+SFRrEcN0xT1wW/zd/fzNwQhGZzE1+VTlL8TF8p1FhxOfeO3QPmaEkhT99QxWUoaKrGHASv/GMkbpLdiWVX23ieJPeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2CC60604FB; Wed, 16 Jul 2025 11:45:00 +0200 (CEST)
Date: Wed, 16 Jul 2025 11:44:59 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH v2] utils: Add helpers for interface name
 wildcards
Message-ID: <aHd0mxVSp_cFcn16@strlen.de>
References: <20250715151526.14573-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715151526.14573-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
>  #include <string.h>
>  #include <stdlib.h>
> +#include <libmnl/libmnl.h>

Why is this include needed?

>  #include <libnftnl/common.h>
>  
>  #include "config.h"
> @@ -83,4 +84,7 @@ int nftnl_fprintf(FILE *fpconst, const void *obj, uint32_t cmd, uint32_t type,
>  int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
>  		       uint16_t attr, const void *data, uint32_t data_len);
>  
> +void mnl_attr_put_ifname(struct nlmsghdr *nlh, int attr, const char *ifname);
> +const char *mnl_attr_get_ifname(struct nlattr *attr);
> +

nftnl_attr_put_ifname, nftnl_attr_get_ifname?
Using mnl_ prefix seems wrong, that should be reserved for libmnl.

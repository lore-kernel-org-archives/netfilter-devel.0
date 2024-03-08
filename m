Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFE18BEF
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2024 14:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709907931; cv=none; b=i5uBU9vUYV5lZBZ63skiQAVYKAgugxK5LJN9Vu3o1WFWBagbPxXZDu1gmEAmN9L9LWurcaUF9NXCT46Qc/BAUMgiFPCsaJ7L9HB+E55AnMjjXcd6EbqEi06uqoLWwZOwmcndtZBOB9zwtMdwEfieIa51eKUXbd5csNMY0gx6HS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709907931; c=relaxed/simple;
	bh=CH/xkP6PYR4iRF6ICAk0VMpU/5ZNYrs26AiINHV1Weo=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fMDzfpGMuNUPePnTW0U6n90dn7drP6CzN/PYgghnmHByhRWPpOtrhQZB2CDLa1Ia25hJk6QWmBNmw5KE2Z73f5TBy0NnKQPJkg/BdrmAuDli4C9zOiC2e/+dZ6hwPRJ/GxK44rPdVLTL7yOFvyaDGHYnUOU3L8NMkxOCgm6z1fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1ribA7-0008SV-QS; Fri, 08 Mar 2024 15:25:27 +0100
Date: Fri, 8 Mar 2024 15:25:27 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH xtables] extensions: xt_TPROXY: add txlate support
Message-ID: <20240308142527.GD22451@breakpoint.cc>
References: <20240307140531.9822-1-fw@strlen.de>
 <Zer9L_EgbICxBu0m@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zer9L_EgbICxBu0m@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> Could you please add a testcase involving an IPv6 address? Just so we
> exercise this code path.

done.

> > +	else if (mask || info->mark_value)
> > +		xt_xlate_add(xl, "meta mark set meta mark & 0x%x or 0x%x",
> > +			     ~mask, info->mark_value);
> 
> Shouldn't this be 'xor' instead of 'or' in translated output?

Makes no difference.  But I see that this might be confusing when
looking at xt_TPROXY.c or the comment so I changed it.

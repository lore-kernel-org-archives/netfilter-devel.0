Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5E31AC89C
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 11:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727349083; cv=none; b=eTjKk4/FgLPxmEm3Ya/wBbCTM0i7RtcOV6qsQZbzgSxbOIIdCSMV4vk4FhHMffNs7AjDQZK7uKczWxuGMOnSdUENhd/RnWZPwzx4ntCSYnFkKMKoeax8NPIkC4odugyEfeQrq/GBMBF7mogEwEA4KIIcpaxMlcVbkyQzl9XP5MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727349083; c=relaxed/simple;
	bh=C5tiPCPUjd8nmNuSU41LjFwpAjIuUeGJdad1aDqFObs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=evduDpK67Zu5EeaTMzTwJvsDwf/f0E5BafHgiRVFRvtONdXNw1xTRLoAMx9cgz45UmH09d2Him0ShoGQ229NHDBd55VHPwl3KdJK224FV+gcj8KPXgCKLI6VileAhndWps6fwJb+U2m8a8cJaV8zcpsD7FKYRNXL429Dt8SyeKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1stmOz-0004ee-P7; Thu, 26 Sep 2024 13:11:17 +0200
Date: Thu, 26 Sep 2024 13:11:17 +0200
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, cmi@nvidia.com, nbd@nbd.name,
	sven.auhagen@voleatech.de
Subject: Re: [PATCH nf-next 5/7] netfilter: conntrack: rework offload nf_conn
 timeout extension logic
Message-ID: <20240926111117.GB16642@breakpoint.cc>
References: <20240924194419.29936-1-fw@strlen.de>
 <20240924194419.29936-6-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240924194419.29936-6-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> +/**
> + * nf_flow_table_tcp_timeout() - new timeout of offloaded tcp entry
> + * @ct:		Flowtable offloaded tcp ct
> + *
> + * Return number of seconds when ct entry should expire.

This needs following kdoc fixup:
- * Return number of seconds when ct entry should expire.
+ * @return: number of seconds when ct entry should expire.

Rest of series doesn't add kdoc warnings.

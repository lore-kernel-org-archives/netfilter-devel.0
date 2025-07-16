Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238A62F50BE
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 12:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752670330; cv=none; b=ZoHIXSOuzj/fKK+L7ocN0qdNfkMWWpB5PRemCqb59cXvliB5SPONlf7ytSUGFRbxJBObkJ/EHTOSfmdNjPlBeXllGXOq4tzB6uPJya2zOYSZoz/EBFvJu8piY6I+dQ6p5Mh4nXJRD8BDllR9/OZ6aBswWhnavT8yTJLWvdRoFTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752670330; c=relaxed/simple;
	bh=358LV/K0sSmumMRKfuhzj5ioJXgz1uXPZ6lSCIS3DZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aD2UDj8KASlWhRQSZqC+A1bTviJvv/HZgAXty3cv148D8D0ZLEBgVzHhQjoxUE0ynbHzAXUrfnaheYwFvsRGzpzILnHYiVM4mbwF+Bo1kdH7PCjWRmPoSeDqb1ztsGuFBicnyRJoQn6xTLHVA9C9o9hCUJXYxFJtuZuWs6GeQhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1BEEC60637; Wed, 16 Jul 2025 14:52:06 +0200 (CEST)
Date: Wed, 16 Jul 2025 14:52:05 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3 2/4] mnl: Support simple wildcards in netdev hooks
Message-ID: <aHegdfoOs5dfm-Jm@strlen.de>
References: <20250716124020.5447-1-phil@nwl.cc>
 <20250716124020.5447-3-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716124020.5447-3-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> +static void mnl_attr_put_ifname(struct nlmsghdr *nlh,
> +				int attr, const char *ifname)
> +{
> +	int len = strlen(ifname) + 1;

Nit: size_t len

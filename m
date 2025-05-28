Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2012A20C47B
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 10:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748429775; cv=none; b=esxQPA5fTvUg0+Cx+4IOobNLpnfTIxx8eLzlnM7eSzZL31Q4K9xLAvacvKjyQX8wZFUCXYSY7wNy9oH98t3BJkpFb7XX6K+N8sAmOt0ZUCh2jr4Y8QgnglOxmJqt6htSfcpbGomKV/eiXTdVc5ndUkdbrhyZLhn3LA2REj3fMPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748429775; c=relaxed/simple;
	bh=o+Jnesj8X84IyOAkawKxLPASW9yrotCvBwaOXeicqjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gx/Ni1PzG2OjOEetE4S8mUWlJfok41H1DNd54Lontldt1Lx0CUxtcH+8bh1P9rNQxtm1ptYmpDOWSDyPqGYNaop34tjzF0ntkU4DmzWLM6lMZewA1TQDvu3IhNe0w7EeeXaNyuHQ+A/FwuOW9wfJtYFwljtAfKDNk7JJ7ZyhuDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0426C603F8; Wed, 28 May 2025 12:56:10 +0200 (CEST)
Date: Wed, 28 May 2025 12:55:32 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 2/2 libnftnl v2] tunnel: add support to geneve options
Message-ID: <aDbrpG4vuB6A_n1z@strlen.de>
References: <20250527193420.9860-1-fmancera@suse.de>
 <20250527193420.9860-2-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250527193420.9860-2-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> +	case NFTNL_OBJ_TUNNEL_GENEVE_OPTS:
> +		geneve = malloc(sizeof(struct nftnl_obj_tunnel_geneve));
> +		memcpy(geneve, data, data_len);
> +
> +		if (!(e->flags & (1ULL << NFTNL_OBJ_TUNNEL_GENEVE_OPTS)))
> +			INIT_LIST_HEAD(&tun->u.tun_geneve);
> +
> +		list_add_tail(&geneve->list, &tun->u.tun_geneve);
> +		break;

I missed this earlier. Do we have precedence for this?

AFAIK for all existing setters, if you do

nftnl_foo_set_data(obj, OPT_FOO, &d, len);
nftnl_foo_set_data(obj, OPT_FOO, &d2, len2);

Then d2 replaces d, it doesn't silently append/add to the
object.

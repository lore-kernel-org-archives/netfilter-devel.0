Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF2B3A963D
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 23:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778802918; cv=none; b=m1kqYVFyAYogzdgaCi1eTW59JhS3jmLvAHgw9tKS+lPFF+KanaiSfIl99KoJ+bKZeUK4MM1JPX9meg7PNP/unmAbs7dv6xz0x3rHq0JuF/0dCj3s8qdYOR5uevyHPLNTFBf3YC7Io4ts53i7o/ab4nXFn7Ul05KCYEVX4oLCTlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778802918; c=relaxed/simple;
	bh=dcvXiNdDg5tCudDfH6m5BlTkTC1w3wNZK0FUo93s1XA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aFV93WPx4Jfn+xZh4FEa5TM/ifo5YQsQ7wqaxfXECPMqwdvSi4AlCgMSlZg8RF0/u8htQZjp2cKfnVGfIMoM2KRg09bZk8gs7eqepYn0CivDW9GI05APLmXmyfYng89miN1yc1K7p7I5F1B0dd0ZQp/+MMVlqVJ41Ig+y06F9J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4290A608A5; Fri, 15 May 2026 01:55:14 +0200 (CEST)
Date: Fri, 15 May 2026 01:55:08 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: conntrack: add dead flag to helpers
Message-ID: <agZg3JjBx6xXyEnW@strlen.de>
References: <20260514143016.874811-1-pablo@netfilter.org>
 <agXfhQb8Dcl9p5ce@strlen.de>
 <agXl-3NDpK3YUZiF@chamomile>
 <agXt-m9yN-oayY1G@strlen.de>
 <agZbFvp_KgGUr2Kw@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agZbFvp_KgGUr2Kw@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > The seqcnt can be pernet and it can be restricted to nfnetlink_queue.
> > 
> > Any better idea?
> 
> Maybe add a helper_id which is set at helper registration time. Then
> nf_conn_help stores this helper_id field.  Unconfirmed conntrack on
> reinject use this helper_id to re-lookup the helper when reinjecting.
> This would force a slow path for unconfirmed conntracks, to
> re-validate if the helper is still there.
> 
> cttimeout would need this too, a lookup to check if the timeout policy
> is still around.

Hmm, maybe just re-use the nf_conntrack_ext_genid for this?
I think this unreg/rmmod isn't so frequent.

Another alternative would be to give up on this design completely
and just grab module references :-)

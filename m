Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF6034A797
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 22:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769552283; cv=none; b=ZsFEcQQOx2qiLrFAZMyqJ0L92SNQNsNcOY+XRLvfNcq4WweV21qQLWWKYJpDqdR4Z3P3w6kIB6GARqh/G2vrnQxrXq/0VRn0SQobsCGP/5Gl94PckFOcf/k0kWGtf/mqlF4197HChXGkviKzgucmI1spjevA3agadmkrPWWFxhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769552283; c=relaxed/simple;
	bh=AJNIIkXKmNKksC0xQyB7TDB0IGRjt0PZqkH1kE4mmWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=itAsg7VJ6HNESjUVp2Wo4JFGoHe1HFN48aUgTRYSezK8/Yu65AIFoFzqmtpJFkGJpyW2WGQmEOpLsnX4oMdeOQxJj9mgi4/KQUbA82KDDO066uS+nDWMPDM20f57RuHOLIpaMnAjye4YET1/ZcbdQgIbDhpqTMyMUqlaEJK7HLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8E14F602B6; Tue, 27 Jan 2026 23:17:58 +0100 (CET)
Date: Tue, 27 Jan 2026 23:17:59 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] doc: nft.8: Describe iface_type data type
Message-ID: <aXk5l4AQ4XHvyBrx@strlen.de>
References: <20260127221252.27440-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127221252.27440-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> An entry in data-types.txt offers space for a name-value table. Even if
> one would refer to ARPHRD_*, some names are not derived from the
> respective macro name and thus not intuitive.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  doc/data-types.txt         | 27 +++++++++++++++++++++++++++
>  doc/primary-expression.txt |  2 --
>  2 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/doc/data-types.txt b/doc/data-types.txt
> index e44308b5322cb..0b350effbea68 100644
> --- a/doc/data-types.txt
> +++ b/doc/data-types.txt
> @@ -83,6 +83,33 @@ filter input iifname eth0
>  filter input iifname "(eth0)"
>  ----------------------------
>  
> +INTERFACE TYPE TYPE
> +~~~~~~~~~~~~~~~~~~~

TYPE TYPE?

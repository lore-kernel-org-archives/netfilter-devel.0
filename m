Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0334084D
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 07:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723707271; cv=none; b=aFwYLdYm+4hlO29S3jfPOYb0S7A0UTUjWyfERJyA9xH38ETKl8bpvOzrdaZNfsHOiKddOvCwwWxSHEb98uBtA0zBr5tYFwY4yl1FKeg1+o4ezuWugaaQ9teefcpV19mTJhd73868/VIP0zm8Y2GsR/6/5MiHBY0O3Bo2PrVMznY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723707271; c=relaxed/simple;
	bh=YtprzrjMYJmTLPeR/ldWzNBhyAMuF3mEQqLai9H1vuk=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qAq2r7MbMzRw4W9Yd2TMHjy4+0rXARIVYG1s7TYWP+MsbTcuILizjL/KiUpFENgTFxip6Iir4L6sqwcCEpF0ByO69tBSOALiLk8aQG1pVLd5AvWszdKjyhFKhvicZcW75bf6Xj69fRbS99xruj711XOs6HkSMdWHmCTLkB5H0ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1seV05-00057V-Kk; Thu, 15 Aug 2024 09:34:25 +0200
Date: Thu, 15 Aug 2024 09:34:25 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Please comment on my libnetfilter_queue build speedup patch
Message-ID: <20240815073425.GA19654@breakpoint.cc>
References: <Zr1JN/xKIuzi9Ii+@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr1JN/xKIuzi9Ii+@slk15.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)

Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> Hi Pablo,
> 
> I submitted
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240628040439.8501-1-duncan_roe@optusnet.com.au/
> some weeks ago. You neither applied it nor requested any changes.

make -j 32  1.19s user 0.70s system 124% cpu 1.525 total

... and thats before this patch, so I don't really see a point.

That said, I see no difference in generated output so I applied it.

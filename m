Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D3A157A46;
	Wed, 28 Aug 2024 06:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724827978; cv=none; b=Kwi8OSHT/fgDPnczPb+zmQBvblY98EWzjZPGGx04B4Jw06eIskGPQ7M4jI/NB0gvaF+P1q22uaPVvy+StZ/TD6L+VZTNRBIXsO3CtI0ky+e2LQbTrYtQjOlhnuBV5231kt8Akh5Ru3AYiVCwrwxvyleh+oq78mRTLtDSRQhD/ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724827978; c=relaxed/simple;
	bh=LNVpowAakEC/8CZyOFiWDAQWPNQiAaRezSPsURIEfMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YQdfsb4nw+Le49T2yJRGssLGnGmDB9Zi69byzhqRmwyeOV0ljpZPa9W5pg349o2HaNxn0uRhMx/vGAXNfjuzRy03YAFL1RDXlBjo1WGcPNOmEFbd11QPvgwinfZFQYKNV5xDahbpXYQpUj2IDdHMNBLohXqySzyvIbzbNrw6o+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=55382 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sjCXu-0017i9-PR; Wed, 28 Aug 2024 08:52:48 +0200
Date: Wed, 28 Aug 2024 08:52:45 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, jmaloy@redhat.com,
	ying.xue@windriver.com, kadlec@netfilter.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] net/netfilter: make use of the helper macro
 LIST_HEAD()
Message-ID: <Zs7JPVbKHo3Hs6Ej@calendula>
References: <20240827100407.3914090-1-lihongbo22@huawei.com>
 <20240827100407.3914090-4-lihongbo22@huawei.com>
 <Zs37l04h3bsK8LIE@calendula>
 <55ea4acb-fd89-4ec2-9eb3-1c6aa1a423ef@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <55ea4acb-fd89-4ec2-9eb3-1c6aa1a423ef@huawei.com>
X-Spam-Score: -1.9 (-)

On Wed, Aug 28, 2024 at 09:35:35AM +0800, Hongbo Li wrote:
> 
> 
> On 2024/8/28 0:15, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > On Tue, Aug 27, 2024 at 06:04:05PM +0800, Hongbo Li wrote:
> > > list_head can be initialized automatically with LIST_HEAD()
> > > instead of calling INIT_LIST_HEAD(). Here we can simplify
> > > the code.
> > > 
> > > Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> > > ---
> > >   net/netfilter/core.c | 4 +---
> > >   1 file changed, 1 insertion(+), 3 deletions(-)
> > > 
> > > diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> > > index b00fc285b334..93642fcd379c 100644
> > > --- a/net/netfilter/core.c
> > > +++ b/net/netfilter/core.c
> > > @@ -655,10 +655,8 @@ void nf_hook_slow_list(struct list_head *head, struct nf_hook_state *state,
> > >   		       const struct nf_hook_entries *e)
> > >   {
> > >   	struct sk_buff *skb, *next;
> > > -	struct list_head sublist;
> > >   	int ret;
> > > -
> > > -	INIT_LIST_HEAD(&sublist);
> > > +	LIST_HEAD(sublist);
> > 
> > comestic:
> > 
> >    	struct sk_buff *skb, *next;
> > 	LIST_HEAD(sublist);          <- here
> >    	int ret;
> > 
> > I think this should be included in the variable declaration area at
> > the beginning of this function.
> 
> It is in the variable declaration area just after ret (with a blank line
> before list_for_each_entry_safe).

Indeed. It is reverse xmas tree what I was missing then.

Thanks.

Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CEA19CC39
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2024 11:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726747190; cv=none; b=OtD6G9B8L6XhdJfJonqDzGuXnXDxuNPqq6lm/88k53L3aQ1JK6L3hVjGloNEvHQZ74Y6LQdJCN5XIVKnZ37xxTIVgQ7mUUc6sCPgJNxUY2oGMz+5Qjm+Qfn4ne+xnslQwFvik71y/zb9NWpApMby2Fgceulz6OHXGiq3fY9lf5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726747190; c=relaxed/simple;
	bh=xcMyrEb6GC7wqKHxUFxdiOoG2lUZRv+JX8KzhKiQ+VE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pXepgyrqX8JNKm5PSafd97hdjUpnXofhPBsfh4N+u6cPP3xewJAmiHTsHQ9JYa+FSNpLWlBpiboG4PFUkYM7XLK63QX8d58XpXyd0B/aOSkATeI1F+vcZ6X2IYh+KP6MsSrYe2cm8AamZu56W5N3eODA23OBHLgQRkO4x+ZVdJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=49432 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1srFp0-003Ia6-AW; Thu, 19 Sep 2024 13:59:44 +0200
Date: Thu, 19 Sep 2024 13:59:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, vasily.averin@linux.dev
Subject: Re: [PATCH nf,v2] netfilter: nf_tables: missing objects with no
 memcg accounting
Message-ID: <ZuwSLa1e1bAsgOVb@calendula>
References: <20240918121945.15702-1-pablo@netfilter.org>
 <20240918132030.GC16721@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240918132030.GC16721@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Wed, Sep 18, 2024 at 03:20:30PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > v2: a more complete version.
> 
> Thanks Pablo, LGTM.  One nit below.
> > diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
> > index 5defe6e4fd98..e35588137995 100644
> > --- a/net/netfilter/nft_log.c
> > +++ b/net/netfilter/nft_log.c
> > @@ -163,7 +163,7 @@ static int nft_log_init(const struct nft_ctx *ctx,
> >  
> >  	nla = tb[NFTA_LOG_PREFIX];
> >  	if (nla != NULL) {
> > -		priv->prefix = kmalloc(nla_len(nla) + 1, GFP_KERNEL);
> > +		priv->prefix = kmalloc(nla_len(nla) + 1, GFP_KERNEL_ACCOUNT);
> >  		if (priv->prefix == NULL)
> >  			return -ENOMEM;
> >  		nla_strscpy(priv->prefix, nla, nla_len(nla) + 1);
> 
> You could update this to use nla_strdup instead of kmalloc+strscpy.
> 
> No need to send a v3 for this I think.

Thanks for reviewing, I promise to address this in nf-next.

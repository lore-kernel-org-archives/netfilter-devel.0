Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F6317625E;
	Thu, 15 Aug 2024 08:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723712152; cv=none; b=c6VxOXRTp+heeXXZYEMZao/XVVOSNui2c0+HOzA3oqKKTVbSg+ckJJPWm6uhfc86hWaqHOHGwrb6R3bM1ktg4poIgKH2nPmAFSck1deXedbnDjOZBXiXl8BMTCTVT4hUTuP57kiInaZIhnC7lZvEA2mJnMfJmtmGeOcVmN9Rg4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723712152; c=relaxed/simple;
	bh=6Pa7Piw4vYLO/WuuQnk7QzeAp3aDRW6Q0Ehifw9hFlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SZFIQkC1UhjJkreeflVcIuNa/t1uwo4KwEALCm9TRtE0iugIXyXL8Go86soVicVOmZZY/IOrK99JVcC6RH+jiz73A6wzHVoFw7kR/Z9pnyT16RF1MkJ64PeYK+2Vy0nMjDoS26XViUuUFVsn3Hirr2hy7nVdbVPo7v8ZQTYy2+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=36446 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1seWGk-00GrRE-Rj; Thu, 15 Aug 2024 10:55:45 +0200
Date: Thu, 15 Aug 2024 10:55:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: icejl <icejl0001@gmail.com>
Cc: kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nfnetlink: fix uninitialized local variable
Message-ID: <Zr3CjbzNMOqntLDi@calendula>
References: <20240815082733.272087-1-icejl0001@gmail.com>
 <Zr29B7UWlDCYQMCR@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zr29B7UWlDCYQMCR@calendula>
X-Spam-Score: -1.9 (-)

For the record:

https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git/commit/?id=d1a7b382a9d3f0f3e5a80e0be2991c075fa4f618

Fixes: bf2ac490d28c ("netfilter: nfnetlink: Handle ACK flags for batch messages")

On Thu, Aug 15, 2024 at 10:32:11AM +0200, Pablo Neira Ayuso wrote:
> There is a fix already traveling for this in a pull request.
> 
> On Thu, Aug 15, 2024 at 04:27:33PM +0800, icejl wrote:
> > In the nfnetlink_rcv_batch function, an uninitialized local variable
> > extack is used, which results in using random stack data as a pointer.
> > This pointer is then used to access the data it points to and return
> > it as the request status, leading to an information leak. If the stack
> > data happens to be an invalid pointer, it can cause a pointer access
> > exception, triggering a kernel crash.
> > 
> > Signed-off-by: icejl <icejl0001@gmail.com>
> > ---
> >  net/netfilter/nfnetlink.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> > index 4abf660c7baf..b29b281f4b2c 100644
> > --- a/net/netfilter/nfnetlink.c
> > +++ b/net/netfilter/nfnetlink.c
> > @@ -427,6 +427,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
> >  
> >  	nfnl_unlock(subsys_id);
> >  
> > +	memset(&extack, 0, sizeof(extack));
> >  	if (nlh->nlmsg_flags & NLM_F_ACK)
> >  		nfnl_err_add(&err_list, nlh, 0, &extack);
> >  
> > -- 
> > 2.34.1
> > 

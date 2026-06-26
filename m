Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B952EEE6A
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2026 11:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782473711; cv=none; b=dQ7kCWwl3mrNksNP0EV5+IU1BezyaAVfJs9uc77avkms+zusDhBOyXi91gpT1olX3V//u0smQUH2DW+WTuDUXb+mjWN8DpN4sST2HgPEa89qquHmhS2z16KSvIZhY0QJjx6Eb8J3vxC73c1BN+mAdkDJQiDbN//ZH3CyRTel500=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782473711; c=relaxed/simple;
	bh=GukIm05WmhWUxJkid1wzKazBXhLsPYFpu6EqWzYHeJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Plb7BZQGKRUcg4lzaVhujAUcQsOkSTBwreMm/OuOlzj1zhjKDXQitUEU98dfNIf7UpUXEOldvLv4kGc+qVu6uCrbkrEYMg1HlfJ8jkhJsROdkFaQ4A4wkG81d1AvFqKwqbXtljcnMIsmGvFh5etjyS4j4ARBDjkgviMc4M74Rno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=c6od6IJ7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="c6od6IJ7"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 158FD6058B;
	Fri, 26 Jun 2026 13:35:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782473708;
	bh=1gEss4CIzTn6EIN8wiK/7OZdsrdI0tRZSvuyRos3dOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c6od6IJ7FBGCs1UbksF3ARQrJonB4nTk8JE+nz5B0k/LE50WAvkBnLnck2KC/6Mtc
	 ppaIgKwI80zYQJ83zN418RQEN4woQFcm4rKsm+qPqhUpHHP/XiX+JsHp/MIRjUnP9h
	 /KYkrP9kg2nsowG6FT7HRcrPM833xJ1RAbLB4vjuH/RsLyCDmgnu/CmyOEWym9b/4C
	 MytuMx5mjwlPahcfO0K6lsporiAV6AhEKFrc2xQEN2JojDh4m1hy3fCddyKY3RnYeL
	 EqSxcP4W16v5wp7Loxavp3bR+PYvjO7u/0mRii0h4d4LhOXgYtU6Lf+1FWVxhMIGEC
	 WS84aE6mgymdQ==
Date: Fri, 26 Jun 2026 13:35:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	alin.nastac@gmail.com, yuantan098@gmail.com, yifanwucs@gmail.com,
	tomapufckgml@gmail.com, bird@lzu.edu.cn, chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf 1/1] netfilter: nf_conntrack_sip: guard against
 missing skb dst
Message-ID: <aj5j6YZG7f6fbtfn@chamomile>
References: <cover.1782349677.git.chzhengyang2023@lzu.edu.cn>
 <47e6e0bdba06326388cd7778403326ff78faf8f0.1782349677.git.chzhengyang2023@lzu.edu.cn>
 <aj5YwOF4Kc71OTdf@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aj5YwOF4Kc71OTdf@chamomile>

On Fri, Jun 26, 2026 at 12:47:31PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jun 26, 2026 at 02:49:37PM +0800, Ren Wei wrote:
> > From: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
> > 
> > set_expected_rtp_rtcp() dereferences skb_dst(skb)->dev when
> > sip_external_media is enabled. The SIP helper can run from tc ingress
> > before routing has attached a dst to the skb, so skb_dst(skb) can be
> > NULL and the helper crashes while parsing SDP media expectations.
> 
> If SIP helper can run from tc ingress, then this has not ever worked?
> Else tc needs to be fixed to set a router to skb before calling the
> helper.
> 
> I don't think this fix belong here.

Actually, it is the most simple way to fix it here, but I posted a
different approach:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260626112449.848283-1-pablo@netfilter.org/

> > Handle a missing skb dst by skipping the same-interface external-media
> > optimization. Still release the routed media dst when one was obtained,
> > and keep the existing expectation setup path unchanged.
> > 
> > Fixes: a3419ce3356c ("netfilter: nf_conntrack_sip: add sip_external_media logic")

I am pointing to different Fixes: tag for practical reasons, to
highlight this is a dependencies for the tc and ovs subsystems.
It seems sip_external_media came _after_ ovs but a bit before tc
act_ct, so a3419ce3356c is not precise either.

> > Cc: stable@vger.kernel.org
> > Reported-by: Yuan Tan <yuantan098@gmail.com>
> > Reported-by: Yifan Wu <yifanwucs@gmail.com>
> > Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> > Reported-by: Xin Liu <bird@lzu.edu.cn>
> > Assisted-by: Codex:gpt-5.4
> > Signed-off-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
> > Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> > 
> > ---
> >  net/netfilter/nf_conntrack_sip.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
> > index 5ec3a4a4bbd7..302dc60c5381 100644
> > --- a/net/netfilter/nf_conntrack_sip.c
> > +++ b/net/netfilter/nf_conntrack_sip.c
> > @@ -956,7 +956,8 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
> >  			return NF_ACCEPT;
> >  		saddr = &ct->tuplehash[!dir].tuple.src.u3;
> >  	} else if (sip_external_media) {
> > -		struct net_device *dev = skb_dst(skb)->dev;
> > +		struct dst_entry *skbdst = skb_dst(skb);
> > +		struct net_device *dev = skbdst ? skbdst->dev : NULL;
> >  		struct dst_entry *dst = NULL;
> >  		struct flowi fl;
> >  
> > @@ -977,12 +978,14 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
> >  		/* Don't predict any conntracks when media endpoint is reachable
> >  		 * through the same interface as the signalling peer.
> >  		 */
> > -		if (dst) {
> > +		if (dst && dev) {
> >  			bool external_media = (dst->dev == dev);
> >  
> >  			dst_release(dst);
> >  			if (external_media)
> >  				return NF_ACCEPT;
> > +		} else if (dst) {
> > +			dst_release(dst);
> >  		}
> >  	}
> >  
> > -- 
> > 2.43.0
> > 

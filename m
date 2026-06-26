Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B4037F72E
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2026 10:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782470856; cv=none; b=HqSJPcxHTfVOJudGTJYRHlfAHNvinKIND6/ZzHLDyc+8bTWSgKAUnsnz8uocS91vDU13wYPlnO/p2rzjmF/QT+OgW5WEXhy454xaWFso/uhQtZNin2HXoP6ZJM/4ciQpQ03vXqVLMqHBdqV2tM/zoBNP+jdYNOEYJbLiKM/rOLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782470856; c=relaxed/simple;
	bh=Lnjbi8giISGJm0qJrrvpNRnRL0cMTn31IY910Bu6OBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nsV/yiYkLNPaOhPk4fdktsOqhuUHP71sCwgxx59h7Xi6kbakumJHGKDuvLjLRDnc7VG68i46ntnw5ma7bqMPY0AOoj/v36h2Z2N8QFY/dg3bwNGknHB8NVhAha+W5V+0mx4WPLJZaYFjmzC08R8+iKms1wFO3cpaOVnX7xbvr28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZghjreI3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZghjreI3"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9CCEE60581;
	Fri, 26 Jun 2026 12:47:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782470850;
	bh=LjKlyQW6bVgo7iFpSJRsLUABMkIrpqoAMnpXTmLJhS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZghjreI3mllf+hXSunTzT7w36j7Dd8JsuKwpzeIIp4uz9wTqiiDgDyZEgMVeu2oms
	 7OqvC+4d2/jUBzjPIkgu7NC7Up6DXr872ly/XJtN3j7mz4R4pMP+xzxlCV3wNTy2y7
	 gcao9ZCllMgoJFZSUl6Tvuq+Vinw66hO4PPrwDcFHrlsYoTfP5Aj/VskYUjXX1VW3Q
	 CZNSOBapsnSxVoDwOQ5CGgtMXANEIhAGlIT9hMSYBx3/bLClmRqdV/K0jQfRaHXAdW
	 iUJZHAM0cLfm804ANg8mf1Tl4ezr5uzJw8dQiJ2FnG2HLgUFgvXeqMj/TG1QpDLzoQ
	 CVWX+NQG//0qw==
Date: Fri, 26 Jun 2026 12:47:28 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	alin.nastac@gmail.com, yuantan098@gmail.com, yifanwucs@gmail.com,
	tomapufckgml@gmail.com, bird@lzu.edu.cn, chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf 1/1] netfilter: nf_conntrack_sip: guard against
 missing skb dst
Message-ID: <aj5YwOF4Kc71OTdf@chamomile>
References: <cover.1782349677.git.chzhengyang2023@lzu.edu.cn>
 <47e6e0bdba06326388cd7778403326ff78faf8f0.1782349677.git.chzhengyang2023@lzu.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47e6e0bdba06326388cd7778403326ff78faf8f0.1782349677.git.chzhengyang2023@lzu.edu.cn>

On Fri, Jun 26, 2026 at 02:49:37PM +0800, Ren Wei wrote:
> From: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
> 
> set_expected_rtp_rtcp() dereferences skb_dst(skb)->dev when
> sip_external_media is enabled. The SIP helper can run from tc ingress
> before routing has attached a dst to the skb, so skb_dst(skb) can be
> NULL and the helper crashes while parsing SDP media expectations.

If SIP helper can run from tc ingress, then this has not ever worked?
Else tc needs to be fixed to set a router to skb before calling the
helper.

I don't think this fix belong here.

> Handle a missing skb dst by skipping the same-interface external-media
> optimization. Still release the routed media dst when one was obtained,
> and keep the existing expectation setup path unchanged.
> 
> Fixes: a3419ce3356c ("netfilter: nf_conntrack_sip: add sip_external_media logic")
> Cc: stable@vger.kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Assisted-by: Codex:gpt-5.4
> Signed-off-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> 
> ---
>  net/netfilter/nf_conntrack_sip.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
> index 5ec3a4a4bbd7..302dc60c5381 100644
> --- a/net/netfilter/nf_conntrack_sip.c
> +++ b/net/netfilter/nf_conntrack_sip.c
> @@ -956,7 +956,8 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
>  			return NF_ACCEPT;
>  		saddr = &ct->tuplehash[!dir].tuple.src.u3;
>  	} else if (sip_external_media) {
> -		struct net_device *dev = skb_dst(skb)->dev;
> +		struct dst_entry *skbdst = skb_dst(skb);
> +		struct net_device *dev = skbdst ? skbdst->dev : NULL;
>  		struct dst_entry *dst = NULL;
>  		struct flowi fl;
>  
> @@ -977,12 +978,14 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
>  		/* Don't predict any conntracks when media endpoint is reachable
>  		 * through the same interface as the signalling peer.
>  		 */
> -		if (dst) {
> +		if (dst && dev) {
>  			bool external_media = (dst->dev == dev);
>  
>  			dst_release(dst);
>  			if (external_media)
>  				return NF_ACCEPT;
> +		} else if (dst) {
> +			dst_release(dst);
>  		}
>  	}
>  
> -- 
> 2.43.0
> 

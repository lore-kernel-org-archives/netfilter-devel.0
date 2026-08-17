Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD23944BCB8
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786983114; cv=none; b=kFNsAGa9Qj7CxTxQytExhtNNfnm4Q3iMXOKiZCL2fYpds7cNsvUosK9nMmSsdovubr8Hjkx8orzT4w8rt2ypInLZyxFwe5OFKhah9a9hQ9DTu1BJ0VCjqC8wDpgkg1TCoODqvG0G/JMrAr76aieO3nQn69rRdEhCBgIRV62Qn74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786983114; c=relaxed/simple;
	bh=Kbtv+kseRirEjX8NKpgWEuDqk7mrTOS1mtVRsueoYzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wc+mYbkf/KluLCIXeTzzpax7Rp3Soe3DNXhA2l/+jLabcz/baybJTlLQzAlZh/JOxNe3Sy6bFU61rXBpKqnnCnoJ+9wIxPEDD/w5NcnPYFUPmxlkrbzQxGA4yjSZmAQnVQqWzw4yXy3eM7yBjmNd4AlWKSptoD3xuEFYTnrCmjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EVHbTDjf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EVHbTDjf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786983108;
	bh=8JCBk6fkEas2REKnDM3WrvkZKeC00+5UuOELMXSHac8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EVHbTDjfy/sgglX6JrB/OV4AQX8EXOAvMc5AZ6k0Np6VyOXCY1zv+m3BVkL8VBVNm
	 LzYcIyFADQzbFvBE+5Ejm2SZmXdLShNFm33lYuLQBrzZa+gcKbOj1FQb24tjhoFVYL
	 i3YpJM58b1eyBEianZHfNzXZOpLEfMD08nF/lBAw5ilQaMIlselCA0Bi+RkmOS24yB
	 87VOW5sW+VFcoyaF0CnnBfcNTsGu763f527rYMjTP1OkYOH9RVUk6CGtIh9iyh1WiR
	 z1lwK5Z6GQDYvhNfXMeqAyug4X9k0rxxQdNHzITQb94j7j2UqlQbFQUITtW5ocQkp9
	 Yvd+dEExGl2nw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4E90E60077;
	Mon, 17 Aug 2026 18:11:48 +0200 (CEST)
Date: Mon, 17 Aug 2026 18:11:45 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: ZhilingZouzhilinz@nebusec.ai
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	horms@kernel.org, bazsi@balabit.hu, kaber@trash.net,
	hidden@balabit.hu, vega@nebusec.ai, zhilinz@nebusec.ai
Subject: Re: [PATCH nf 1/1] netfilter: xt_TPROXY: require IPv6 protocol match
Message-ID: <aoMywaT0eQWFS3I7@chamomile>
References: <cover.1786968834.git.zhilinz@nebusec.ai>
 <6ca536c61d358bfb1bdfd20aafe3cc16acfd45db.1786968834.git.zhilinz@nebusec.ai>
 <aoMx5TSCLinBXwNz@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aoMx5TSCLinBXwNz@chamomile>

On Mon, Aug 17, 2026 at 06:08:08PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 17, 2026 at 08:26:37PM +0800, ZhilingZouzhilinz@nebusec.ai wrote:
> > From: Zhiling Zou <zhilinz@nebusec.ai>
> > 
> > tproxy_tg6_check() verifies the protocol field value but does not
> > require IP6T_F_PROTO. A crafted ip6tables rule can set the field to
> > TCP or UDP while leaving the protocol matching flag clear.
> > 
> > ip6_packet_match() treats such a rule as protocol agnostic and can
> > invoke tproxy_tg6_v1() for ICMPv6. nf_tproxy_get_sock_v6() warns for
> > protocols other than TCP and UDP.
> > 
> > Reject rules without IP6T_F_PROTO so TPROXY is invoked only for the
> > protocols it supports.
> > 
> > Fixes: 6ad7889327a5e ("tproxy: added IPv6 support to the TPROXY target")
> > Cc: stable@vger.kernel.org
> > Reported-by: Vega <vega@nebusec.ai>
> > Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
> > ---
> >  net/netfilter/xt_TPROXY.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
> > index 5f60e7298a1ea..13a94c9d06c0f 100644
> > --- a/net/netfilter/xt_TPROXY.c
> > +++ b/net/netfilter/xt_TPROXY.c
> > @@ -179,7 +179,8 @@ static int tproxy_tg6_check(const struct xt_tgchk_param *par)
> >  	if (err)
> >  		return err;
> >  
> > -	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP) &&
> > +	if ((i->flags & IP6T_F_PROTO) &&
> > +	    (i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP) &&
> >  	    !(i->invflags & IP6T_INV_PROTO))
> 
> And why not tproxy_tg4_check?

I answer myself: there is no such flag in IPv4.

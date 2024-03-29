Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D600479DF
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Mar 2024 21:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711748582; cv=none; b=msboR3eKu2jg4D7AwZyZse312OK9L+Rdg1UuYeICk4R+74iD5ctU7omNEWRs/dRdVewHe1Rf5emyjyFg68QIQ7FtX2RUgY5JozTGepx3bleMEcQR3ayT1MfD7itwl57m3KCdLkq62wXfNbNkOdztDFB88MJ5NRZ92xVWr45nziA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711748582; c=relaxed/simple;
	bh=FxieBW7gIq8hQkSiALwOhaG+Kra6/Q0zFFQx8nd7R5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SchxI3FSMOfQHaQZfsVO/u0vWGbsf2dODwNfu7UztdIoMjUNJCvYG0ZfQ4KDnoU/Ipc4C/NzF5lOHzunotW6bEm7BucjaSsDra+u9sqFwUN7B71y1McnMNKGshpY8DiFe9ccOB3iMjNL4gtgxYMyZx/Yh/yEvDNWZ/lPv9pqv2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Fri, 29 Mar 2024 22:42:48 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: kadlec@netfilter.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH net-next v2] netfilter: use NF_DROP instead of -NF_DROP
Message-ID: <Zgc12IWMR6Lw3Cq4@calendula>
References: <20240325123614.10425-1-kerneljasonxing@gmail.com>
 <CAL+tcoCobqkfKX__xKwwp2u1FH29=+uAUtzwZRnfQjiyudS-eg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL+tcoCobqkfKX__xKwwp2u1FH29=+uAUtzwZRnfQjiyudS-eg@mail.gmail.com>

Hi Jason,

On Fri, Mar 29, 2024 at 08:33:32PM +0800, Jason Xing wrote:
> On Mon, Mar 25, 2024 at 8:36 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > At the beginning in 2009 one patch [1] introduced collecting drop
> > counter in nf_conntrack_in() by returning -NF_DROP. Later, another
> > patch [2] changed the return value of tcp_packet() which now is
> > renamed to nf_conntrack_tcp_packet() from -NF_DROP to NF_DROP. As
> > we can see, that -NF_DROP should be corrected.
> >
> > Similarly, there are other two points where the -NF_DROP is used.
> >
> > Well, as NF_DROP is equal to 0, inverting NF_DROP makes no sense
> > as patch [2] said many years ago.
> >
> > [1]
> > commit 7d1e04598e5e ("netfilter: nf_conntrack: account packets drop by tcp_packet()")
> > [2]
> > commit ec8d540969da ("netfilter: conntrack: fix dropping packet after l4proto->packet()")
> >
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> 
> Hello Pablo,
> 
> I don't know how it works in the nf area, so I would like to know the
> status of this patch and another one (netfilter: conntrack: dccp: try
> not to drop skb in conntrack
> )? Is there anything I need to change?

No action on your side, I will start collecting pending material for
nf-next next week.

Thanks for your patience.

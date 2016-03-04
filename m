From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 3/4] meta: add probability matching
Date: Fri, 4 Mar 2016 14:13:06 +0100
Message-ID: <20160304131306.GB31929@breakpoint.cc>
References: <1457027814-14795-1-git-send-email-fw@strlen.de>
 <1457027814-14795-2-git-send-email-fw@strlen.de>
 <alpine.LSU.2.20.1603032005570.446@nerf40.vanv.qr>
 <20160303203226.GA2728@breakpoint.cc>
 <alpine.LSU.2.20.1603032141160.3198@nerf40.vanv.qr>
 <20160304111206.GA31929@breakpoint.cc>
 <alpine.LSU.2.20.1603041322500.8964@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58452 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313AbcCDNNJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Mar 2016 08:13:09 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1603041322500.8964@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> On Friday 2016-03-04 12:12, Florian Westphal wrote:
> >Jan Engelhardt <jengelh@inai.de> wrote:
> >> >> >+		if (tmp >= UINT_MAX || d > 0.9999999)
> >> >> >+			return error(loc, "Probability " META_PROB_FMT " too %s", d, "big");
> >> >> 
> >> >> You are misappropriating some 430 points here. 0.9999999 maps to
> >> >> just 0xfffffe51.
> >> >
> >> >Sorry, I am not following.
> >> 
> >> 0.9999999997 is still a valid probability, but you are making it 
> >> impossible to select it by cutting off at d > 0.9999999000.
> >
> >I'll change it to allow one more digit, so that supported range will
> >be 0.00000001 [10^-8] (0x0000002a) to
> >   0.99999999 (0xffffffd4).
> 
> Let's ask differently. What precludes the use of the full range
> (0x0/0x1) [2*10^-10] to (0xffffffff)?

Mapping smallest probability to 0x1 and largest one to 0xffffffff
means I lose ability to print back a number as entered.

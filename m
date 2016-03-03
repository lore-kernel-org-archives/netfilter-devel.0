From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 3/4] meta: add probability matching
Date: Thu, 3 Mar 2016 21:32:26 +0100
Message-ID: <20160303203226.GA2728@breakpoint.cc>
References: <1457027814-14795-1-git-send-email-fw@strlen.de>
 <1457027814-14795-2-git-send-email-fw@strlen.de>
 <alpine.LSU.2.20.1603032005570.446@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56577 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755344AbcCCUc2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Mar 2016 15:32:28 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1603032005570.446@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> On Thursday 2016-03-03 18:56, Florian Westphal wrote:
> 
> >The float value has to be in range of 0.0000001 to 0.9999999 and
> >+
> >+		if (tmp >= UINT_MAX || d > 0.9999999)
> >+			return error(loc, "Probability " META_PROB_FMT " too %s", d, "big");
> 
> You are misappropriating some 430 points here. 0.9999999 maps to
> just 0xfffffe51.

Sorry, I am not following.
What would you likew to change here?

> >+		*value = (uint32_t) tmp;
> >+		if (*value == 0)
> >+			return error(loc, "Probability " META_PROB_FMT " too %s", d, "small");
> 
> Though d==0 and d==1 are not overly useful, why prohibit them? iptables 
> allowed taking them, and I hear people are working on a translator...*boom*

No, thats easy to translate to nft :-)

1.0 -> ""
0.0 -> "#"

i.e. not print a "1.0" match, its always true so irrelevant and print
comment a sign (#) to make nft ignore whatever comes after it, since it
did not match in the iptables rule either.

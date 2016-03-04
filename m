From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH nft 3/4] meta: add probability matching
Date: Fri, 4 Mar 2016 13:34:34 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1603041322500.8964@nerf40.vanv.qr>
References: <1457027814-14795-1-git-send-email-fw@strlen.de> <1457027814-14795-2-git-send-email-fw@strlen.de> <alpine.LSU.2.20.1603032005570.446@nerf40.vanv.qr> <20160303203226.GA2728@breakpoint.cc> <alpine.LSU.2.20.1603032141160.3198@nerf40.vanv.qr>
 <20160304111206.GA31929@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:48294 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbcCDMeg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Mar 2016 07:34:36 -0500
In-Reply-To: <20160304111206.GA31929@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2016-03-04 12:12, Florian Westphal wrote:
>Jan Engelhardt <jengelh@inai.de> wrote:
>> >> >+		if (tmp >= UINT_MAX || d > 0.9999999)
>> >> >+			return error(loc, "Probability " META_PROB_FMT " too %s", d, "big");
>> >> 
>> >> You are misappropriating some 430 points here. 0.9999999 maps to
>> >> just 0xfffffe51.
>> >
>> >Sorry, I am not following.
>> 
>> 0.9999999997 is still a valid probability, but you are making it 
>> impossible to select it by cutting off at d > 0.9999999000.
>
>I'll change it to allow one more digit, so that supported range will
>be 0.00000001 [10^-8] (0x0000002a) to
>   0.99999999 (0xffffffd4).

Let's ask differently. What precludes the use of the full range
(0x0/0x1) [2*10^-10] to (0xffffffff)?

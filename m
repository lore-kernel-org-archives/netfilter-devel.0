From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH nft 3/4] meta: add probability matching
Date: Thu, 3 Mar 2016 21:45:06 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1603032141160.3198@nerf40.vanv.qr>
References: <1457027814-14795-1-git-send-email-fw@strlen.de> <1457027814-14795-2-git-send-email-fw@strlen.de> <alpine.LSU.2.20.1603032005570.446@nerf40.vanv.qr> <20160303203226.GA2728@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:45506 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756948AbcCCUpI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Mar 2016 15:45:08 -0500
In-Reply-To: <20160303203226.GA2728@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2016-03-03 21:32, Florian Westphal wrote:

>Jan Engelhardt <jengelh@inai.de> wrote:
>> On Thursday 2016-03-03 18:56, Florian Westphal wrote:
>> 
>> >The float value has to be in range of 0.0000001 to 0.9999999 and
>> >+
>> >+		if (tmp >= UINT_MAX || d > 0.9999999)
>> >+			return error(loc, "Probability " META_PROB_FMT " too %s", d, "big");
>> 
>> You are misappropriating some 430 points here. 0.9999999 maps to
>> just 0xfffffe51.
>
>Sorry, I am not following.

0.9999999997 is still a valid probability, but you are making it 
impossible to select it by cutting off at d > 0.9999999000.


>What would you likew to change here?

Change to
	if (tmp >= UINT_MAX || d >= 1)

(or better yet, d > 1)

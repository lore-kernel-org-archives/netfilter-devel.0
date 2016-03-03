From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH nft 3/4] meta: add probability matching
Date: Thu, 3 Mar 2016 20:36:38 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1603032005570.446@nerf40.vanv.qr>
References: <1457027814-14795-1-git-send-email-fw@strlen.de> <1457027814-14795-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:45174 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbcCCTgl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Mar 2016 14:36:41 -0500
In-Reply-To: <1457027814-14795-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2016-03-03 18:56, Florian Westphal wrote:

>The float value has to be in range of 0.0000001 to 0.9999999 and
>+
>+		if (tmp >= UINT_MAX || d > 0.9999999)
>+			return error(loc, "Probability " META_PROB_FMT " too %s", d, "big");

You are misappropriating some 430 points here. 0.9999999 maps to
just 0xfffffe51.

>+		*value = (uint32_t) tmp;
>+		if (*value == 0)
>+			return error(loc, "Probability " META_PROB_FMT " too %s", d, "small");

Though d==0 and d==1 are not overly useful, why prohibit them? iptables 
allowed taking them, and I hear people are working on a translator...*boom*

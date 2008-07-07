From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fwd: [PATCH] nf_nat_core: eliminate find_appropriate_src call
 if range is set IP_NAT_RANGE_PROTO_RANDOM bit on
Date: Mon, 07 Jul 2008 13:24:46 +0200
Message-ID: <4871FCFE.1020202@trash.net>
References: <412e6f7f0806292132l18c747d6h982c64ce7c9d9c85@mail.gmail.com>	 <412e6f7f0806300100t6bc37635pc922405705f1784d@mail.gmail.com>	 <4868D76D.6050008@trash.net> <412e6f7f0806300634g1d82ffcewd3ba7ef0b951cd1a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57316 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbYGGLYt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 07:24:49 -0400
In-Reply-To: <412e6f7f0806300634g1d82ffcewd3ba7ef0b951cd1a@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> On Mon, Jun 30, 2008 at 8:54 PM, Patrick McHardy <kaber@trash.net> wrote:
>> Changli Gao wrote:
>>> ---------- Forwarded message ----------
>>> From: Changli Gao <xiaosuo@gmail.com>
>>> Date: 2008/6/30
>>> Subject: [PATCH] nf_nat_core: eliminate find_appropriate_src call if
>>> range is set IP_NAT_RANGE_PROTO_RANDOM bit on
>>> To: netfilter-devel@lists.netfilter.org
>>> Cc: Changli Gao <xiaosuo@gmail.com>
>>>
>>>
>>> Eliminate find_appropriate_src call if range is set
>>> IP_NAT_RANGE_PROTO_RANDOM bit on.
>> Please explain why the call isn't necessary.
>>
> In fact, my patch doesn't change the logic of the code, it just
> eliminates the uesless call find_appropriate_src. Because the tuple
> returned by find_appropriate is only useful when the
> IP_NAT_RANGE_PROTO_RANDOM isn't set on.  instead of testing the bit
> IP_NAT_RANGE_PROTO_RANDOM after calling find_appropriate_src, I do
> that before it to eliminate the cost of calling find_appropriate_src.

OK, but it does not apply cleanly because of whitespace mangling.
Please resend as attachment.

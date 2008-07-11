From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD PATCH] rework, fill MAC address in ULOG for ethernet.
Date: Fri, 11 Jul 2008 16:08:50 +0200
Message-ID: <48776972.8080305@trash.net>
References: <486B88F4.7060704@trash.net> <1215554219-13763-1-git-send-email-eric@inl.fr> <487497F4.8070004@netfilter.org> <48749899.7070505@trash.net> <48749AF1.60900@netfilter.org> <48749CAA.3030306@trash.net> <20080709210454.GA4461@ghlodit.inl.fr> <48752B26.3010404@trash.net> <20080710203931.GB4000@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>, Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60184 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYGKOJG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:09:06 -0400
In-Reply-To: <20080710203931.GB4000@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> On Wednesday, 2008 July  9 at 23:18:30 +0200, Patrick McHardy wrote:
>> Eric Leblond wrote:
>>> I think the proposed patch is a best effort work. It should be enough
>>> for most users as ethernet headers are the more common. But I agree, we
>>> can't have a full working solution with ULOG.
>>>
>>> I will try to find some time to rework my NFLOG patch to see if it is
>>> possible to cleanly send the source and destination hardware address to
>>> userspace via NFLOG.
> 
> I don't see any other mean but to get hardware address from device and
> not from skb. I really don't like it, as this can be done from userspace
> directly. I will thus stop working on adding destination address to
> NFLOG messages.
> 
>>> IMHO, this patch is not harmfull and will help some people. It may worth
>>> to be push in the git tree.
>>> +			ulogd_log(ULOGD_DEBUG, "Unknown mac_len (%d), "
>>> +					"rejecting packet", pkt->mac_len);
>> This comment made me believe that it would break header
>> printing for non-ethernet packets. If that is not true,
>> I have no objections.
> 
> Hmm, you're right but user using non-ethernet packets can upgrade to
> NFLOG ;)

I assume thats not meant seriously :) But we should integrate
new features into the new things, not break old things and
expect users to upgrade :)

From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH] rework, fill MAC address in ULOG for ethernet.
Date: Thu, 10 Jul 2008 22:39:32 +0200
Message-ID: <20080710203931.GB4000@bayen.regit.org>
References: <486B88F4.7060704@trash.net> <1215554219-13763-1-git-send-email-eric@inl.fr> <487497F4.8070004@netfilter.org> <48749899.7070505@trash.net> <48749AF1.60900@netfilter.org> <48749CAA.3030306@trash.net> <20080709210454.GA4461@ghlodit.inl.fr> <48752B26.3010404@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:60044 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbYGJUjf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:39:35 -0400
Content-Disposition: inline
In-Reply-To: <48752B26.3010404@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Wednesday, 2008 July  9 at 23:18:30 +0200, Patrick McHardy wrote:
> Eric Leblond wrote:
>> I think the proposed patch is a best effort work. It should be enough
>> for most users as ethernet headers are the more common. But I agree, we
>> can't have a full working solution with ULOG.
>>
>> I will try to find some time to rework my NFLOG patch to see if it is
>> possible to cleanly send the source and destination hardware address to
>> userspace via NFLOG.

I don't see any other mean but to get hardware address from device and
not from skb. I really don't like it, as this can be done from userspace
directly. I will thus stop working on adding destination address to
NFLOG messages.

>> IMHO, this patch is not harmfull and will help some people. It may worth
>> to be push in the git tree.
>
>> +			ulogd_log(ULOGD_DEBUG, "Unknown mac_len (%d), "
>> +					"rejecting packet", pkt->mac_len);
>
> This comment made me believe that it would break header
> printing for non-ethernet packets. If that is not true,
> I have no objections.

Hmm, you're right but user using non-ethernet packets can upgrade to
NFLOG ;)

BR,
-- 
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

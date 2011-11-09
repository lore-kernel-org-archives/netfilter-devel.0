From: Alex Bligh <alex@alex.org.uk>
Subject: Re: [PATCH] netfilter: fix ->nfnl NULL oops
Date: Wed, 09 Nov 2011 19:06:13 +0000
Message-ID: <739793C1875DFFB8AD91547F@nimrod.local>
References: <20111108221634.GA13261@p183.telecom.by>
 <20111109143423.GA24158@1984>
Reply-To: Alex Bligh <alex@alex.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	Alex Bligh <alex@alex.org.uk>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.avalus.com ([89.16.176.221]:45159 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab1KITGP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Nov 2011 14:06:15 -0500
In-Reply-To: <20111109143423.GA24158@1984>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



--On 9 November 2011 15:34:23 +0100 Pablo Neira Ayuso <pablo@netfilter.org> 
wrote:

>> I recall myself writing that net->nfnl NULL check is racy or
>> something like that (but I can't find this email in archives).
>>
>> I've read the code once again, and I'm quite sure,
>> NULL ->nfnl check is correct if RCU precautions are made.
>>
>> Regarding ->report check, I think it's bogus.
>>
>> If there are no listeners, there are NO listeners
>> and whether to report back to userspace doesn't matter.
>>
>> I'm sure I'm missing something obvious here.
>>
>> Please, review.
>
> Alexey. This is a workaround. We have to make ctnl_notifier
> container-aware which is the real problem.

It is indeed a workaround. However, until we have a real solution,
we need a workaround, or we can trivially generate fatal oopses.
I am all for fixing it properly, but please can we leave the workaround
in place until we have the proper answer, as without this we see
machines die frequently.

-- 
Alex Bligh

From: Alex Bligh <alex@alex.org.uk>
Subject: Re: [PATCH] netfilter: fix ->nfnl NULL oops
Date: Tue, 08 Nov 2011 22:50:05 +0000
Message-ID: <32FF200DF1281ACA19CF3807@nimrod.local>
References: <20111108221634.GA13261@p183.telecom.by>
Reply-To: Alex Bligh <alex@alex.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	Alex Bligh <alex@alex.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.avalus.com ([89.16.176.221]:53201 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab1KHW4t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:56:49 -0500
In-Reply-To: <20111108221634.GA13261@p183.telecom.by>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--On 9 November 2011 01:16:35 +0300 Alexey Dobriyan <adobriyan@gmail.com> 
wrote:

> Sorry for delay.
>
> I recall myself writing that net->nfnl NULL check is racy or
> something like that (but I can't find this email in archives).
>
> I've read the code once again, and I'm quite sure,
> NULL ->nfnl check is correct if RCU precautions are made.

Your patch looks better than mine in this respect (as far as I
can tell from code reading rather than testing)

> Regarding ->report check, I think it's bogus.

All I can tell is that net->nfnl == NULL is a condition that happens in 
practice. If that is read, race free, and treated as something that causes 
nfnetlink_has_listeners to return 0 irrespective of item_report, then the 
oops will not occur. So from my point of view it seems right.

Note that in the mean time I think my patch made -stable.

-- 
Alex Bligh

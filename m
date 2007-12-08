From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter_queue: byte order of mark
Date: Sat, 08 Dec 2007 04:05:07 +0100
Message-ID: <475A09E3.4080407@trash.net>
References: <Pine.LNX.4.64.0712071544240.2760@dent.vctlabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Stephanie Lockwood-Childs <sjl@vctlabs.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47236 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbXLHDFn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Dec 2007 22:05:43 -0500
In-Reply-To: <Pine.LNX.4.64.0712071544240.2760@dent.vctlabs.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephanie Lockwood-Childs wrote:
> when trying to set marks with netfilter_queue library, I discovered 
> there is
> a discrepency in byte ordering between the library and the 
> nfnetlink_queue
> kernel model. The kernel code expects to receive the mark attribute in
> network order
>
> net/netfilter/nfnetlink_queue.c
> if (nfqa[NFQA_MARK-1])
>     entry->skb->mark = ntohl(*(__be32 *)
>                 NFA_DATA(nfqa[NFQA_MARK-1]));
>
> so netfilter_queue library should put the mark into network order when
> sending it.

Yes, its a stupid bug and even I got bitten by it multiple times,
but we can't change it since users already rely on this behaviour.
You could introduce a new, fixed version of set_verdict_mark and
deprecate the old one.

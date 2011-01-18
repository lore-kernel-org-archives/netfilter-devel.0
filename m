From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/6] netfilter: reduce NF_VERDICT_MASK to 0xff
Date: Tue, 18 Jan 2011 15:52:47 +0100
Message-ID: <4D35A93F.2040405@trash.net>
References: <1295183947-12786-1-git-send-email-fw@strlen.de> <1295183947-12786-5-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57121 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab1AROwt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 09:52:49 -0500
In-Reply-To: <1295183947-12786-5-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16.01.2011 14:19, Florian Westphal wrote:
> NF_VERDICT_MASK is currently 0xffff. This is because the upper
> 16 bits are used to store errno (for NF_DROP) or the queue number
> (NF_QUEUE verdict).
> 
> As there are up to 0xffff different queues available, there is no more
> room to store additional flags.
> 
> At the moment there are only 6 different verdicts, i.e. we can reduce
> NF_VERDICT_MASK to 0xff to allow storing additional flags in the 0xff00 space.
> 
> NF_VERDICT_BITS would then be reduced to 8, but because the value is
> exported to userspace, this might cause breakage; e.g.:
> 
> e.g. 'queuenr = (1 << NF_VERDICT_BITS) | NF_QUEUE'  would now break.
> 
> Thus, remove NF_VERDICT_BITS usage in the kernel and move the old value
> to the 'userspace compat' section.

Applied, thanks.

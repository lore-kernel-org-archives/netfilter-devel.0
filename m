From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/6] netfilter: allow NFQUEUE bypass if no listener is
 available
Date: Tue, 18 Jan 2011 16:09:29 +0100
Message-ID: <4D35AD29.2060400@trash.net>
References: <1295183947-12786-1-git-send-email-fw@strlen.de> <1295183947-12786-6-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fwestphal@astaro.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57423 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab1ARPJc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:09:32 -0500
In-Reply-To: <1295183947-12786-6-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16.01.2011 14:19, Florian Westphal wrote:
> If an skb is to be NF_QUEUE'd, but no program has opened the queue, the
> packet is dropped.
> 
> This adds a v2 target revision of xt_NFQUEUE that allows packets to
> continue through the ruleset instead.
> 
> Because the actual queueing happens outside of the target context, the
> 'bypass' flag has to be communicated back to the netfilter core.
> 
> Unfortunately the only choice to do this without adding a new function
> argument is to use the target function return value (i.e. the verdict).
> 
> In the NF_QUEUE case, the upper 16bit already contain the queue number
> to use.  The previous patch reduced NF_VERDICT_MASK to 0xff, i.e.
> we now have extra room for a new flag.
> 
> If a hook issued a NF_QUEUE verdict, then the netfilter core will
> continue packet processing if the queueing hook
> returns -ESRCH (== "this queue does not exist") and the new
> NF_VERDICT_FLAG_QUEUE_BYPASS flag is set in the verdict value.
> 
> Note: If the queue exists, but userspace does not consume packets fast
> enough, the skb will still be dropped.

Applied, thanks.

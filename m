From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 2/3] netfilter: NFQUEUE: queue balancing support
Date: Fri, 5 Jun 2009 15:35:25 +0200
Message-ID: <20090605133525.GI29745@Chamillionaire.breakpoint.cc>
References: <1244164542-10739-1-git-send-email-fw@strlen.de> <1244164542-10739-3-git-send-email-fw@strlen.de> <4A2900CE.5090004@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Holger Eitzenberger <heitzenberger@astaro.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41727 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbZFENfX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:35:23 -0400
Content-Disposition: inline
In-Reply-To: <4A2900CE.5090004@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> Nice work, applied. I've made two minor cosmetic changes:
[..]
>> +	return jhash2(addr, 4, jhash_initval);
>
> I changed 4 to ARRAY_SIZE(addr)

agreed.

>> +		printk(KERN_ERR "NFQUEUE: number of queues (%u) out of range (got 
>> %u)\n",
>> +							info->queues_total, maxid);
>> +		return false;
> and these printks to use pr_err to bring the line size down.

Indeed, it looks better that way :-)

Thanks a lot Patrick.

From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/2] netfilter: conntrack: cache route for
 forwarded connections
Date: Mon, 8 Dec 2014 23:33:45 +0100
Message-ID: <20141208223345.GE6672@breakpoint.cc>
References: <1418052964-4632-1-git-send-email-fw@strlen.de>
 <1418052964-4632-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	brouer@redhat.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53128 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755132AbaLHWdr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:33:47 -0500
Content-Disposition: inline
In-Reply-To: <1418052964-4632-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> +	if (likely(dst))
> +		skb_dst_set_noref_force(skb, dst);

Note that Hannes submitted a patch vs. net-next that removes
skb_dst_set_noref_force().

So depending on the oder in which the patches are applied
(iff they are...) the above should read

skb_dst_set_noref(skb, dst);

instead.

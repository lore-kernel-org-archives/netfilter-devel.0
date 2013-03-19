From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH RFC 2/3] NFQUEUE: coalesce IPv4 and IPv6 hashing
Date: Tue, 19 Mar 2013 15:39:30 +0100
Message-ID: <20130319143930.GB13505@imap.eitzenberger.org>
References: <20130319141442.150005875@eitzenberger.org>
 <20130319141605.728912499@eitzenberger.org>
 <20130319.102749.234269518851550039.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:51577 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab3CSOjh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:39:37 -0400
Content-Disposition: inline
In-Reply-To: <20130319.102749.234269518851550039.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 19, 2013 at 10:27:49AM -0400, David S. Miller wrote:
> From: holger@eitzenberger.org
> Date: Tue, 19 Mar 2013 15:14:44 +0100
> 
> > +	if (par->family == NFPROTO_IPV4)
> > +		queue = (((u64) hash_v4(skb) * info->queues_total) >>
> > +			 32) + queue;
> >  #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> > -		else if (par->family == NFPROTO_IPV6)
> > -			queue = (((u64) hash_v6(skb) * info->queues_total) >>
> > -				 32) + queue;
> > +	else if (par->family == NFPROTO_IPV6)
> > +		queue = (((u64) hash_v6(skb) * info->queues_total) >>
> > +			 32) + queue;
> >  #endif
> 
> Similarly, add a helper function.
> 
> Since there are so many similar call sites, perhaps put it into a
> common header file.

Look at patch #2! :)


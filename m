From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH RFC 1/3] NFQUEUE: introduce CPU fanout
Date: Tue, 19 Mar 2013 22:38:11 +0100
Message-ID: <20130319213811.GF13505@imap.eitzenberger.org>
References: <20130319141605.158831637@eitzenberger.org>
 <20130319.102620.2063759629502166169.davem@davemloft.net>
 <alpine.LNX.2.01.1303191531210.9679@nerf07.vanv.qr>
 <20130319.103708.24746976367419338.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:53699 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933797Ab3CSVi3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:38:29 -0400
Content-Disposition: inline
In-Reply-To: <20130319.103708.24746976367419338.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 19, 2013 at 10:37:08AM -0400, David S. Miller wrote:
> From: Jan Engelhardt <jengelh@inai.de>
> Date: Tue, 19 Mar 2013 15:34:56 +0100 (CET)
> 
> > 
> > On Tuesday 2013-03-19 15:26, David Miller wrote:
> >>
> >>> +			if (par->family == NFPROTO_IPV4)
> >>> +				queue = (((u64) hash_v4(skb) * info->queues_total) >>
> >>> +						 32) + queue;
> >>> +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> >>> +			else if (par->family == NFPROTO_IPV6)
> >>> +				queue = (((u64) hash_v6(skb) * info->queues_total) >>
> >>> +						 32) + queue;
> >>> +#endif
> >>
> >>Maybe add a helper function so you don't have to indent so deeply.  Something
> >>like:
> > 
> > And combined with smart arranging of clauses, won't need an extra 
> > helper function.
> > http://www.braceless.org/Various/The%20Else%20Statement%20Considered%20Harmful
> > 
> > Something like
> 
> Yes, but:
> 
> > +		queue = (((u64) hash_v4(skb) * info->queues_total) >>
> > +				 32) + queue;
>                                  ^^^^^^
> 
> it's that terribly indented giblet that I want to disappear.

Fully agreed, but at this time I kept the indentation.  Take
a look at the changes done in nfqueue_tg_v1() from patch #2.

Will see how I can address your point.

From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack EILSEQ followed by ENOBUFS
Date: Thu, 13 Oct 2011 13:02:10 +0200
Message-ID: <20111013110210.GA20533@1984>
References: <20111010211702.4a666dfc@wwwwww-701SD>
 <20111012161615.GA14338@1984>
 <20111013111020.60e09065@wwwwww-701SD>
 <20111013093014.GB19706@1984>
 <20111013125055.0f19237c@wwwwww-701SD>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: abirvalg@lavabit.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42743 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab1JMLCR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:02:17 -0400
Content-Disposition: inline
In-Reply-To: <20111013125055.0f19237c@wwwwww-701SD>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 13, 2011 at 12:50:55PM +0000, abirvalg@lavabit.com wrote:
> Sorry for not being sufficiently specific. Since you showed more interest, I feel empowered to go into further detail.

You're reporting problems, I'm not a wizard, if you don't provide
details, it's way harder for me to guess what's wrong ;-)

> My app uses libnetfilter_queue. When it NF_ACCEPTs a packet, it immediately goes on to set a mark on the connection of which the ACCEPTed packet is part of. But in order to set the mark on the connection, it first NFCT_Q_GETs that conntrack (because it knows srcIP, destIP, srcPort, destPort, L4proto, L3proto). Once it got the conntrack, it can proceed to set a mark on it using NFCT_Q_UPDATE.
> 
> I'm hitting EBUSY with NFCT_Q_GET.
> My impression was that it was ok to hit EBUSY, since I'm making such a heavy use of conntrack table, contantly updating in. Besides I have watch -n 1 'conntrack -L' running in another console. So it's double pressure.
> It may be beside the point, but apart from this GETing and UPDATEing, I have another thread (that uses a different handle) which every minute or so does NFCT_Q_DUMP (that's 1000+ entries) and the handle's callback then NFCT_Q_DESTROYS (based on the nfmark) approx. 80% of the dump. 

There are different situations in which you may hit EBUSY:

For example, if you call NFCT_Q_DUMP after some unconcluded dumping
(one previous NFCT_Q_DUMP operation that is still on the way).

Regarding threads, it's a bad idea to share conntrack handlers between
different threads.

As said, I need some code to look at for better helping.

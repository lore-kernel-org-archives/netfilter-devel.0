From: <abirvalg@lavabit.com>
Subject: Re: conntrack EILSEQ followed by ENOBUFS
Date: Thu, 13 Oct 2011 12:50:55 +0000
Message-ID: <20111013125055.0f19237c@wwwwww-701SD>
References: <20111010211702.4a666dfc@wwwwww-701SD>
	<20111012161615.GA14338@1984>
	<20111013111020.60e09065@wwwwww-701SD>
	<20111013093014.GB19706@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from karen.lavabit.com ([72.249.41.33]:46123 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab1JMJvB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:51:01 -0400
Received: from a.earth.lavabit.com (a.earth.lavabit.com [192.168.111.10])
	by karen.lavabit.com (Postfix) with ESMTP id 7529011BB83
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2011 04:51:01 -0500 (CDT)
Received: from wwwwww-701sd (62.63.182.28)
	by lavabit.com with ESMTP id 2YQZ6EF7MT9H
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2011 04:51:01 -0500
In-Reply-To: <20111013093014.GB19706@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry for not being sufficiently specific. Since you showed more interest, I feel empowered to go into further detail.

My app uses libnetfilter_queue. When it NF_ACCEPTs a packet, it immediately goes on to set a mark on the connection of which the ACCEPTed packet is part of. But in order to set the mark on the connection, it first NFCT_Q_GETs that conntrack (because it knows srcIP, destIP, srcPort, destPort, L4proto, L3proto). Once it got the conntrack, it can proceed to set a mark on it using NFCT_Q_UPDATE.

I'm hitting EBUSY with NFCT_Q_GET.
My impression was that it was ok to hit EBUSY, since I'm making such a heavy use of conntrack table, contantly updating in. Besides I have watch -n 1 'conntrack -L' running in another console. So it's double pressure.

It may be beside the point, but apart from this GETing and UPDATEing, I have another thread (that uses a different handle) which every minute or so does NFCT_Q_DUMP (that's 1000+ entries) and the handle's callback then NFCT_Q_DESTROYS (based on the nfmark) approx. 80% of the dump. 




On Thu, 13 Oct 2011 11:30:14 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Thu, Oct 13, 2011 at 11:10:20AM +0000, abirvalg@lavabit.com wrote:
> > Gracias for responding, Pablo.
> > My problem has now scaled down by 50%. EILSEQ happened due to a race when 2 threads in my app set_attr* to the same stuct nf_conntrack simultaneously.
> 
> Hm, you didn't mention you were using threads. Then, it's normal to
> run into sequence tracking issues if both are using the same socket.
> It can be a good idea to give a try to use two different sockets, one
> per thread.
> 
> > I only have EBUSY error occasionally. I now upgraded to libnetfilter_conntrack 0.9.1 and the frequency of EBUSY has dropped significantly. I seed a torrent which creates 30 NEW connections per second and leave the machine running for 24  hours.
> > I put a mark on each of those NEW connection.  I only got 1 EBUSY so far.
> > 
> > Please let me know if you are still interested in getting to the bottom of that 1 EBUSY per 24 hours.
> 
> I'd need to know more information on what you're doing. Right now, I
> don't understand what you're doing further than "updating one ct mark".
> 
> Again, some example code that I can look at, or some description would
> help me a lot.
> 
> > >EBUSY shouldn't happen unless you are playing with the conntrack
> > >flags or trying to assign some conntrack helper.
> > >In that case, I'd need some example code that can trigger this error.
> > 
> > No, I don't have any conntrack helpers. And I'm not touching any conntrack flags. Just doing nfct_query(...NFCT_Q_GET...).
> 
> You're hitting EBUSY with NFCT_Q_GET or NFCT_Q_UPDATE?


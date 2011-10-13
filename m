From: <abirvalg@lavabit.com>
Subject: Re: conntrack EILSEQ followed by ENOBUFS
Date: Thu, 13 Oct 2011 14:19:12 +0000
Message-ID: <20111013141912.60febfa8@wwwwww-701SD>
References: <20111010211702.4a666dfc@wwwwww-701SD>
	<20111012161615.GA14338@1984>
	<20111013111020.60e09065@wwwwww-701SD>
	<20111013093014.GB19706@1984>
	<20111013125055.0f19237c@wwwwww-701SD>
	<20111013110210.GA20533@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from karen.lavabit.com ([72.249.41.33]:52554 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626Ab1JMLUC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:20:02 -0400
In-Reply-To: <20111013110210.GA20533@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 13 Oct 2011 13:02:10 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Thu, Oct 13, 2011 at 12:50:55PM +0000, abirvalg@lavabit.com wrote:
> > Sorry for not being sufficiently specific. Since you showed more interest, I feel empowered to go into further detail.
> 
> You're reporting problems, I'm not a wizard, if you don't provide
> details, it's way harder for me to guess what's wrong ;-)
> 
> > My app uses libnetfilter_queue. When it NF_ACCEPTs a packet, it immediately goes on to set a mark on the connection of which the ACCEPTed packet is part of. But in order to set the mark on the connection, it first NFCT_Q_GETs that conntrack (because it knows srcIP, destIP, srcPort, destPort, L4proto, L3proto). Once it got the conntrack, it can proceed to set a mark on it using NFCT_Q_UPDATE.
> > 
> > I'm hitting EBUSY with NFCT_Q_GET.
> > My impression was that it was ok to hit EBUSY, since I'm making such a heavy use of conntrack table, contantly updating in. Besides I have watch -n 1 'conntrack -L' running in another console. So it's double pressure.
> > It may be beside the point, but apart from this GETing and UPDATEing, I have another thread (that uses a different handle) which every minute or so does NFCT_Q_DUMP (that's 1000+ entries) and the handle's callback then NFCT_Q_DESTROYS (based on the nfmark) approx. 80% of the dump. 
> 
> There are different situations in which you may hit EBUSY:
> 
> For example, if you call NFCT_Q_DUMP after some unconcluded dumping
> (one previous NFCT_Q_DUMP operation that is still on the way).
> 
> Regarding threads, it's a bad idea to share conntrack handlers between
> different threads.
> 
> As said, I need some code to look at for better helping.

Sorry for not being forthcoming with the code, I forgot that my project has gitweb enabled,
Here is the offending line: (line 1541)

http://leopardflower.git.sourceforge.net/git/gitweb.cgi?p=leopardflower/leopardflower;a=blob;f=lpfw.c;h=a95e80359b5b3c00657d1e695ff273e84e8288d1;hb=8e787ce7e0800c1541b9427e517d14d8ae55e756#l1541

Cheers.


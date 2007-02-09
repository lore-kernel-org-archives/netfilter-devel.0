From: Andrew Beverley <andy@andybev.com>
Subject: Re: Opinions about pom/patches [was: iptables 1.3.7,
	kernel 2.6.19, ROUTE and Layer7 issues]
Date: Fri, 09 Feb 2007 17:30:28 +0000
Message-ID: <1171042229.4244.50.camel@andybev.localdomain>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>
	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>
	<457E6997.1050001@trash.net>
	<36479.195.55.244.106.1165998665.squirrel@www.arcoscom.com>
	<457FBBFD.6060009@trash.net>
	<Pine.LNX.4.64.0612282158360.16672@bizon.gios.gov.pl>
	<45A48087.8090200@trash.net>
	<Pine.LNX.4.61.0701101233080.3029@yvahk01.tjqt.qr>
	<54696.195.55.244.106.1168435275.squirrel@www.arcoscom.com>
	<1169746884.4253.51.camel@andybev.localdomain>
	<45C005EB.1040704@netfilter.org>
	<1171028254.4244.26.camel@andybev.localdomain>
	<Pine.LNX.4.64.0702091741250.9884@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <lartc-bounces@mailman.ds9a.nl>
In-Reply-To: <Pine.LNX.4.64.0702091741250.9884@bizon.gios.gov.pl>
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

> >>> I would also like to see as many of the POM included in the stable
> >>> kernel. It's a bit of a headache to patch in what I want each time I
> >>> update the kernel, and on a fresh system I have to install CURL just to
> >>> update POM just to add connlimit to the kernel...
> >>
> >> IMHO, patching kernels to add some certain shiny-feature(TM) is
> >> generally a bad idea if you don't know how the patch internally works or
> >> if you can't directly get support from the author of such patch.
> >
> > Yes, agreed. I was more thinking of those that (look like) they have
> > been stable for a few years.
> >
> >> Anyway, if you think that some certain patch is stable enough to push it
> >> forward to mainline, encourage the author to push it forward. Probably
> >> there is a reason why he decided not to do that.
> >
> > Okay, I've emailed the author (of connlimit) but not received a reply. I
> > did ask him a while ago on the same subject but didn't really get a
> > reason as to why it is not. Anybody have any ideas?
> >
> > In this case can *I* push it forward to the stable kernel?
> 
> Please excuse me - I have been _extremely _ busy for the last three weeks.

No please accept my apologies - I was a bit impatient.

> Getting back to the question: generally I have no objection for forwarding 
> connlinit to the mainline but I believe we should first investigate a 
> possibilty to add support for other protocols than TCP. AFAIK at least UDP 
> support could be very usefull - p2p software generates not only a lot of 
> tcp cnnections but also udp flows and main job for this extension is to 
> prevent conntrack database overflows.

Very interesting. I had exactly the same thoughts myself, and have
actually already created a patch for hashlimit which matches on the
number of UDP 'connections'.

Of course, the problem with UDP is that there are no connections as such
to count, which is why I chose to patch hashlimit rather than connlimit.
Hashlimit (as I am sure you are aware) keeps a table of recent data
flows which die after a set time, making it easier to count UDP flows.
I'm not sure how easy this would be to achieve with connlimit.

I was planning on sending the patch to hashlimit's author, if nothing
else just to get feedback on it, as it is the first kernel hacking I
have done. Maybe I should post it to the netfilter-devel list instead,
or am I using the wrong tool for the wrong job?

Regards,

Andy Beverley

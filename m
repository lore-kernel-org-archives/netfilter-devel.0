From: Andrew Beverley <andy@andybev.com>
Subject: Re: Opinions about pom/patches [was: iptables 1.3.7,
	kernel 2.6.19, ROUTE and Layer7 issues]
Date: Thu, 25 Jan 2007 17:41:24 +0000
Message-ID: <1169746884.4253.51.camel@andybev.localdomain>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>
	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>
	<457E6997.1050001@trash.net>
	<36479.195.55.244.106.1165998665.squirrel@www.arcoscom.com>
	<457FBBFD.6060009@trash.net>
	<Pine.LNX.4.64.0612282158360.16672@bizon.gios.gov.pl>
	<45A48087.8090200@trash.net>
	<Pine.LNX.4.61.0701101233080.3029@yvahk01.tjqt.qr>
	<54696.195.55.244.106.1168435275.squirrel@www.arcoscom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org
To: linux@arcoscom.com
Return-path: <lartc-bounces@mailman.ds9a.nl>
In-Reply-To: <54696.195.55.244.106.1168435275.squirrel@www.arcoscom.com>
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

Sorry, a bit late replying to this but just wanted to add my thoughts.

> I think so, there are many old matches that are stables and I have to
> apply many times when I update the kernel. If they where into kernel and
> iptables (because they are now not as experimental than many months/years
> ago) these problem when new kernel releases and/or iptables releases
> disapears very quickly.
> 
> I have a great headache now, I had to patch my kernel, patch iptables,
> update iproute to allow "mark-and" operations for routing. Yes, I can
> adapt many thinks and forgot many routing/filtering functionality, but
> then, my linux box will be useless for the purposes I deploy it.
> 
> I have no problem in patch and upgrade thinks, my problem is that I have
> no time to do all these steps every any important bug, improvement is
> released.

I would also like to see as many of the POM included in the stable
kernel. It's a bit of a headache to patch in what I want each time I
update the kernel, and on a fresh system I have to install CURL just to
update POM just to add connlimit to the kernel...

It's also a bit of a problem because I am looking to hand my server over
to professional support. I've got to explain to them that if they ever
update the kernel that it will need patching. If they don't, or forget,
then it will significantly affect the system's performance in the
particular situation.

Finally, I can't help but think it puts off newcomers. Although fairly
simple when you know what you're doing, when someone comes from a
point-and-click windows background it is incredibly complicated!

The two I would like to see in the main kernel are connlimit (stable for
a few years?) and ipset.

Regards,

Andy Beverley

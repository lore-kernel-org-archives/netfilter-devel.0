From: Michael Rash <mbr@cipherdyne.org>
Subject: Re: iptables match rule for DNS RR?
Date: Thu, 05 Apr 2007 20:17:59 -0400
Message-ID: <20070406001759.GA4379@minastirith>
References: <20070404131825.GB20515@kallisti.us>
	<twig.1175694568.67940@bugmachine.ca>
	<20070404135651.GA20727@kallisti.us>
	<Pine.LNX.4.61.0704042212240.22282@yvahk01.tjqt.qr>
	<20070404203918.GA23386@kallisti.us> <46140F3D.2050605@trash.net>
	<20070405135234.GA27429@kallisti.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <20070405135234.GA27429@kallisti.us>
Content-disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Apr 05, 2007, Ross Vandegrift wrote:

> On Wed, Apr 04, 2007 at 10:49:01PM +0200, Patrick McHardy wrote:
> > Ross Vandegrift wrote:
> > > What does it mean for netlink to say "no such file or directory"?
> > 
> > 
> > The queue entry you're sending a verdict for does not exist.
> 
> Aha, thanks for the tip, that does make perfect sense.  Turns out I
> had a packet parser bug fouling things up.
> 
> Thanks again - I'm really amazed at how easy it was to extend
> netfilter to do what I needed in a pinch.  I'm now processing about
> 10k packets per second across a cluster of 15 servers, cutting their
> CPU load by 30-50%.  I'm quite thrilled!

You could also potentially use the string match extension to drop
offending packets from within the kernel (you mentioned odd query types,
so this is what you would match on).  For example, for ISDN queries you
could do:

iptables -I FORWARD 1 -p udp --dport 53 -d <dns_server> -m string
--hex-string "|00 00 14 00 01|" --from 46 --algo bm -j DROP

The --from value of 46 is somewhat arbitrary, but it gets past the MAC,
IP [1], and UDP headers, with 4 bytes to spare for a query that contains
at least something like \x03com.

[1] Assuming no IP options

--
Michael Rash
http://www.cipherdyne.org/
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F

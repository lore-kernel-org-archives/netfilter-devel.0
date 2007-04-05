From: Ross Vandegrift <ross@kallisti.us>
Subject: Re: iptables match rule for DNS RR?
Date: Thu, 5 Apr 2007 09:52:35 -0400
Message-ID: <20070405135234.GA27429@kallisti.us>
References: <20070404131825.GB20515@kallisti.us>
	<twig.1175694568.67940@bugmachine.ca>
	<20070404135651.GA20727@kallisti.us>
	<Pine.LNX.4.61.0704042212240.22282@yvahk01.tjqt.qr>
	<20070404203918.GA23386@kallisti.us> <46140F3D.2050605@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Samuel Jean <jix@bugmachine.ca>, netfilter-devel@lists.netfilter.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Ross Vandegrift <ross@eris.kallisti.us>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <46140F3D.2050605@trash.net>
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

On Wed, Apr 04, 2007 at 10:49:01PM +0200, Patrick McHardy wrote:
> Ross Vandegrift wrote:
> > What does it mean for netlink to say "no such file or directory"?
> 
> 
> The queue entry you're sending a verdict for does not exist.

Aha, thanks for the tip, that does make perfect sense.  Turns out I
had a packet parser bug fouling things up.

Thanks again - I'm really amazed at how easy it was to extend
netfilter to do what I needed in a pinch.  I'm now processing about
10k packets per second across a cluster of 15 servers, cutting their
CPU load by 30-50%.  I'm quite thrilled!

-- 
Ross Vandegrift
ross@kallisti.us

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37

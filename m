From: Andy Polyakov <appro@fy.chalmers.se>
Subject: Re: [netfilter-core] linux-2.6.0-testX ipchains oops in NAT
Date: Thu, 23 Oct 2003 11:52:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F97A4C5.982725B0@fy.chalmers.se>
References: <3F964F9D.D5C69498@fy.chalmers.se> <20031023090238.GE1418@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org,
        Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Just a quick unrelated question: Why would somebody be using ipchains on
> a 2.6 kernel?

Well, I use it, because it was on my computer since eternity and I used
to it. It's hardly a "crime":-):-):-)

> > What the heck with rebooting guest and connecting to same URL? Guest OS
> > will use very same port numbers at second boot and NAT layer will use
> > same port translations, which appears as the triggering factor itself.
> >
> > Reloading ipchains module in between guest OS boots makes it possible to
> > avoid lock-ups/oopses.
> 
> As I have no idea about vmware: does it destroy the virtual interface on
> the host at time of the reboot in your guest os?

No, vmnetN interfaces are persistent and are taken up/down upon system
boot/shutdown. They are pretty much independent from the VMware
application, the one which arranges for communication between guest OS
and the vmnetN interface.

> What about using iptables?  Does it produce a similar behaviour?

I don't know. I'll check at some point, but not right away...

> I
> think this is the first time within at least a year that we've had any
> report of somebody using (or finding bugs) in the ipfwadm/ipchains
> compat layer... it wasn't even frequently used with 2.4.x

Well, then it probably should have disappeared from 2.6. I mean if the
code is there, then it should work and is actually expected to work.

> > Question. Should I pursue the issue further?
> 
> yes, please.  Especially a means of reproduction without running
> proprietary software (and thus being repruducable for me) would be very
> helpful.

Would eth0:1 be sufficient? A.

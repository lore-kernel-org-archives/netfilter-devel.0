From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Oops in replace_in_hashes (ip_net_core.c) 2.4.19 (and 2.4.21)
Date: Tue, 22 Jul 2003 11:50:25 +0200 (CEST)
Sender: linux-net-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.52.0307221141050.20491@tux.rsn.bth.se>
References: <S261808AbTGAJfh/20030701093537Z+14616@vger.kernel.org>
 <20030721084011.8347162D3E@wlug.westbo.se> <Pine.LNX.4.52.0307211319260.16207@tux.rsn.bth.se>
 <20030722090917.BC18E62D3A@wlug.westbo.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-net@vger.kernel.org,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <linux-net-owner@vger.kernel.org>
To: Mike Smith <mikesmith1@btconnect.com>
In-Reply-To: <20030722090917.BC18E62D3A@wlug.westbo.se>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 22 Jul 2003, Mike Smith wrote:

> On Monday 21 Jul 2003 11:22 am, Martin Josefsson wrote:
> > I'll look over it again later tonight, in the mean time could you switch
> > to 2.4.21? And apply everything from submitted and pending in
> > patch-o-matic from cvs (cvs instructions can be found on
> > http://netfilter.org). Any eventual debugging-patches will be against that
> > kernel and those patches.
> >
> > /Martin
>
> Martin,
>
> vanilla 2.4.21 oopsed last night. Hand-transcribed oops below. I want to
> apply all the cvs fixes but am a bit short of clues. Is it pom-20030107
> that I want? (it is advertised as 2.4.18 thru 2.4.20...) or do I need to
> do a 'cvs update -d -P' ? Sorry to be so clueless but it's the first
> time I've had to do stuff like this. Help!

You don't want that pom release, it's very old.
You want to get pom from cvs. You have instructions on netfilter.org

cvs -d :pserver:cvs@pserver.netfilter.org:/cvspublic login
(password cvs)

cvs -d :pserver:cvs@pserver.netfilter.org:/cvspublic co netfilter/userspace netfilter/patch-o-matic
(you need the userspace directory since there's a patch that tries to
patch that as well)

cd netfilter/patch-o-matic
KERNEL_DIR=/usr/src/yourkernel ./runme --batch pending

then recompile and reboot.

It would be helpful if you could give me all your rules. If you don't want
the whole world to see them you can send them to me privately. And if you
could describe the type of traffic that goes through the router...

That way I might be able to reproduce the bug.

UP/SMP? any other patches applied? Which modules do you have loaded?
Or do you have the iptables stuff compiled into your kernel? If so, which
things did you select? ...
(You probably wrote some of this stuff in your first mail but I'm too lazy
to find it :)

/Martin

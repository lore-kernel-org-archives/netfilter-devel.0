From: "Richard B. Johnson" <root@chaos.analogic.com>
Subject: Re: [PATCH] Warn people that ipchains and ipfwadm are going away.
Date: Wed, 22 Sep 2004 08:05:00 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0409220800200.2147@chaos.analogic.com>
References: <1095721742.5886.128.camel@bach>  <20040921143613.2dc78e2f.Ballarin.Marc@gmx.de>
 <1095803902.1942.211.camel@bach> <Pine.LNX.4.53.0409220735080.2066@chaos.analogic.com>
 <Pine.LNX.4.58.0409221347010.23967@tux.rsn.bth.se>
Reply-To: root@chaos.analogic.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Marc Ballarin <Ballarin.Marc@gmx.de>,
	Linus Torvalds <torvalds@osdl.org>,
	netfilter-devel@lists.netfilter.org,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S264795AbUIVMFy@vger.kernel.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.58.0409221347010.23967@tux.rsn.bth.se>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 22 Sep 2004, Martin Josefsson wrote:

> On Wed, 22 Sep 2004, Richard B. Johnson wrote:
>
> > > Sure, but you have to start somewhere.  Next step will be #error.  Then
> > > finally remove the whole thing (I don't want to remove the whole thing
> > > to start with, since that would create a silent failure).
> > >
> > > Cheers,
> > > Rusty.
> > > --
> >
> > What replaces the firewall stuff? It can't just "go away"!
>
> Ever heard of iptables?
>
> /Martin

I guess I'll have to convert 1340 lines of ipchains commands to
iptables -yech!

I had convert something to ipchains a couple of years ago.
That's when I only had to kill-off only about 100 spam-hosts.

Now I gotta convert again. Soon they'll be replacing `ls`
with `echo *` and nothing will work.


Cheers,
Dick Johnson
Penguin : Linux version 2.4.26 on an i686 machine (5570.56 BogoMips).
            Note 96.31% of all statistics are fiction.

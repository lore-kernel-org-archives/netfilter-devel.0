From: "Richard B. Johnson" <root@chaos.analogic.com>
Subject: Re: [PATCH] Warn people that ipchains and ipfwadm are going away.
Date: Wed, 22 Sep 2004 12:03:52 -0400 (EDT)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.53.0409221158410.575@chaos.analogic.com>
References: <1095721742.5886.128.camel@bach>
	<20040921143613.2dc78e2f.Ballarin.Marc@gmx.de>
	<1095803902.1942.211.camel@bach>
	<Pine.LNX.4.53.0409220735080.2066@chaos.analogic.com>
	<Pine.LNX.4.58.0409221347010.23967@tux.rsn.bth.se>
	<Pine.LNX.4.53.0409220800200.2147@chaos.analogic.com>
	<Pine.LNX.4.58.0409221110260.3523@sparrow>
Reply-To: root@chaos.analogic.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Rusty Russell <rusty@rustcorp.com.au>, Marc Ballarin <Ballarin.Marc@gmx.de>,
	ML-netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Linus Torvalds <torvalds@osdl.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: William Stearns <wstearns@pobox.com>
In-Reply-To: <Pine.LNX.4.58.0409221110260.3523@sparrow>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 22 Sep 2004, William Stearns wrote:

> Good day, all,
>
> On Wed, 22 Sep 2004, Richard B. Johnson wrote:
>
> > On Wed, 22 Sep 2004, Martin Josefsson wrote:
> >
> > > On Wed, 22 Sep 2004, Richard B. Johnson wrote:
> > >
> > > > What replaces the firewall stuff? It can't just "go away"!
> > >
> > > Ever heard of iptables?
> >
> > I guess I'll have to convert 1340 lines of ipchains commands to
> > iptables -yech!
>
> 	I have a script that does a first pass of converting an ipchains
> firewall script to an iptables firewall script at
>
> http://www.stearns.org/i2i/ipchains2iptables
> http://www.stearns.org/i2i/ipchains2iptables.README
>
> 	Because of architectural differences between the two firewall
> technologies it can't produce a perfect translation, but it does handle
> most of the grunt work.
> 	Cheers,
> 	- Bill

Thanks. I just wrote a 10-line 'C' program to do it. Just changes
"ipchains" to "iptables" and removes "-y". I had to add the
create command on the first line, simple. Thanks -all.

Cheers,
Dick Johnson
Penguin : Linux version 2.4.26 on an i686 machine (5570.56 BogoMips).
            Note 96.31% of all statistics are fiction.

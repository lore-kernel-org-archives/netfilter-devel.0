From: William Stearns <wstearns@pobox.com>
Subject: Re: [PATCH] Warn people that ipchains and ipfwadm are going away.
Date: Wed, 22 Sep 2004 12:27:59 -0400 (EDT)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0409221225550.3247@sparrow>
References: <1095721742.5886.128.camel@bach>
	<20040921143613.2dc78e2f.Ballarin.Marc@gmx.de>
	<1095803902.1942.211.camel@bach>
	<Pine.LNX.4.53.0409220735080.2066@chaos.analogic.com>
	<Pine.LNX.4.58.0409221347010.23967@tux.rsn.bth.se>
	<Pine.LNX.4.53.0409220800200.2147@chaos.analogic.com>
	<Pine.LNX.4.58.0409221110260.3523@sparrow>
	<Pine.LNX.4.53.0409221158410.575@chaos.analogic.com>
Reply-To: William Stearns <wstearns@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Martin Josefsson <gandalf@wlug.westbo.se>,
	William Stearns <wstearns@pobox.com>,
	ML-netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Richard B. Johnson" <root@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.53.0409221158410.575@chaos.analogic.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Good day, all,
	[CC list snipped]

> > > I guess I'll have to convert 1340 lines of ipchains commands to
> > > iptables -yech!
> >
> > 	I have a script that does a first pass of converting an ipchains
> > firewall script to an iptables firewall script at
> >
> > http://www.stearns.org/i2i/ipchains2iptables
> > http://www.stearns.org/i2i/ipchains2iptables.README
> >
> > 	Because of architectural differences between the two firewall
> > technologies it can't produce a perfect translation, but it does handle
> > most of the grunt work.
> 
> Thanks. I just wrote a 10-line 'C' program to do it. Just changes
> "ipchains" to "iptables" and removes "-y". I had to add the
> create command on the first line, simple. Thanks -all.

	If that works for you, great, but depending on your firewall 
structure there are more differences between the two than simply replacing 
ipchains with iptables.
	Cheers,
	- Bill

---------------------------------------------------------------------------
	"Decisive action in the hour of need
	denotes the hero but does not succeed."
	-- Marion D. Hutchins
(Courtesy of Kate Bates)
--------------------------------------------------------------------------
William Stearns (wstearns@pobox.com).  Mason, Buildkernel, freedups, p0f,
rsync-backup, ssh-keyinstall, dns-check, more at:   http://www.stearns.org
--------------------------------------------------------------------------

From: Willy Tarreau <willy@w.ods.org>
Subject: Re: NAT before IPsec with 2.6
Date: Wed, 28 Jan 2004 01:14:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040128001420.GA10121@alpha.home.local>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com> <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040127235525.GG11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
   Henrik Nordstrom <hno@marasystems.com>, Tom Eastep <teastep@shorewall.net>,
   Michal Ludvig <mludvig@suse.cz>, netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040127235525.GG11761@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 28, 2004 at 12:55:25AM +0100, Harald Welte wrote:
> Hi!
> 
> I've now hacked a preliminary patch.  Be warned, I didn't even test if
> it compiles.  Maybe someone who actually has a running 2.6.x ipsec setup
> can give it a try.

I have somewhere a working 2.6 ipsec backport to 2.4 thanks to Davem and
Herbert Xu. I'll see how it applies on it and if it works too, because
this is nearly the only thing refraining me from definitely switching over
this new stack. But don't expect any feedback before this week-end.

Thanks,
willy

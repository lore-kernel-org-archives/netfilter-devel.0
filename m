From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] aggressive early_drop and reserved conntrack entries
Date: Sat, 11 Dec 2004 17:56:28 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412111740420.16780@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0412090845060.11649@blackhole.kfki.hu>
	<20041209085249.GA22714@oknodo.bof.de>
	<Pine.LNX.4.58.0412091108420.11649@blackhole.kfki.hu>
	<Pine.LNX.4.58.0412102315110.15772@blackhole.kfki.hu>
	<1102772053.12078.40.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>,
	Grzegorz Piotr Jaskiewicz <gj@pointblue.com.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1102772053.12078.40.camel@tux.rsn.bth.se>
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

Hi Martin,

On Sat, 11 Dec 2004, Martin Josefsson wrote:

> > Attached (;-) is the new patch, which implements the list of unassured
> > connections. (Reserving conntracks is dropped completely as unnecessary.)
> > I tested it slighgtly and seems to work fine. What do you think about it?
>
> I've been thinking about this as well, but mostly I've been thinking
> about how to get it to scale when we go for more finegrained locking.
> The locking is going to be nasty.

It's already a little bit messy. I strongly believe, we must revise
reference counting in order to make locking more straightforward (and to
be able to introduce say per bucket locking at all). The
conntrack_arefcount patch tries to step ahead in that direction.

> Why not loop and kill multiple entries each time? Saves some locking and
> cache. But in order to do that in a good way wee need a counter of how
> many entries we have in the unassured list. But we don't want to kill
> too many each time, then almost no real connections will get through.

An atomic counter could help: this is just a proof of concept code :-)

> @@ -1107,6 +1117,10 @@
>  			add_timer(&ct->timeout);
>  		}
>  		ct_add_counters(ct, ctinfo, skb);
> +		if (set_assured) {
> +			set_bit(IPS_ASSURED_BIT, &ct->status);
> +			list_del(&ct->unassured);
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Huh? No check to see if we already are assured or not?
> Not needed for icmp, tcp or sctp but udp and the generic handler does.

Oops, absolutely correct, I tested the code with TCP only. Fortunately
it's easy to fix :-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary

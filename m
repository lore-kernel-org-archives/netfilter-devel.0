From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] aggressive early_drop and reserved conntrack entries
Date: Mon, 13 Dec 2004 14:25:47 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412131423340.18050@tux.rsn.bth.se>
References: <Pine.LNX.4.58.0412090845060.11649@blackhole.kfki.hu>
	<20041209085249.GA22714@oknodo.bof.de>
	<Pine.LNX.4.58.0412091108420.11649@blackhole.kfki.hu>
	<Pine.LNX.4.58.0412102315110.15772@blackhole.kfki.hu>
	<1102772053.12078.40.camel@tux.rsn.bth.se>
	<Pine.LNX.4.58.0412111740420.16780@blackhole.kfki.hu>
	<Pine.LNX.4.58.0412131310420.19191@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>,
	Grzegorz Piotr Jaskiewicz <gj@pointblue.com.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0412131310420.19191@blackhole.kfki.hu>
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

On Mon, 13 Dec 2004, Jozsef Kadlecsik wrote:

> > > Huh? No check to see if we already are assured or not?
> > > Not needed for icmp, tcp or sctp but udp and the generic handler does.
> >
> > Oops, absolutely correct, I tested the code with TCP only. Fortunately
> > it's easy to fix :-)
>
> Attached is the patch which takes into account that the assured bit might
> already be set (and thus we are on the unassured list).

I'll take this for a testdrive during a DoS on a testmachine here later
this evening. I doubt it makes any diffrence compared to the old one when
you have virtually no assured entries, just a truckload of unassured ones.
So it's a bit tricky to test in a lab, I need to set up that
sniffermachine on the real internet feed so I get a proper conntrack
table to test with.

/Martin

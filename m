From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] Warn people that ipchains and ipfwadm are going away.
Date: Wed, 22 Sep 2004 13:47:21 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0409221347010.23967@tux.rsn.bth.se>
References: <1095721742.5886.128.camel@bach>
	<20040921143613.2dc78e2f.Ballarin.Marc@gmx.de>
	<1095803902.1942.211.camel@bach>
	<Pine.LNX.4.53.0409220735080.2066@chaos.analogic.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Marc Ballarin <Ballarin.Marc@gmx.de>,
	Rusty Russell <rusty@rustcorp.com.au>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@osdl.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Richard B. Johnson" <root@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.53.0409220735080.2066@chaos.analogic.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 22 Sep 2004, Richard B. Johnson wrote:

> > Sure, but you have to start somewhere.  Next step will be #error.  Then
> > finally remove the whole thing (I don't want to remove the whole thing
> > to start with, since that would create a silent failure).
> >
> > Cheers,
> > Rusty.
> > --
>
> What replaces the firewall stuff? It can't just "go away"!

Ever heard of iptables?

/Martin

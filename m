From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] please kill santa-claus
Date: Sun, 9 Jul 2006 16:48:03 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0607091641180.11701@blackhole.kfki.hu>
References: <20060630153802.GA27351@phoenix.home.spootnik.org>
	<44ABDBB4.5010605@trash.net> <44ABDF70.2010705@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	Pierre-Yves Ritschard <pierre-yves@spootnik.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44ABDF70.2010705@netfilter.org>
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

On Wed, 5 Jul 2006, Pablo Neira Ayuso wrote:

> Patrick McHardy wrote:
> > Pierre-Yves Ritschard wrote:
> >
> >>While running our home-brewed firewall scripts the output was broken by
> >>a weird message spewed by the libipt_iprange extension:
> >>	"hoho" (sic)
> >>I wonder why that is, it seems not too many people noticed or use
> >>src-range inversion which is the feature that triggers this friendly yet
> >>surprising message.
> >>If there's a specific reason (which I haven't found in TFA or google)
> >>please let me know, otherwise please consider this one-liner:
> >>
> >>--- extensions/libipt_iprange.c.orig    Fri Jun 30 17:34:05 2006
> >>+++ extensions/libipt_iprange.c Fri Jun 30 17:34:21 2006
> >>@@ -73,7 +73,6 @@
> >>                check_inverse(optarg, &invert, &optind, 0);
> >>                if (invert) {
> >>                        info->flags |= IPRANGE_SRC_INV;
> >>-                       printf("hoho\n");
> >>                }
> >>                parse_iprange(optarg, &info->src);
> >
> >
> > LOL :) Applied, thanks.
>
> This is Jozsef's :D

Yes, that's from me: I'm surprised the (probably :-) debug message could
survive unnoticed so long.

The cryptic word means 'whoa!' approximately in Hungarian :-).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary

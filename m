From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Mon, 21 Jun 2004 15:32:22 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406211510550.31871-100000@blackhole.kfki.hu>
References: <40D6D8A7.4040809@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Martin Josefsson <gandalf@wlug.westbo.se>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Willy Tarreau <willy@w.ods.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40D6D8A7.4040809@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

On Mon, 21 Jun 2004, Pablo Neira wrote:

> >Let us be very careful here and not add half of the unclean match to
> >conntrack.
>
> thanks, it's always ok having someone who has the feet on the ground :-)

That sentence was in plural because it refers to me as well. :-)

> >I had already hesitated over the implications of the code
[...]
> >because it means that if a new ICMP code is introduced, even if we modify
> >the source code, all previously installed systems runnin netfilter
> >(estimate that number) would refuse to handle the new ICMP code: we
> >created a forward-incompatibility.
>
> that's true but, if that day comes, we can provide different ways to
> work around the problem:
>
> - The admin could disable dropping invalid ICMP.
> - We could use some some /proc stuff or implement custom options in
> iptables like:
> iptables setting strong-icmp-tracking on
> iptables setting strong-tcp-tracking off
> and so on. This way the admin could choose to use your current
> tcp-window-tracking or the old one which is softer.
> - We could use that NOTRACK target to untrack icmp packets which have
> those new codes, actually I don't love that target but it could be ok.

Probably the first one is just enough: if upgrade/recompiling is not an
option, the admin can anytime escape selected INVALID packets not to drop.

> And of course, document these issues: Let everyone know what conntrack
> is setting as INVALID. I'll be please to do that, even your
> tcp-window-tracking patch.

Documentation would be really, really great, as part of the iptables
manpage. Luckily it's already splitted up and handled by pom-ng.

> If you still consider that we can't provide any methods to work around
> to possible problem, I'll drop checkings and we could leave them in a
> patch in pom-ng as something optional.

OK, I'm convinced :-). Please send an updated patch, based on
conntrack_error-api/linux-2.6.patch_02-udp-icmp from cvs (there were some
modification in the patch by me and Martin).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary

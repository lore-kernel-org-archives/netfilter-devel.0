From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 4 May 2005 09:16:38 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0505040909090.18836@blackhole.kfki.hu>
References: <20050413152307.0312.LARK@linux.net.cn> <425CEFE3.2010200@rtij.nl>
	<20050413182822.0317.LARK@linux.net.cn> <425CFFE0.1000803@rtij.nl>
	<20050413112518.GB22865@oknodo.bof.de>
	<Pine.LNX.4.61.0504140315010.16405@filer.marasystems.com>
	<7174b1e40504140101b5138e0@mail.gmail.com>
	<425E3032.2060409@outerspace.dyndns.org>
	<Pine.LNX.4.61.0504141340130.28938@filer.marasystems.com>
	<425E6E4C.2010406@outerspace.dyndns.org>
	<42780DE4.9060808@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Ben La Monica <ben.lamonica@gmail.com>,
	Patrick Schaaf <bof@bof.de>, Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <42780DE4.9060808@outerspace.dyndns.org>
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

Hi,

On Tue, 3 May 2005, Jonas Berlin wrote:

> >>>All which is technically required for this while keeping full binary
> >>>copatibility is to modify non-terminal targets to register themselves as
> >>>matches in addition to targets.
> >
> > Does iptables have any requirement that matches have to be lowercase?
>
> It seemed not.

Technically there is no such requirement. In practice there is a strict
naming convention: matches are always lovercase while targets are always
uppercase. I object any proposal changing that.

> Alternative implementations:
>
> a) Do you think my idea of updating each potential target with match
> code is ok, or
>
> b) should maybe iptables automatically let one use any non-builtin
> target as a match directly, or
>
> c) same as b) but instead only let one use targets that have a special
> flag set in their ipt_target structure, or
>
> d) same as c) but instead add another struct ipt_match_target interface
> (and accompanying register_match_target()) that have modified function
> prototypes with only arguments common to both matches and targets..

What I can see as viable solution is a flag, which tells which targets may
be used in cascade and let make it possible to type

... -j LOG -j DROP

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary

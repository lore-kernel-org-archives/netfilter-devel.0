From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: About matching (also was: Multiple Targets)
Date: Thu, 14 Apr 2005 13:21:16 +0000
Message-ID: <425E6E4C.2010406@outerspace.dyndns.org>
References: <20050413152307.0312.LARK@linux.net.cn> <425CEFE3.2010200@rtij.nl>
	<20050413182822.0317.LARK@linux.net.cn> <425CFFE0.1000803@rtij.nl>
	<20050413112518.GB22865@oknodo.bof.de>
	<Pine.LNX.4.61.0504140315010.16405@filer.marasystems.com>
	<7174b1e40504140101b5138e0@mail.gmail.com>
	<425E3032.2060409@outerspace.dyndns.org>
	<Pine.LNX.4.61.0504141340130.28938@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Ben La Monica <ben.lamonica@gmail.com>,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0504141340130.28938@filer.marasystems.com>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Quoting Henrik Nordstrom on 2005-04-14 11:43 UTC:

> All which is technically required for this while keeping full binary
> copatibility is to modify non-terminal targets to register themselves as
> matches in addition to targets.

Ingenious! I didn't see this alternative evolution of Ben La Monica's
approach.

Does iptables have any requirement that matches have to be lowercase?

One thing that would not fall into this category is calling a subchain,
because the subchain can either be terminal or non-terminal. Thus, in
the light of not liking the -j RETURN --up N approach, I wonder if it
would be better to have a --return flag or similar to deprecate -j
RETURN so one can write -j SUBCHAIN --return .. I guess that would be
the only need for multi-targets after turning the non-terminal targets
into matches..

> The only thing holding this back is a conceptual design question if you
> should be allowed to mix non-terminal targets and matches freely, but
> this can be addressed in userspace if desired to force all non-terminal
> targets last in the match list.

I think the return values of targets used as matches should verified to
be IPT_CONTINUE (or whatever it was called) and syslog messages written
if that wasn't the case. In either case, the return value would not be
used for anything else..

> Having more than one terminal target is nonsense ihmo.

I agree.

I will be away until next Monday, but if you still haven't started
implementing this by then, I will probably give it a shot :) Otoh I
guess by then this already huge thread will be double the size that it
is now :)

Have a nice weekend,
- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCXm5KxyF48ZTvn+4RAuIjAJkB06iKB94pfgWov9YhlvU6bfAx5wCfVcnZ
b30ovalYYVqbdqfltKB0vP0=
=8NnI
-----END PGP SIGNATURE-----

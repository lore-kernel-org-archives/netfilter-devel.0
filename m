From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 5 Oct 2008 09:47:51 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810050925350.21891@fbirervta.pbzchgretzou.qr>
References: <48E8B439.6030608@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55775 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbYJENrx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 09:47:53 -0400
In-Reply-To: <48E8B439.6030608@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 08:34, Patrick McHardy wrote:

> We've talked about reorganizing net/netfilter in a smaller group
> during the workshop. Its currently quite crowded in there,
> additionally the IPVS guys are moving their code under
> net/netfilter/ipvs in 2.6.28.
>
> Some suggestions for a new directory structure:
>
> net/netfilter/xtables
> net/netfilter/{ct, conntrack, nfct, ...}
> net/netfilter/nftables for my new stuff

Yes definitely welcomed.

> We could go further by splitting up xtables and conntrack,

That's just what you proposed! Or at least that is what I think of
Netfilter. Xtables and Conntrack are already separated, simply
because each one can be used without the other. (Minus things like
xt_conntrack, which I think belong to Xtables.)

> parts of this structure would be mirrored in net/ipv4/netfilter
> and net/ipv6/netfilter:
>
> net/netfilter/xtables/matches
> net/netfilter/xtables/targets
> net/netfilter/ct/protocols
> net/netfilter/ct/helpers
>
> I'm not sure whether this is too much since 4 directory
> levels seem a bit extreme.

If you take that structure _and_ mirror it in ipv4, you get:
net/ipv4/netfilter/xtables/matches/ which is already 5 :-)

> Since the amount of core code is increasing too, one more
> thought was
>
> net/netfilter/core
>
> containing core.c, netfilter.c, logging and queuing stuff and
> everything netlink related that doesn't fall in a more specific
> area.

I think the core stuff can remain in net/netfilter/. Not because
it is growing, but because other subsystems do just that.
Like, there is fs/ (with the core code) and fs/<component>/ for
anything not-so-core-y.

What I really certainly would like to see is that we somehow get rid
of the oddness of naming L3 trackers and L4 trackers. Right now we
have (two examples)

-rw-r--r-- 1 15924 2008-09-09 20:34 nf_conntrack_ftp.c
-rw-r--r-- 1 43369 2008-09-09 20:33 nf_conntrack_proto_tcp.c

and in everybody's mind, FTP is a protocol too of course, =E2=80=9Cso w=
hy
does not ftp have a _proto part, and why does TCP?=E2=80=9D one might a=
sk.
We could just remove the _proto part (also helpful to reduce the
name length), as there is no clash between L3 and L4 trackers
except perhaps for proto_generic and l3proto_generic. Hm?

One thing I have done in my git realms is just call my branches
"nfct_foo" simply because I was too lazy to type "nf_conntrack_foo".
Maybe we could do the same for our files? Maybe we can even get rid
of the nf_conntrack_/nfct_ prefix at all when they are moved into
net/netfilter/conntrack/, but still have it in their .ko files. IOW:
net/netfilter/conntrack/ftp.c produces
net/netfilter/conntrack/nfct_ftp.ko. How about it?

core.c (remains)
nf_conntrack_acct.c            -> conntrack/acct.c    =20
nf_conntrack_amanda.c          -> conntrack/amanda.c
nf_conntrack_core.c            -> conntrack/core.c
=2E..
nf_log.c (remains)
nfnetlink.c (remains)
nfnetlink_log.c (remains)
nfnetlink_queue.c (...)
nf_queue.c
nf_sockopt.c
x_tables.c              -> xtables/x_tables.c
xt_CLASSIFY.c           -> xtables/CLASSIFY.c (or just keep xt_ prefix?=
)
xt_comment.c            -> ...
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

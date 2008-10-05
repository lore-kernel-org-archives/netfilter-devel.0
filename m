From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 05 Oct 2008 16:02:53 +0200
Message-ID: <48E8C90D.10202@trash.net>
References: <48E8B439.6030608@trash.net> <alpine.LNX.1.10.0810050925350.21891@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45464 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbYJEOC7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 10:02:59 -0400
In-Reply-To: <alpine.LNX.1.10.0810050925350.21891@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2008-10-05 08:34, Patrick McHardy wrote:
>=20
>> Some suggestions for a new directory structure:
>>
>> net/netfilter/xtables
>> net/netfilter/{ct, conntrack, nfct, ...}
>> net/netfilter/nftables for my new stuff
>=20
> Yes definitely welcomed.
>=20
>> We could go further by splitting up xtables and conntrack,
>=20
> That's just what you proposed! Or at least that is what I think of
> Netfilter. Xtables and Conntrack are already separated, simply
> because each one can be used without the other. (Minus things like
> xt_conntrack, which I think belong to Xtables.)

Yes, confusing wording. I meant splitting them up internally,
i.e. xtables =3D> matches/targets etc, as described below. And
its only about the directory structure of course, how things
work together at runtime remains the same.

>> Since the amount of core code is increasing too, one more
>> thought was
>>
>> net/netfilter/core
>>
>> containing core.c, netfilter.c, logging and queuing stuff and
>> everything netlink related that doesn't fall in a more specific
>> area.
>=20
> I think the core stuff can remain in net/netfilter/. Not because
> it is growing, but because other subsystems do just that.
> Like, there is fs/ (with the core code) and fs/<component>/ for
> anything not-so-core-y.

I agree that its more logical to keep the core stuff at the
netfilter root.

> What I really certainly would like to see is that we somehow get rid
> of the oddness of naming L3 trackers and L4 trackers. Right now we
> have (two examples)
>=20
> -rw-r--r-- 1 15924 2008-09-09 20:34 nf_conntrack_ftp.c
> -rw-r--r-- 1 43369 2008-09-09 20:33 nf_conntrack_proto_tcp.c
>=20
> and in everybody's mind, FTP is a protocol too of course, =E2=80=9Cso=
 why
> does not ftp have a _proto part, and why does TCP?=E2=80=9D one might=
 ask.
> We could just remove the _proto part (also helpful to reduce the
> name length), as there is no clash between L3 and L4 trackers
> except perhaps for proto_generic and l3proto_generic. Hm?

Agreed, this is a good opportunity to fix that as well.
The _proto prefix becomes redundant if we use

net/netfilter/ct/protocols

anyway.

> One thing I have done in my git realms is just call my branches
> "nfct_foo" simply because I was too lazy to type "nf_conntrack_foo".
> Maybe we could do the same for our files? Maybe we can even get rid
> of the nf_conntrack_/nfct_ prefix at all when they are moved into
> net/netfilter/conntrack/, but still have it in their .ko files. IOW:
> net/netfilter/conntrack/ftp.c produces
> net/netfilter/conntrack/nfct_ftp.ko. How about it?

Its a quite verbose naming scheme currently, I agree. I like
some common prefixes for related things, even if slightly
redundant, but using nfct_ instead of nf_conntrack_ sounds
fine to me.

> core.c (remains)
> nf_conntrack_acct.c            -> conntrack/acct.c    =20
> nf_conntrack_amanda.c          -> conntrack/amanda.c
> nf_conntrack_core.c            -> conntrack/core.c
> ...
> nf_log.c (remains)
> nfnetlink.c (remains)
> nfnetlink_log.c (remains)
> nfnetlink_queue.c (...)
> nf_queue.c
> nf_sockopt.c
> x_tables.c              -> xtables/x_tables.c
> xt_CLASSIFY.c           -> xtables/CLASSIFY.c (or just keep xt_ prefi=
x?)
> xt_comment.c            -> ...


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

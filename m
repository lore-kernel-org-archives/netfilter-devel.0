From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 05 Oct 2008 16:48:36 +0200
Message-ID: <48E8D3C4.60306@trash.net>
References: <48E8B439.6030608@trash.net> <alpine.LNX.1.10.0810050925350.21891@fbirervta.pbzchgretzou.qr> <48E8C90D.10202@trash.net> <alpine.LNX.1.10.0810051004230.21891@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46394 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbYJEOsm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 10:48:42 -0400
In-Reply-To: <alpine.LNX.1.10.0810051004230.21891@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2008-10-05 10:02, Patrick McHardy wrote:
>> Yes, confusing wording. I meant splitting them up internally,
>> i.e. xtables =3D> matches/targets etc, as described below. And
>> its only about the directory structure of course, how things
>> work together at runtime remains the same.
>=20
> I would not want to split matches and targets. Yes I am aware that we
> have these guys wanting to store it on case-ignorant filesystems, but
> we would still have all the include files in a conflicting position.
>=20
> net/netfilter/xtables/matches is already over my personal
> preferred limit of 3. If at all, I think they should get
> {pre|post}fixed =C3=A0 la tg_connmark.c (target) and mt_connmark.c (o=
r
> connmark_{tg,mt}.c, whichever makes 'em happy).

Yes, its probably going overboard in case of xtables. For conntrack
helpers and l4 protocols I'm not sure yet. I'll probably just give
it a try without the 4 levels and see how it turns out.

> Also the idea of merging files for the benefit of reduces in-memory
> size was floating. I have revisited the koredux branch since you said
> on-disk size ain't important, so the exact _memory_ statistic is:

Well, not completely unimportant for some people, but its not
really my main concern since in those cases people tend not to
use modules anyway.

> One extension per module:
>=20
> Single blob:
> 	Module                  Size  Used by
> 	xtables_ext            94312  0 (on-disk size 160K)
>=20
> All blobs that xtables_ext encompasses:
> 	Module                  Size  Used by
>	[...]
> 	total                 165992  (on disk about 1037K)
>=20
> That's a 43% reduction in memory.

Its a clear benefit, I don't doubt that. I mainly think this is not
netfilter specific at all and should be done on a kbuild level.

Linking all of them together also has some runtime impact because
of symbol dependencies, using let say tcpudp will probably pull
in (parts of) IPv6 and NAT. Having them grouped by dependencies
would avoid this.

>>> -rw-r--r-- 1 15924 2008-09-09 20:34 nf_conntrack_ftp.c
>>> -rw-r--r-- 1 43369 2008-09-09 20:33 nf_conntrack_proto_tcp.c
>>>
>>> and in everybody's mind, FTP is a protocol too of course, =E2=80=9C=
so why
>>> does not ftp have a _proto part, and why does TCP?=E2=80=9D one mig=
ht ask.
>>> We could just remove the _proto part (also helpful to reduce the
>>> name length), as there is no clash between L3 and L4 trackers
>>> except perhaps for proto_generic and l3proto_generic. Hm?
>> Agreed, this is a good opportunity to fix that as well.
>> The _proto prefix becomes redundant if we use
>>
>> net/netfilter/ct/protocols
>>
>> anyway.
>=20
> It does not really solve anything IMHO. Protocols? FTP is one, so hm,
> same confusion. This also got my anti-favorite 4-depth :)

Well, its not *that much* confusing since I believe most people are
aware of that part of the netfilter terminology. The main goal is
to get the directory contents to a more reasonable level and group
related stuff together; using just net/netfilter/ct is still a bit
too coarse in my opinion. Under that aspect, what would your proposed
structure be?

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

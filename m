From: Patrick McHardy <kaber@trash.net>
Subject: Re: libiptc, arptables, ebtables plans or so - and header files
Date: Mon, 10 Nov 2008 19:07:30 +0100
Message-ID: <49187862.50306@trash.net>
References: <alpine.LNX.1.10.0811101726310.23956@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56134 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502AbYKJSHn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:07:43 -0500
In-Reply-To: <alpine.LNX.1.10.0811101726310.23956@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hi Patrick and list,
>=20
>=20
> when Adam sent his xt_LED, I noticed that he avoided to create an=20
> xt_LED.h and instead had the definition of the blob structs directly =
in=20
> xt_LED.c and libxt_LED.c. It occurred to me that this has some=20
> implications.
>=20
> Theoretically, we could kill all {ipt,ip6t,xt}_*.h files in=20
> <kernel>/include/linux/netfilter*/ -- since userspace, usually only=20
> iptables, does not make use of them anyway, but has its own copies.
>=20
> Yes, for simplicity, we let unifdef run over these headers before=20
> copying them, but then again, when was the last time you had __KERNEL=
__=20
> in xt_*.h?
>=20
> I really doubt there are any other userspace programs of these=20
> files at this time. As I see it, these header files make only sense=20
> when you are crafting blobs when interacting with libiptc. I am not=20
> aware of any program making such extensive use of libiptc, probably d=
ue=20
> to libiptc having been very closely kept in the iptables garden.
>=20
> I would be tempted to suggest their removal from=20
> <kernel>/include/linux/ and moving them into the code.
>=20
> However... realistically you would need those files if you ever wante=
d=20
> to interpret the blob when dealing with iptc.
>=20
> Giving this some consideration, perhaps these header files should be=20
> made available through iptables/a separate libiptc(-devel) package=20
> instead of the kernel.

About moving the definitions - I don't see what this would buy us.
Besides that, the kernel defines these structures, so they really
belong there.

> All these philosophical questions lead to the question what should be=
=20
> done about libiptc itself. It only looks bad because of the macro=20
> substitution that is applied to produce a libip6tc... and this sort o=
f=20
> thing cannot really be resolved I figured. As in, using VFT tables to=
=20
> dispatch for a given NFPROTO to get rid of the macro constructs is no=
t=20
> going to buy us anything - the code is so identical, it's really beca=
use=20
> of miniscule differences between struct ipt_{internal_stuff} and stru=
ct=20
> ip6t_{internal_stuff} that seem to make this an impossible undertakin=
g.=20
> Is it actually worth working on it?

Without having looked at it in much detail, I think it should
be pretty easy to define per-family functions to fill the
ipt_entry/ip6t_entry structs and a struct to describe the
length and offset differences. The remaining parts are invariant
across families, so the code should be easily unifiable.

> I have stopped my efforts to push arptables into iptables because=20
> eventually I would have come to think about getting libiptc and libar=
ptc=20
> together, and I practically just did that with iptc and ip6tc (see=20
> previous paragraph). Yeah I see it's SNAFU.
>=20
> Possible exit? Clone iptables/libiptc/sonstwastables yet again into =E2=
=80=94=20
> this time =E2=80=94 an nfproto-agnostic table structure, but keep mos=
t other=20
> pieces. No sample code yet, because I usually try to ask before going=
 on=20
> tasks like these.
>=20
> Comments?

I think the best way is to abstract the very minor differences
using an af-specific callback for *_entry and some length information.
But I'm not familiar with libarptc, so this might not be enough.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

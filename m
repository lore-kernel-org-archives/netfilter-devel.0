From: Jan Engelhardt <jengelh@medozas.de>
Subject: libiptc, arptables, ebtables plans or so - and header files
Date: Mon, 10 Nov 2008 17:48:16 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811101726310.23956@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38890 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYKJQsS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:48:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick and list,


when Adam sent his xt_LED, I noticed that he avoided to create an=20
xt_LED.h and instead had the definition of the blob structs directly in=
=20
xt_LED.c and libxt_LED.c. It occurred to me that this has some=20
implications.

Theoretically, we could kill all {ipt,ip6t,xt}_*.h files in=20
<kernel>/include/linux/netfilter*/ -- since userspace, usually only=20
iptables, does not make use of them anyway, but has its own copies.

Yes, for simplicity, we let unifdef run over these headers before=20
copying them, but then again, when was the last time you had __KERNEL__=
=20
in xt_*.h?

I really doubt there are any other userspace programs of these=20
files at this time. As I see it, these header files make only sense=20
when you are crafting blobs when interacting with libiptc. I am not=20
aware of any program making such extensive use of libiptc, probably due=
=20
to libiptc having been very closely kept in the iptables garden.

I would be tempted to suggest their removal from=20
<kernel>/include/linux/ and moving them into the code.

However... realistically you would need those files if you ever wanted=20
to interpret the blob when dealing with iptc.

Giving this some consideration, perhaps these header files should be=20
made available through iptables/a separate libiptc(-devel) package=20
instead of the kernel.

All these philosophical questions lead to the question what should be=20
done about libiptc itself. It only looks bad because of the macro=20
substitution that is applied to produce a libip6tc... and this sort of=20
thing cannot really be resolved I figured. As in, using VFT tables to=20
dispatch for a given NFPROTO to get rid of the macro constructs is not=20
going to buy us anything - the code is so identical, it's really becaus=
e=20
of miniscule differences between struct ipt_{internal_stuff} and struct=
=20
ip6t_{internal_stuff} that seem to make this an impossible undertaking.=
=20
Is it actually worth working on it?

I have stopped my efforts to push arptables into iptables because=20
eventually I would have come to think about getting libiptc and libarpt=
c=20
together, and I practically just did that with iptc and ip6tc (see=20
previous paragraph). Yeah I see it's SNAFU.

Possible exit? Clone iptables/libiptc/sonstwastables yet again into=C2=A0=
=E2=80=94=20
this time=C2=A0=E2=80=94 an nfproto-agnostic table structure, but keep =
most other=20
pieces. No sample code yet, because I usually try to ask before going o=
n=20
tasks like these.

Comments?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

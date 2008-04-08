From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: 0/8 Netfilter patches (group 2)
Date: Tue, 8 Apr 2008 18:21:02 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804081814580.2229@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804081803370.2229@fbirervta.pbzchgretzou.qr> <47FB99CA.5060002@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50974 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbYDHQVD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:21:03 -0400
In-Reply-To: <47FB99CA.5060002@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-04-08 18:14, Patrick McHardy wrote:
>
> Small suggestion for improvement (don't worry, your series
> is fine :)): the best ordering for all these patches would
> have been:
>
> Set 1: boolean conversions
> Set 2: length match (shouldn't have dependencies)
> Set 3: recent match (also shouldn't have dependencies)
> Set 4: prefix table
> Set 5: TCPMSS target
> Set 6: ARP-tables patches

You would not believe it, but it was set-ordered.
YMMV what makes up a set, though.

(reverse order as git-forest and gitk do)

Group 7: independent things (i think you have b8a already)
Depends on: Nothing.

=E2=95=9F [NETFILTER]: nf_nat: autoload IPv4 connection tracking=E2=94=80=
=E2=94=80(b8a26c9)
=E2=95=9F [NETFILTER]: Deploy a prefix_length-to-network mask mapping t=
able=E2=94=80=E2=94=80(f6984b5)
=E2=95=9F [NETFILTER]: Collapse tcpmss_reverse_mtu{4,6} into one functi=
on=E2=94=80=E2=94=80(b98252d)

Group 6: Ebtables.
Depends on: Nothing.

=E2=95=9F [NETFILTER]: Make Ebtables use Xtables infrastructure=E2=94=80=
=E2=94=80(00e0636)

Group 5: Arptables.
Depends on Group 4.

=E2=95=9F [NETFILTER]: Give AF-independent extensions an arpt_ alias=E2=
=94=80=E2=94=80(2974d08)

Group 4: Xtables basement.
Depends on: Nothing.

=E2=95=9F [NETFILTER]: Implement AF_UNSPEC as a wildcard for extensions=
=E2=94=80=E2=94=80(cd37935)
=E2=95=9F [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign a non-cl=
ashing value=E2=94=80=E2=94=80(2a

Group 3: xt_recent.
Depends on: Nothing.

=E2=95=9F [NETFILTER]: xt_recent: IPv6 support=E2=94=80=E2=94=80(e6fb81=
7)
=E2=95=9F [NETFILTER]: Rename ipt_recent to xt_recent=E2=94=80=E2=94=80=
(5130e28)

Group 2: xt_length.
Depends on: Nothing.

=E2=95=9F [NETFILTER]: xt_length match, revision 1=E2=94=80=E2=94=80(9e=
46f22)

Group 1: Bools, Consts, Cleanups.
Depends on: Nothing.

=E2=95=9F [NETFILTER]: Replace NF_CT_DUMP_TUPLE macro indrection by fun=
ction call=E2=94=80=E2=94=80(f73c
=E2=95=9F [NETFILTER]: const annotations in nf_conntrack_{sctp,dccp}, n=
f_nat_proto_gre=E2=94=80=E2=94=80
=E2=95=9F [NETFILTER]: Use bool type in nf_nat_proto=E2=94=80=E2=94=80(=
2c53bda)
=E2=95=9F [NETFILTER]: Use bool type in struct nf_conntrack_tuple.h=E2=94=
=80=E2=94=80(aca885c)
=E2=95=9F [NETFILTER]: Use unsigned types for hooknum and pf vars=E2=94=
=80=E2=94=80(91d8746)
=E2=95=9F [NETFILTER]: Use bool type in struct nf_conntrack_l4proto=E2=94=
=80=E2=94=80(37930da)
=E2=95=9F [NETFILTER]: Use bool type in struct nf_conntrack_l3proto=E2=94=
=80=E2=94=80(67629b2)


> This way each logical set of changes can be discussed
> seperately. I'd also send things that need additional
> userspace-patches (like length) as kernel patch 1-n +
> iptables patch 1-n, but closely together.
>
Invent house numbering?

 [patch 12/xx] xt_length
 [patch 12a/xx] xt_length userspace
 [patch 13/xx] xt_foobar (kernel only thing)
 [patch 14/xx] xt_bazzzz
 [patch 14a/xx] ..

don't think git likes that :p
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

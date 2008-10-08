From: Patrick McHardy <kaber@trash.net>
Subject: Re: Expectation not quite up to where I want it
Date: Wed, 08 Oct 2008 15:07:26 +0200
Message-ID: <48ECB08E.5070909@trash.net>
References: <alpine.LNX.1.10.0810041816150.21891@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49826 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYJHNH2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 09:07:28 -0400
In-Reply-To: <alpine.LNX.1.10.0810041816150.21891@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
>=20
> I am not quite sure whether it is possible to even set up an
> expectation when ctstate(ct) =3D=3D IP_CT_NEW, is it?=20

It is - TFTP, SIP and netbios_ns are doing this.

> Fact is, this piece
> of code segfaults on me right away in nf_ct_expect_related(),
> possibly because exp->master or so is NULL, causing bad things when
> issuing nfct_help(exp->master) in nf_ct_expect_related.
> Any hints?
>=20
>     =E2=86=92   nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, PF=
_INET6,=20
>     =E2=86=92       =E2=86=92   (const union nf_inet_addr *)&iph->dad=
dr,=20
>     =E2=86=92       =E2=86=92   (const union nf_inet_addr *)&iph->sad=
dr,=20
>     =E2=86=92       =E2=86=92   IPPROTO_MH, NULL, &man);=20
>     =E2=86=92   printk(KERN_INFO "expectation set up\n");=20
>     =E2=86=92   nf_ct_dump_tuple(&exp->tuple);=20
>     =E2=86=92   if (nf_ct_expect_related(exp) !=3D 0)=20
>     =E2=86=92       =E2=86=92   printk(KERN_INFO "hm\n");=20
>     =E2=86=92   nf_ct_expect_put(exp); /* yes no ? /=20

                                     ^ yes

The part above is correct, the bug must be elsewhere.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

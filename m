From: "Anders K. Pedersen" <akp@akp.dk>
Subject: Re: nftables: Dynamically updating sets gives syntax error
Date: Wed, 13 Jul 2016 09:14:32 +0200
Message-ID: <1468394072.20551.169.camel@akp.dk>
References: <1466861422.29189.75.camel@akp.dk>
 <1467468776.1011.14.camel@akp.dk> <20160712152207.GA2275@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 85.204.120.79.ip4.gigabit.dk ([85.204.120.79]:49161 "EHLO
	mail.kbh.akp.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbcGMHOu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jul 2016 03:14:50 -0400
In-Reply-To: <20160712152207.GA2275@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On tir, 2016-07-12 at 17:22 +0200, Pablo Neira Ayuso wrote:
> On Sat, Jul 02, 2016 at 04:12:56PM +0200, Anders K. Pedersen wrote:
> > Hello,
> >=20
> > On l=C3=B8r, 2016-06-25 at 15:30 +0200, Anders K. Pedersen wrote:
> > > With nftables 0.6 I'm getting a syntax error, when I try to use
> > > the
> > > feature that was introduced
> > > by=C2=A0http://git.netfilter.org/nftables/commit
> > > /?id=3Da9467e55973b10c2e8fe37525514c961580f8506=C2=A0. For exampl=
e:
> > >=20
> > > # nft filter input set add tcp dport @myset
> > > <cmdline>:1:26-30: Error: syntax error, unexpected dport
> > > filter input set add tcp dport @myset
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0^^^^^
> > > # nft filter input set add ip saddr timeout 10s @myset
> > > <cmdline>:1:25-29: Error: syntax error, unexpected saddr
> > > filter input set add ip saddr timeout 10s @myset
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0^^^^^
> > > # nft filter input set update ip saddr timeout 10s @myset
> > > <cmdline>:1:28-32: Error: syntax error, unexpected saddr
> > > filter input set update ip saddr timeout 10s @myset
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0^^^^^
> >=20
> > I did a git bisect on this and found that it was broken by
> >=20
> > commit a3e60492a684be09374d0649735da42bdadc6b48
> > Author: Pablo Neira Ayuso <pablo@netfilter.org>
> > Date:=C2=A0=C2=A0=C2=A0Sun Dec 27 22:15:17 2015 +0100
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0parser: restrict relational rhs expression =
recursion
> >=20
> > After studying it a bit I reverted a part of it with the following
> > change, which made the commands above work again:
> >=20
> > --- a/src/parser_bison.y
> > +++ b/src/parser_bison.y
> > @@ -2054,7 +2054,7 @@ set_elem_option		:	TIMEO
> > UT			time_spec
> > =C2=A0			}
> > =C2=A0			;
> > =C2=A0
> > -set_lhs_expr		:	concat_rhs_expr
> > +set_lhs_expr		:	concat_expr
> > =C2=A0			|	multiton_rhs_expr
> > =C2=A0			;
> > =C2=A0
> > The commit message indicated that it intended to handle rhs
> > expressions, but this is a lhs expression, so maybe this change was
> > unintended?
>=20
> Thanks for reporting. This results however in shift/reduce conflicts
> in the grammar, just sent patches to address this:
>=20
> http://patchwork.ozlabs.org/patch/647448/
> http://patchwork.ozlabs.org/patch/647447/
>=20
> Please, test and let me know if this works for you. Thanks.

I applied these patches on top of current nftables git, and tested that
they solve the problem. Thanks for fixing this.

Regards,
Anders K. Pedersen
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

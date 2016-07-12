From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables: Dynamically updating sets gives syntax error
Date: Tue, 12 Jul 2016 17:22:07 +0200
Message-ID: <20160712152207.GA2275@salvia>
References: <1466861422.29189.75.camel@akp.dk>
 <1467468776.1011.14.camel@akp.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: "Anders K. Pedersen" <akp@akp.dk>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467468776.1011.14.camel@akp.dk>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, Jul 02, 2016 at 04:12:56PM +0200, Anders K. Pedersen wrote:
> Hello,
>=20
> On l=F8r, 2016-06-25 at 15:30 +0200, Anders K. Pedersen wrote:
> > With nftables 0.6 I'm getting a syntax error, when I try to use the
> > feature that was introduced
> > by=A0http://git.netfilter.org/nftables/commit
> > /?id=3Da9467e55973b10c2e8fe37525514c961580f8506=A0. For example:
> >=20
> > # nft filter input set add tcp dport @myset
> > <cmdline>:1:26-30: Error: syntax error, unexpected dport
> > filter input set add tcp dport @myset
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0^^^^^
> > # nft filter input set add ip saddr timeout 10s @myset
> > <cmdline>:1:25-29: Error: syntax error, unexpected saddr
> > filter input set add ip saddr timeout 10s @myset
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0^^^^^
> > # nft filter input set update ip saddr timeout 10s @myset
> > <cmdline>:1:28-32: Error: syntax error, unexpected saddr
> > filter input set update ip saddr timeout 10s @myset
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0^^^^^
>=20
> I did a git bisect on this and found that it was broken by
>=20
> commit a3e60492a684be09374d0649735da42bdadc6b48
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:=A0=A0=A0Sun Dec 27 22:15:17 2015 +0100
>=20
> =A0=A0=A0=A0parser: restrict relational rhs expression recursion
>=20
> After studying it a bit I reverted a part of it with the following
> change, which made the commands above work again:
>=20
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -2054,7 +2054,7 @@ set_elem_option		:	TIMEOUT			time_spec
> =A0			}
> =A0			;
> =A0
> -set_lhs_expr		:	concat_rhs_expr
> +set_lhs_expr		:	concat_expr
> =A0			|	multiton_rhs_expr
> =A0			;
> =A0
> The commit message indicated that it intended to handle rhs
> expressions, but this is a lhs expression, so maybe this change was
> unintended?

Thanks for reporting. This results however in shift/reduce conflicts
in the grammar, just sent patches to address this:

http://patchwork.ozlabs.org/patch/647448/
http://patchwork.ozlabs.org/patch/647447/

Please, test and let me know if this works for you. Thanks.

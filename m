From: "Anders K. Pedersen" <akp@akp.dk>
Subject: Re: nftables: Dynamically updating sets gives syntax error
Date: Sat, 02 Jul 2016 16:12:56 +0200
Message-ID: <1467468776.1011.14.camel@akp.dk>
References: <1466861422.29189.75.camel@akp.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <1466861422.29189.75.camel@akp.dk>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

On l=C3=B8r, 2016-06-25 at 15:30 +0200, Anders K. Pedersen wrote:
> With nftables 0.6 I'm getting a syntax error, when I try to use the
> feature that was introduced
> by=C2=A0http://git.netfilter.org/nftables/commit
> /?id=3Da9467e55973b10c2e8fe37525514c961580f8506=C2=A0. For example:
>=20
> # nft filter input set add tcp dport @myset
> <cmdline>:1:26-30: Error: syntax error, unexpected dport
> filter input set add tcp dport @myset
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0^^^^^
> # nft filter input set add ip saddr timeout 10s @myset
> <cmdline>:1:25-29: Error: syntax error, unexpected saddr
> filter input set add ip saddr timeout 10s @myset
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0^^^^^
> # nft filter input set update ip saddr timeout 10s @myset
> <cmdline>:1:28-32: Error: syntax error, unexpected saddr
> filter input set update ip saddr timeout 10s @myset
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0^^^^^

I did a git bisect on this and found that it was broken by

commit a3e60492a684be09374d0649735da42bdadc6b48
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:=C2=A0=C2=A0=C2=A0Sun Dec 27 22:15:17 2015 +0100

=C2=A0=C2=A0=C2=A0=C2=A0parser: restrict relational rhs expression recu=
rsion

After studying it a bit I reverted a part of it with the following
change, which made the commands above work again:

--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2054,7 +2054,7 @@ set_elem_option		:	TIMEOUT			time_spec
=C2=A0			}
=C2=A0			;
=C2=A0
-set_lhs_expr		:	concat_rhs_expr
+set_lhs_expr		:	concat_expr
=C2=A0			|	multiton_rhs_expr
=C2=A0			;
=C2=A0
The commit message indicated that it intended to handle rhs
expressions, but this is a lhs expression, so maybe this change was
unintended?

Regards,
Anders K. Pedersen

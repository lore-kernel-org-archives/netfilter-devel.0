From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft] segfault, bitmask datatype without parse() function
Date: Tue, 25 Nov 2014 16:43:41 +0100
Message-ID: <20141125154341.GA3579@salvia>
References: <CAOkSjBhYt+tnDo7vP=bz5hP37cePGxvW2TApPtbXdA0FKkx9dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41002 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaKYPlh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:41:37 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBhYt+tnDo7vP=bz5hP37cePGxvW2TApPtbXdA0FKkx9dg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 25, 2014 at 01:53:20PM +0100, Arturo Borrero Gonzalez wrote=
:
> Hi,
>=20
> It seems there is a segfault in nft.
>=20
> How to reproduce:
>=20
> % nft add rule inet filter ct state established,related accept

Where is the chain there?

I think this crash happens in an error path.

> =3D=3D28442=3D=3D Jump to the invalid address stated on the next line
> =3D=3D28442=3D=3D    at 0x0: ???
> =3D=3D28442=3D=3D    by 0x4099EA: symbolic_constant_parse (datatype.c=
:133)
> =3D=3D28442=3D=3D    by 0x40BFD8: expr_evaluate (evaluate.c:199)
> =3D=3D28442=3D=3D    by 0x40D524: list_member_evaluate (evaluate.c:59=
7)
> =3D=3D28442=3D=3D    by 0x40C25B: expr_evaluate (evaluate.c:649)
> =3D=3D28442=3D=3D    by 0x40C103: expr_evaluate (evaluate.c:879)
> =3D=3D28442=3D=3D    by 0x40D908: stmt_evaluate (evaluate.c:1103)
> =3D=3D28442=3D=3D    by 0x40DF27: rule_evaluate (evaluate.c:1727)
> =3D=3D28442=3D=3D    by 0x40E0A6: chain_evaluate (evaluate.c:1788)
> =3D=3D28442=3D=3D    by 0x40E4CE: cmd_evaluate (evaluate.c:1807)
> =3D=3D28442=3D=3D    by 0x423757: nft_parse (parser_bison.y:549)
> =3D=3D28442=3D=3D    by 0x4061CC: nft_run (main.c:231)
> =3D=3D28442=3D=3D  Address 0x0 is not stack'd, malloc'd or (recently)=
 free'd
> =3D=3D28442=3D=3D
> =3D=3D28442=3D=3D
> =3D=3D28442=3D=3D Process terminating with default action of signal 1=
1 (SIGSEGV)
> =3D=3D28442=3D=3D  Bad permissions for mapped region at address 0x0
> =3D=3D28442=3D=3D    at 0x0: ???
> =3D=3D28442=3D=3D    by 0x4099EA: symbolic_constant_parse (datatype.c=
:133)
> =3D=3D28442=3D=3D    by 0x40BFD8: expr_evaluate (evaluate.c:199)
> =3D=3D28442=3D=3D    by 0x40D524: list_member_evaluate (evaluate.c:59=
7)
> =3D=3D28442=3D=3D    by 0x40C25B: expr_evaluate (evaluate.c:649)
> =3D=3D28442=3D=3D    by 0x40C103: expr_evaluate (evaluate.c:879)
> =3D=3D28442=3D=3D    by 0x40D908: stmt_evaluate (evaluate.c:1103)
> =3D=3D28442=3D=3D    by 0x40DF27: rule_evaluate (evaluate.c:1727)
> =3D=3D28442=3D=3D    by 0x40E0A6: chain_evaluate (evaluate.c:1788)
> =3D=3D28442=3D=3D    by 0x40E4CE: cmd_evaluate (evaluate.c:1807)
> =3D=3D28442=3D=3D    by 0x423757: nft_parse (parser_bison.y:549)
> =3D=3D28442=3D=3D    by 0x4061CC: nft_run (main.c:231)
> =3D=3D28442=3D=3D
>=20
> As far as I've investigated, it seems the bitmask datatype is missing
> somehow the parse() function.
>=20
> My HEAD is cf1e7d4 (netlink: don't bug on unknown events).
>
>=20
> regards.
>=20
> --=20
> Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

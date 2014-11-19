From: Giorgio <giorgio.nicole@arcor.de>
Subject: Re: nftables error compile current git
Date: Wed, 19 Nov 2014 21:33:18 +0100
Message-ID: <546CFE8E.7070806@arcor.de>
References: <DUB126-W257DF7FB1DCA4D59818B22B2890@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="HFmrhtUGgj8Ato651kjJcp6h3UbdMbWwu"
Cc: netfilter-devel@vger.kernel.org
To: Marco Berizzi <pupilla@hotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:40505 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756640AbaKSUdd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:33:33 -0500
In-Reply-To: <DUB126-W257DF7FB1DCA4D59818B22B2890@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HFmrhtUGgj8Ato651kjJcp6h3UbdMbWwu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

to debug such problems you should try issuing:

# make V=3D1 all

to see the actual command line executed by make;
also very helpfull is the file 'config.log' produced by
the configure script.

giorgio

On 11/19/2014 03:11 PM, Marco Berizzi wrote:
> Hi Folks,
>=20
> I trying to compile nftables, with the following configure options:
>=20
> configure --prefix=3D/usr --without-cli
>=20
> but I get the following error:
>=20
>   CC     mnl.o
>   LEX    scanner.c
>   CC     scanner.o
> scanner.c: In function 'nft_lex':
> scanner.c:1956:23: warning: comparison between signed and unsigned inte=
ger expressions [-Wsign-compare]
>     for ( yyl =3D 0; yyl < yyleng; ++yyl )
>                        ^
> scanner.c: In function 'nft__scan_bytes':
> scanner.c:4091:17: warning: comparison between signed and unsigned inte=
ger expressions [-Wsign-compare]
>   for ( i =3D 0; i < _yybytes_len; ++i )
>                  ^
>   CC     parser_bison.o
>   CCLD   nft
> mnl.o: In function `mnl_batch_begin':
> /tmp/NFTABLES/nftables/src/mnl.c:199: undefined reference to `nft_batch=
_begin'
> mnl.o: In function `mnl_batch_end':
> /tmp/NFTABLES/nftables/src/mnl.c:207: undefined reference to `nft_batch=
_end'
> mnl.o: In function `mnl_nft_setelem_add':
> /tmp/NFTABLES/nftables/src/mnl.c:877: undefined reference to `nft_set_e=
lems_nlmsg_build_payload_iter'
> mnl.o: In function `mnl_nft_setelem_batch_add':
> /tmp/NFTABLES/nftables/src/mnl.c:925: undefined reference to `nft_set_e=
lems_nlmsg_build_payload_iter'
> collect2: error: ld returned 1 exit status
> make[3]: *** [nft] Error 1
> make[3]: Leaving directory `/tmp/NFTABLES/nftables/src'
> make[2]: *** [all] Error 2
> make[2]: Leaving directory `/tmp/NFTABLES/nftables/src'
> make[1]: *** [all-recursive] Error 1
> make[1]: Leaving directory `/tmp/NFTABLES/nftables'
> make: *** [all] Error 2
>=20
> libmnl is current git clone at the time of writing
> libnftnl is current git clone at the time of writing
> nftables is current git clone at the time of writing
>=20
> I'm running slackware 14.1 64bit
> Any response are welcome
>=20
> TIA
>  		 	   		  --
> To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20



--HFmrhtUGgj8Ato651kjJcp6h3UbdMbWwu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlRs/pYACgkQYqbc2h3T5VCRegCgkOypFn/5MRysmJmo9x4uygpb
emoAn0+8P+84/LvnFZuZw/2FqbOe6BG1
=CID1
-----END PGP SIGNATURE-----

--HFmrhtUGgj8Ato651kjJcp6h3UbdMbWwu--

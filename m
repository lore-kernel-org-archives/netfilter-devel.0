From: Giorgio <giorgio.nicole@arcor.de>
Subject: Re: nftables error compile current git
Date: Thu, 20 Nov 2014 22:43:22 +0100
Message-ID: <546E607A.6040209@arcor.de>
References: <DUB126-W257DF7FB1DCA4D59818B22B2890@phx.gbl>,<546CFE8E.7070806@arcor.de> <DUB126-W94B8412C0BC21B1B7E1475B2760@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="IgduFX8ST26HHtD631Pf0f1Pp22IQfJDi"
Cc: Marco Berizzi <pupilla@hotmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:54925 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755849AbaKTVnf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:43:35 -0500
In-Reply-To: <DUB126-W94B8412C0BC21B1B7E1475B2760@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IgduFX8ST26HHtD631Pf0f1Pp22IQfJDi
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/20/2014 09:07 AM, Marco Berizzi wrote:
> giorgio.nicole@arcor.de wrote:
>=20
>> Hi,
>>
>> to debug such problems you should try issuing:
>>
>> # make V=3D1 all
>>
>> to see the actual command line executed by make;
>> also very helpfull is the file 'config.log' produced by
>> the configure script.
>=20
> Hi Giorgio,
>=20
> Here is the output from make V=3D1 all
>=20
> gcc
>  -DHAVE_CONFIG_H -I. -I..  -I../include=20
> -DDEFAULT_INCLUDE_PATH=3D"\"/usr/etc\""  -Wall -Wstrict-prototypes=20
> -Wmissing-prototypes -Wmissing-declarations=20
> -Wdeclaration-after-statement -Wsign-compare -Winit-self=20
> -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute=20
> -Wcast-align -Wundef -Wbad-function-cast -Wno-missing-prototypes=20
> -Wno-missing-declarations -Wno-implicit-function-declaration=20
> -Wno-nested-externs -Wno-undef -Wno-redundant-decls -g -O2 -MT scanner.=
o
>  -MD -MP -MF $depbase.Tpo -c -o scanner.o scanner.c &&\
> mv -f $depbase.Tpo $depbase.Po
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
> depbase=3D`echo parser_bison.o | sed 's|[^/]*$|.deps/&|;s|\.o$||'`;\
> gcc
>  -DHAVE_CONFIG_H -I. -I..  -I../include=20
> -DDEFAULT_INCLUDE_PATH=3D"\"/usr/etc\""  -Wall -Wstrict-prototypes=20
> -Wmissing-prototypes -Wmissing-declarations=20
> -Wdeclaration-after-statement -Wsign-compare -Winit-self=20
> -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute=20
> -Wcast-align -Wundef -Wbad-function-cast -Wno-missing-prototypes=20
> -Wno-missing-declarations -Wno-implicit-function-declaration=20
> -Wno-nested-externs -Wno-undef -Wno-redundant-decls -g -O2 -MT=20
> parser_bison.o -MD -MP -MF $depbase.Tpo -c -o parser_bison.o=20
> parser_bison.c &&\
> mv -f $depbase.Tpo $depbase.Po
> gcc=20
> -Wall -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations=20
> -Wdeclaration-after-statement -Wsign-compare -Winit-self=20
> -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute=20
> -Wcast-align -Wundef -Wbad-function-cast -g -O2   -o nft main.o rule.o =

> statement.o datatype.o expression.o evaluate.o proto.o payload.o=20
> exthdr.o meta.o ct.o netlink.o netlink_linearize.o netlink_delinearize.=
o
>  segtree.o rbtree.o gmputil.o utils.o erec.o mnl.o scanner.o=20
> parser_bison.o  -lmnl   -lnftnl   -lgmp=20
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
> Attached the config.log
>  		 	   		 =20
>=20
Hi,

the command line and the config.log seems OK.

You probably need to update your installed libnftnl. I had a look in the
repo. and saw your undefined functions were added recently to the lib
with the following commit on 13.08.2014:

common: add batching interfaces

This patch adds the following new interfaces:

 int nft_batch_is_supported(void);
 void nft_batch_begin(char *buf, uint32_t seq);
 void nft_batch_end(char *buf, uint32_t seq);

Quite likely this is going to be reused by third party applications
requiring to put things in the batch. We already have potential clients
for this code in nft and iptables-compat.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

giorgio



--IgduFX8ST26HHtD631Pf0f1Pp22IQfJDi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlRuYIEACgkQYqbc2h3T5VCHyQCfY4A0XUOy5nDMP2iMnPW33fOI
6wEAnRV+MfkvgBnhGX+Howgjgr82PLvb
=7TXq
-----END PGP SIGNATURE-----

--IgduFX8ST26HHtD631Pf0f1Pp22IQfJDi--

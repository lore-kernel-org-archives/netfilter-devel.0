From: Marco Berizzi <pupilla@hotmail.com>
Subject: nftables error compile current git
Date: Wed, 19 Nov 2014 15:11:48 +0100
Message-ID: <DUB126-W257DF7FB1DCA4D59818B22B2890@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dub004-omc1s6.hotmail.com ([157.55.0.205]:53236 "EHLO
	DUB004-OMC1S6.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaKSOQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:16:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Folks,

I trying to compile nftables, with the following configure options:

configure --prefix=3D/usr --without-cli

but I get the following error:

=A0 CC=A0=A0=A0=A0 mnl.o
=A0 LEX=A0=A0=A0 scanner.c
=A0 CC=A0=A0=A0=A0 scanner.o
scanner.c: In function 'nft_lex':
scanner.c:1956:23: warning: comparison between signed and unsigned inte=
ger expressions [-Wsign-compare]
=A0=A0=A0 for ( yyl =3D 0; yyl < yyleng; ++yyl )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ^
scanner.c: In function 'nft__scan_bytes':
scanner.c:4091:17: warning: comparison between signed and unsigned inte=
ger expressions [-Wsign-compare]
=A0 for ( i =3D 0; i < _yybytes_len; ++i )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ^
=A0 CC=A0=A0=A0=A0 parser_bison.o
=A0 CCLD=A0=A0 nft
mnl.o: In function `mnl_batch_begin':
/tmp/NFTABLES/nftables/src/mnl.c:199: undefined reference to `nft_batch=
_begin'
mnl.o: In function `mnl_batch_end':
/tmp/NFTABLES/nftables/src/mnl.c:207: undefined reference to `nft_batch=
_end'
mnl.o: In function `mnl_nft_setelem_add':
/tmp/NFTABLES/nftables/src/mnl.c:877: undefined reference to `nft_set_e=
lems_nlmsg_build_payload_iter'
mnl.o: In function `mnl_nft_setelem_batch_add':
/tmp/NFTABLES/nftables/src/mnl.c:925: undefined reference to `nft_set_e=
lems_nlmsg_build_payload_iter'
collect2: error: ld returned 1 exit status
make[3]: *** [nft] Error 1
make[3]: Leaving directory `/tmp/NFTABLES/nftables/src'
make[2]: *** [all] Error 2
make[2]: Leaving directory `/tmp/NFTABLES/nftables/src'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/tmp/NFTABLES/nftables'
make: *** [all] Error 2

libmnl is current git clone at the time of writing
libnftnl is current git clone at the time of writing
nftables is current git clone at the time of writing

I'm running slackware 14.1 64bit
Any response are welcome

TIA
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

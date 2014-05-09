From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [contrack-tools PATCH] build: do not compile nfct if we disabled
 cttimeout
Date: Fri, 9 May 2014 15:59:42 +0200
Message-ID: <20140509135942.GA11325@localhost>
References: <1399543345-3634-1-git-send-email-liuhangbin@gmail.com>
 <20140509112959.GA3812@localhost>
 <20140509115411.GJ25631@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter dev <netfilter@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Hangbin Liu <liuhangbin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43427 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbaEIN7s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 09:59:48 -0400
Content-Disposition: inline
In-Reply-To: <20140509115411.GJ25631@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 09, 2014 at 07:54:11PM +0800, Hangbin Liu wrote:
> On Fri, May 09, 2014 at 01:29:59PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, May 08, 2014 at 06:02:25PM +0800, Hangbin Liu wrote:
> > > If we do not have libnetfilter_cttimeout and disabled cttimeout, =
conntrack-tools
> > > will compile fail because nfct.c include nfnetlink_cttimeout.h. F=
ix it by only
> > > compile nfct when we have enabled cttimeout
> >=20
> > Strange. The nfnetlink_cttimeout.h file is cached inside the
> > conntrack-tools tree:
> >=20
> > conntrack-tools/include/linux/netfilter/nfnetlink_cttimeout.h
> >=20
> > Here this compiles fine with my current tree and using:
> >=20
> > ./configure --prefix=3D/usr --disable-cthelper --disable-cttimeout
> >=20
> > Please, investigate this issue a bit further.
>=20
> That's weird, on my system without libnetfilter_cttimeout.
> # ./configure --prefix=3D/usr
> checking build system type... x86_64-unknown-linux-gnu
> checking host system type... x86_64-unknown-linux-gnu
> checking for a BSD-compatible install... /usr/bin/install -c
> checking whether build environment is sane... yes
>=20
> <snip>
>=20
> checking for LIBNETFILTER_CONNTRACK... yes
> checking for LIBNETFILTER_CTTIMEOUT... no
> configure: error: Package requirements (libnetfilter_cttimeout >=3D 1=
=2E0.0) were not met:
>=20
> No package 'libnetfilter_cttimeout' found
>=20
> Consider adjusting the PKG_CONFIG_PATH environment variable if you
> installed software in a non-standard prefix.
>=20
> Alternatively, you may set the environment variables LIBNETFILTER_CTT=
IMEOUT_CFLAGS
> and LIBNETFILTER_CTTIMEOUT_LIBS to avoid the need to call pkg-config.
> See the pkg-config man page for more details.
>=20
> # ./configure --prefix=3D/usr --disable-cthelper --disable-cttimeout
>=20
> <snip>
>=20
> config.status: executing depfiles commands
> config.status: executing libtool commands
>=20
> conntrack-tools configuration:
>   userspace conntrack helper support:   no
>   conntrack timeout support:            no
>=20
> # make
> Making all in extensions
> make[1]: Entering directory `/root/conntrack-tools/extensions'
>   CC       libct_proto_tcp.lo
>   CCLD     libct_proto_tcp.la
>=20
> <snip>
>=20
>   YACC     read_config_yy.c
> updating read_config_yy.h
>   CC       read_config_yy.o
>   LEX      read_config_lex.c
>   CC       read_config_lex.o
> read_config_lex.c: In function =E2=80=98yylex=E2=80=99:
> read_config_lex.c:2333:23: warning: comparison between signed and uns=
igned integer expressions [-Wsign-compare]
>     for ( yyl =3D 0; yyl < yyleng; ++yyl )
>                        ^
> read_config_lex.c: In function =E2=80=98yy_scan_bytes=E2=80=99:
> read_config_lex.c:3658:17: warning: comparison between signed and uns=
igned integer expressions [-Wsign-compare]
>   for ( i =3D 0; i < _yybytes_len; ++i )
>                  ^
>   CC       stack.o
>   CCLD     conntrackd
>   CC       nfct.o
> nfct.c:26:59: fatal error: libnetfilter_cttimeout/libnetfilter_cttime=
out.h: No such file or directory
>  #include <libnetfilter_cttimeout/libnetfilter_cttimeout.h>
>                                                            ^

OK, I see. That's not nfnetlink_cttimeout.h, it's
libnetfilter_cttimeout.h.

Let me check if I can come up with some alternative solution.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

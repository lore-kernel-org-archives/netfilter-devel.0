From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 3/4] src: add xt compat support
Date: Thu, 9 Apr 2015 14:58:59 +0200
Message-ID: <20150409125859.GA21110@salvia>
References: <20150408174818.28553.96128.stgit@nfdev2.cica.es>
 <20150408174829.28553.71132.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57180 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbbDIMyt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 08:54:49 -0400
Content-Disposition: inline
In-Reply-To: <20150408174829.28553.71132.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 08, 2015 at 07:48:29PM +0200, Arturo Borrero Gonzalez wrote=
:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>=20
> At compilation time, you have to pass this option.
>=20
>   # ./configure --with-xtables
>=20
> And libxtables needs to be installed in your system.
>=20
> This patch allows you to use xt extensions from nft, eg.
>=20
>   # nft add rule filter output \
> 	tcp flags syn xt target TCPMSS [ --clamp-mss-to-pmtu ]
>=20
> This provides access to all existing xt modules from nft. Users can
> meanwhile use xt extension until we can provide native expressions.
>=20
> You can build this optionally, if disabled it displays an error:
>=20
>   # nft add rule filter output tcp flags syn xt target TCPMSS [ --cla=
mp-mss-to-pmtu ]
>   <cmdline>:1:38-77: Error: this build does not support xtables
>   add rule filter output tcp flags syn xt target TCPMSS [ --clamp-mss=
-to-pmtu ]
>                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^^
>=20
> so you know your build doesn't support this.
>=20
> Limitations:
>=20
> * Beware of clashes with keywords, eg. state, from bison parser.
> * Better xt parsing errors for unknown options.
>=20
> This is joint work with Arturo Borrero Gonzalez.

$ make
make  all-recursive
make[1]: se ingresa al directorio
`/home/pablo/devel/scm/git-netfilter/nftables'
Making all in src
make[2]: se ingresa al directorio
`/home/pablo/devel/scm/git-netfilter/nftables/src'
make  all-am
make[3]: se ingresa al directorio
`/home/pablo/devel/scm/git-netfilter/nftables/src'
  CC     rule.o
In file included from ../include/statement.h:6:0,
                 from rule.c:19:
=2E./include/xt.h: In function =E2=80=98stmt_evaluate_xt=E2=80=99:
=2E./include/xt.h:60:2: warning: implicit declaration of function
=E2=80=98stmt_error=E2=80=99 [-Wimplicit-function-declaration]
=2E./include/xt.h: At top level:
=2E./include/xt.h:100:34: error: field =E2=80=98entry=E2=80=99 has inco=
mplete type
make[3]: *** [rule.o] Error 1
make[3]: se sale del directorio
`/home/pablo/devel/scm/git-netfilter/nftables/src'
make[2]: *** [all] Error 2
make[2]: se sale del directorio
`/home/pablo/devel/scm/git-netfilter/nftables/src'
make[1]: *** [all-recursive] Error 1
make[1]: se sale del directorio
`/home/pablo/devel/scm/git-netfilter/nftables'
make: *** [all] Error 2

This doesn't compile without libxtables support.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

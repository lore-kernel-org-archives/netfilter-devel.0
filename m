From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 3/3] build: use automake and pkgconfig
Date: Wed, 20 Nov 2013 11:54:21 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1311201008300.24243@nerf07.vanv.qr>
References: <1382280491-9921-1-git-send-email-jengelh@inai.de> <1382280491-9921-4-git-send-email-jengelh@inai.de> <20131119202815.GC4929@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:44367 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab3KTKyX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Nov 2013 05:54:23 -0500
In-Reply-To: <20131119202815.GC4929@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2013-11-19 21:28, Pablo Neira Ayuso wrote:

>On Sun, Oct 20, 2013 at 04:48:11PM +0200, Jan Engelhardt wrote:
>> This now also honors the cflags as obtained from pkgconfig, otherwis=
e
>> one gets a compile error if the headers are in a location other than
>> /usr/include.
>
>I don't want to consider changing the build system at this stage.

At this stage, the build is rather broken, for cases that are not
even far-fetched.



10:08 ares07:../nftables/obj > ../configure
[...]
configure: creating ./config.status
config.status: creating Makefile
config.status: creating Makefile.defs
config.status: creating Makefile.rules
config.status: creating src/Makefile
config.status: creating doc/Makefile
config.status: creating files/Makefile
config.status: creating config.h
10:08 ares07:../nftables/obj > make -j8
  SUBDIR        src/
  SUBDIR        doc/
  SUBDIR        files/
make[1]: *** No rule to make target `src/main.o', needed by `src/nft'. =
 Stop.
make: *** [src] Error 2
make: *** Waiting for unfinished jobs....

	^ builddir!=3Dsrcdir not handled


10:09 ares07:../nftables/nftables > configure
[...]
10:09 ares07:../nftables/nftables > make -j8
  SUBDIR        src/
  SUBDIR        files/
  SUBDIR        doc/
  LEX           src/scanner.l
  YACC          src/parser.y
  DEP           src/mnl.c
  DEP           src/erec.c
src/mnl.c:11:27: fatal error: libmnl/libmnl.h: No such file or director=
y
 #include <libmnl/libmnl.h>

	^ pkgconfig files ignored


10:17 ares07:../nftables/nftables > make CPPFLAGS=3D/usr/include/pkg/li=
bnftables
  SUBDIR        src/
  CC            src/main.c
In file included from src/main.c:25:0:
include/netlink.h:4:31: fatal error: libnftables/table.h: No such file =
or directory

	^ CPPFLAGS ignored


10:17 ares07:../nftables/nftables > make CPPFLAGS+=3D/usr/include/pkg/l=
ibnftables
  SUBDIR        src/
  CC            src/main.c
In file included from src/main.c:25:0:
include/netlink.h:4:31: fatal error: libnftables/table.h: No such file =
or directory

	^ so is the (unusual) approach of working around with +=3D


10:13 ares07:../nftables/nftables > make CFLAGS=3D-I/usr/include/pkg/li=
bnftables
  SUBDIR        src/
  CC            src/main.c
src/main.c:21:22: fatal error: nftables.h: No such file or directory
 #include <nftables.h>

	^ CFLAGS ignored as well


10:15 ares07:../nftables/nftables > ./configure CFLAGS=3D-I/usr/include=
/pkg/libnftables
[...]
configure: creating ./config.status
config.status: creating Makefile
config.status: creating Makefile.defs
config.status: creating Makefile.rules
config.status: creating src/Makefile
config.status: creating doc/Makefile
config.status: creating files/Makefile
config.status: creating config.h
config.status: config.h is unchanged
10:15 ares07:../nftables/nftables > make
  SUBDIR        src/
  LEX           src/scanner.l
  DEP           src/scanner.c
In file included from src/scanner.l:21:0:
/usr/include/pkg/libnftables/rule.h:9:32: fatal error: libnftables/comm=
on.h: No such file or directory

	^ CFLAGS/CPPFLAGS specified at configure time are ignored as well


11:42 ares07:../nftables/nftables > make install DESTDIR=3D/tmp/foo
  SUBDIR        src/
  INSTALL       nft
/usr/bin/install: cannot change ownership of =E2=80=98/tmp/foo//usr/x86=
_64-suse-linux/sys-root/sbin/nft=E2=80=99: Operation not permitted
make[1]: *** [nft-install] Error 1
make: *** [src] Error 2

	^ install uses -o root -g root, which fails if you are not
	already root (in which case -o/-g is pointless, because install
	defaults to using root anyway)

	* There is no way to get a verbose build

	* Makefile runs a separate "DEPS" stage even though there is
	absolutely no need to

  CC            src/scanner.c
<stdout>: In function =E2=80=98nft_lex=E2=80=99:
<stdout>:1738:23: error: comparison between signed and unsigned integer=
 expressions [-Werror=3Dsign-compare]

I'll overlook -Werror for now=E2=80=A6


	* Remake is oddly broken (compiler throws errors).
	(Patch 2 would probably fix that in the same go too.)
	This is especially nasty, because despite the gcc error given,
	the build completes.


$ make clean
  SUBDIR	src/
  CLEAN		nft
  SUBDIR	files/
  SUBDIR	doc/
  CLEAN		doc
$ make -j8
  SUBDIR	src/
  SUBDIR	doc/
  SUBDIR	files/
  LEX		src/scanner.l
  YACC		src/parser.y
  DEP		src/mnl.c
  DEP		src/erec.c
  DEP		src/utils.c
  DEP		src/gmputil.c
  DEP		src/rbtree.c
  DEP		src/segtree.c
  DEP		src/netlink_delinearize.c
  DEP		src/netlink_linearize.c
  DEP		src/netlink.c
  DEP		src/ct.c
  DEP		src/meta.c
  DEP		src/exthdr.c
  DEP		src/payload.c
  DEP		src/evaluate.c
  DEP		src/expression.c
  DEP		src/datatype.c
  DEP		src/statement.c
  DEP		src/rule.c
  DEP		src/cli.c
  DEP		src/main.c
  DEP		src/scanner.c
  DEP		src/parser.c
  LEX		src/scanner.l
  YACC		src/parser.y
  DEP		src/scanner.c
  DEP		src/parser.c
  CC		src/main.c
  CC		src/cli.c
  CC		src/rule.c
  CC		src/statement.c
  CC		src/datatype.c
  CC		src/expression.c
  CC		src/evaluate.c
  CC		src/payload.c
  CC		src/exthdr.c
  CC		src/meta.c
  CC		src/ct.c
  CC		src/netlink.c
  CC		src/netlink_linearize.c
  CC		src/netlink_delinearize.c
  CC		src/segtree.c
  CC		src/rbtree.c
  CC		src/gmputil.c
  CC		src/utils.c
  CC		src/erec.c
  CC		src/mnl.c
  CC		src/parser.c
  CC		src/scanner.c
<stdout>: In function =E2=80=98nft_lex=E2=80=99:
<stdout>:1738:23: warning: comparison between signed and unsigned integ=
er expressions [-Wsign-compare]
<stdout>: In function =E2=80=98nft__scan_bytes=E2=80=99:
<stdout>:3583:17: warning: comparison between signed and unsigned integ=
er expressions [-Wsign-compare]
  LD		src/nft
$ touch Makefile.rules
$ make -j1
  SUBDIR	src/
  LEX		src/scanner.l
  YACC		src/parser.y
src/parser.y: warning: conflicting outputs to file =E2=80=98src/parser.=
h=E2=80=99
  DEP		src/scanner.c
In file included from src/parser.y:28:0,
                 from src/parser.y:28,
                 from src/parser.y:28,
                 from src/parser.y:28, [repeated over 20 times]
                 from src/parser.y:28,
                 from src/scanner.l:23:
src/parser.y:13:20: error: #include nested too deeply
 #include <stddef.h>
                    ^
src/parser.y:14:19: error: #include nested too deeply
 #include <stdio.h>
                   ^
src/parser.y:15:22: error: #include nested too deeply
 #include <inttypes.h>
                      ^
src/parser.y:16:24: error: #include nested too deeply
 #include <netinet/ip.h>
                        ^
src/parser.y:17:29: error: #include nested too deeply
 #include <linux/netfilter.h>
                             ^
src/parser.y:18:39: error: #include nested too deeply
 #include <linux/netfilter/nf_tables.h>
                                       ^
src/parser.y:19:55: error: #include nested too deeply
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
                                                       ^
src/parser.y:21:18: error: #include nested too deeply
 #include <rule.h>
                  ^
src/parser.y:22:23: error: #include nested too deeply
 #include <statement.h>
                       ^
src/parser.y:23:24: error: #include nested too deeply
 #include <expression.h>
                        ^
src/parser.y:24:19: error: #include nested too deeply
 #include <utils.h>
                   ^
src/parser.y:25:20: error: #include nested too deeply
 #include <parser.h>
                    ^
src/parser.y:26:18: error: #include nested too deeply
 #include <erec.h>
                  ^
src/parser.y:28:20: error: #include nested too deeply
 #include "parser.h"
                    ^
src/parser.y:29:21: error: #include nested too deeply
 #include "scanner.h"
                     ^
In file included from src/parser.y:28:0,
                 from src/parser.y:28,
                 from src/scanner.l:23:
src/parser.h:1673:56: error: #include nested too deeply
 #  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
                                                        ^
In file included from src/parser.y:29:0,
                 from src/parser.y:28,
                 from src/scanner.l:23:
src/scanner.h:36:19: error: #include nested too deeply
 #include <stdio.h>
                   ^
src/scanner.h:37:20: error: #include nested too deeply
 #include <string.h>
                    ^
src/scanner.h:38:19: error: #include nested too deeply
 #include <errno.h>
                   ^
src/scanner.h:39:20: error: #include nested too deeply
 #include <stdlib.h>
                    ^
src/scanner.h:299:20: error: #include nested too deeply
 #include <unistd.h>
                    ^
  DEP		src/parser.c
In file included from src/parser.y:28:0,
                 from src/parser.y:28,
                 from src/parser.y:28:
src/parser.y:13:20: error: #include nested too deeply
 #include <stddef.h>
                    ^
src/parser.y:14:19: error: #include nested too deeply
 #include <stdio.h>
                   ^
src/parser.y:15:22: error: #include nested too deeply
 #include <inttypes.h>
                      ^
src/parser.y:16:24: error: #include nested too deeply
 #include <netinet/ip.h>
                        ^
src/parser.y:17:29: error: #include nested too deeply
 #include <linux/netfilter.h>
                             ^
src/parser.y:18:39: error: #include nested too deeply
 #include <linux/netfilter/nf_tables.h>
                                       ^
src/parser.y:19:55: error: #include nested too deeply
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
                                                       ^
src/parser.y:21:18: error: #include nested too deeply
 #include <rule.h>
                  ^
src/parser.y:22:23: error: #include nested too deeply
 #include <statement.h>
                       ^
src/parser.y:23:24: error: #include nested too deeply
 #include <expression.h>
                        ^
src/parser.y:24:19: error: #include nested too deeply
 #include <utils.h>
                   ^
src/parser.y:25:20: error: #include nested too deeply
 #include <parser.h>
                    ^
src/parser.y:26:18: error: #include nested too deeply
 #include <erec.h>
                  ^
src/parser.y:28:20: error: #include nested too deeply
 #include "parser.h"
                    ^
src/parser.y:29:21: error: #include nested too deeply
 #include "scanner.h"
                     ^
In file included from src/parser.y:28:0,
                 from src/parser.y:28,
                 from src/parser.y:28:
src/parser.h:1673:56: error: #include nested too deeply
 #  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
                                                        ^
In file included from src/parser.y:29:0,
                 from src/parser.y:28,
                 from src/parser.y:28:
src/scanner.h:36:19: error: #include nested too deeply
 #include <stdio.h>
                   ^
src/scanner.h:37:20: error: #include nested too deeply
 #include <string.h>
                    ^
src/scanner.h:38:19: error: #include nested too deeply
 #include <errno.h>
                   ^
src/scanner.h:39:20: error: #include nested too deeply
 #include <stdlib.h>
                    ^
src/scanner.h:299:20: error: #include nested too deeply
 #include <unistd.h>
                    ^
  DEP		src/mnl.c
  DEP		src/erec.c
  DEP		src/utils.c
  DEP		src/gmputil.c
  DEP		src/rbtree.c
  DEP		src/segtree.c
  DEP		src/netlink_delinearize.c
  DEP		src/netlink_linearize.c
  DEP		src/netlink.c
  DEP		src/ct.c
  DEP		src/meta.c
  DEP		src/exthdr.c
  DEP		src/payload.c
  DEP		src/evaluate.c
  DEP		src/expression.c
  DEP		src/datatype.c
  DEP		src/statement.c
  DEP		src/rule.c
  DEP		src/cli.c
  DEP		src/main.c
  YACC		src/parser.y
  DEP		src/parser.c
  CC		src/main.c
  CC		src/cli.c
  CC		src/rule.c
  CC		src/statement.c
  CC		src/datatype.c
  CC		src/expression.c
  CC		src/evaluate.c
  CC		src/payload.c
  CC		src/exthdr.c
  CC		src/meta.c
  CC		src/ct.c
  CC		src/netlink.c
  CC		src/netlink_linearize.c
  CC		src/netlink_delinearize.c
  CC		src/segtree.c
  CC		src/rbtree.c
  CC		src/gmputil.c
  CC		src/utils.c
  CC		src/erec.c
  CC		src/mnl.c
  CC		src/parser.c
  CC		src/scanner.c
<stdout>: In function =E2=80=98nft_lex=E2=80=99:
<stdout>:1738:23: warning: comparison between signed and unsigned integ=
er expressions [-Wsign-compare]
<stdout>: In function =E2=80=98nft__scan_bytes=E2=80=99:
<stdout>:3583:17: warning: comparison between signed and unsigned integ=
er expressions [-Wsign-compare]
  LD		src/nft
  SUBDIR	files/
  SUBDIR	doc/
ares07:../nftables/nftables > echo $?
0
ares07:../nftables/nftables >
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

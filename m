From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables-goes-automake patch series
Date: Wed, 25 Mar 2009 14:11:04 +0100
Message-ID: <49CA2D68.20601@trash.net>
References: <1237937468-31476-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62439 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbZCYNLN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:11:13 -0400
In-Reply-To: <1237937468-31476-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Not much more to elaborate on, this was straight forward to do
> and only a matter of time, and really needed :)
>
>  20 files changed, 145 insertions(+), 455 deletions(-)
>
> It is available too from  git://dev.medozas.de/nftables master
>
> Awaiting comments.

Patch 1 looks fine, although I might take the liberty to rename the
file again :)

About automake - I'm glad you're fixing up the makefiles, but I'm
quite attached to the silent build and the automake version that
comes with Debian unstable is 1.10, so I assume it won't be
silent anymore. It also doesn't build anymore on my system, the
parser.h file is not generated:

make  all-recursive
make[1]: Entering directory `/tmp/nftables'
Making all in doc
make[2]: Entering directory `/tmp/nftables/doc'
make[2]: F=FCr das Ziel =BBall=AB ist nichts zu tun.
make[2]: Leaving directory `/tmp/nftables/doc'
Making all in files/nftables
make[2]: Entering directory `/tmp/nftables/files/nftables'
make[2]: F=FCr das Ziel =BBall=AB ist nichts zu tun.
make[2]: Leaving directory `/tmp/nftables/files/nftables'
Making all in src
make[2]: Entering directory `/tmp/nftables/src'
depbase=3D`echo scanner.o | sed 's|[^/]*$|.deps/&|;s|\.o$||'`;\
        gcc -DHAVE_CONFIG_H -I. -I..    -D_FILE_OFFSET_BITS=3D64=20
-D_REENTRANT -Wall -Waggregate-return    -Wbad-function-cast=20
-Wcast-align -Wdeclaration-after-statement  -Werror -Wformat=3D2=20
-Winit-self -Winline -Wmissing-declarations        =20
-Wmissing-format-attribute -Wmissing-prototypes         -Wshadow=20
-Wsign-compare -Wstrict-prototypes -Wundef -Wunused    -Wwrite-strings=20
-fno-strict-aliasing -pipe -I../include=20
-DDEFAULT_INCLUDE_PATH=3D\"/usr/local/etc/nftables\" -g -O2 -MT scanner=
=2Eo=20
-MD -MP -MF $depbase.Tpo -c -o scanner.o scanner.c &&\
        mv -f $depbase.Tpo $depbase.Po
scanner.l:23:20: Fehler: parser.h: Datei oder Verzeichnis nicht gefunde=
n
<stdout>:1395: Fehler: expected specifier-qualifier-list before =BBYYST=
YPE=AB
<stdout>:1454: Fehler: expected =BB=3D=AB, =BB,=AB, =BB;=AB, =BBasm=AB =
or =BB__attribute__=AB=20
before =BB*=AB token...

About -Wshadow: in my experience it usually at some point becomes a nui=
sance
and starts causing strange naming. But for now I'm willing to try, your=
 fix
looks simple enough.


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

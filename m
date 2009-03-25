From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nftables-goes-automake patch series
Date: Wed, 25 Mar 2009 15:02:44 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903251447320.13559@fbirervta.pbzchgretzou.qr>
References: <1237937468-31476-1-git-send-email-jengelh@medozas.de> <49CA2D68.20601@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51336 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbZCYOCr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:02:47 -0400
In-Reply-To: <49CA2D68.20601@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-03-25 14:11, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Not much more to elaborate on, this was straight forward to do
>> and only a matter of time, and really needed :)
>
> Patch 1 looks fine, although I might take the liberty to rename the
> file again :)
>
> About automake - I'm glad you're fixing up the makefiles, but I'm
> quite attached to the silent build and the automake version that
> comes with Debian unstable is 1.10, so I assume it won't be
> silent anymore.

I do have a patch for 1.10 too, if you need.

> It also doesn't build anymore on my system, the
> parser.h file is not generated:
>
> make  all-recursive
> make[1]: Entering directory `/tmp/nftables'
> Making all in doc
> make[2]: Entering directory `/tmp/nftables/doc'
> make[2]: F=C3=BCr das Ziel =C2=BBall=C2=AB ist nichts zu tun.
> make[2]: Leaving directory `/tmp/nftables/doc'
> Making all in files/nftables
> make[2]: Entering directory `/tmp/nftables/files/nftables'
> make[2]: F=C3=BCr das Ziel =C2=BBall=C2=AB ist nichts zu tun.
> make[2]: Leaving directory `/tmp/nftables/files/nftables'
> Making all in src
> make[2]: Entering directory `/tmp/nftables/src'
> depbase=3D`echo scanner.o | sed 's|[^/]*$|.deps/&|;s|\.o$||'`;\
>       gcc -DHAVE_CONFIG_H -I. -I..    -D_FILE_OFFSET_BITS=3D64 -D_REE=
NTRANT
> -Wall -Waggregate-return    -Wbad-function-cast -Wcast-align
> -Wdeclaration-after-statement  -Werror -Wformat=3D2 -Winit-self -Winl=
ine
> -Wmissing-declarations         -Wmissing-format-attribute -Wmissing-p=
rototypes
> -Wshadow -Wsign-compare -Wstrict-prototypes -Wundef -Wunused    -Wwri=
te-strings
> -fno-strict-aliasing -pipe -I../include
> -DDEFAULT_INCLUDE_PATH=3D\"/usr/local/etc/nftables\" -g -O2 -MT scann=
er.o -MD -MP
> -MF $depbase.Tpo -c -o scanner.o scanner.c &&\
>       mv -f $depbase.Tpo $depbase.Po
> scanner.l:23:20: Fehler: parser.h: Datei oder Verzeichnis nicht gefun=
den
> <stdout>:1395: Fehler: expected specifier-qualifier-list before =C2=BB=
YYSTYPE=C2=AB
> <stdout>:1454: Fehler: expected =C2=BB=3D=C2=AB, =C2=BB,=C2=AB, =C2=BB=
;=C2=AB, =C2=BBasm=C2=AB or =C2=BB__attribute__=C2=AB before
> =C2=BB*=C2=AB token...

It does do it here:

make[2]: Entering directory `/home/jengelh/Coding/nftables/src'
flex --header-file=3Dscanner.h -t scanner.l >scanner.c
/bin/sh ../ylwrap parser.y y.tab.c parser.c y.tab.h parser.h y.output p=
arser.output -- bison -y  -d --skeleton=3D../../../../../../../..//home=
/jengelh/Coding/nftables/src/parser-skeleton.c
updating parser.h
depbase=3D`echo scanner.o | sed 's|[^/]*$|.deps/&|;s|\.o$||'`;\
        gcc -DHAVE_CONFIG_H -I. -I..    -D_FILE_OFFSET_BITS=3D64 -D_REE=
NTRANT -Wall -Waggregate-return    -Wbad-function-cast -Wcast-align -Wd=
eclaration-after-statement  -Werror -Wformat=3D2 -Winit-self -Winline -=
Wmissing-declarations  -Wmissing-format-attribute -Wmissing-prototypes =
        -Wshadow -Wsign-compare -Wstrict-prototypes -Wundef -Wunused   =
 -Wwrite-strings -fno-strict-aliasing -pipe -I../include -DDEFAULT_INCL=
UDE_PATH=3D\"/usr/local/etc/nftables\" -g -O2 -MT scanner.o -MD -MP -MF=
 $depbase.Tpo -c -o scanner.o scanner.c &&\
        mv -f $depbase.Tpo $depbase.Po

Maybe you need a distclean? Are you sure you are on commit
v0.01-alpha1-23-g85bf078?

> About -Wshadow: in my experience it usually at some point becomes a n=
uisance
> and starts causing strange naming. But for now I'm willing to try, yo=
ur fix
> looks simple enough.
>
Yes, but shadow warns about possibly wrong reuses of variables, i.e.
stuff like

	ctx_t ctx;
	{
		ctx_t ctx;
		memset(&ctx, 0, sizeof(ctx)); // intended to nuke the near ctx
		...
		2-5 lines padding
		...
		send(&ctx); // but wanted to send the far ctx.
	}

You could also move it into a standalone function to avoid this problem=
 ;-)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

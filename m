From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables-goes-automake patch series
Date: Wed, 25 Mar 2009 15:33:22 +0100
Message-ID: <49CA40B2.5010300@trash.net>
References: <1237937468-31476-1-git-send-email-jengelh@medozas.de> <49CA2D68.20601@trash.net> <alpine.LSU.2.00.0903251447320.13559@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64290 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZCYOda (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:33:30 -0400
In-Reply-To: <alpine.LSU.2.00.0903251447320.13559@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2009-03-25 14:11, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> Not much more to elaborate on, this was straight forward to do
>>> and only a matter of time, and really needed :)
>> Patch 1 looks fine, although I might take the liberty to rename the
>> file again :)
>>
>> About automake - I'm glad you're fixing up the makefiles, but I'm
>> quite attached to the silent build and the automake version that
>> comes with Debian unstable is 1.10, so I assume it won't be
>> silent anymore.
>=20
> I do have a patch for 1.10 too, if you need.

I don't really want to compile my own automake. Can't we just keep
the silent build in combination with automake? I'm fine with doing
the final conversion once that version of automake is commonly
available in distributions.

>> It also doesn't build anymore on my system, the
>> parser.h file is not generated:
>>
>> ...
>> scanner.l:23:20: Fehler: parser.h: Datei oder Verzeichnis nicht gefu=
nden
>> <stdout>:1395: Fehler: expected specifier-qualifier-list before =BBY=
YSTYPE=AB
>> <stdout>:1454: Fehler: expected =BB=3D=AB, =BB,=AB, =BB;=AB, =BBasm=AB=
 or =BB__attribute__=AB before
>> =BB*=AB token...
>=20
> It does do it here:
>=20
> make[2]: Entering directory `/home/jengelh/Coding/nftables/src'
> flex --header-file=3Dscanner.h -t scanner.l >scanner.c
> /bin/sh ../ylwrap parser.y y.tab.c parser.c y.tab.h parser.h y.output=
 parser.output -- bison -y  -d --skeleton=3D../../../../../../../..//ho=
me/jengelh/Coding/nftables/src/parser-skeleton.c
> updating parser.h
> depbase=3D`echo scanner.o | sed 's|[^/]*$|.deps/&|;s|\.o$||'`;\
>         gcc -DHAVE_CONFIG_H -I. -I..    -D_FILE_OFFSET_BITS=3D64 -D_R=
EENTRANT -Wall -Waggregate-return    -Wbad-function-cast -Wcast-align -=
Wdeclaration-after-statement  -Werror -Wformat=3D2 -Winit-self -Winline=
 -Wmissing-declarations  -Wmissing-format-attribute -Wmissing-prototype=
s         -Wshadow -Wsign-compare -Wstrict-prototypes -Wundef -Wunused =
   -Wwrite-strings -fno-strict-aliasing -pipe -I../include -DDEFAULT_IN=
CLUDE_PATH=3D\"/usr/local/etc/nftables\" -g -O2 -MT scanner.o -MD -MP -=
MF $depbase.Tpo -c -o scanner.o scanner.c &&\
>         mv -f $depbase.Tpo $depbase.Po
>=20
> Maybe you need a distclean? Are you sure you are on commit
> v0.01-alpha1-23-g85bf078?

I tried both pulling your tree into mine, as well as a fresh clone of
your tree. Let me know if you need more information.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/6] build: add debug configure flag
Date: Sat, 2 Oct 2010 00:22:53 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010020021520.26371@obet.zrqbmnf.qr>
References: <1285116442-32490-1-git-send-email-eric@inl.fr>  <1285116442-32490-4-git-send-email-eric@inl.fr>  <4CA45D5E.9010103@netfilter.org> <1285881721.21111.1.camel@ice-age>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39260 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab0JAWWy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Oct 2010 18:22:54 -0400
In-Reply-To: <1285881721.21111.1.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-09-30 23:22, Eric Leblond wrote:

>Hi,
>
>Le jeudi 30 septembre 2010 =C3=A0 11:50 +0200, Pablo Neira Ayuso a =C3=
=A9crit :
>> On 22/09/10 02:47, Eric Leblond wrote:
>> > --- a/src/Makefile.am
>> > +++ b/src/Makefile.am
>> > @@ -6,4 +6,8 @@ AM_CPPFLAGS =3D $(all_includes) -I$(top_srcdir)/in=
clude \
>> >  sbin_PROGRAMS =3D ulogd
>> > =20
>> >  ulogd_SOURCES =3D ulogd.c select.c timer.c rbtree.c conffile.c ha=
sh.c
>> > +if HAVE_DEBUG
>> > +ulogd_LDFLAGS =3D -lpthread -export-dynamic
>>=20
>> Do we still have the gdb pthread issue?
>
>I've got it on my debian "sid" and it seems someone has got it on
>bugzilla.

When exactly does it happen? Do you have a testcase?
(I tried `grep -ri pthr .` in ulogd2 but that showed no use of pthr at=20
all.)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

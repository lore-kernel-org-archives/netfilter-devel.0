From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/6] build: add debug configure flag
Date: Sun, 03 Oct 2010 12:15:20 +0200
Message-ID: <4CA857B8.3070205@netfilter.org>
References: <1285116442-32490-1-git-send-email-eric@inl.fr>  <1285116442-32490-4-git-send-email-eric@inl.fr>  <4CA45D5E.9010103@netfilter.org> <1285881721.21111.1.camel@ice-age> <alpine.LNX.2.01.1010020021520.26371@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55756 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801Ab0JCKP1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Oct 2010 06:15:27 -0400
In-Reply-To: <alpine.LNX.2.01.1010020021520.26371@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/10/10 00:22, Jan Engelhardt wrote:
> On Thursday 2010-09-30 23:22, Eric Leblond wrote:
>=20
>> Hi,
>>
>> Le jeudi 30 septembre 2010 =C3=A0 11:50 +0200, Pablo Neira Ayuso a =C3=
=A9crit :
>>> On 22/09/10 02:47, Eric Leblond wrote:
>>>> --- a/src/Makefile.am
>>>> +++ b/src/Makefile.am
>>>> @@ -6,4 +6,8 @@ AM_CPPFLAGS =3D $(all_includes) -I$(top_srcdir)/in=
clude \
>>>>  sbin_PROGRAMS =3D ulogd
>>>> =20
>>>>  ulogd_SOURCES =3D ulogd.c select.c timer.c rbtree.c conffile.c ha=
sh.c
>>>> +if HAVE_DEBUG
>>>> +ulogd_LDFLAGS =3D -lpthread -export-dynamic
>>>
>>> Do we still have the gdb pthread issue?
>>
>> I've got it on my debian "sid" and it seems someone has got it on
>> bugzilla.
>=20
> When exactly does it happen? Do you have a testcase?
> (I tried `grep -ri pthr .` in ulogd2 but that showed no use of pthr a=
t=20
> all.)

The problem is gdb in debian, which doesn't seem to work if ulogd2 is
not compiled with pthread.

If this is a gdb bug, it should be fixed there, I know that it's
annoying for debugging ulogd2. However, I think this may confuse people
since ulogd2 require no pthreads at all.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

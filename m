From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Can't link C++ program to libipset
Date: Wed, 18 Mar 2015 13:01:11 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1503181258200.8959@nerf40.vanv.qr>
References: <CALgsdbeBy=wDnyEpZTrGb0=HKPB9kcS03m=jPzCLfzotyA7P8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pavel Odintsov <pavel.odintsov@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:46450 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006AbbCRMBN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2015 08:01:13 -0400
In-Reply-To: <CALgsdbeBy=wDnyEpZTrGb0=HKPB9kcS03m=jPzCLfzotyA7P8Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2015-03-18 12:20, Pavel Odintsov wrote:
>
>I trying to integrate ipset to my flood monitoring toolkit
>https://github.com/FastVPSEestiOu/fastnetmon but can't link it
>correctly.
>
>Here you can find [the snippet of] my code:
>https://gist.github.com/pavel-odintsov/b2277822e5c88e136550
>
>And tried link my tool with libipset but haven't any success:
>g++ ipset.c  -I/opt/ipset/include/ -L/opt/ipset/lib -lipset
>ipset.c: In function =E2=80=98int main()=E2=80=99:
>ipset.c:15:37: warning: deprecated conversion from string constant to
>=E2=80=98char*=E2=80=99 [-Wwrite-strings]

This is a bug in your code, not ipset. In C++, string literals
have type const char=C2=A0*. In C, they have type char=C2=A0* but are s=
till
immutable, so you better treat them as const char=C2=A0* in both cases.

>/tmp/ccWP0vdf.o:ipset.c:function ban_ip(char*, char*): error:
>undefined reference to 'ipset_session_init(int (*)(char const*, ...))'

It's an ipset bug. The ipset header files are missing

#ifdef __cplusplus
extern "C" {
#endif
=2E..
wraps.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

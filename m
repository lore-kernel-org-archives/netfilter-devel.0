From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [RFC conntrackd PATCH] conntrackd: add basic systemd notification
 support
Date: Fri, 16 Oct 2015 23:37:31 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1510162326001.24538@nerf40.vanv.qr>
References: <20151016120800.15632.42888.stgit@r2d2.cica.es> <alpine.LSU.2.20.1510161607550.18200@nerf40.vanv.qr> <CAOkSjBh7hyB_QAidiXsoBtCOj9xG8y0cUcu-ERZTCZQsnHXRJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:34755 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbbJPVhd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Oct 2015 17:37:33 -0400
In-Reply-To: <CAOkSjBh7hyB_QAidiXsoBtCOj9xG8y0cUcu-ERZTCZQsnHXRJA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2015-10-16 21:23, Arturo Borrero Gonzalez wrote:

>On 16 October 2015 at 16:10, Jan Engelhardt <jengelh@inai.de> wrote:
>>
>> On Friday 2015-10-16 14:10, Arturo Borrero Gonzalez wrote:
>>
>>>+AC_ARG_ENABLE([systemd],
>>>+      AS_HELP_STRING([--disable-systemd], [Do not build systemd sup=
port]),
>>>+      [enable_systemd=3D"no"], [enable_systemd=3D"yes"])
>>
>> This is incorrect. It needs to be
>>
>>         [enable_systemd=3D"$enableval"], [enable_systemd=3D"yes"])
>>
>
>I don't understand why. Could you please elaborate? The code above
>(cthelper, cttimeout) is also bad?
>
>https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.=
69/html_node/Package-Options.html

Quoting the page:

=E2=80=94 Macro: AC_ARG_ENABLE (feature, help-string, [action-if-given]=
,=20
[action-if-not-given])
    If the user gave configure the option --enable-feature or=20
    --disable-feature, run shell commands action-if-given.


So

$ ./configure --enable-systemd

runs the 3rd argument, and always sets enable_systemd=3Dno,
which is counter to what the user requested of configure.

In that regard, yes, conntrack-tools is also negatively affected.=20
Possibly other software from netfilter.org too.



>Sending READY=3D1 is just a basic starting feature. I don't want to
>implement more things until it's clear we want systemd integration in
>conntrackd.

ok
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

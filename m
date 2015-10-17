From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC conntrackd PATCH] conntrackd: add basic systemd
 notification support
Date: Sat, 17 Oct 2015 12:57:20 +0200
Message-ID: <20151017105720.GA1462@salvia>
References: <20151016120800.15632.42888.stgit@r2d2.cica.es>
 <alpine.LSU.2.20.1510161607550.18200@nerf40.vanv.qr>
 <CAOkSjBh7hyB_QAidiXsoBtCOj9xG8y0cUcu-ERZTCZQsnHXRJA@mail.gmail.com>
 <alpine.LSU.2.20.1510162326001.24538@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44464 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbbJQKuS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Oct 2015 06:50:18 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1510162326001.24538@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 16, 2015 at 11:37:31PM +0200, Jan Engelhardt wrote:
> On Friday 2015-10-16 21:23, Arturo Borrero Gonzalez wrote:
>=20
> >On 16 October 2015 at 16:10, Jan Engelhardt <jengelh@inai.de> wrote:
> >>
> >> On Friday 2015-10-16 14:10, Arturo Borrero Gonzalez wrote:
> >>
> >>>+AC_ARG_ENABLE([systemd],
> >>>+      AS_HELP_STRING([--disable-systemd], [Do not build systemd s=
upport]),
> >>>+      [enable_systemd=3D"no"], [enable_systemd=3D"yes"])
> >>
> >> This is incorrect. It needs to be
> >>
> >>         [enable_systemd=3D"$enableval"], [enable_systemd=3D"yes"])
> >>
> >
> >I don't understand why. Could you please elaborate? The code above
> >(cthelper, cttimeout) is also bad?
> >
> >https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-=
2.69/html_node/Package-Options.html
>=20
> Quoting the page:
>=20
> =E2=80=94 Macro: AC_ARG_ENABLE (feature, help-string, [action-if-give=
n],=20
> [action-if-not-given])
>     If the user gave configure the option --enable-feature or=20
>     --disable-feature, run shell commands action-if-given.
>=20
>=20
> So
>=20
> $ ./configure --enable-systemd
>=20
> runs the 3rd argument, and always sets enable_systemd=3Dno,
> which is counter to what the user requested of configure.
>=20
> In that regard, yes, conntrack-tools is also negatively affected.=20
> Possibly other software from netfilter.org too.

Something like this (that we already have in nftables) should be fine:

commit 26b31033261427a3058a8fb994d54273bc93f7bf
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue Jul 7 14:32:21 2015 +0200

    configure: fix --enable-debug
   =20
    As the documentation indicates "The most common mistake for this
macro is to
    consider the two actions as action-if-enabled and
action-if-disabled."
   =20
    Use AS_IF in the action-if-present to check the real argument that
we're
    getting from the user.
   =20
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/configure.ac b/configure.ac
index d8f949a..931dbe1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -23,8 +23,8 @@ AC_DEFINE([_GNU_SOURCE], [], [Enable various GNU
extensions])
 AC_DEFINE([_STDC_FORMAT_MACROS], [], [printf-style format macros])
=20
 AC_ARG_ENABLE([debug],
-             AS_HELP_STRING([--enable-debug], [Enable debugging]),
-             [with_debug=3Dno],
+             AS_HELP_STRING([--enable-debug], [Disable debugging]),
+             AS_IF([test "x$enable_debug" =3D "xno"], [with_debug=3Dno=
],
[with_debug=3Dyes]),
              [with_debug=3Dyes])
 AC_SUBST(with_debug)
 AM_CONDITIONAL([BUILD_DEBUG], [test "x$with_debug" !=3D xno])

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

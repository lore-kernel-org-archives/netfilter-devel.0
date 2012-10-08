From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: static build breakage - 1.4.16.2.
Date: Tue, 9 Oct 2012 00:04:56 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1210090002380.21001@nerf07.vanv.qr>
References: <CAHo-Ooy1C9kV2NT=R8vTnaDccHnenkC1Scm+W0NrjgN1iUsvsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:51212 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab2JHWFA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:05:00 -0400
In-Reply-To: <CAHo-Ooy1C9kV2NT=R8vTnaDccHnenkC1Scm+W0NrjgN1iUsvsQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2012-10-08 23:04, Maciej =C5=BBenczykowski wrote:
>
>Not entirely clear what's breaking, but:
>
>./configure --enable-static --disable-shared --enable-ipv4 --enable-ip=
v6
>
>make[3]: *** No rule to make target `libxt_NOTRACK.o', needed by
>`libext.a'.  Stop.
>

(N.B. You can have both --enable-static and --enable-shared)

This patch seems to do it for me. Ok for you?

origin git://git.inai.de/iptables master
parent c1a150c98fc94858a440550f0cb347a6060ebb30 (v1.4.16.2)
commit 13527271f1db3c0576ab47b84e85d979f56281a6
Author: Jan Engelhardt <jengelh@inai.de>
Date:   Mon Oct 8 23:56:12 2012 +0200

build: remove symlink-only extensions from static object list

$ ./configure --enable-static --disable-shared --enable-ipv4
  --enable-ipv6 && make
[...]
make[3]: *** No rule to make target "libxt_NOTRACK.o", needed by
"libext.a". Stop.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/GNUmakefile.in |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 8b38df9..1cef239 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -39,7 +39,7 @@ endif
 #	Wildcard module list
 #
 pfx_build_mod :=3D $(patsubst ${srcdir}/libxt_%.c,%,$(sort $(wildcard =
${srcdir}/libxt_*.c)))
-pfx_build_mod +=3D NOTRACK state
+pfx_symlinks  :=3D NOTRACK state
 @ENABLE_IPV4_TRUE@ pf4_build_mod :=3D $(patsubst ${srcdir}/libipt_%.c,=
%,$(sort $(wildcard ${srcdir}/libipt_*.c)))
 @ENABLE_IPV6_TRUE@ pf6_build_mod :=3D $(patsubst ${srcdir}/libip6t_%.c=
,%,$(sort $(wildcard ${srcdir}/libip6t_*.c)))
 pfx_build_mod :=3D $(filter-out @blacklist_modules@,${pfx_build_mod})
@@ -48,7 +48,7 @@ pf6_build_mod :=3D $(filter-out @blacklist_modules@,$=
{pf6_build_mod})
 pfx_objs      :=3D $(patsubst %,libxt_%.o,${pfx_build_mod})
 pf4_objs      :=3D $(patsubst %,libipt_%.o,${pf4_build_mod})
 pf6_objs      :=3D $(patsubst %,libip6t_%.o,${pf6_build_mod})
-pfx_solibs    :=3D $(patsubst %,libxt_%.so,${pfx_build_mod})
+pfx_solibs    :=3D $(patsubst %,libxt_%.so,${pfx_build_mod} ${pfx_syml=
inks})
 pf4_solibs    :=3D $(patsubst %,libipt_%.so,${pf4_build_mod})
 pf6_solibs    :=3D $(patsubst %,libip6t_%.so,${pf6_build_mod})
=20
@@ -220,7 +220,7 @@ man_run    =3D \
 	done >$@;
=20
 matches.man: .initext.dd .initext4.dd .initext6.dd $(wildcard ${srcdir=
}/lib*.man)
-	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod} ${=
pf6_build_mod}))
+	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod} ${=
pf6_build_mod} ${pfx_symlinks}))
=20
 targets.man: .initext.dd .initext4.dd .initext6.dd $(wildcard ${srcdir=
}/lib*.man)
-	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod} ${=
pf6_build_mod}))
+	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod} ${=
pf6_build_mod} ${pfx_symlinks}))
--=20
# Created with git-export-patch
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

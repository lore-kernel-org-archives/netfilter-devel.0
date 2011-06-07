From: Jan Engelhardt <jengelh@medozas.de>
Subject: Installer, option fixes
Date: Tue,  7 Jun 2011 22:35:58 +0200
Message-ID: <1307478964-2034-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:39430 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564Ab1FGUgH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:36:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Here are a couple of fixes. I have also taken the liberty to move the
main code into a directory of its own to unclutter the toplevel directo=
ry.
This does not impact AFAICS.

With this in, it would be prudent to produce a 1.4.12.
=3D=3D=3D
The following changes since commit a1cd1f2a4a35427c68cd0d1bd2761d5be42b=
12b1:

  doc: fix trivial typo in libipt_SNAT (2011-06-01 02:35:28 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (4):
      src: move all libiptc pieces into its directory
      src: move all iptables pieces into a separate directory
      tests: add some sample rulesets to test save-restore cycle
      option: fix ignored negation before implicit extension loading

Maciej =C5=BBenczykowski (1):
      xtables-multi: fix absence of xml translator in IPv6-only builds

 .gitignore                                         |   15 --
 Makefile.am                                        |   78 +---------
 configure.ac                                       |    5 +-
 iptables/.gitignore                                |   14 ++
 iptables/Makefile.am                               |   67 ++++++++
 ip6tables-multi.h =3D> iptables/ip6tables-multi.h    |    0
 .../ip6tables-restore.8                            |    0
 .../ip6tables-restore.c                            |    0
 ip6tables-save.8 =3D> iptables/ip6tables-save.8      |    0
 ip6tables-save.c =3D> iptables/ip6tables-save.c      |    0
 .../ip6tables-standalone.c                         |    0
 ip6tables.8.in =3D> iptables/ip6tables.8.in          |    0
 ip6tables.c =3D> iptables/ip6tables.c                |    8 +-
 iptables-apply =3D> iptables/iptables-apply          |    0
 iptables-apply.8 =3D> iptables/iptables-apply.8      |    0
 iptables-multi.h =3D> iptables/iptables-multi.h      |    1 -
 iptables-restore.8 =3D> iptables/iptables-restore.8  |    0
 iptables-restore.c =3D> iptables/iptables-restore.c  |    0
 iptables-save.8 =3D> iptables/iptables-save.8        |    0
 iptables-save.c =3D> iptables/iptables-save.c        |    0
 .../iptables-standalone.c                          |    0
 iptables-xml.1 =3D> iptables/iptables-xml.1          |    0
 iptables-xml.c =3D> iptables/iptables-xml.c          |    4 +-
 iptables.8.in =3D> iptables/iptables.8.in            |    0
 iptables.c =3D> iptables/iptables.c                  |    4 +-
 iptables.xslt =3D> iptables/iptables.xslt            |    0
 xshared.c =3D> iptables/xshared.c                    |   12 +-
 xshared.h =3D> iptables/xshared.h                    |    2 +-
 xtables-multi.c =3D> iptables/xtables-multi.c        |    6 +-
 iptables/xtables-multi.h                           |    6 +
 xtables.c =3D> iptables/xtables.c                    |    0
 xtables.pc.in =3D> iptables/xtables.pc.in            |    0
 xtoptions.c =3D> iptables/xtoptions.c                |    0
 libiptc/.gitignore                                 |    1 +
 libiptc/Makefile.am                                |   12 ++
 libiptc.pc.in =3D> libiptc/libiptc.pc.in             |    0
 tests/options-ipv4.rules                           |   52 ++++++
 tests/options-most.rules                           |  172 ++++++++++++=
++++++++
 38 files changed, 352 insertions(+), 107 deletions(-)
 create mode 100644 iptables/.gitignore
 create mode 100644 iptables/Makefile.am
 rename ip6tables-multi.h =3D> iptables/ip6tables-multi.h (100%)
 rename ip6tables-restore.8 =3D> iptables/ip6tables-restore.8 (100%)
 rename ip6tables-restore.c =3D> iptables/ip6tables-restore.c (100%)
 rename ip6tables-save.8 =3D> iptables/ip6tables-save.8 (100%)
 rename ip6tables-save.c =3D> iptables/ip6tables-save.c (100%)
 rename ip6tables-standalone.c =3D> iptables/ip6tables-standalone.c (10=
0%)
 rename ip6tables.8.in =3D> iptables/ip6tables.8.in (100%)
 rename ip6tables.c =3D> iptables/ip6tables.c (99%)
 rename iptables-apply =3D> iptables/iptables-apply (100%)
 rename iptables-apply.8 =3D> iptables/iptables-apply.8 (100%)
 rename iptables-multi.h =3D> iptables/iptables-multi.h (83%)
 rename iptables-restore.8 =3D> iptables/iptables-restore.8 (100%)
 rename iptables-restore.c =3D> iptables/iptables-restore.c (100%)
 rename iptables-save.8 =3D> iptables/iptables-save.8 (100%)
 rename iptables-save.c =3D> iptables/iptables-save.c (100%)
 rename iptables-standalone.c =3D> iptables/iptables-standalone.c (100%=
)
 rename iptables-xml.1 =3D> iptables/iptables-xml.1 (100%)
 rename iptables-xml.c =3D> iptables/iptables-xml.c (99%)
 rename iptables.8.in =3D> iptables/iptables.8.in (100%)
 rename iptables.c =3D> iptables/iptables.c (99%)
 rename iptables.xslt =3D> iptables/iptables.xslt (100%)
 rename xshared.c =3D> iptables/xshared.c (96%)
 rename xshared.h =3D> iptables/xshared.h (97%)
 rename xtables-multi.c =3D> iptables/xtables-multi.c (93%)
 create mode 100644 iptables/xtables-multi.h
 rename xtables.c =3D> iptables/xtables.c (100%)
 rename xtables.pc.in =3D> iptables/xtables.pc.in (100%)
 rename xtoptions.c =3D> iptables/xtoptions.c (100%)
 create mode 100644 libiptc/.gitignore
 create mode 100644 libiptc/Makefile.am
 rename libiptc.pc.in =3D> libiptc/libiptc.pc.in (100%)
 create mode 100644 tests/options-ipv4.rules
 create mode 100644 tests/options-most.rules
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

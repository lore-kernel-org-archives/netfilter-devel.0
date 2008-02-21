From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [announce] Xtables, Xtables-addons 1.5.1 and Writing Xtables Modules
Date: Thu, 21 Feb 2008 20:37:19 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802211742431.26109@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46865 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760546AbYBUThV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:37:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello everyone,


I have released =E2=80=9CXtables=E2=80=9D 1.5.1, which is a package of =
my ongoing
iptables development=C2=B9 that I did lately. Patrick McHardy was not
available last week to merge patches due to higher powers, so I
branched off the iptables subversion trunk into git since quilting on
top of svn was not so fun.

Xtables, that is the goal sought, will merge and unify arptables and=20
ebtables=C2=B2 as becomes possible.

What will now become of the iptables and xtables packages? Xtables
clearly is "more recent" than the latest iptables svn, but I would
not want to do Xtables as a continuous parallel fork to iptables=C2=B3.
Maybe merge=E2=81=B4 or declare it the new official thing -- who knows.

Additionally, =E2=80=9CXtables-addons=E2=80=9D 1.5.1 was released, whic=
h is supposed
to supersede patch-o-matic(-ng). As with POM, this package contains
not-so-officially-approved extensions. But different from POM is that
it does not (and will not) contain any "patches" that would require
patching the kernel. Just extensions that can be compiled and then
run instantly.

=46urthermore, I would like to make aware of =E2=80=9CWriting your own =
Xtables
module=E2=80=9D document, which describes the code needed to get starte=
d with
your own xtables modules. It is based upon Nicolas's earlier "Writing
your own iptables module"
 . . . . . . . http://jengelh.hopto.org/documents/Writing_Xtables.pdf

URLs:
tarballs . . . http://dev.computergmbh.de/files/xtables/
gitweb . . . . http://dev.computergmbh.de/gitweb.cgi?p=3Dxtables
 . . . . . . . http://dev.computergmbh.de/gitweb.cgi?p=3Dxtables-addons
gitclone . . . git://dev.computergmbh.de/xtables
 . . . . . . . git://dev.computergmbh.de/xtables-addons

SRPM for reference how to build it in an automatic environment
 . . . . . . . http://ftp.gwdg.de/pub/linux/misc/suser-jengelh/SRPMS/
RPMs (SUSE). . http://ftp.gwdg.de/pub/linux/misc/suser-jengelh/SUSE-10.=
3/



=C2=B9It is supposed to be stable.
=C2=B2FAQ: On a source base. User-visible commands like ip6tables remai=
n.
=C2=B3Read: merging forth and back between iptables-svn and xtables-git=
 =3D
not good.
=E2=81=B4There were talks about moving the iptables subversion reposito=
ry to
git, but I could not wait for you guys, sorry ;-)
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jan Engelhardt <jengelh@medozas.de>
Subject: Xtables-addons 1.18 released
Date: Wed, 9 Sep 2009 17:54:17 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909091747080.23602@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jr+netfilter-devel@cedric.unob.cz
To: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi everyone,


Coinciding with the imminent release of Linux kernel 2.6.31, here is
Xtables-addons 1.18. Of the numerous submissions I have received
recently (thank you!), I got to merge the "ACCOUNT" and "psd"
modules. The rest still needs review, but did not want to hold up
some release here. There are also a number of fixes to the
(already-existing) quota2 match=C2=A0=E2=80=94 which can be used for sm=
all-scale
accounting too.

Boilerplate:
http://downloads.sf.net/xtables-addons/xtables-addons-1.18.tar.bz2 {,.a=
sc}

REMINDER that the Sourceforge GIT URL changed due to multi-repo support=
=2E
The new one is:
git://xtables-addons.git.sf.net/gitroot/xtables-addons/xtables-addons

If in doubt, just visit the frontpage at
http://xtables-addons.sf.net/

From: Jan Engelhardt <jengelh@medozas.de>
Subject: pom: remove superseded patchlets
Date: Sat, 16 Jan 2010 22:52:30 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1001162247110.4057@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Nicolas Bouliane <acidfu@netfilter.org>, max@nucleus.it,
	ole@ans.pl, frozenspot@gmail.com
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46324 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab0APVwc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jan 2010 16:52:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


People are still on the old trail. Another attempt at reducing the
pitfalls with /svn/patch-o-matic-ng.


---=E2=9C=82---
Remove patchlets that have been merged into Xtables-addons

All deleted modules have either been merged upstream in the kernel,
or merged into Xtables-addons with the authors' consent, and have
been improved from there. We should not been offering outdated
versions. It happens that people still run across this.

diff -dpru patch-o-matic-ng-20100115~/sources.list patch-o-matic-ng-201=
00115/sources.list
--- patch-o-matic-ng-20100115~/sources.list	2010-01-15 23:55:58.0000000=
00 +0100
+++ patch-o-matic-ng-20100115/sources.list	2010-01-16 22:45:32.20296535=
4 +0100
@@ -1,17 +1,5 @@
 # Add the URLs for external patchlets here
 #=20
=20
-# geoip, maintained by Nicolas Bouliane <nicboul@gmail.com>
-http://people.netfilter.org/acidfu/patchlets/
-
-# condition, maintained by Massimiliano Hofer <max@nucleus.it>
-http://www.nucleus.it/pom-repo
-
-# ipp2p, time, IPMARK and connlimit maintained by Krzysztof Oledzki <o=
le@ans.pl>
-http://people.netfilter.org/ole/pom/
-
 # ACCOUNT, maintained by Intra2net AG <opensource@intra2net.com>
 http://www.intra2net.com/en/developer/ipt_ACCOUNT/download/
-
-# Portknocking and SPA (J. Federico Hernandez <frozenspot@gmail.com>)
-http://svn.berlios.de/svnroot/repos/portknocko/trunk/pom/
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

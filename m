From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnl buildsys updates
Date: Sun,  5 Jul 2009 18:08:44 +0200
Message-ID: <1246810126-23428-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: tgraf@suug.ch
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48989 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbZGEQIp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jul 2009 12:08:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Please pull from
	git://dev.medozas.de/libnl master

to receive

Jan Engelhardt (2):
      Move to automake-based build
      build: make use of library dependencies

 .gitignore          |   35 ++-
 Makefile            |   63 ----
 Makefile.am         |   11 +
 Makefile.opts.in    |   40 ---
 Makefile.rules      |   37 ---
 aclocal.m4          |  831 ---------------------------------------------------
 autogen.sh          |    4 +
 configure.in        |   30 +-
 doc/Makefile        |   35 ---
 doc/Makefile.am     |    9 +
 include/Makefile    |   42 ---
 include/Makefile.am |   67 ++++
 install-sh          |  294 ------------------
 lib/Makefile        |  103 -------
 lib/Makefile.am     |   43 +++
 lib/defs.h.in       |   25 --
 libnl-2.0.pc.in     |    4 +-
 m4/.gitignore       |    2 +
 src/Makefile        |   62 ----
 src/Makefile.am     |   86 ++++++
 20 files changed, 264 insertions(+), 1559 deletions(-)

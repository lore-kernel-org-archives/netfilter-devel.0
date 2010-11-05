From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnfnetlink build updates 2
Date: Fri,  5 Nov 2010 18:34:12 +0100
Message-ID: <1288978456-15380-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58448 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab0KEReU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:34:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 01a7a3bddd5a6dd21cf23c2e8b097abd935ad15a:

  Add .gitignore files (2010-10-30 23:45:17 +0200)

are available in the git repository at:
  git://dev.medozas.de/libnfnetlink master

Jan Engelhardt (3):
      build: use AC_OUTPUT
      build: default to not building static libraries
      Remove distro-specific parts

 configure.ac                    |    5 ++++-
 debian/changelog                |   17 -----------------
 debian/control                  |   23 -----------------------
 debian/copyright                |    9 ---------
 debian/libnfnetlink-dev.install |    2 --
 debian/libnfnetlink0.install    |    1 -
 debian/rules                    |   17 -----------------
 7 files changed, 4 insertions(+), 70 deletions(-)
 delete mode 100644 debian/changelog
 delete mode 100644 debian/control
 delete mode 100644 debian/copyright
 delete mode 100644 debian/libnfnetlink-dev.install
 delete mode 100644 debian/libnfnetlink0.install
 delete mode 100755 debian/rules

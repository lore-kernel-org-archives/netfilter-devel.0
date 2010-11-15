From: Jan Engelhardt <jengelh@medozas.de>
Subject: iproute2: use automake
Date: Mon, 15 Nov 2010 23:23:02 +0100
Message-ID: <1289859785-3098-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: stephen.hemminger@vyatta.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43333 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997Ab0KOWXH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:23:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 3f5c1a01e6bc15593635705aa0b19dcac965be26:

  Update to 2.6.36 headers (2010-10-20 17:38:04 -0700)

are available in the git repository at:
  git://dev.medozas.de/iproute2 master

Jan Engelhardt (2):
      Fix up permissions on scripts
      build: start using Automake for building

 .gitignore                             |   42 ++++----
 Makefile                               |   89 ----------------
 Makefile.am                            |   36 +++++++
 autogen.sh                             |    4 +
 configure                              |  180 --------------------------------
 configure.ac                           |   55 ++++++++++
 doc/{Makefile => Makefile.am}          |   28 ++---
 genl/Makefile                          |   38 -------
 genl/Makefile.am                       |    8 ++
 ip/Makefile                            |   43 --------
 ip/Makefile.am                         |   17 +++
 ip/iplink.c                            |    6 +-
 lib/Makefile                           |   19 ----
 lib/Makefile.am                        |   13 +++
 lib/rt_names.c                         |   10 +-
 m4/.gitignore                          |    2 +
 misc/.gitignore                        |   16 ++--
 misc/Makefile                          |   35 ------
 misc/Makefile.am                       |   19 ++++
 netem/.gitignore                       |   11 +-
 netem/Makefile                         |   29 -----
 netem/Makefile.am                      |   23 ++++
 tc/.gitignore                          |   11 +-
 tc/Makefile                            |  144 -------------------------
 tc/Makefile.am                         |   44 ++++++++
 tc/{emp_ematch.l => emp_ematch_lex.l}  |    2 +-
 tc/{emp_ematch.y => emp_ematch_yacc.y} |    0
 tc/q_netem.c                           |    2 +-
 tc/tc_util.c                           |   14 ++-
 tc/tc_util.h                           |    1 +
 30 files changed, 292 insertions(+), 649 deletions(-)
 delete mode 100644 Makefile
 create mode 100644 Makefile.am
 create mode 100755 autogen.sh
 delete mode 100755 configure
 create mode 100644 configure.ac
 rename doc/{Makefile => Makefile.am} (61%)
 mode change 100644 => 100755 doc/do-psnup
 delete mode 100644 genl/Makefile
 create mode 100644 genl/Makefile.am
 delete mode 100644 ip/Makefile
 create mode 100644 ip/Makefile.am
 mode change 100644 => 100755 ip/ifcfg
 mode change 100644 => 100755 ip/routef
 mode change 100644 => 100755 ip/routel
 mode change 100644 => 100755 ip/rtpr
 delete mode 100644 lib/Makefile
 create mode 100644 lib/Makefile.am
 create mode 100644 m4/.gitignore
 delete mode 100644 misc/Makefile
 create mode 100644 misc/Makefile.am
 delete mode 100644 netem/Makefile
 create mode 100644 netem/Makefile.am
 delete mode 100644 tc/Makefile
 create mode 100644 tc/Makefile.am
 rename tc/{emp_ematch.l => emp_ematch_lex.l} (99%)
 rename tc/{emp_ematch.y => emp_ematch_yacc.y} (100%)

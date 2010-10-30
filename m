From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_conntrack: build system cleanup
Date: Sun, 31 Oct 2010 00:08:14 +0200
Message-ID: <1288476502-18721-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46340 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab0J3WJC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:09:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit f52f7122c72515b21472e72f99b5fd7c0060dc87:

  conntrack: fix independent metadata checkings in XML output (2010-10-28 16:56:42 +0200)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_conntrack master

Jan Engelhardt (7):
      build: set Libs.private for pkgconfig file
      build: use sh -e, remove autom4te.cache
      build: remove statements without effect
      build: remove unused $(all_includes)
      build: remove -fPIC flag
      build: no need for error message in PKG_CHECK_MODULES
      Update .gitignore

 Make_global.am               |    2 +-
 Makefile.am                  |    4 ----
 autogen.sh                   |    3 ++-
 configure.ac                 |   13 -------------
 libnetfilter_conntrack.pc.in |    1 +
 qa/.gitignore                |    2 ++
 src/Makefile.am              |    6 +++---
 src/conntrack/Makefile.am    |    3 +--
 src/expect/Makefile.am       |    3 +--
 utils/.gitignore             |   18 ++++++++++++++++++
 10 files changed, 29 insertions(+), 26 deletions(-)
 create mode 100644 qa/.gitignore
 create mode 100644 utils/.gitignore

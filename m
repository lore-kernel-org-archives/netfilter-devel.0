From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: build updates and fixes
Date: Fri, 30 Dec 2011 02:34:55 +0100
Message-ID: <1325208902-2014-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40844 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab1L3BfH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:35:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit b8c42eca0f224a00bf55b60ded81af14a1e07da1:
  libiptc: provide separate pkgconfig files (2011-12-18 02:52:32 +0100)

are available FOR REVIEW in the git repository at:
  git://dev.medozas.de/iptables stable

Jan Engelhardt (6):
      Update .gitignore
      build: use AC_CONFIG_AUX_DIR and stash away tools
      Update .gitignore
      build: use delayed expansion on the user-settable variables
      extensions: link on libxtables and check symbols
      nfnl_osf: add missing libnfnetlink_CFLAGS to compile process

 .gitignore                |   27 ++++-----------------
 configure.ac              |   11 +++++++++
 extensions/.gitignore     |    9 +++++++
 extensions/GNUmakefile.in |   56 +++++++++++++++++++-------------------------
 utils/Makefile.am         |    3 +-
 5 files changed, 51 insertions(+), 55 deletions(-)
 create mode 100644 extensions/.gitignore

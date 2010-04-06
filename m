From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables pull: osf and misc
Date: Tue,  6 Apr 2010 12:52:38 +0200
Message-ID: <1270551164-2945-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36842 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0DFKwt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:52:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 21d1283750d9c4df7ca80165d2b9dc0b9bd214eb:
  Jan Engelhardt (1):
        iptables: correctly check for too-long chain/target/match names

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (5):
      doc: libxt_MARK: no longer restricted to mangle table
      doc: remove claim that TCPMSS is limited to mangle
      libxt_recent: add a missing space in output
      doc: add manpage for libxt_osf
      libxt_osf: import nfnl_osf program

 Makefile.am                 |    2 +-
 configure.ac                |    6 +-
 extensions/libxt_MARK.man   |    7 +-
 extensions/libxt_TCPMSS.man |    5 +-
 extensions/libxt_osf.c      |    4 +-
 extensions/libxt_osf.man    |   45 +++
 extensions/libxt_recent.c   |    2 +-
 utils/.gitignore            |    1 +
 utils/Makefile.am           |    6 +
 utils/nfnl_osf.c            |  485 ++++++++++++++++++++++++++++++
 utils/pf.os                 |  687 +++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 1238 insertions(+), 12 deletions(-)
 create mode 100644 extensions/libxt_osf.man
 create mode 100644 utils/.gitignore
 create mode 100644 utils/Makefile.am
 create mode 100644 utils/nfnl_osf.c
 create mode 100644 utils/pf.os

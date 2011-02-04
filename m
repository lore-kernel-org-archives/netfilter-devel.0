From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: mainloop cleanup, symbol vis+versioning
Date: Fri,  4 Feb 2011 14:08:46 +0100
Message-ID: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36760 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab1BDNI4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:08:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 9ee2a9fe2f74b616da34878104bd1ff406534ad1:

  extensions: add extension for devgroup match (2011-02-03 06:10:41 +0100)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (8):
      iptables: reduce indentation of parse loop (1/3)
      iptables: reduce indentation of parse loop (2/3)
      iptables: use variable as shortcut in parse loop
      iptables: reduce indentation of parse loop (3/3)
      iptables: fix error message for unknown options
      build: directly use config.h in internal.h
      libxtables: symbol visibility
      libxtables: symbol versioning

 .gitignore                     |    1 -
 Makefile.am                    |    9 +-
 configure.ac                   |    6 +-
 extensions/GNUmakefile.in      |    2 +-
 include/iptables/internal.h    |   21 +++++
 include/iptables/internal.h.in |   13 ---
 ip6tables.c                    |  187 ++++++++++++++++++---------------------
 iptables.c                     |  194 ++++++++++++++++++----------------------
 libxtables.map                 |   55 +++++++++++
 m4/gcc4_visibility.m4          |   21 +++++
 xtables.c                      |  109 +++++++++++++----------
 11 files changed, 340 insertions(+), 278 deletions(-)
 create mode 100644 include/iptables/internal.h
 delete mode 100644 include/iptables/internal.h.in
 create mode 100644 libxtables.map
 create mode 100644 m4/gcc4_visibility.m4

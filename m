From: Jan Engelhardt <jengelh@medozas.de>
Subject: pull: misc nf bugfixes
Date: Wed, 15 Sep 2010 20:53:43 +0200
Message-ID: <1284576828-32412-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46812 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab0IOSxx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:53:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>




Again I went through the bugzilla and shelve off some bugreports.
Please apply.


The following changes since commit 0428e5a6541c3f5eaaf683d8da9ea60c44eac4c7:

  build: fix static linking (2010-08-03 19:58:38 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (4):
      iptables-xml: resolve compiler warnings
      iptables: limit chain name length to be consistent with targets
      libiptc: build with -Wl,--no-as-needed
      libiptc: add Libs.private to pkgconfig files

 Makefile.am                 |    4 +-
 configure.ac                |    5 +++
 ip6tables.c                 |    6 ++--
 iptables-xml.c              |    2 +-
 iptables.c                  |    6 ++--
 libiptc.pc.in               |    1 +
 m4/ax_check_linker_flags.m4 |   78 +++++++++++++++++++++++++++++++++++++++++++
 xtables.pc.in               |    1 +
 8 files changed, 94 insertions(+), 9 deletions(-)
 create mode 100644 m4/ax_check_linker_flags.m4

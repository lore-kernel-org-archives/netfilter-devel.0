From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables build fixes
Date: Mon,  8 Aug 2011 02:42:16 +0200
Message-ID: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44401 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab1HHAm1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Aug 2011 20:42:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 88e0a097c3f23dadf041b60445c6c9802c502f15:

  Merge branch 'master' of git://dev.medozas.de/iptables (2011-07-11 10:41:10 +0200)

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (7):
      extensions: use multi-target registration
      libxt_TCPMSS: restore build with IPv6-less libcs
      libxt_string: define _GNU_SOURCE for strnlen
      build: workaround broken linux-headers on RHEL-5
      build: strengthen check for overlong lladdr components
      build: abort autogen on subcommand failure
      libipq: add pkgconfig file

 autogen.sh                |    2 +-
 configure.ac              |    4 ++-
 extensions/GNUmakefile.in |    2 +-
 extensions/libxt_TCPMSS.c |   62 ++++++++++++++++++++++----------------------
 extensions/libxt_TEE.c    |   56 ++++++++++++++++++++--------------------
 extensions/libxt_string.c |    1 +
 iptables/xtables.c        |    2 +
 iptables/xtoptions.c      |    4 +-
 libipq/.gitignore         |    1 +
 libipq/Makefile.am        |    2 +
 libipq/libipq.pc.in       |   11 ++++++++
 11 files changed, 83 insertions(+), 64 deletions(-)
 create mode 100644 libipq/.gitignore
 create mode 100644 libipq/libipq.pc.in

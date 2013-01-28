From: Jan Engelhardt <jengelh@inai.de>
Subject: Accumulated fixes v2
Date: Mon, 28 Jan 2013 14:59:40 +0100
Message-ID: <1359381586-11940-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:37332 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339Ab3A1N7s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 08:59:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 166f20a3665a28e0f5fcedd0914c8e7d41521428:

  doc: document nat table for IPv6 (2013-01-28 12:38:21 +0100)

are available in the git repository at:

  git://git.inai.de/iptables master

for you to fetch changes up to 22a75444ef99f72235ef31ae516c15999e268b04:

  iptables: reword warning on using an alias (2013-01-28 14:39:00 +0100)

----------------------------------------------------------------
Jan Engelhardt (6):
      build: also use libtool for install stage
      build: do not dereference symlinks on installation
      libxtables: centralize checking for a .save function
      extensions: eui64: set userspacesize=0
      iptables: fall back to using save function when print is not defined
      iptables: reword warning on using an alias

 extensions/GNUmakefile.in   |   21 +++++++++++++++------
 extensions/libip6t_eui64.c  |    2 +-
 extensions/libxt_standard.c |   14 ++++++++++++++
 iptables/ip6tables.c        |   31 +++++++++++++------------------
 iptables/iptables.c         |   31 +++++++++++++------------------
 libxtables/xtables.c        |   21 +++++++++++++++++++++
 tests/options-most.rules    |    2 ++
 7 files changed, 79 insertions(+), 43 deletions(-)

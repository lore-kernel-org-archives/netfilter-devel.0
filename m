From: Jan Engelhardt <jengelh@inai.de>
Subject: Extension alias support
Date: Fri, 28 Sep 2012 00:48:22 +0200
Message-ID: <1348786109-20894-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:56151 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962Ab2I0Wsc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:48:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This is the newest round of the alias support.
Difference to the previous submission is that now, "NOTRACK" will
also work when the replacement ("CT") is not available.
I also added 5 new patches around it:

new 1/7: to make my new automake happy
new 2/7: to make developers happier
new 3/7: cleanup
refreshed 4/7: removed ->real_revision, this is not needed
refreshed 5/7: support all NOTRACK constellations
new 6/7: match aliases
new 7/7: state is an alias for conntrack

Please give it a spin.

----
The following changes since commit 3abf5cc5ac0c32eba2436567d25e175d7e0f42bc:

  libxt_tcp: print space before, not after "flags:" (2012-08-21 12:29:44 +0200)

are available in the git repository at:

  git://git.inai.de/iptables master

for you to fetch changes up to 60343c195e5d171b5139a6580d1b6b478e183a00:

  libxt_state: replace as an alias to xt_conntrack (2012-09-28 00:37:00 +0200)

----------------------------------------------------------------
Jan Engelhardt (7):
      build: support for automake-1.12
      build: separate AC variable replacements from xtables.h
      libxtables: consolidate preference logic
      iptables: support for target aliases
      libxt_NOTRACK: replace as an alias to CT --notrack
      iptables: support for match aliases
      libxt_state: replace as an alias to xt_conntrack

 .gitignore                          |    2 +-
 Makefile.am                         |    2 +-
 configure.ac                        |    7 +-
 extensions/GNUmakefile.in           |    7 +-
 extensions/libxt_CT.c               |   40 ++++++++
 extensions/libxt_NOTRACK.c          |   15 ---
 extensions/libxt_conntrack.c        |  189 +++++++++++++++++++++++++++++++++++
 extensions/libxt_state.c            |  137 -------------------------
 include/Makefile.am                 |    2 +-
 include/xtables-version.h.in        |    2 +
 include/{xtables.h.in => xtables.h} |    7 +-
 iptables/ip6tables.c                |   13 ++-
 iptables/iptables.c                 |   14 ++-
 libxtables/xtables.c                |   95 ++++++++++++++----
 14 files changed, 349 insertions(+), 183 deletions(-)
 delete mode 100644 extensions/libxt_NOTRACK.c
 delete mode 100644 extensions/libxt_state.c
 create mode 100644 include/xtables-version.h.in
 rename include/{xtables.h.in => xtables.h} (99%)

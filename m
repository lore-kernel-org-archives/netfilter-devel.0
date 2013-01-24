From: Jan Engelhardt <jengelh@inai.de>
Subject: Accumulated fixes
Date: Thu, 24 Jan 2013 20:37:50 +0100
Message-ID: <1359056278-27618-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:40464 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab3AXTiH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:38:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 983196ceb4d3bb7b6d3cf6da18bb6d5a5eafb347:

  doc: document the -4 and -6 options (2013-01-07 02:26:16 +0100)

are available in the git repository at:

  git://git.inai.de/iptables master

for you to fetch changes up to 4ce010a66d8479521a5f2cfc94fbaa232163f80c:

  build: fix libiptc build failure on old linux-glibc-devel headers (2013-01-24 20:36:18 +0100)

----------------------------------------------------------------
Jan Engelhardt (8):
      build: also use libtool for install stage
      build: do not dereference symlinks on installation
      libxtables: centralize checking for a .save function
      extensions: eui64: set userspacesize=0
      extensions: S/DNPT: add missing save function
      iptables: fall back to using save function when print is not defined
      iptables: reword warning on using an alias
      build: fix libiptc build failure on old linux-glibc-devel headers

 extensions/GNUmakefile.in   |   21 +++++++++++++++------
 extensions/libip6t_DNPT.c   |   19 +++++++++++++++++++
 extensions/libip6t_SNPT.c   |   19 +++++++++++++++++++
 extensions/libip6t_eui64.c  |    2 +-
 extensions/libxt_standard.c |    6 ++++++
 iptables/ip6tables.c        |   33 +++++++++++++++------------------
 iptables/iptables.c         |   31 +++++++++++++------------------
 libiptc/linux_list.h        |    4 ++--
 libiptc/linux_stddef.h      |    4 ++--
 libxtables/xtables.c        |   21 +++++++++++++++++++++
 tests/options-most.rules    |    2 ++
 11 files changed, 115 insertions(+), 47 deletions(-)

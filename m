From: Jan Engelhardt <jengelh@inai.de>
Subject: Save funcs, installation, const
Date: Tue,  5 Mar 2013 02:08:10 +0100
Message-ID: <1362445695-15952-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45710 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758884Ab3CEBIR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:08:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit d797d0ff0338d2938d18b03038d6f4455b000579:

  build: bump version to 1.4.18 (2013-03-03 22:40:11 +0100)

are available in the git repository at:

  git://git.inai.de/iptables master

for you to fetch changes up to 8b83282ec032ecf643f2f47cd86a3f2c5991d10a:

  libxtables: constify xtables_option_[mt]fcall argument (2013-03-05 02:05:46 +0100)

----------------------------------------------------------------
Jan Engelhardt (5):
      libxtables: centralize checking for a .save function
      extensions: eui64: set userspacesize=0
      iptables: fall back to using save function when print is not defined
      build: do not dereference symlinks on installation
      libxtables: constify xtables_option_[mt]fcall argument

 extensions/GNUmakefile.in   |   15 ++++++++++-----
 extensions/libip6t_eui64.c  |    2 +-
 extensions/libxt_standard.c |   14 ++++++++++++++
 include/xtables.h           |    4 ++--
 iptables/ip6tables.c        |   22 ++++++++--------------
 iptables/iptables.c         |   22 ++++++++--------------
 libxtables/xtables.c        |   21 +++++++++++++++++++++
 libxtables/xtoptions.c      |    4 ++--
 tests/options-most.rules    |    2 ++
 9 files changed, 68 insertions(+), 38 deletions(-)

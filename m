From: Jan Engelhardt <jengelh@inai.de>
Subject: Assorted fixes v3
Date: Wed,  6 Feb 2013 01:47:01 +0100
Message-ID: <1360111625-1759-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:58913 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330Ab3BFArJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Feb 2013 19:47:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Removed
  build: also use libtool for install stage
  iptables: reword warning on using an alias
Added:
  build: bump SONAME for libxtables

===
The following changes since commit 817ac5a5e54d083983b7c834194b46c4366d71d2:

  Merge branch 'master' of vishnu.netfilter.org:/data/git/iptables (2013-01-31 20:36:27 +0100)

are available in the git repository at:


  git://git.inai.de/iptables master

for you to fetch changes up to 80722f5b0c2723d34782affec7dc247352d9be33:

  iptables: fall back to using save function when print is not defined (2013-02-06 01:40:43 +0100)

----------------------------------------------------------------
Jan Engelhardt (4):
      build: bump SONAME for libxtables
      libxtables: centralize checking for a .save function
      extensions: eui64: set userspacesize=0
      iptables: fall back to using save function when print is not defined

 configure.ac                |    2 +-
 extensions/libip6t_eui64.c  |    2 +-
 extensions/libxt_standard.c |   14 ++++++++++++++
 iptables/ip6tables.c        |   22 ++++++++--------------
 iptables/iptables.c         |   22 ++++++++--------------
 libxtables/xtables.c        |   21 +++++++++++++++++++++
 tests/options-most.rules    |    2 ++
 7 files changed, 55 insertions(+), 30 deletions(-)

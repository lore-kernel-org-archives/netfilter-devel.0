From: Jan Engelhardt <jengelh@medozas.de>
Subject: (unknown)
Date: Sat, 25 Jul 2009 22:22:38 +0200
Message-ID: <1248553363-26903-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55091 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbZGYUWq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Jul 2009 16:22:46 -0400
Subject: 
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi Patrick,

Please pull from
	git://dev.medozas.de/iptables master

which contains a pack of patches to build iptables without libdl,
obsoleting iptables-static (leaving -multi) and using the -multi
program exclusively.

Jan Engelhardt (5):
      build: order of dependent libs is sensitive
      multi binary: allow subcommand via argv[1]
      build: fix struct size mismatch
      build: combine iptables-multi and iptables-static
      build: build only iptables-multi

 INSTALL                   |   41 ++++++++++++++++------
 Makefile.am               |   84 ++++++++++++++-------------------------------
 extensions/GNUmakefile.in |    4 +-
 include/xtables.h.in      |    6 +---
 ip6tables-multi.c         |   53 +++++++++++++++++-----------
 ip6tables-restore.c       |    2 +-
 ip6tables-save.c          |    2 +-
 ip6tables-standalone.c    |    2 +-
 iptables-multi.c          |   60 ++++++++++++++++++++------------
 iptables-restore.c        |    2 +-
 iptables-save.c           |    2 +-
 iptables-standalone.c     |    2 +-
 12 files changed, 135 insertions(+), 125 deletions(-)

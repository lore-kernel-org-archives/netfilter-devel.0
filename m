From: Jan Engelhardt <jengelh@medozas.de>
Subject: [pull] fixes to bz items
Date: Fri, 3 Apr 2009 23:01:47 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904032254260.8946@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52045 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbZDCVBu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:01:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


Please pull from
	git://dev.medozas.de/iptables master
to receive fixes to bug reports told via e-mail and the Netfilter 
bugzilla.

Jan Engelhardt (5):
      libxtables: reorder .version member
      build: do not run ldconfig for DESTDIR installations
      build: add configure option to disable ip6tables
      build: add configure option to disable ipv4 iptables
      libxtables: provide IPv6 zero address variable

Updating cdf51d0..9c0fa7d
Fast forward
 Makefile.am               |   20 ++++++++++++++------
 configure.ac              |   10 +++++++++-
 extensions/GNUmakefile.in |    4 ++--
 include/xtables.h.in      |   16 +++++++++++++---
 xtables.c                 |    3 ++-
 5 files changed, 40 insertions(+), 13 deletions(-)

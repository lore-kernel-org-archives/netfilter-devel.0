From: jengelh@medozas.de
Subject: pull request
Date: Wed, 11 Feb 2009 16:03:28 +0100
Message-ID: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48685 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346AbZBKPDj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:03:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Please pull from
	git://dev.medozas.de/iptables master
to recive
Jan Engelhardt (8):
      libxtables: recognize IP6TABLES_LIB_DIR old-style environment variable
      build: move -ldl to proper LDADD
      libxtables: remove unused XT_LIB_DIR macro
      libxtables: decouple non-xtables parts from header
      src: remove iptables_rule_match indirection macro
      src: remove unused ipt_tryload macro
      libxtables: move compat defines to xtables.c
      src: consolidate duplicate code in iptables/internal.h

 .gitignore                         |    2 +-
 Makefile.am                        |    8 +-
 configure.ac                       |    2 +-
 include/ip6tables.h                |   11 +---
 include/iptables.h                 |   11 +---
 include/iptables/internal.h.in     |   13 ++++
 include/linux/netfilter/xt_NFLOG.h |    2 +-
 include/xtables.h.in               |   22 +++-----
 include/xtables/internal.h.in      |   17 ------
 ip6tables.c                        |   35 ++++-------
 iptables-xml.c                     |   19 ++++--
 iptables.c                         |   37 ++++--------
 xtables.c                          |  111 +++++++++++++-----------------------
 13 files changed, 108 insertions(+), 182 deletions(-)

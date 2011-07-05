From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables fixes 20110705
Date: Tue,  5 Jul 2011 15:14:37 +0200
Message-ID: <1309871682-27307-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:42313 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab1GENOs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:14:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 411b390f3ffcd4708a0dfc0f2824a637de511cea:

  Merge branch 'master' of git://dev.medozas.de/iptables (2011-06-30 13:35:56 +0200)

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (4):
      build: install modules in arch-dependent location
      doc: fix version string in ip6tables.8
      doc: the -m option cannot be inverted
      iptables: restore negation for -f

 INSTALL                 |    2 +-
 configure.ac            |    2 +-
 iptables/ip6tables.8.in |    5 +----
 iptables/iptables.8.in  |    3 ---
 iptables/iptables.c     |    2 +-
 5 files changed, 4 insertions(+), 10 deletions(-)

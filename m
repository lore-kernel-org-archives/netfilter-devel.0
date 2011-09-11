From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: restore -T option
Date: Sun, 11 Sep 2011 12:38:42 +0200
Message-ID: <1315737527-19595-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:56939 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab1IKKiw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Sep 2011 06:38:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Suggestion to merge this into 'stable'.

===
The following changes since commit 62fc25fd1625f0f65b9eed3e15fe929dd0aff2c5:

  Merge branch 'master' of git://dev.medozas.de/iptables (2011-09-08 17:00:49 +0200)

are available in the git repository at:

  git://dev.medozas.de/iptables stable

Jan Engelhardt (4):
      build: sort file list before build
      doc: fix undesired newline in ip6tables-restore(8)
      ip6tables-restore: implement missing -T option
      doc: document iptables-restore's -T option

 extensions/GNUmakefile.in    |   12 ++++++------
 iptables/ip6tables-restore.8 |    4 +++-
 iptables/ip6tables-restore.c |   11 ++++++++++-
 iptables/iptables-restore.8  |    5 ++++-
 4 files changed, 23 insertions(+), 9 deletions(-)

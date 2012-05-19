From: Jan Engelhardt <jengelh@inai.de>
Subject: libnetfilter_conntrack updates
Date: Sun, 20 May 2012 00:08:08 +0200
Message-ID: <1337465292-28924-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38046 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab2ESWIT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 May 2012 18:08:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 6fdd30fe6de1311022ae9e17304dd72f4958bbb8:

  build: bump version to 1.0.1 (2012-05-18 01:24:29 +0200)

are available in the git repository at:
  git://git.inai.de/libnetfilter_conntrack master

Jan Engelhardt (4):
      build: remove unused LDFLAGS
      qa: change an if to elseif
      build: remove unused -DLIBNETFILTER_CONNTRACK_DIR
      Update .gitignore

 configure.ac            |    5 -----
 qa/.gitignore           |    2 ++
 qa/Makefile.am          |    4 ----
 qa/ct_events_reliable.c |    2 +-
 utils/.gitignore        |    1 +
 utils/Makefile.am       |   20 --------------------
 6 files changed, 4 insertions(+), 30 deletions(-)

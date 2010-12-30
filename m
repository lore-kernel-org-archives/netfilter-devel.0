From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_queue: build improvements
Date: Fri, 31 Dec 2010 00:42:51 +0100
Message-ID: <1293752575-13611-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43814 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab0L3Xm5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:42:57 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit e07ff761686629a3a7cf5af67f281a5b6ce4d8c5:

  doc: fix wrong documentation on NFQNL_COPY_NONE (2010-12-07 10:06:21 +0100)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_queue master

Jan Engelhardt (3):
      build: remove unused LIBTOOL_DEPS
      build: create a Make_global.am file
      build: use -Wall across the entire source

 Make_global.am    |    2 ++
 configure.ac      |    2 --
 src/Makefile.am   |    3 +--
 utils/Makefile.am |    3 +--
 4 files changed, 4 insertions(+), 6 deletions(-)
 create mode 100644 Make_global.am

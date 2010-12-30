From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_log: build improvements
Date: Fri, 31 Dec 2010 00:42:11 +0100
Message-ID: <1293752536-13491-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43783 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab0L3XmR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:42:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 9ce233ad4377b609ecb8d3bb84036bb629f7b291:

  src: declare non-modified data as const (2010-12-21 20:54:42 +0100)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_log master

Jan Engelhardt (4):
      build: remove unused LIBTOOL_DEPS
      build: create a Make_global.am file
      build: use -Wall across the entire source
      utils: resolve compiler warnings

 Make_global.am      |    2 ++
 configure.ac        |    2 --
 src/Makefile.am     |    3 +--
 utils/Makefile.am   |    2 +-
 utils/nfulnl_test.c |    4 ++--
 utils/ulog_test.c   |    4 ++--
 6 files changed, 8 insertions(+), 9 deletions(-)
 create mode 100644 Make_global.am

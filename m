From: Jan Engelhardt <jengelh@medozas.de>
Subject: libmnl: build improvements
Date: Fri, 31 Dec 2010 00:43:24 +0100
Message-ID: <1293752607-13822-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43842 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab0L3Xn3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:43:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 091286e666a9d34818a875152ac7659b38656f06:

  build: libmnl 1.0.1 release (2010-12-26 21:17:54 +0100)

are available in the git repository at:
  git://dev.medozas.de/libmnl master

Jan Engelhardt (2):
      build: use AM_CPPFLAGS
      build: use only AC_CANONICAL_HOST

 Make_global.am |    2 +-
 configure.ac   |    9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

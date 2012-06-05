From: Jan Engelhardt <jengelh@inai.de>
Subject: ulogd: build fixes
Date: Tue,  5 Jun 2012 10:41:00 +0200
Message-ID: <1338885663-30131-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:54613 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760517Ab2FEIlI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jun 2012 04:41:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 5dc52c43c4d9e0e8a6813cdcd8e1d12a9f1e3fe8:

  build: use pkglibdir instead of pkglibexecdir for automake (2012-05-18 02:50:11 +0200)

are available in the git repository at:
  git://git.inai.de/ulogd master

Jan Engelhardt (3):
      sqlite: resolve compiler warnings
      nfacct: resolve build failure
      pcap: resolve unreliable detection

 configure.ac                          |    7 +++----
 input/sum/Makefile.am                 |    6 +++---
 output/pcap/Makefile.am               |    4 ++--
 output/sqlite3/ulogd_output_SQLITE3.c |    2 +-
 4 files changed, 9 insertions(+), 10 deletions(-)

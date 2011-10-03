From: Jan Engelhardt <jengelh@medozas.de>
Subject: snet-tools: AM building
Date: Mon,  3 Oct 2011 22:38:30 +0200
Message-ID: <1317674312-20531-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: sam@synack.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:58315 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195Ab1JCUif (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:38:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 292938bd0764be0c5d24edceaa3a4081b0af16ad:

  Initial import from sam's source tarball (2011-10-03 22:35:41 +0200)

are available in the git repository at:
  git://dev.medozas.de/snet-tools master

Jan Engelhardt (1):
      build: use automake for building

 .gitignore   |   15 +++++++++++++++
 Makefile     |   24 ------------------------
 Makefile.am  |    7 +++++++
 autogen.sh   |    3 +++
 configure.ac |   10 ++++++++++
 5 files changed, 35 insertions(+), 24 deletions(-)
 create mode 100644 .gitignore
 delete mode 100644 Makefile
 create mode 100644 Makefile.am
 create mode 100755 autogen.sh
 create mode 100644 configure.ac

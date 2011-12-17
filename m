From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_queue: build updates
Date: Sat, 17 Dec 2011 16:36:31 +0100
Message-ID: <1324136195-7784-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59447 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab1LQPgh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:36:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 4b3d0a4763b440ef748d537d86f0869d09544ab2:

  src: add notes on NF_STOLEN and NF_REPEAT to documentation (2011-09-06 13:48:25 +0200)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_queue master

Jan Engelhardt (3):
      Update .gitignore
      build: use AC_CONFIG_AUX_DIR and stash away tools
      build: disable implicit .tar.gz archive generation and use POSIX mode

 .gitignore   |   12 ++++--------
 configure.ac |    4 +++-
 2 files changed, 7 insertions(+), 9 deletions(-)

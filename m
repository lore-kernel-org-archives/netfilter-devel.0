From: Jan Engelhardt <jengelh@inai.de>
Subject: libnetfilter_acct: ancient systems
Date: Sat, 13 Oct 2012 14:09:20 +0200
Message-ID: <1350130162-13193-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:60248 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab2JMMJ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Oct 2012 08:09:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Please review (and if ok, do merge).

===
The following changes since commit a5e394e469f7c3e4e40dd60da2ddc0294f485fdc:

  Partially revert "src: remove unnecessary castings" (2012-10-10 13:37:48 +0200)

are available in the git repository at:

  git://git.inai.de/libnetfilter_acct master

for you to fetch changes up to e01126788f5d1eb4b2b1bc3de72a419a18a5ba7e:

  build: resolve compile abort on RHEL5 #2 (2012-10-13 14:05:47 +0200)

----------------------------------------------------------------
Jan Engelhardt (2):
      build: resolve compile abort on RHEL5 #1
      build: resolve compile abort on RHEL5 #2

 include/linux/netfilter/nfnetlink.h        |   50 +++--------------------
 include/linux/netfilter/nfnetlink_acct.h   |   15 ++-----
 include/linux/netfilter/nfnetlink_compat.h |   61 ++++++++++++++++++++++++++++
 src/internal.h                             |   12 ++++++
 4 files changed, 82 insertions(+), 56 deletions(-)
 create mode 100644 include/linux/netfilter/nfnetlink_compat.h

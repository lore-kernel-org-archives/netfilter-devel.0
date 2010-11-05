From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_log build updates 2
Date: Fri,  5 Nov 2010 18:55:18 +0100
Message-ID: <1288979721-18198-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55330 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab0KERz0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:55:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit b472e11be65855088bbe144acfc779ae5a3a66f2:

  Add .gitignore files (2010-10-31 00:05:50 +0200)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_log master

Jan Engelhardt (2):
      build: default to not building static libraries
      build: use AC_OUTPUT

 configure.ac |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

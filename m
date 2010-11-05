From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_conntrack build updates 2
Date: Fri,  5 Nov 2010 18:37:28 +0100
Message-ID: <1288978652-15892-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42069 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab0KERhf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:37:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit cc3b3ef6c269549a45ba16cd1bb3b4316091906d:

  Update .gitignore (2010-10-30 23:53:12 +0200)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_conntrack master

Jan Engelhardt (3):
      build: default to not building static libraries
      build: use AC_OUTPUT
      build: run autoupdate to replace obsolete constructs

 configure.ac |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

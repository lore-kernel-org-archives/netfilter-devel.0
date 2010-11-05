From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_queue build updates 2
Date: Fri,  5 Nov 2010 18:56:11 +0100
Message-ID: <1288979774-18386-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55354 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab0KER4Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:56:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit ddd8ea0add4eb4390763d066d0673c6d94dec1f3:

  Update .gitignore (2010-10-30 23:56:24 +0200)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_queue master

Jan Engelhardt (2):
      build: default to not building static libraries
      build: use AC_OUTPUT

 configure.ac |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

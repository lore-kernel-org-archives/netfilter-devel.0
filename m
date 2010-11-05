From: Jan Engelhardt <jengelh@medozas.de>
Subject: libmnl build updates 2
Date: Fri,  5 Nov 2010 19:30:41 +0100
Message-ID: <1288981844-22714-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33310 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab0KESaq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:30:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit f7cfd408bee4a14f705565a95f98caf3c35bd57e:

  examples: remove redundant casts (2010-10-30 22:22:52 +0200)

are available in the git repository at:
  git://dev.medozas.de/libmnl master

Jan Engelhardt (2):
      build: remove -fPIC flag
      build: remove statements without obvious effect

 Make_global.am |    2 +-
 Makefile.am    |    4 ----
 configure.ac   |    1 -
 3 files changed, 1 insertions(+), 6 deletions(-)

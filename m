From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnfnetlink: cast removal
Date: Sat, 18 Dec 2010 21:18:55 +0100
Message-ID: <1292703537-16532-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47430 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab0LRUS7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 15:18:59 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit ac19c1954c3d8505c1612b219f71d7c86cc7fb13:

  Remove distro-specific parts (2010-11-05 18:31:30 +0100)

are available in the git repository at:
  git://dev.medozas.de/libnfnetlink master

Jan Engelhardt (1):
      src: remove redundant casts

 src/iftable.c      |    4 ++--
 src/libnfnetlink.c |   27 +++++++++++++--------------
 src/rtnl.c         |   12 ++++++------
 3 files changed, 21 insertions(+), 22 deletions(-)

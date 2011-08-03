From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_conntrack: build fix
Date: Wed,  3 Aug 2011 17:08:46 +0200
Message-ID: <1312384128-26273-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59500 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579Ab1HCPIu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:08:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 75c69a3da6ae268f42aecca7e5ae79dacdd87414:

  conntrack: objopt: NO_EFFECT (2011-06-13 19:52:49 +0200)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_conntrack master

Jan Engelhardt (1):
      build: fix error with automake-1.9

 .gitignore   |    1 +
 configure.ac |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

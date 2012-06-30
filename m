From: Jan Engelhardt <jengelh@inai.de>
Subject: libnetfilter_queue build fix
Date: Sat, 30 Jun 2012 03:07:53 +0200
Message-ID: <1341018474-1274-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:57307 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393Ab2F3BSE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jun 2012 21:18:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This was a fun one... I knew it pays off to build the openSUSE distro
packages with `./configure --includedir=SomethingNonStandard`
throughout! :)


The following changes since commit 7bd9edfe7849d8d1bc35f9ac28e949409da0bf10:

  build: remove unused lines in Makefile.am (2012-06-24 14:58:28 +0200)

are available in the git repository at:
  git://git.inai.de/libnetfilter_queue master

Jan Engelhardt (1):
      build: remove stray empty variable

 Make_global.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

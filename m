From: Jan Engelhardt <jengelh@medozas.de>
Subject: ulogd: build fix
Date: Wed,  3 Aug 2011 17:37:18 +0200
Message-ID: <1312385840-32490-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38450 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab1HCPhY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:37:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit c8fb552eeabd1a7cd9440d55c96918c0aa1ae3a9:

  ulogd: fix segfault if syslog and SIGTERM is received (2011-03-27 21:47:42 +0200)

are available in the git repository at:
  git://dev.medozas.de/ulogd2 master

Jan Engelhardt (1):
      build: abort autogen on subcommand failure

 autogen.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

From: Jan Engelhardt <jengelh@medozas.de>
Subject: libmnl: build fix
Date: Wed,  3 Aug 2011 17:07:23 +0200
Message-ID: <1312384045-26056-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:39950 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579Ab1HCPH1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:07:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit b9f9a7e96fa52f287ddf7f8433ad02b3a245dcf6:

  doc: fix wrong comment describing mnl_nlmsg_batch_stop() (2011-03-17 23:42:55 +0100)

are available in the git repository at:
  git://dev.medozas.de/libmnl master

Jan Engelhardt (1):
      build: abort autogen on subcommand failure

 autogen.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

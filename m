From: Jan Engelhardt <jengelh@medozas.de>
Subject: libmnl cast remover
Date: Sat, 30 Oct 2010 22:35:37 +0200
Message-ID: <1288470939-7346-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48489 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab0J3Ufo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 16:35:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit bae340593494739f873a2e00d6c8bcfc3777edc1:

  attr: rename str_null from NULL away (2010-10-25 00:44:00 +0200)

are available in the git repository at:
  git://dev.medozas.de/libmnl master

Jan Engelhardt (1):
      examples: remove redundant casts

 examples/genl/genl-family-get.c |    6 +++---
 examples/netfilter/nf-queue.c   |    2 +-
 examples/netfilter/nfct-event.c |    8 ++++----
 examples/rtnl/rtnl-link-dump.c  |    2 +-
 examples/rtnl/rtnl-link-event.c |    2 +-
 examples/rtnl/rtnl-route-dump.c |    2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

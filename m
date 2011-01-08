From: Jan Engelhardt <jengelh@medozas.de>
Subject: libmnl: genl patches
Date: Sat,  8 Jan 2011 04:09:45 +0100
Message-ID: <1294456188-4221-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41628 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab1AHDJv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jan 2011 22:09:51 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 89bb1e00f921a4e8b0e1e3b3e6aea5d26ccd0435:

  Merge branch 'master' of git://dev.medozas.de/libmnl (2011-01-06 03:19:29 +0100)

are available in the git repository at:

  git://dev.medozas.de/libmnl master

Jan Engelhardt (2):
      examples/genl: fix newline imbalance
      examples/genl: support dumping the genl families

 examples/genl/genl-family-get.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

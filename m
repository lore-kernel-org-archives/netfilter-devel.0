From: Jan Engelhardt <jengelh@inai.de>
Subject: libnetfilter_conntrack: build updates
Date: Mon, 25 Jun 2012 20:25:20 +0200
Message-ID: <1340648721-16435-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48574 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694Ab2FYSZY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:25:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 7ea731b0e8582ff67ef2703e05c4a45220da538c:

  examples: add example using libmnl and the new low-level API (expectation) (2012-05-26 17:24:45 +0200)

are available in the git repository at:
  git://git.inai.de/libnetfilter_conntrack master

Jan Engelhardt (1):
      build: move library flags to CPPFLAGS

 Make_global.am |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

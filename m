From: Jan Engelhardt <jengelh@inai.de>
Subject: iptables -stable patches
Date: Wed, 10 Oct 2012 12:35:12 +0200
Message-ID: <1349865314-27640-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:57231 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab2JJKfR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2012 06:35:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit c1a150c98fc94858a440550f0cb347a6060ebb30:

  bump version to 1.4.16.2 (2012-10-08 10:09:04 +0200)

are available in the git repository at:

  git://git.inai.de/iptables master

for you to fetch changes up to f525886fc628341809e9139f87eab92f3f6f31da:

  build: resolve compile abort in libxt_limit on RHEL5 (2012-10-09 02:01:09 +0200)

----------------------------------------------------------------
Jan Engelhardt (2):
      build: remove symlink-only extensions from static object list
      build: resolve compile abort in libxt_limit on RHEL5

 extensions/GNUmakefile.in    |    8 ++++----
 extensions/libxt_hashlimit.c |    2 ++
 extensions/libxt_limit.c     |    2 ++
 3 files changed, 8 insertions(+), 4 deletions(-)

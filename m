From: Jan Engelhardt <jengelh@inai.de>
Subject: libnetfilter_conntrack patches
Date: Mon,  8 Oct 2012 15:12:18 +0200
Message-ID: <1349701939-19896-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49000 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab2JHNMU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:12:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



(Uncritical, since it only fixes a warning, not an error.)

===
The following changes since commit 4cea72f6badb1bfbef7d804edebec053d6769393:

  update LIBVERSION (2012-10-08 11:09:30 +0200)

are available in the git repository at:

  git://git.inai.de/libnetfilter_conntrack master

for you to fetch changes up to 1044ffcc44ad49b27467548ac79b03d9861c8a45:

  build: resolve automake-1.12 warnings (2012-10-08 15:11:07 +0200)

----------------------------------------------------------------
Jan Engelhardt (1):
      build: resolve automake-1.12 warnings

 configure.ac |    1 +
 1 file changed, 1 insertion(+)

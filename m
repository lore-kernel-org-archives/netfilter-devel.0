From: Jan Engelhardt <jengelh@inai.de>
Subject: libnetfilter_queue patches
Date: Mon,  8 Oct 2012 15:17:18 +0200
Message-ID: <1349702239-25213-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49128 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab2JHNRU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:17:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit f5d092dd3145d427c7c2ed668e3ac899875c9612:

  bump version to 1.0.2 (2012-10-08 12:28:40 +0200)

are available in the git repository at:

  git://git.inai.de/libnetfilter_queue master

for you to fetch changes up to e40bec63be85d4458d2bdef7b23641e578ea2640:

  build: resolve automake-1.12 warnings (2012-10-08 15:16:32 +0200)

----------------------------------------------------------------
Jan Engelhardt (1):
      build: resolve automake-1.12 warnings

 bl           |    2 ++
 configure.ac |    1 +
 2 files changed, 3 insertions(+)
 create mode 100644 bl

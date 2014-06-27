From: Jan Engelhardt <jengelh@inai.de>
Subject: libnftnl 0.3: build fixes
Date: Fri, 27 Jun 2014 18:13:31 +0200
Message-ID: <1403885612-22792-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:50544 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaF0QNg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:13:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 041c85f7b62529a60d1b61f959bd95b049d2e7f5:

  bump version to 1.0.2 (2014-06-25 16:42:47 +0200)

are available in the git repository at:

  git://git.inai.de/libnftnl HEAD

for you to fetch changes up to c228843f6bc13179dfec43a4a135f9283a1a151e:

  build: resolve build failure on systems with old glibc-linux headers (2014-06-27 18:10:56 +0200)

----------------------------------------------------------------
Jan Engelhardt (1):
      build: resolve build failure on systems with old glibc-linux headers

 include/linux/netfilter/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

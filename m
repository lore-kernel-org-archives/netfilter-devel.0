From: Jan Engelhardt <jengelh@inai.de>
Subject: libnetfilter_acct patches
Date: Mon,  8 Oct 2012 15:08:29 +0200
Message-ID: <1349701710-17325-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:48974 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab2JHNIg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:08:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>




(This is all non-critical; the absence of AM_PROG_AR does not make
building fail.)

===
The following changes since commit ac67061eee650e5638bf8b792a47038ed895c21d:

  build: remove unnecessary pkgconfig->config.status dependency (2012-06-24 14:56:07 +0200)

are available in the git repository at:

  git://git.inai.de/libnetfilter_acct master

for you to fetch changes up to 912f17c49e54edae656524ddfb8ae974e9dadde3:

  build: resolve automake-1.12 warnings (2012-10-08 15:07:12 +0200)

----------------------------------------------------------------
Jan Engelhardt (1):
      build: resolve automake-1.12 warnings

 configure.ac |    1 +
 1 file changed, 1 insertion(+)

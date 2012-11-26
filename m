From: Jan Engelhardt <jengelh@inai.de>
Subject: ulogd fixes
Date: Tue, 27 Nov 2012 00:54:57 +0100
Message-ID: <1353974099-19891-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: eric@regit.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:48987 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293Ab2KZXzK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:55:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 85393baff66bfe69d053e1bf3a7230025e5f229a:

  XML: add missing include (2012-11-04 09:19:53 +0100)

are available in the git repository at:

  git://git.inai.de/ulogd master

for you to fetch changes up to 58a5cac020af30544c59b32496072ee131b65821:

  build: resolve compile error due to missing nfacct CPPFLAGS (2012-11-27 00:53:10 +0100)

----------------------------------------------------------------
Jan Engelhardt (2):
      build: resolve automake-1.12 warnings
      build: resolve compile error due to missing nfacct CPPFLAGS

 configure.ac       |    1 +
 output/Makefile.am |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

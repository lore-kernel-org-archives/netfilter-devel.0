From: Jan Engelhardt <jengelh@inai.de>
Subject: iptables: build fixes
Date: Thu, 10 Jan 2013 16:15:17 +0100
Message-ID: <1357830919-10367-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:57820 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab3AJPPX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:15:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 983196ceb4d3bb7b6d3cf6da18bb6d5a5eafb347:

  doc: document the -4 and -6 options (2013-01-07 02:26:16 +0100)

are available in the git repository at:

  git://git.inai.de/iptables master

for you to fetch changes up to dd5fd152645c572e76ad7a02084ea8ef19552a93:

  build: do not dereference symlinks on installation (2013-01-10 16:02:09 +0100)

----------------------------------------------------------------
Jan Engelhardt (2):
      build: also use libtool for install stage
      build: do not dereference symlinks on installation

 extensions/GNUmakefile.in |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

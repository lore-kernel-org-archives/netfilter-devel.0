From: Jan Engelhardt <jengelh@medozas.de>
Subject: libmnl misc patches Nov 11
Date: Thu, 11 Nov 2010 00:07:59 +0100
Message-ID: <1289430485-16467-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56300 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496Ab0KJXIH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:08:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Please review, and if ok, apply.

__

The following changes since commit 415a51b34293eac33a7d2152b909f89e5af4ed10:

  Merge branch 'master' of git://dev.medozas.de/libmnl (2010-11-07 20:53:15 +0100)

are available in the git repository at:

  git://dev.medozas.de/libmnl master

Jan Engelhardt (5):
      socket: constify a struct sockaddr_nl
      include: use C++ headers in C++ mode
      nlmsg: use bool for all _ok functions
      attr: remove redundant check for NULL
      attr: avoid multiple definition of hidden variable

 include/libmnl/libmnl.h |   41 +++++++++++++++++++++--------------------
 src/attr.c              |   23 ++++++++---------------
 src/nlmsg.c             |    2 +-
 src/socket.c            |    2 +-
 4 files changed, 31 insertions(+), 37 deletions(-)

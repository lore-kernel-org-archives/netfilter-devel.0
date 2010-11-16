From: Jan Engelhardt <jengelh@medozas.de>
Subject: libmnl: proposed patches 20101116
Date: Tue, 16 Nov 2010 12:43:27 +0100
Message-ID: <1289907814-32706-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47716 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933053Ab0KPLng (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:43:36 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi Pablo,


feel free to cherry-pick either if not all pass review.

===
The following changes since commit bb8c40e9ef7cb39edd144067d65378c49b837205:

  include: use C++ headers in C++ mode (2010-11-15 20:38:05 +0100)

are available in the git repository at:
  git://dev.medozas.de/libmnl master

Jan Engelhardt (6):
      attr: avoid multiple definition of hidden variable
      socket: propagate sendto/recvmsg's return types
      Update .gitignore
      build: tag function headers rather than decls as exported
      build: add some more precautionary CFLAGS
      nlmsg: remove unused function

 Make_global.am                |    2 +-
 configure.ac                  |    8 ++-
 examples/netfilter/.gitignore |    1 +
 include/libmnl/libmnl.h       |  122 +++++++++++++++++++----------------------
 m4/gcc4_visibility.m4         |   21 +++++++
 m4/visibility.m4              |   52 -----------------
 src/Makefile.am               |    2 -
 src/attr.c                    |   86 +++++++++++++++-------------
 src/callback.c                |   13 +++--
 src/internal.h                |   11 ++++
 src/nlmsg.c                   |   45 +++++++--------
 src/socket.c                  |   28 +++++----
 12 files changed, 188 insertions(+), 203 deletions(-)
 create mode 100644 m4/gcc4_visibility.m4
 delete mode 100644 m4/visibility.m4
 create mode 100644 src/internal.h

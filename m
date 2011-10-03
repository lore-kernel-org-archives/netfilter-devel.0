From: Jan Engelhardt <jengelh@medozas.de>
Subject: libsnet: build sys
Date: Mon,  3 Oct 2011 22:10:06 +0200
Message-ID: <1317672610-29855-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: sam@synack.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48170 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab1JCUKm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:10:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


I see that your libsnet-0.1.tar contains a git tree, so I used that
as a base for now.

With the three patches here, distro packaging is stress-free
(means $developer does not have to read the Makefile to figure out
what variables to set :-).

Please add header notices to the .c files to refer to the particular
license that they are under, and a LICENSE/COPYING file for the
particular license you will be choosing for the package.

thanks,
Jan

----

The following changes since commit 83884836dc5f636b4f46c75d372ec47ed7a9c98e:

  snetd: fix netlink attributs (2009-12-29 17:49:03 +0100)

are available in the git repository at:
  git://dev.medozas.de/libsnet master

Jan Engelhardt (3):
      build: provide buildsys with automake and pkgconfig
      build: resolve compiler warnings
      src: put include files into their own directory

 .gitignore                       |   19 +++++++++++++++++++
 Makefile                         |   38 --------------------------------------
 Makefile.am                      |   20 ++++++++++++++++++++
 autogen.sh                       |    4 ++++
 configure.ac                     |   17 +++++++++++++++++
 include/{ => libsnet}/snet.h     |    0
 include/{ => libsnet}/snet_lib.h |    2 +-
 include/{ => libsnet}/sql.h      |    0
 include/{ => libsnet}/utils.h    |    0
 libsnet.pc.in                    |   10 ++++++++++
 m4/.gitignore                    |    2 ++
 snet.c                           |    5 +++--
 snet_lib.c                       |    7 ++++---
 utils.c                          |    5 +++--
 14 files changed, 83 insertions(+), 46 deletions(-)
 create mode 100644 .gitignore
 delete mode 100644 Makefile
 create mode 100644 Makefile.am
 create mode 100755 autogen.sh
 create mode 100644 configure.ac
 rename include/{ => libsnet}/snet.h (100%)
 rename include/{ => libsnet}/snet_lib.h (95%)
 rename include/{ => libsnet}/sql.h (100%)
 rename include/{ => libsnet}/utils.h (100%)
 create mode 100644 libsnet.pc.in
 create mode 100644 m4/.gitignore

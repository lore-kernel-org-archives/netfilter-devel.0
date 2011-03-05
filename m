From: Jan Engelhardt <jengelh@medozas.de>
Subject: libmnl: other OS support
Date: Sat,  5 Mar 2011 13:31:28 +0100
Message-ID: <1299328292-4469-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58535 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab1CEMbe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Mar 2011 07:31:34 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 30923494424b604b1d59087e06fccf0637c0c2c5:

  doxygen: exclude EXPORT_SYMBOL and skip .git files (2011-02-08 15:19:19 +0100)

are available in the git repository at:
  git://dev.medozas.de/libmnl master

Jan Engelhardt (3):
      src: use limits.h header
      include: use sanitized header from headers_install
      build: support compilation on non-Linuxes

 configure.ac                    |   13 ++--
 include/generic/linux/netlink.h |  152 +++++++++++++++++++++++++++++++++++++++
 include/linux/netlink.h         |  128 +--------------------------------
 src/attr.c                      |    3 +-
 4 files changed, 162 insertions(+), 134 deletions(-)
 create mode 100644 include/generic/linux/netlink.h

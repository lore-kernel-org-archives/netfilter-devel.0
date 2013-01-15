From: Jan Engelhardt <jengelh@inai.de>
Subject: Build fixes for old Linuxes
Date: Tue, 15 Jan 2013 19:20:00 +0100
Message-ID: <1358274002-6042-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38860 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056Ab3AOSUG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:20:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


With this, iptables-1.4.17a (current git state) is tested to compile
and, to the degree covered by this patchset, to function under
Linux 2.4.27/glibc-2.3.2/Debian-3.1.

===
The following changes since commit 983196ceb4d3bb7b6d3cf6da18bb6d5a5eafb347:

  doc: document the -4 and -6 options (2013-01-07 02:26:16 +0100)

are available in the git repository at:

  git://git.inai.de/iptables old-linux

for you to fetch changes up to 1071ec54e6d7af406fe34afea1ce2c3e49ee1914:

  parser: workaround glibc-2.3.2 bug 358 (2013-01-15 19:16:55 +0100)

----------------------------------------------------------------
Jan Engelhardt (2):
      build: fix libiptc build failure on old linux-glibc-devel headers
      parser: workaround glibc-2.3.2 bug 358

 libiptc/linux_list.h   |    4 ++--
 libiptc/linux_stddef.h |    4 ++--
 libxtables/xtoptions.c |   14 ++++++++++++++
 3 files changed, 18 insertions(+), 4 deletions(-)

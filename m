From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: SAME, -p 0, libiptc pkgconfig
Date: Sun, 18 Dec 2011 03:06:45 +0100
Message-ID: <1324174009-1559-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:55611 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1LRCIM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 21:08:12 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 79ddbf202a06e6f018e087a328c2ca91e65a8463:

  libxt_recent: Add support for --reap option (2011-12-09 05:11:45 +0100)

are available in the git repository at:
  git://dev.medozas.de/iptables stable -> stable

Jan Engelhardt (3):
      libipt_SAME: set PROTO_RANDOM on all ranges
      doc: clarification on the meaning of -p 0
      libiptc: provide separate pkgconfig files

 configure.ac             |    4 +++-
 extensions/libipt_DNAT.c |   17 ++++++++++-------
 extensions/libipt_SAME.c |   24 ++++++++++++++----------
 extensions/libipt_SNAT.c |   17 ++++++++++-------
 iptables/ip6tables.8.in  |   16 ++++++++++++----
 iptables/iptables.8.in   |   10 +++++++---
 libiptc/.gitignore       |    2 +-
 libiptc/Makefile.am      |    2 +-
 libiptc/libip4tc.pc.in   |   10 ++++++++++
 libiptc/libip6tc.pc.in   |   10 ++++++++++
 libiptc/libiptc.pc.in    |    6 ++----
 11 files changed, 80 insertions(+), 38 deletions(-)
 create mode 100644 libiptc/libip4tc.pc.in
 create mode 100644 libiptc/libip6tc.pc.in

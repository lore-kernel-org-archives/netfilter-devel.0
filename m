From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: response to modern linkers, and symbol maps
Date: Fri, 30 Dec 2011 02:46:31 +0100
Message-ID: <1325209595-23244-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:58640 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab1L3Bqh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:46:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 57ccd9b9b02d93091fa162c854d57073d7ad64d4:
  Merge branch 'stable' (2011-12-30 02:37:31 +0100) [temp]

are available FOR REVIEW in the git repository at:
  git://dev.medozas.de/iptables master
and proposed for:
  master

Description:
  Changes to accomodate contemporary tool chain and distro-level build
  systems. Not a bugfix, and since it emits e.g. new rpm symbols for
  distros, this is not for the stable branch.


Jan Engelhardt (3):
      libiptc: remove libiptc.so
      libiptc: add symbol maps to libiptc
      libipq: add symbol map to libipq

 configure.ac         |    5 ----
 libipq/Makefile.am   |    8 ++++++-
 libipq/libipq.map    |   28 ++++++++++++++++++++++++++
 libiptc/Makefile.am  |   15 ++++++++-----
 libiptc/libip4tc.map |   52 +++++++++++++++++++++++++++++++++++++++++++++++++
 libiptc/libip6tc.map |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 149 insertions(+), 12 deletions(-)
 create mode 100644 libipq/libipq.map
 create mode 100644 libiptc/libip4tc.map
 create mode 100644 libiptc/libip6tc.map

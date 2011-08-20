From: Jan Engelhardt <jengelh@medozas.de>
Subject: Fixes to iptables-1.4.12
Date: Sat, 20 Aug 2011 21:24:47 +0200
Message-ID: <1313868294-21471-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40054 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab1HTTY7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Aug 2011 15:24:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 91ca4603f649a9b9fed4f2e31a8c005cdbdacd1e:

  Merge branch 'master' of git://dev.medozas.de/iptables (2011-08-09 13:23:17 +0200)

are available in the git repository at:

  git://dev.medozas.de/iptables master

Bernard Massot (1):
      doc: fix typo in libxt_TRACE

Dwight Davis (1):
      libxt_string: fix space around arguments

Jan Engelhardt (4):
      libxt_u32: fix missing allowance for inversion
      libxt_set: update man page about kernel support on the feature
      libxt_tcp: always print the mask parts
      libxt_set: put differing variable names in directly

 extensions/libxt_SET.c     |   13 +++----------
 extensions/libxt_SET.man   |    5 ++---
 extensions/libxt_TRACE.man |    2 +-
 extensions/libxt_set.c     |   11 +++--------
 extensions/libxt_set.man   |    5 ++---
 extensions/libxt_string.c  |    4 ++--
 extensions/libxt_tcp.c     |    4 +---
 extensions/libxt_u32.c     |    2 +-
 tests/options-most.rules   |    3 ++-
 9 files changed, 17 insertions(+), 32 deletions(-)

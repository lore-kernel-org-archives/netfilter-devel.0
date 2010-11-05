From: Jan Engelhardt <jengelh@medozas.de>
Subject: conntrack-tools build updates 2
Date: Fri,  5 Nov 2010 18:56:48 +0100
Message-ID: <1288979814-18512-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55370 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab0KER44 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:56:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 89189d0799a158cab83c564f57aaa9942a4cc19e:

  Add .gitignore files (2010-10-31 00:46:35 +0200)

are available in the git repository at:
  git://dev.medozas.de/conntrack-tools master

Jan Engelhardt (5):
      build: resolve automake warning
      build: default to not building static libraries
      build: run autoupdate to replace obsolete constructs
      build: use AM_YFLAGS instead of overriding YACC
      build: remove redundant bison/lex tests

 configure.ac    |   22 ++++++++++------------
 src/Makefile.am |    4 ++--
 2 files changed, 12 insertions(+), 14 deletions(-)

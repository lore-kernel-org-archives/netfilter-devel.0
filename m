From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: option precedence order change
Date: Tue, 19 Oct 2010 17:16:26 +0200
Message-ID: <1287501388-5948-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35810 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab0JSPQa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:16:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 81defdb2c3ad0e461f6487dc75abb8d4fc77519b:

  libiptc: add Libs.private to pkgconfig files (2010-09-13 23:43:12 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (1):
      libxtables: change option precedence order to be intuitive

 include/xtables.h.in |    5 +++--
 ip6tables.c          |    7 +++----
 iptables.c           |   13 +++++++++----
 xtables.c            |   50 ++++++++++++++++++++++++++++----------------------
 4 files changed, 43 insertions(+), 32 deletions(-)

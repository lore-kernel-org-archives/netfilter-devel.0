From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables fixes for 2011-05-30
Date: Mon, 30 May 2011 12:18:00 +0200
Message-ID: <1306750686-11595-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:49381 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab1E3KSJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2011 06:18:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 874b76221f74a00520a712ef89b5254a1ed896f8:

  libxt_owner: restore inversion support (2011-05-29 16:43:25 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables next

Jan Engelhardt (5):
      build: remove dead code parts
      build: fix installation of symlinks
      build: fix absence of xml translator in IPv6-only builds
      doc: update GPL license text
      doc: iptables-xml should be in manpage section 1

 COPYING                          |   42 +++++++++++++++++++-------------------
 Makefile.am                      |   10 ++++----
 ip6tables.c                      |    2 -
 iptables-xml.8 => iptables-xml.1 |    0
 iptables-xml.c                   |    3 --
 libiptc/libiptc.c                |    7 +----
 6 files changed, 28 insertions(+), 36 deletions(-)
 rename iptables-xml.8 => iptables-xml.1 (100%)

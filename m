From: Jan Engelhardt <jengelh@medozas.de>
Subject: Compile fix
Date: Wed,  8 Jun 2011 12:33:48 +0200
Message-ID: <1307529230-20173-1-git-send-email-jengelh@medozas.de>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:50132 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab1FHKdw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:33:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 780607f8b040a47cd2d4775376e2d30f567dc049:

  option: fix ignored negation before implicit extension loading (2011-06-07 22:33:13 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (1):
      build: re-add missing CPPFLAGS for libiptc

 libiptc/Makefile.am |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

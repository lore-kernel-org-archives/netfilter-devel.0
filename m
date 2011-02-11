From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: option fix
Date: Fri, 11 Feb 2011 02:07:25 +0100
Message-ID: <1297386447-30546-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52919 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930Ab1BKBH3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Feb 2011 20:07:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 7ada0bb7aafd94ef7c9c076e8be50c80bc549a4f:

  Merge branch 'master' of git://dev.medozas.de/iptables (2011-02-09 08:13:23 +0100)

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (1):
      iptables: fix segfault target option parsing

 ip6tables.c |    6 +++---
 iptables.c  |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

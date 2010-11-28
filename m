From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: option parsing fixes
Date: Sun, 28 Nov 2010 15:44:02 +0100
Message-ID: <1290955445-17833-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48192 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab0K1OoH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Nov 2010 09:44:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit a905ea5c97149da9d76cd278b0447e3316087a45:

  Merge branch 'master' of git://dev.medozas.de/iptables into m2 (2010-11-15 14:39:50 +0100)

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (2):
      iptables: reset options at the start of each command
      iptables: do not emit orig_opts twice

 ip6tables.c |    2 +-
 iptables.c  |    2 +-
 xtables.c   |    4 ++++
 3 files changed, 6 insertions(+), 2 deletions(-)

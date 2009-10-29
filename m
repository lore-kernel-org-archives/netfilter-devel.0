From: Jan Engelhardt <jengelh@medozas.de>
Subject: (unknown)
Date: Thu, 29 Oct 2009 19:11:14 +0100
Message-ID: <1256839878-24358-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56273 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbZJ2SLQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2009 14:11:16 -0400
Subject: 
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


here are three commits that fix bugzilla entries and/or other
problems encountered. There are also two extra commits prepended
without any changes, which only provide missing log entries for
already-merged commits.


The following changes since commit 7fa7329fc972513021131416dbd9d535141bd2ea:
  Jan Engelhardt (1):
        iprange: roll address parsing into a loop

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (4):
      iprange: do accept non-ranges for xt_iprange v1 (log)
      iprange: warn on reverse range (log)
      libiptc: fix wrong maptype of base chain counters on restore
      iptables: fix undersized deletion mask creation

Olaf Rempel (1):
      build: restore --disable-ipv6 functionality on system w/o v6 headers

 ip6tables.c       |   14 ++++++++------
 iptables.c        |   14 ++++++++------
 libiptc/libiptc.c |    2 +-
 xtables.c         |    3 ++-
 4 files changed, 19 insertions(+), 14 deletions(-)

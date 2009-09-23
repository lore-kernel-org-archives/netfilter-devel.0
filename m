From: Jan Engelhardt <jengelh@medozas.de>
Subject: iprange non-range recognition
Date: Wed, 23 Sep 2009 23:26:30 +0200
Message-ID: <1253741194-26060-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52863 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZIWV0d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:26:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


here is a fix and subsequent cleanups to Debian bug #547139.
Please merge.


The following changes since commit 2463f7dcee97efe7dfc4b2e1f6a3c552f23a8d8c:
  Patrick McHardy (1):
        Merge branch 'zero' of git://dev.medozas.de/iptables

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (3):
      iprange: do accept non-ranges for xt_iprange v1
      iprange: warn on reverse range
      iprange: roll address parsing into a loop

 extensions/libxt_iprange.c |  128 ++++++++++++++++++--------------------------
 1 files changed, 53 insertions(+), 75 deletions(-)

# templated by git request-pull

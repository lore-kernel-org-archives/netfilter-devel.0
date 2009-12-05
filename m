From: Jan Engelhardt <jengelh@medozas.de>
Subject: nfbz 621 - 3 kernel patches
Date: Sat,  5 Dec 2009 21:26:21 +0100
Message-ID: <1260044785-20962-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54525 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757603AbZLEU0U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:26:20 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


a few simple commits that turned up while processing NF bug 621.
Thanks for taking care of them :)


The following changes since commit 22763c5cf3690a681551162c15d34d935308c8d7:
  Linus Torvalds (1):
        Linux 2.6.32

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (3):
      netfilter: xt_recent: save 8 bytes per htable
      netfilter: xtables: do not grab random bytes at __init
      netfilter: xtables: obtain random bytes earlier, in checkentry

 net/netfilter/xt_NFQUEUE.c   |    6 +++++-
 net/netfilter/xt_RATEEST.c   |    7 ++++++-
 net/netfilter/xt_connlimit.c |   17 ++++++-----------
 net/netfilter/xt_hashlimit.c |    8 ++++----
 net/netfilter/xt_recent.c    |   20 ++++++++------------
 5 files changed, 29 insertions(+), 29 deletions(-)

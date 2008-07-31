From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/03: netfilter update/fixes
Date: Thu, 31 Jul 2008 08:33:12 +0200 (MEST)
Message-ID: <20080731063312.18150.49494.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34598 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbYGaGdO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 02:33:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

these patches fix a proc file removal race in ipt_recent, a timer removal
race in hashlimit and, based upon a suggestion by Herbert, change TCP
conntrack to keep track of unacknowledged data and reduce the timeout to
5 minutes while data is unacknowledged in order to more aggressively prune
dead connections.

Please apply, thanks.


 include/linux/netfilter/nf_conntrack_tcp.h |    3 ++
 net/ipv4/netfilter/ipt_recent.c            |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c     |   29 +++++++++++++++++++++++----
 net/netfilter/xt_hashlimit.c               |    4 +--
 4 files changed, 29 insertions(+), 9 deletions(-)

Patrick McHardy (1):
      netfilter: nf_conntrack_tcp: decrease timeouts while data in unacknowledged

Pavel Emelyanov (2):
      netfilter: ipt_recent: fix race between recent_mt_destroy and proc manipulations
      netfilter: xt_hashlimit: fix race between htable_destroy and htable_gc

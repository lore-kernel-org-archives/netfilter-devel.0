From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable 00/03]: Netfilter 2.6.24 -stable fixes
Date: Mon, 17 Mar 2008 15:41:43 +0100 (MET)
Message-ID: <20080317143311.20525.87504.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53626 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbYCQOlp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Mar 2008 10:41:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches fix a problem in the time match, causing it to never
match on Sunday, and undersized skb allocation in nfnetlink_log
and nfnetlink_queue, causing lost messages.

Please apply, thanks.


 net/netfilter/nfnetlink_log.c   |    2 +-
 net/netfilter/nfnetlink_queue.c |    2 +-
 net/netfilter/xt_time.c         |    7 +++++--
 3 files changed, 7 insertions(+), 4 deletions(-)

Eric Leblond (2):
      [NETFILTER]: nfnetlink_queue: fix computation of allocated size for netlink skb
      [NETFILTER]: nfnetlink_log: fix computation of netlink skb size

Jan Engelhardt (1):
      [NETFILTER]: xt_time: fix failure to match on Sundays

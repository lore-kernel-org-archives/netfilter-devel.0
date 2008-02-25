From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable 00/03]: 2.6.24 regression fixes
Date: Mon, 25 Feb 2008 15:01:00 +0100 (MET)
Message-ID: <20080225140058.20602.52127.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50663 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbYBYOBE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2008 09:01:04 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches fix some netfilter regressions in 2.6.24 introduced by the
removal of double skb pointers:

- a BUG when enlarging packets queued to userspace
- inverted error checking of skb_make_writable in bridge netfilter
- use of incorrect return codes after skb_make_writable errors in
  bridge netfilter

Please apply, thanks.


 net/bridge/netfilter/ebt_dnat.c     |    4 ++--
 net/bridge/netfilter/ebt_redirect.c |    4 ++--
 net/bridge/netfilter/ebt_snat.c     |    4 ++--
 net/ipv4/netfilter/arpt_mangle.c    |    2 +-
 net/ipv4/netfilter/ip_queue.c       |   12 +++++++-----
 net/ipv6/netfilter/ip6_queue.c      |   10 ++++++----
 net/netfilter/nfnetlink_queue.c     |   10 ++++++----
 7 files changed, 26 insertions(+), 20 deletions(-)

Patrick McHardy (3):
      [NETFILTER]: nfnetlink_queue: fix SKB_LINEAR_ASSERT when mangling packet data
      [NETFILTER]: Fix incorrect use of skb_make_writable
      [NETFILTER]: fix ebtable targets return

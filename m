From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/02]: Netfilter fixes
Date: Tue, 11 Dec 2007 18:42:08 +0100 (MET)
Message-ID: <20071211174205.1042.29518.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53971 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbXLKRmK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:42:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

these two patches fix a missing bit on conntrack entries with master
connections created through ctnetlink and some brokeness in the
iptables compat code, causing it to use pointers dumped to userspace
and copied back again to the kernel without any checks for validity.

Pleasy apply, thanks.


 net/ipv4/netfilter/ip_tables.c       |   57 +++++++--------------------------
 net/netfilter/nf_conntrack_netlink.c |    4 ++-
 net/netfilter/x_tables.c             |    8 +++-
 3 files changed, 21 insertions(+), 48 deletions(-)

Pablo Neira Ayuso (1):
      [NETFILTER]: ctnetlink: set expected bit for related conntracks

Patrick McHardy (1):
      [NETFILTER]: ip_tables: fix compat copy race

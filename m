From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/02: netfilter fixes
Date: Fri, 17 Apr 2009 18:09:13 +0200 (MEST)
Message-ID: <20090417160913.32484.93063.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56944 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbZDQQJO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:09:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

the following two patches fix two netfilter bugs:

- missing socket notification for ctnetlink skb allocation errors

- an incorrect return code in nfnetlink for netlink_kernel_create() failure

Please apply or pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git

Thanks!


 net/netfilter/nf_conntrack_netlink.c |   10 ++++++----
 net/netfilter/nfnetlink.c            |    2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

Pablo Neira Ayuso (2):
      netfilter: ctnetlink: report error if event message allocation fails
      netfilter: nfnetlink: return ENOMEM if we fail to create netlink socket

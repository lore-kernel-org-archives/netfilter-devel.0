From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [NOTICE] nftables rebased upon 3.11 and rule batching update
Date: Tue, 24 Sep 2013 12:49:43 +0200
Message-ID: <20130924104943.GA8176@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33773 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab3IXKtx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Sep 2013 06:49:53 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have rebased nftables upon 3.11, you can find the current Linux
kernel tree at:

https://git.kernel.org/cgit/linux/kernel/git/pablo/nftables.git/log/

The old tree that is based upon 3.10 is still reachable here:

https://git.kernel.org/cgit/linux/kernel/git/pablo/nftables.git/log/?h=master-3.10

The rule batching patches requires 3.11 as it contains large skb
support for netlink, so don't try the fast path of taking new patches
there and applying them to 3.10, it won't work ;-).

I have also pushed patches for libnftables, nft and iptables-nftables.
The rule batching support is an interface update, so make sure you run
latest git tree snapshots with nftables upon 3.11.

Please, help testing, report problems and send me patches for it :-)

Thanks!

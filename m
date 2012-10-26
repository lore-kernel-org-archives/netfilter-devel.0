From: pablo@netfilter.org
Subject: [PATCH 0/8] IPVS updates for net-next tree
Date: Fri, 26 Oct 2012 11:24:30 +0200
Message-ID: <1351243478-4852-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59566 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543Ab2JZJYq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:24:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi David,

The following changeset contains updates for IPVS from Jesper Dangaard
Brouer that did not reach the previous merge window in time.

More specifically, updates to improve IPv6 support in IPVS. More
relevantly, some of the existing code performed wrong handling of the
extensions headers and better fragmentation handling.

Jesper promised more follow-up patches to refine this after this batch
hits net-next. Yet to come.

You can pull these changes from:

git://1984.lsi.us.es/nf-next master

Thanks!

Jesper Dangaard Brouer (8):
  ipvs: Trivial changes, use compressed IPv6 address in output
  ipvs: IPv6 extend ICMPv6 handling for future types
  ipvs: Use config macro IS_ENABLED()
  ipvs: Fix faulty IPv6 extension header handling in IPVS
  ipvs: Complete IPv6 fragment handling for IPVS
  ipvs: API change to avoid rescan of IPv6 exthdr
  ipvs: SIP fragment handling
  ipvs: fix build errors related to config option combinations


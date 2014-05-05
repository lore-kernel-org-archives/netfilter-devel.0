From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH RFC 0/7] users counter to manage ipv4 defragmentation on bridge
Date: Mon, 05 May 2014 16:55:26 +0400
Message-ID: <53678A3E.3060903@parallels.com>
References: <20140503233908.GA6297@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:35122 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219AbaEEM5J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 May 2014 08:57:09 -0400
In-Reply-To: <20140503233908.GA6297@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

I've implemented your wishes, could you please review my new patch set?

> In general, I believe bridges should silently drop packets that are
> larger than the mtu and they should perform no fragmentation handling,
> no gathering and no [re]fragmentation. They are transparent devices
> that operate at layer 2.
> 
> The conntrack case is a special case that forces us to enable
> fragmentation handling since we get sort of a bridge that inspects
> layer 3 and 4 packet information. So we have sort of, let's call it, a
> mutant bridge.
> 
> We also have the tproxy target and the socket match, they seem to
> require defragmentation as well, I'm afraid the skb->nfct check will
> not help for those cases. I think that we need some counter to know
> how many clients we have that require the gathering + fragmentation
> code, so if we have at least one, we have to enable it.
> 
> Perhaps we can also display a message to inform the user that
> netfilter fragmentation handling is enabled.

For nf_conntrack_ipv4 I increment counter once only,
For TPROXY target and socket match I increment counter on checkentry and
decrement on destroy hook. So if these modules are just loaded but are not
used in net namespace, they will not affect ipv4 defragmentation.

Please let me know if you have some better ideas.

Vasily Averin (7):
  nf: added per net namespace ipv4 defragmentation users counter
  nf: initialization of ipv4 defragmentation users counter
  nf: increment and decrement for ipv4 defragmentation users counter
  nf: ipv4 defragmentation users counter changes in nf_conntrack_ipv4
  nf: ipv4 defragmentation users counter changes in TPROXY target
  nf: ipv4 defragmentation users counter changes in xt_socket match
  nf: use counter to manage ipv4 defragmentation on bridge

 include/net/net_namespace.h                    |    3 ++
 include/net/netfilter/ipv4/nf_defrag_ipv4.h    |   13 +++++++
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +
 net/ipv4/netfilter/nf_defrag_ipv4.c            |   46 +++++++++++++++++++++++-
 net/netfilter/xt_TPROXY.c                      |   11 +++++-
 net/netfilter/xt_socket.c                      |   19 ++++++++++
 6 files changed, 92 insertions(+), 2 deletions(-)

-- 
1.7.5.4


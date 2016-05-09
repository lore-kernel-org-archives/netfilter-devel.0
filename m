From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: remove per-netns conntrack tables, part 3
Date: Mon,  9 May 2016 16:24:29 +0200
Message-ID: <1462803872-13497-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33839 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991AbcEIOYP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2016 10:24:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series removes the per-namespace duplication of the NAT bysource table.

We use one table for all namespaces, using net_hash_mix(net) as additional
hash seed so entries are spread evenly even if addresses overlap.

We then also remove the per-namespace kmem cache and allocate all
conntrack entries from the same cache.

This is the last table: earlier patches already converted conntrack and
expectation tables.

I have another patch queued to convert nat bysource table to an rhashtable.
However; it seems better to wait until the next merge window so that bug
reports can be more easily pointed to the de-duplication work or a rhashtable
conversion, I will therefore hold this back for now.

Other items that might be de-namespaced but are not being worked on at
the moment:

struct ct_pcpu __percpu *pcpu_lists

Only problem might be reliable event redelivery; such conntracks sit on
the dying list, if this list is global we also need to make sure that we
don't spend too much cycles iterating, especially if lots of namespaces
use reliable event delivery and are backlogged (userspace not reading
events fast enough).

struct ip_conntrack_stat __percpu *stat;

Easy to convert. However this would mean that information gets leaked
as all namespaces would see same stats.


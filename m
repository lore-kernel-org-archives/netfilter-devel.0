From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/5] netfilter: nf_tables: dynamic stateful expression instantiation
Date: Sat, 11 Apr 2015 10:46:37 +0100
Message-ID: <1428745602-31799-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49248 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbbDKJqp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Apr 2015 05:46:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches are the grand finale of my nf_tables set work,
using all the building blocks put in place by the previous patches
to support something like iptables hashlimit, but a lot more powerful.

Sets are extended to allow attaching expressions to set elements.
The dynset expression dynamically instantiates these expressions
based on a template when creating new set elements and evaluates
them for all new or updated set members.

In combination with concatenations this effectively creates state
tables for arbitrary combinations of keys, using the existing
expression types to maintain that state. Regular set GC takes care
of purging expired states.

We currently support two different stateful expressions, counter
and limit. Using limit as a template we can express the functionality
of hashlimit, but completely unrestricted in the combination of keys.
Using counter we can perform accounting for arbitrary flows.

The following examples from patch 5/5 show some possibilities.
Userspace syntax is still WIP, especially the listing of state
tables will most likely be seperated from normal set listings
and use a more structured format:

1. Limit the rate of new SSH connections per host, similar to iptables
   hashlimit:

# nft filter input tcp dport ssh ct state new \
	flow ip saddr timeout 60s \
	limit 10/second \
	accept

2. Account network traffic between each set of /24 networks:

# nft filter forward \
	flow ip saddr & 255.255.255.0 . ip daddr & 255.255.255.0 \
	counter

3. Account traffic to each host per user:

# nft filter output \
	flow skuid . ip daddr \
	counter

4. Account traffic for each combination of source address and TCP flags:

# nft filter input \
	flow ip saddr . tcp flags \
	counter

The resulting set content after a Xmas-scan look like this:

{
	192.168.122.1 . fin | psh | urg : counter packets 1001 bytes 40040,
	192.168.122.1 . ack : counter packets 74 bytes 3848,
	192.168.122.1 . psh | ack : counter packets 35 bytes 3144
}

In the future the "expressions attached to elements" will be extended
to also support user created non-stateful expressions to allow to
efficiently select beween a set of parameter sets, f.i. a set of log
statements with different prefixes based on the interface, which currently
require one rule each. This will most likely have to wait until the next
kernel version though.


Please apply, thanks!


Patrick McHardy (5):
  netfilter: nf_tables: add helper functions for expression handling
  netfilter: nf_tables: prepare for expressions associated to set elements
  netfilter: nf_tables: mark stateful expressions
  netfilter: nf_tables: add flag to indicate set contains expressions
  netfilter: nft_dynset: dynamic stateful expression instantiation

 include/net/netfilter/nf_tables.h        | 24 +++++++++++
 include/uapi/linux/netfilter/nf_tables.h |  6 +++
 net/netfilter/nf_tables_api.c            | 73 +++++++++++++++++++++++++++++---
 net/netfilter/nft_counter.c              |  1 +
 net/netfilter/nft_dynset.c               | 52 +++++++++++++++++++++--
 net/netfilter/nft_limit.c                |  1 +
 net/netfilter/nft_lookup.c               |  3 ++
 7 files changed, 149 insertions(+), 11 deletions(-)

-- 
2.1.0


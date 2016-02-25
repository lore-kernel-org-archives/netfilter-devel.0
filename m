From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/4] netfilter: xtables: don't register hooks by default
Date: Thu, 25 Feb 2016 10:08:34 +0100
Message-ID: <1456391318-11601-1-git-send-email-fw@strlen.de>
Cc: ebiederm@xmission.com
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37806 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758938AbcBYJN5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2016 04:13:57 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This work changes xtables to register tables only
when the ip(6)tables/arptables command is invoked inside a netns.
Also changes br_netfilter to not add its sabotage hooks until
a bridge is created inside the netns.

The initial namespace isn't affected; hooks are still registered
on module load time there.

netperf receiver running in netns 1.
init ns with empty mangle+filter table.

Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

>From ns2 (empty mangle + filter table):
87380  16384  16384    180.00   22034.90
87380  16384  16384    180.00   22355.71
87380  16384  16384    180.00   21906.88

from ns3, no iptables invocations:
87380  16384  16384    180.00   23103.76
87380  16384  16384    180.00   22975.47
87380  16384  16384    180.00   22880.08

-> ~4% delta.

Changes since last iteration:
 - dropped the conntrack changes for now
 - split patch #2 to make review a bit easier

 No other changes.

 include/linux/netfilter.h                 |   29 ++++--------
 include/linux/netfilter/x_tables.h        |    6 +-
 include/linux/netfilter_arp/arp_tables.h  |    9 ++-
 include/linux/netfilter_ipv4/ip_tables.h  |    9 ++-
 include/linux/netfilter_ipv6/ip6_tables.h |    9 ++-
 net/bridge/br_netfilter_hooks.c           |   68 ++++++++++++++++++++++++++++--
 net/ipv4/netfilter/arp_tables.c           |   66 ++++++++++++++++++-----------
 net/ipv4/netfilter/arptable_filter.c      |   40 ++++++++++-------
 net/ipv4/netfilter/ip_tables.c            |   63 ++++++++++++++++-----------
 net/ipv4/netfilter/iptable_filter.c       |   44 ++++++++++++-------
 net/ipv4/netfilter/iptable_mangle.c       |   41 ++++++++++++------
 net/ipv4/netfilter/iptable_nat.c          |   41 +++++++++---------
 net/ipv4/netfilter/iptable_raw.c          |   38 +++++++++++-----
 net/ipv4/netfilter/iptable_security.c     |   44 ++++++++++++-------
 net/ipv6/netfilter/ip6_tables.c           |   65 +++++++++++++++++-----------
 net/ipv6/netfilter/ip6table_filter.c      |   47 ++++++++++++--------
 net/ipv6/netfilter/ip6table_mangle.c      |   46 ++++++++++++--------
 net/ipv6/netfilter/ip6table_nat.c         |   41 +++++++++---------
 net/ipv6/netfilter/ip6table_raw.c         |   46 ++++++++++++--------
 net/ipv6/netfilter/ip6table_security.c    |   44 +++++++++++--------
 net/netfilter/x_tables.c                  |   65 +++++++++++++++++-----------
 21 files changed, 544 insertions(+), 317 deletions(-)

From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH 0/6] netfilter: nf_tables: add mixed IPv4/IPv6 table support
Date: Fri,  3 Jan 2014 12:16:12 +0000
Message-ID: <1388751378-23272-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56518 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaACMQZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 07:16:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches add support for mixed IPv4/IPv6 tables to nftables.

The first patch fixes the chain type override logic so chain types override
the AF defaults instead of the other way around. The second patch adds a
pointer to the nf_hook_ops struct to nft_pktinfo for a later patch which
uses ops->pf to match the actual AF of the packet instead of the dummy
NFPROTO_INET value. The third patch changes the chain and hook registration
logic to support multiple hook registrations. The nf_tables AF modules can
provide a callback function to override defaults. The fourth patch finally
adds a new "inet" family, which basically only initializes the hook
functions to the IPv4 and IPv6 specific ones and registers a dummy filter
chain type for NFPROTO_INET. Patches 5 and 6 add support for matching on
the netfilter hook family and the L4 protocol number to the meta match.

With all this in place, we can create AF-specific rules and AF-independant
rules that only match on the L4 protocol header and above in the inet table:

table inet filter {
        chain input {
                 type filter hook input priority 0;
        }

	chain forward {
                 type filter hook forward priority 0;
        }

	chain output {
                 type filter hook output priority 0;
                 ip protocol tcp tcp dport 1234 counter packets 2 bytes 120
                 ip6 nexthdr tcp tcp dport 1234 counter packets 2 bytes 160
                 tcp dport 1234 counter packets 4 bytes 280
	}
}

Userspace needs a bit of polishing but will most likely follow in a few
hours.

Comments welcome.


Patrick McHardy (6):
      netfilter: nf_tables: make chain types override the default AF functions
      netfilter: nf_tables: add hook ops to struct nft_pktinfo
      netfilter: nf_tables: add support for multi family tables
      netfilter: nf_tables: add "inet" table for IPv4/IPv6
      netfilter: nf_tables: add nfproto support to meta expression
      netfilter: nft_meta: add l4proto support

 include/net/netfilter/nf_tables.h        | 15 ++++-
 include/net/netfilter/nf_tables_ipv4.h   |  5 +-
 include/net/netfilter/nf_tables_ipv6.h   |  3 +
 include/net/netns/nftables.h             |  1 +
 include/uapi/linux/netfilter.h           |  1 +
 include/uapi/linux/netfilter/nf_tables.h |  4 ++
 net/bridge/netfilter/nf_tables_bridge.c  | 39 ++++++-------
 net/ipv4/netfilter/nf_tables_arp.c       | 39 ++++++-------
 net/ipv4/netfilter/nf_tables_ipv4.c      | 47 +++++++---------
 net/ipv6/netfilter/nf_tables_ipv6.c      | 52 ++++++++---------
 net/netfilter/Kconfig                    |  8 +++
 net/netfilter/Makefile                   |  1 +
 net/netfilter/nf_tables_api.c            | 53 +++++++++--------
 net/netfilter/nf_tables_core.c           |  2 +-
 net/netfilter/nf_tables_inet.c           | 97 ++++++++++++++++++++++++++++++++
 net/netfilter/nft_compat.c               |  8 +--
 net/netfilter/nft_log.c                  |  2 +-
 net/netfilter/nft_meta.c                 |  8 +++
 18 files changed, 260 insertions(+), 125 deletions(-)


From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC nf-next 0/3] named expressions for nf_tables
Date: Wed,  6 Apr 2016 18:51:30 +0200
Message-ID: <1459961493-7494-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42815 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbcDFQvs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2016 12:51:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 23C3CC9EE8
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Apr 2016 18:51:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 09B93DA388
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Apr 2016 18:51:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2AAE7DA38F
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Apr 2016 18:51:39 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset introduces the named stateful expressions for nf_tables,
that allows userspace to set a name for the stateful expression for
several reasons:

 * Provide a unique identifier to fetch and reset it internal state.
 * Allow to update of their parameters and internal state.
 * Allow to fetch and reset its internal state.
 * Refer to the same stateful expression from one or more rules.

nf_tables currently supports to stateful expressions: limit and counter,
therefore you can create named instances of this expressions through
this new infrastructure.

This batch is composed of three patches:

1) Extend the nf_tables netlink interface to add, delete, dump and reset
   named expressions.

2) Add a new expression to dereference named expressions.

3) Support atomic dump and reset of named expressions.

Note that this provides a native replacement for the iptables' nfacct
infrastructure, the use of nfacct is out of question due to the lack of
integration with nftables netlink interface and its 2-phase commit
protocol.

Several examples on how this would look from userspace:

* Add the 'tcp-counter' counter to the 'filter' table:

 # nft add counter filter tcp-counter

* Delete this counter (only possible if not dereferenced from a rule):

 # nft delete counter filter tcp-counter

* List existing named counters:

 # nft lists counters
 table ip filter {
        counter tcp-counter {
                packets 6086 bytes 6278052
        }
        counter udp-counter {
                packets 272 bytes 64690
        }
        counter icmp-counter {
                packets 10 bytes 840
        }
 }

* Atomically fetch and reset counters:

 # nft reset counters
 table ip filter {
        counter tcp-counter {
                packets 6086 bytes 6278052
        }
        counter udp-counter {
                packets 272 bytes 64690
        }
        counter icmp-counter {
                packets 10 bytes 840
        }
 }

 This retrieves the existing counter values and reset them, a follow up
 listing confirms this:

 # nft list counters
 table ip filter {
        counter tcp-counter {
                packets 0 bytes 0
        }
        counter udp-counter {
                packets 0 bytes 0
        }
        counter icmp-counter {
                packets 0 bytes 0
        }
 }

The snippet below shows a simplistic configuration to account tcp, udp
and icmp traffic through the named counter:

-o-
table ip filter {
        counter tcp-counter {
                packets 6086 bytes 6278052
        }

        counter udp-counter {
                packets 272 bytes 64690
        }

        counter icmp-counter {
                packets 10 bytes 840
        }

        chain input {
                type filter hook input priority 0; policy accept;
                ip protocol vmap { tcp : jump tcp-chain, icmp : jump icmp-chain, udp : jump udp-chain}
        }

        chain output {
                type filter hook output priority 0; policy accept;
        }

        chain tcp-chain {
                counter name tcp-counter
        }

        chain udp-chain {
                counter name udp-counter
        }

        chain icmp-chain {
                counter name icmp-counter
        }
}
-o-

So far, only counters are supported, but it should be possible to
support named limits. I have another (imcomplete) patch that allows to
update the named expressions parameters, this can be useful to
dynamically update the ratelimiting policies, the command line should
look like:

 # nft update limit name user01234 rate 250 mbytes/day

This example above updates the existing ratelimit 'user01234' to
250 mbytes/day.

Comments welcome,
Thanks.

Pablo Neira Ayuso (3):
  netfilter: nf_tables: add stateful named expressions
  netfilter: nf_tables: support for named expression reference
  netfilter: nf_tables: support dump and reset for named expressions

 include/net/netfilter/nf_tables.h        |  32 +++
 include/uapi/linux/netfilter/nf_tables.h |  41 +++
 net/netfilter/Kconfig                    |   6 +
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nf_tables_api.c            | 453 ++++++++++++++++++++++++++++++-
 net/netfilter/nft_counter.c              |  36 ++-
 net/netfilter/nft_nexpr.c                | 112 ++++++++
 7 files changed, 667 insertions(+), 14 deletions(-)
 create mode 100644 net/netfilter/nft_nexpr.c

--
2.1.4


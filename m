From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 00/11] nf_tables: add stateful objects
Date: Mon, 28 Nov 2016 01:00:59 +0100
Message-ID: <1480291270-3715-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40096 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753237AbcK1ABW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Nov 2016 19:01:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6BDB7D1633
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B59FDA729
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A878DA729
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:18 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset adds support for nf_tables stateful objects. Two object
types are supported at this stage: counters and quotas. Stateful objects
are uniquely identified by a user-defined name and you have to attach
them to tables.

You can create a counter via:

 # nft add table filter
 # nft add counter filter http-traffic

Then, list existing counters through:

 # nft list counters
 table ip filter {
       counter http-traffic {
             packets 0 bytes 0
       }
 }

The counter and quota stateful object type definitions reside in
nft_counter.c and nft_quota.c respectively, as they share code with
these two stateful expressions. The new object reference (objref)
expression allows us to refer to stateful objects from rules. Assuming
you already have a base chain in place:

 # nft add chain filter input { type filter hook input priority 0\; }

You can refer to this counter from rules, eg.

 # nft add rule filter input tcp dport 80 counter http-traffic

But adding one rule per object is expensive, so you can instead use our
map infrastructure instead for fast lookups:

The following example shows how to use this through an anonymous map:

 # nft add counter filter ftp-traffic
 # nft add counter filter ssh-traffic
 # nft add rule filter input counter name tcp dport map { \
	20 : "ftp-traffic",
	21 : "ftp-traffic",
	22 : "ssh-traffic",
	80 : "http-traffic",
	443 : "http-traffic",
	8080 : "http-traffic"
   }

The rule above update a given counter based on the destination tcp port.

The nf_tables codebase has been extended to add a new NFT_SET_OBJECT set
flag that indicates that the set stores a mapping between any arbitrary
key and an existing stateful object. There is also a new
NFTA_SET_OBJTYPE attribute to indicate the stateful object type. Then,
there is a new NFTA_SET_ELEM_OBJREF that allows us to specific the right
hand side of the mapping using the string that uniquely identify the
stateful object. The objref expression has been extended to take a map
as parameter.

You also refer to stateful object from dynamic maps, eg.

 # nft add map filter servers { type ipv4_addr . inet_service : counter \; }
 # nft add rule filter input counter name ip daddr . tcp dport map @servers
 # nft add counter filter www
 # nft add counter filter ftp
 # nft add element filter servers { 192.168.2.3 . 80 : "www" }
 # nft add element filter servers { 192.168.2.4 . 20 : "ftp" }
 # nft add element filter servers { 192.168.2.4 . 21 : "ftp" }

You can also atomically dump-and-reset stateful objects through:

 # nft reset counter filter www
 table filter {
        counter www {
                packets 123489 bytes 748374399
        }
 }
 # nft list counter filter www
 table filter {
        counter www {
                packets 0 bytes 0
        }
 }

As I said, this patch also comes with quota support, this also include
new infrastructure to deliver event notifications to userspace via
netlink whenever the quota has expired.

Comments welcome.

P.S: Limit stateful objects are not covered by this patchset, but it
should be relatively easy to add them later.

Pablo Neira Ayuso (11):
  netfilter: nf_tables: add stateful objects
  netfilter: nft_counter: add stateful object type
  netfilter: nft_quota: add stateful object type
  netfilter: nf_tables: add stateful object reference expression
  netfilter: nf_tables: atomic dump and reset for stateful objects
  netfilter: nf_tables: notify internal updates of stateful objects
  netfilter: nft_quota: dump consumed quota
  netfilter: nft_quota: add depleted flag for objects
  netfilter: nf_tables: add stateful object reference to set elements
  netfilter: nft_objref: support for stateful object maps
  netfilter: nf_tables: allow to filter stateful object dumps by type

 include/net/netfilter/nf_tables.h        |  91 +++++
 include/uapi/linux/netfilter/nf_tables.h |  67 ++-
 net/netfilter/Kconfig                    |   6 +
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nf_tables_api.c            | 674 ++++++++++++++++++++++++++++++-
 net/netfilter/nft_counter.c              | 138 +++++--
 net/netfilter/nft_objref.c               | 227 +++++++++++
 net/netfilter/nft_quota.c                | 116 +++++-
 8 files changed, 1256 insertions(+), 64 deletions(-)
 create mode 100644 net/netfilter/nft_objref.c

-- 
2.1.4


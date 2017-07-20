From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH 0/5] netfilter: nf_tables: Kill name length restrictions
Date: Thu, 20 Jul 2017 17:24:45 +0200
Message-ID: <20170720152450.27693-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:41989 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965021AbdGTPZ2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2017 11:25:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series removes the hard-coded restriction on name length
of tables, chains, sets and objects.

The first patch introduces nla_strdup() which aids in duplicating a
string contained in a netlink attribute. It is used to replace the call
to nla_strlcpy() when populating name fields.

I've tested the series manually by creating tables, chains, sets and
counter objects with long names and automated by running the py and
shell testsuites of nftables repo. Also, kmemleak did not find anything
nftables related.

Phil Sutter (5):
  networking: Introduce nla_strdup()
  netfilter: nf_tables: Unlimit table name length
  netfilter: nf_tables: Unlimit chain name length
  netfilter: nf_tables: Unlimit set name length
  netfilter: nf_tables: Unlimit object name length

 include/net/netfilter/nf_tables.h        |  10 +--
 include/net/netlink.h                    |   1 +
 include/uapi/linux/netfilter/nf_tables.h |   4 -
 lib/nlattr.c                             |  24 +++++
 net/netfilter/nf_tables_api.c            | 148 ++++++++++++++++++++-----------
 net/netfilter/nf_tables_trace.c          |  10 ++-
 net/netfilter/nft_dynset.c               |   3 +-
 net/netfilter/nft_lookup.c               |   3 +-
 net/netfilter/nft_objref.c               |   6 +-
 9 files changed, 138 insertions(+), 71 deletions(-)

-- 
2.13.1


From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH v3 0/6] netfilter: nf_tables: Kill name length restrictions
Date: Thu, 27 Jul 2017 16:56:38 +0200
Message-ID: <20170727145644.16888-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:38767 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751556AbdG0O5J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 10:57:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series lifts the tight restriction on name length of
tables, chains, sets and objects. This is done by allocating memory for
names dynamically, so there is no added overhead when reducing the
restriction to a mere sanity level of 255 characters.

The first patch removes a needless check discovered when discussing v2
of this patch set.

The second patch introduces nla_strdup() which aids in duplicating a
string contained in a netlink attribute. It is used to replace the call
to nla_strlcpy() when populating name fields.

I've tested the series manually by creating tables, chains, sets and
counter objects with long names and automated by running the py and
shell testsuites of nftables repo. Also, kmemleak did not find anything
nftables related.

Changes since v2:
- Added new patch 1.
- Patch 2 remains unchanged.
- Detailed changelog of remaining patches is found there.

Phil Sutter (6):
  netfilter: nf_tables: No need to check chain existence when tracing
  networking: Introduce nla_strdup()
  netfilter: nf_tables: Allow table names of up to 255 chars
  netfilter: nf_tables: Allow chain name of up to 255 chars
  netfilter: nf_tables: Allow set names of up to 255 chars
  netfilter: nf_tables: Allow object names of up to 255 chars

 include/net/netfilter/nf_tables.h        |  10 +--
 include/net/netlink.h                    |   1 +
 include/uapi/linux/netfilter/nf_tables.h |   9 +--
 lib/nlattr.c                             |  24 +++++++
 net/netfilter/nf_tables_api.c            | 112 +++++++++++++++++++++++--------
 net/netfilter/nf_tables_trace.c          |  42 +++++++++---
 6 files changed, 151 insertions(+), 47 deletions(-)

-- 
2.13.1


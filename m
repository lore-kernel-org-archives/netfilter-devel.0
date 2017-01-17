From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 0/3] Boolean comparison and exthdr existence match support
Date: Tue, 17 Jan 2017 23:10:04 +0100
Message-ID: <20170117221007.14951-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:42483 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751146AbdAQWHn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2017 17:07:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series adds two distinct features to nftables, though
since the second one depends on presence of the first one this is
submitted as a series.

Patch 1 adds support for a boolean variant of relational expression.
It's OP is strictly implicit and determined by RHS being a boolean
expression. It depends on a related kernel patch adding support for
NFT_CMP_BOOL to nft_cmp.c.

Patch 2 extends exthdr expression by a private flags field which will be
used in patch 3. It depends on a related patch for libnftnl to handle
the new field.

Patch 3 then adds support for checking extension header presence to
exthdr expression by making use of the previously introduced exthdr flag
NFT_EXTHDR_F_PRESENT. It's ideally used together with a boolean
relational expression for a syntax of e.g.:

| exthdr hbh exists

to match on hop-by-hop options presence or:

| exthdr frag missing

to match on packets without fragmentation header present.

Phil Sutter (3):
  Implement boolean comparison in relational expression
  exthdr: Add support for exthdr specific flags
  exthdr: Implement exthdr existence check

 include/expression.h                | 10 +++++++++
 include/exthdr.h                    |  4 ++++
 include/linux/netfilter/nf_tables.h |  1 +
 include/netlink.h                   |  2 ++
 src/evaluate.c                      | 13 ++++++++++++
 src/expression.c                    | 39 ++++++++++++++++++++++++++++++++++
 src/exthdr.c                        | 10 +++++++--
 src/netlink.c                       | 20 ++++++++++++++++++
 src/netlink_delinearize.c           | 12 +++++++++--
 src/netlink_linearize.c             |  4 ++++
 src/parser_bison.y                  | 42 +++++++++++++++++++++++++++++++++++++
 src/scanner.l                       |  7 +++++++
 12 files changed, 160 insertions(+), 4 deletions(-)

-- 
2.11.0


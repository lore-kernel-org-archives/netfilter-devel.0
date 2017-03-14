From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/9] ct helper set support
Date: Tue, 14 Mar 2017 20:58:07 +0100
Message-ID: <20170314195816.1721-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42136 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750780AbdCNT6A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 15:58:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series adds the frontend/nft support to define and
assign connection tracking helpers.

Example:

table inet myhelpers {
  ct helper ftp-standard {
     type "ftp"
     protocol tcp
  }
  chain prerouting {
      type filter hook prerouting priority 0;
      tcp dport 21 ct helper set "ftp-standard"
  }
}

A future extension could also allow to define/set knobs
that can only be set via module parameters at this time,
for instance the ftp 'loose mode' or the number of allowed expectations.

 doc/nft.xml                                   |   99 +++++++++++++++
 files/nftables/Makefile.am                    |    4 
 files/nftables/ipv4-raw                       |    6 
 files/nftables/ipv6-raw                       |    6 
 include/ct.h                                  |    1 
 include/datatype.h                            |    1 
 include/linux/netfilter/nf_conntrack_common.h |   80 ++----------
 include/linux/netfilter/nf_tables.h           |    5 
 include/rule.h                                |   12 +
 src/ct.c                                      |   40 ++++++
 src/evaluate.c                                |   37 ++++-
 src/netlink.c                                 |   16 ++
 src/parser_bison.y                            |  162 +++++++++++++++++++++++++-
 src/rule.c                                    |   59 +++++++++
 src/statement.c                               |   10 +
 tests/py/ip/objects.t                         |    4 
 tests/py/ip/objects.t.payload                 |   14 ++
 tests/py/nft-test.py                          |   11 +
 18 files changed, 481 insertions(+), 86 deletions(-)


From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 00/12] nftables: generic protocol contexts, "inet" family
Date: Wed,  8 Jan 2014 13:08:51 +0000
Message-ID: <1389186543-6919-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40180 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaAHNJK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:09:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches implement the necessary support for the mixed IPv4/IPv6
"inet" family. The patchset consists of two major parts:

- introduction of generic protocol contexts
- support for the inet family and nfproto/l4proto meta expression types

The generic protocol contexts are a generalization of the payload contexts.
Since not only the payload expression, but also the ct and meta expression
can imply higher or lower layer protocols, the context tracking is
generalized. A small patch for the ct expression for context dependant
parsing of ct-src, ct-dst, ct-proto-src and ct-proto-dst is also included.

Support for the inet family mainly consist of adding a mapping for the
parser and netlink support for "inet" <-> NFPROTO_INET and adding support
for the meta nfproto and l4proto types.

With this in place, we can create rules like:

inet filter output tcp dport ssh counter

to match on ssh traffic for both IPv4 and IPv6.

inet filter output nfproto ipv4 tcp dport ssh

to match on ssh traffic for only IPv4.

Sets etc. have been verified to work as expected.

I've rebased the patches on the next-3.14 branch and will push them to
the nftables tree shortly.

Patrick McHardy (12):
      expr: replace PAYLOAD_PROTOCOL_EXPR by generic flag
      nftables: generic procotol contexts
      expr: add protocol context update callback
      proto: add helper function to update protocol context
      proto: add debugging for protocol context updates
      ct expr: protocol context updates and dynamic typing
      include: resync nftables.h with kernel
      nftables: add support for the "inet" family
      netlink_delinearize: remove implied meta expressions
      proto: add support for meta templates
      meta: add nfproto support
      meta: add l4proto support

 include/ct.h                        |   1 +
 include/datatype.h                  |   3 +
 include/expression.h                |  18 +-
 include/exthdr.h                    |   6 +-
 include/linux/netfilter.h           |  22 +-
 include/linux/netfilter/nf_tables.h | 116 ++++-
 include/nftables.h                  |   1 +
 include/payload.h                   | 288 +-----------
 include/proto.h                     | 304 +++++++++++++
 include/rule.h                      |   2 +-
 src/Makefile.in                     |   1 +
 src/ct.c                            |  58 +++
 src/datatype.c                      |  18 +
 src/evaluate.c                      |  47 +-
 src/exthdr.c                        |  26 +-
 src/main.c                          |   6 +-
 src/meta.c                          |  70 +++
 src/netlink_delinearize.c           |  43 +-
 src/parser.y                        |  43 +-
 src/payload.c                       | 855 +++---------------------------------
 src/proto.c                         | 814 ++++++++++++++++++++++++++++++++++
 src/rule.c                          |   3 +
 src/scanner.l                       |   4 +
 23 files changed, 1581 insertions(+), 1168 deletions(-)


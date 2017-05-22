From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 0/4 RFC] Support IPv6 AH header matches
Date: Mon, 22 May 2017 18:49:32 +0200
Message-ID: <20170522164936.28034-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:34933 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934960AbdEVQtt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 May 2017 12:49:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series allows users to match on IPv6 AH header fields. I
consider this a bit of a hack since it's the "cheap" solution. As to why
this is, let me first picture the problem once again:

AH header is an extension header in IPv6 land. This means in order to
find it, one has to use ip6_find_hdr() (in kernel space) since
pkt->xt.thoff (which payload expression uses) points past extension
headers in IPv6 packets. So while the existing AH header match for IPv4
uses payload expression, a theoretical one for IPv6 has to use exthdr
expression.

Expressions are constructed in user space at rule creation time, so it
is not always clear which packet family they will get applied to (see
inet or bridge family tables).

I see two alternatives for solving this situation: The better one is to
allow the kernel to choose the right expression (payload or exthdr)
depending on IP address family when searching the AH header. The other
one is presented here: Userspace demands the user to clarify which IP
address family an AH header match should apply to, so it can create the
right expression for the job.

For the sake of simplicity, in this implementation I went without some
kind of placeholder expression but just convert the parser-generated
payload expression into an exthdr one if protocol context states layer 3
is IPv6.

I looked at netlink debug output and the following commands seem to turn
out right:

| $ nft add rule ip t c ah spi 2	# ip table family
| $ nft add rule ip6 t c ah spi 2	# ip6 table family
| $ nft add rule inet t c ip6 version 6 ah spi 2
| $ nft add rule inet t c ip version 4 ah spi 2

There are still a few oddities here: E.g. 'meta protocol ip6' is not
sufficient since that doesn't create a protocol dependency, hence why I
used the somewhat redundant 'ip6 version 6' match instead. So if we
decide to use the solution proposed here, I'd suggest do patch up meta
expression to generate the dependency as well.

Phil Sutter (4):
  payload: Carry template number around for internal use
  exthdr: Align max templates count with payload expr
  exthdr: Define AH header description
  payload: Convert AH header expression to exthdr for IPv6

 include/expression.h |  1 +
 include/exthdr.h     |  3 ++-
 src/evaluate.c       | 30 ++++++++++++++++++++++++++++++
 src/exthdr.c         | 16 ++++++++++++++++
 src/payload.c        |  1 +
 5 files changed, 50 insertions(+), 1 deletion(-)

-- 
2.11.0


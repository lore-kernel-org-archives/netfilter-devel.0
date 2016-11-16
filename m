From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/2] netfilter: nat: fix regressions introduced by rhashtable conversion
Date: Wed, 16 Nov 2016 15:13:34 +0100
Message-ID: <1479305616-4171-1-git-send-email-fw@strlen.de>
Cc: herbert@gondor.apana.org.au
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49170 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752291AbcKPON3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Nov 2016 09:13:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These two patches address bugs added when I converted the nat bysource hash
to rhashtable.

First patch fixes object comparision, second patch converts
nat bysource to the rhlist interface, we have to deal with identical
source identities (distinct connections sharing same ip/port source pair).

Unfortunately the rhashlist interface isn't available in 4.8, so the question
is how to address patch #2 for -stable.

One way would be to revert the rhashtable conversion, the other one
would be to just set .insecure_elasticity in the rhashtable params.

The latter should work fine, as we do NOT need to identify the individual
duplicate keys.

 include/net/netfilter/nf_conntrack.h |    2 -
 net/netfilter/nf_nat_core.c          |   49 +++++++++++++++++++++--------------
 2 files changed, 31 insertions(+), 20 deletions(-)

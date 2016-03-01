From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 00/10] nft: exthdr fixes and improvements
Date: Tue,  1 Mar 2016 16:37:40 +0100
Message-ID: <1456846670-28179-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49296 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543AbcCAPhc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 10:37:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds following enhancements and fixes for the exthdr
expression.

#1.  Treat exthdr as if user asked for an ip6 protocol header field,
i.e. add ipv6 dependency for bridge/netdev/inet family.

#2.  Add scaling and masking to handle protocol headers that have
non-byte divisible sizes.

Tested briefly with following dummy rules (nf_defrag_ipv6 module not loaded):

frag frag-off 0 counter packets 40 bytes 59840
frag frag-off 131 counter packets 0 bytes 0
frag frag-off 1448 counter packets 0 bytes 0
frag frag-off 181 counter packets 40 bytes 59840
frag frag-off > 0 counter packets 120 bytes 148160

Note that the offsets are *NOT* scaled, i.e. we match the raw values
contained in the packet.  To match offset of 1448 one thus needs to
ask for 181.

This is same behaviour as ip hdrlength, where 5 matches a value of 20 bytes.

 include/expression.h             |    1
 include/exthdr.h                 |    2
 include/payload.h                |    2
 src/evaluate.c                   |   29 +++++++
 src/exthdr.c                     |   33 ++++++++
 src/netlink_delinearize.c        |   36 +++++----
 src/netlink_linearize.c          |   62 +++++++++++----
 src/payload.c                    |   75 ++++++++++++-------
 tests/py/ip6/dst.t.payload.inet  |   30 +++++++
 tests/py/ip6/frag.t              |   63 ++++++++++++++++
 tests/py/ip6/frag.t.payload.inet |  145 +++++++++++++++++++++++++++++++++++++
 tests/py/ip6/frag.t.payload.ip6  |  109 +++++++++++++++++++++++++++
 tests/py/ip6/hbh.t.payload.inet  |   30 +++++++
 tests/py/ip6/mh.t.payload.inet   |   64 ++++++++++++++++
 tests/py/ip6/rt.t.payload.inet   |   58 ++++++++++++++
 tests/py/any/frag.t                |   67 -----------------
 tests/py/any/frag.t.payload        |  109 ---------------------------
 17 files changed, 685 insertions(+), 230 deletions(-)

Note: frag-off match is broken at the moment, I passed a patch
to netdev:

https://patchwork.ozlabs.org/patch/590568/


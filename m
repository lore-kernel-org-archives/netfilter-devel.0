From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/2] netfilter: simplify nf_defrag_ipv6
Date: Wed, 18 Nov 2015 23:32:38 +0100
Message-ID: <1447885960-5495-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46925 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757087AbbKRWcv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Nov 2015 17:32:51 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 6aafeef03b9d9ecf
("netfilter: push reasm skb through instead of original frag skbs")
changed ipv6 defrag to not use the original skbs anymore.

However, we still clone fragment skbs and retain original ones
just to free them soon after.  Since reassembled skb is newly
allocated, we also need to recursively re-invoke the netfilter hooks
so they can work on the reassembled skb.

This removes those clone/free operations and also avoids the
hook reinvocation by morphing the reassembled skb into the last skb
(i.e. the skb that completes the frag queue), just like ipv4 defrag.

include/net/netfilter/ipv6/nf_defrag_ipv6.h |    3
net/ipv6/netfilter/nf_conntrack_reasm.c     |  168 +++++++++++-----------------
net/ipv6/netfilter/nf_defrag_ipv6_hooks.c   |   20 ---
net/openvswitch/conntrack.c                 |   25 ----
4 files changed, 78 insertions(+), 138 deletions(-)

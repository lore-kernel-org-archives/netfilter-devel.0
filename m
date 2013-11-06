From: Jiri Pirko <jiri@resnulli.us>
Subject: [patch net-next 0/2] netfilter: push reasm skb through instead of original frag skbs
Date: Wed,  6 Nov 2013 17:52:18 +0100
Message-ID: <1383756740-7392-1-git-send-email-jiri@resnulli.us>
Cc: davem@davemloft.net, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org, yoshfuji@linux-ipv6.org,
	kadlec@blackhole.kfki.hu, kaber@trash.net, mleitner@redhat.com,
	kuznet@ms2.inr.ac.ru, jmorris@namei.org, wensong@linux-vs.org,
	horms@verge.net.au, ja@ssi.bg, edumazet@google.com,
	pshelar@nicira.com, jasowang@redhat.com,
	alexander.h.duyck@intel.com, fw@strlen.de
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:34599 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3KFQwZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:52:25 -0500
Received: by mail-ee0-f44.google.com with SMTP id d41so2539165eek.31
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Nov 2013 08:52:24 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jiri Pirko (2):
  ip6_output: fragment outgoing reassembled skb properly
  netfilter: push reasm skb through instead of original frag skbs

 include/linux/skbuff.h                         | 32 ---------------
 include/net/ip_vs.h                            | 32 +--------------
 include/net/netfilter/ipv6/nf_defrag_ipv6.h    |  4 +-
 net/core/skbuff.c                              |  3 --
 net/ipv6/ip6_output.c                          |  3 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c | 56 +-------------------------
 net/ipv6/netfilter/nf_conntrack_reasm.c        | 19 +--------
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |  7 +++-
 net/netfilter/ipvs/ip_vs_core.c                | 55 +------------------------
 net/netfilter/ipvs/ip_vs_pe_sip.c              |  8 +---
 10 files changed, 15 insertions(+), 204 deletions(-)

-- 
1.8.3.1


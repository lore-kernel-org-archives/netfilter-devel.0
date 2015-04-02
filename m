From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 0/6] netfilter: prepare for skb->nf_bridge removal
Date: Thu,  2 Apr 2015 14:31:39 +0200
Message-ID: <1427977905-9927-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44233 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753000AbbDBMb4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2015 08:31:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series prepares skb->nf_bridge pointer removal.

This is a resend without the ip_fragment changes since
its not clear to me (yet) how to resolve that.

This also means that this resend doesn't include the skb->nf_bridge
removal since the 'mtu reduction' in ip_fragment() should
be made private to bridge netfilter first.

Feedback welcome.

 include/linux/netfilter_bridge.h           |   28 +++++-
 include/linux/skbuff.h                     |    8 +
 net/bridge/br_netfilter.c                  |  127 +++++++++++++++++------------
 net/ipv4/netfilter/nf_reject_ipv4.c        |    4 
 net/ipv6/netfilter/nf_reject_ipv6.c        |    4 
 net/netfilter/ipset/ip_set_hash_netiface.c |   32 +++++--
 net/netfilter/nf_log_common.c              |    5 -
 net/netfilter/nf_queue.c                   |   18 ++--
 net/netfilter/nfnetlink_log.c              |   17 ++-
 net/netfilter/nfnetlink_queue_core.c       |   28 ++++--
 net/netfilter/xt_physdev.c                 |   34 +++++--
 11 files changed, 204 insertions(+), 101 deletions(-)

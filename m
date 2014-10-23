From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/3] netfilter: nf_log: nlmsg size fixes
Date: Thu, 23 Oct 2014 10:36:05 +0200
Message-ID: <1414053368-29037-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49320 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752216AbaJWIgP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:36:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following three patches attempt to cure the reported
nlmsg skb trailroom exhaustion bug.

First two patches add missing size accounting, third patch
relaxes the impact of out-of-tailroom by tossing the skb
and giving a WARN_ONCE trace with size information, so we can
investigate further if needed.

Florian Westphal (2):
      netfilter: nf_log: account for size of NLMSG_DONE attribute in skb size
      netfilter: nfnetlink_log: fix maximum packet length logged to userspace

Houcheng Lin (1):
      netfilter: nf_log: release skbuff on nlmsg put failure

 net/netfilter/nfnetlink_log.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

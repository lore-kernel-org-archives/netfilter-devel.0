From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: remove need for skb_clone in nf_fwd_netdev_egress
Date: Mon, 28 Nov 2016 11:40:04 +0100
Message-ID: <1480329606-6592-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35034 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751148AbcK1Kjv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 05:39:51 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

forward expression currently clones the skb, then forwards the clone and returns
NF_DROP to the core.

First patch allows using NF_STOLEN from ingress/netdev hook, 2nd patch
adds a new helper that then forwards the original skb.


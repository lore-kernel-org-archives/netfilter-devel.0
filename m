From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: convert hook list to an array
Date: Wed, 23 Aug 2017 17:26:24 +0200
Message-ID: <20170823152627.19865-1-fw@strlen.de>
Cc: aconole@bytheb.org
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58158 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932304AbdHWP0K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2017 11:26:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series converts netfilters linked-list to an array.
This improves cache utilization as the next hook will be either
in same or next cacheline.

Tested:
- nfqueue test program still works
- ip and ebtables rule counters increment
- nftables can register base chains

Joint work with Aaron Conole.

Aaron Conole (1):
      netfilter: convert hook list to an array

Florian Westphal (4):
      netfilter: debug: check for sorted array
      netfilter: core: batch nf_unregister_net_hooks synchronize_net calls


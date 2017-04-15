From: Florian Westphal <fw@strlen.de>
Subject: netfilter: nftables: ctnetlink event type set support
Date: Sat, 15 Apr 2017 10:45:02 +0200
Message-ID: <20170415084505.26176-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56828 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751893AbdDOIos (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 04:44:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nftables equivalent for -j CT --ctevents.

Unlike iptables this doesn't work with conntrack templates,
it must be used with the real conntrack objects instead (i.e.,
after conntrack picked the packet up for processing).

patch #1 is for kernel, 2 and 3 for libnftnl/nftables userland.


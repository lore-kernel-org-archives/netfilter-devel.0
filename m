From: Florian Westphal <fw@strlen.de>
Subject: [PATCH next] nftables: add inbound ipsec matching
Date: Fri,  1 Dec 2017 13:40:18 +0100
Message-ID: <20171201124021.20973-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40870 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752418AbdLAMkT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Dec 2017 07:40:19 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This can be used to check if a packet has a secpath attached to it, i.e.
was subject to ipsec processing.  Example:

add rule inet raw prerouting meta secpath exists accept

More complex matching implemented in xt_policy is not supported
at this point.

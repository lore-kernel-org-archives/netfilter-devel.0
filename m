From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/3 various] netfilter: add fib expression
Date: Mon, 24 Oct 2016 16:56:39 +0200
Message-ID: <1477321002-14056-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45996 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932806AbcJXO4Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Oct 2016 10:56:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds the FIB expression to query fib for oif and route/address type.

This provides functionality of the xtables 'rpfilter' and 'addrtype' matches.

The '--local' option supported by the rpfilter match is not supported
anymore, but it is possible to use extra rules (either checking for explicit
saddr/daddr pairs) or the 'fib type' result to make packets coming from
external source but with a locally configured address bypass 'fib oif'
queries.

oif is supported in prerouting, type can be used in all hooks.  The
kernel validates that the combinations make sense (e.g., you cannot
ask for iif in OUTPUT).

ipv4, ipv6 and inet families are supported at the moment.

Comments welcome.

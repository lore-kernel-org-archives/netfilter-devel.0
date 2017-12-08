From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: disable parallel use of xtables and nftables nat
Date: Fri,  8 Dec 2017 17:01:52 +0100
Message-ID: <20171208160155.968-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52218 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754475AbdLHQCT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Dec 2017 11:02:19 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The netfilter NAT core cannot deal with both nftables and ip(6)tables nat
at the same time.
When both are active, one of the two will not work, depending on the
order in which the modules were loaded.

NAT hooks install a NAT null binding in case the iptables/nftables
nat chain did not specify a nat mapping.

Null bindings are needed to detect port collsisions between NAT-ed and
non-NAT-ed connections.

This causes nftables NAT rules to not work when iptable_nat module is
loaded, and vice versa because nat binding has already been attached
when the second nat hook is consulted.

The alternative is to allow both at the same time.
This requirs new internal nat hooks to do the null binding, but doesn't
handle the more fundamental issue of precedence.

Example:

iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
nft add rule ip nat postrouting oifname ppp0 ip protocol udp dport 53 snat to 10.1.1.1

should nft override iptables?
What if one is restored before the other (this seems to be the worst part as it could
cause random behaviour with parallel init schemes ...)

So, better explicitly disallow this for now.


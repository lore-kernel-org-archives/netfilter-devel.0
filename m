From: Florian Westphal <fw@strlen.de>
Subject: Re: [Bug 1145] nft 0.7: expression.c:966: range_expr_value_low:
 Assertion '0' failed.
Date: Mon, 15 May 2017 14:03:57 +0200
Message-ID: <20170515120357.GA32767@breakpoint.cc>
References: <bug-1145-20@https.bugzilla.netfilter.org/>
 <bug-1145-20-O7t1kbwESB@https.bugzilla.netfilter.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ian.kumlien@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36504 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758339AbdEOMEe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 08:04:34 -0400
Content-Disposition: inline
In-Reply-To: <bug-1145-20-O7t1kbwESB@https.bugzilla.netfilter.org/>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

bugzilla-daemon@netfilter.org <bugzilla-daemon@netfilter.org> wrote:

[ Switching to email ]

> https://bugzilla.netfilter.org/show_bug.cgi?id=1145
> 
> --- Comment #1 from Ian Kumlien <ian.kumlien@gmail.com> ---
> Is there anything obvious that i'm doing wrong? Is there something else i could
> try?

This boils down to nested sets:

define dnat_host        = 10.1.2.3
define dnat_ports       = { 1234-1567 }

define port_allow = {
        53,             # dns
        $dnat_ports,    # dnat
}
define port_allow_tcp = {
        80,
        443,
        $port_allow
}
define port_allow_udp = {
        67, 68,         # dhcp
        123, 1027,      # ntp
        $port_allow
}

... which we don't support at the moment.

So, should we
a). expand/'inline' the sets?

(i.e. port_allow_tcp would contain
 1234-1567, 53, 80, 443)

b) support lookups within lookups?

This would be needed to support non-anonymous sets within sets.

or

c) never support this?  This would probably need some work on parser
to be able to provide a clean error message rather than BUG() ...

Opinions?


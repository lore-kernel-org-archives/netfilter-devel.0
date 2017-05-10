From: Phil Sutter <phil@nwl.cc>
Subject: RFC: Ideas about possible solutions for nfbz#949
Date: Wed, 10 May 2017 17:34:29 +0200
Message-ID: <20170510153429.GZ20805@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:50599 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753487AbdEJPeb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2017 11:34:31 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Netfilter Bugzilla #949[1] complains about broken output when trying to
match icmpv6 message fields. This is a problem in how payload match is
implemented in nft: The given match (e.g. 'icmp6 id 2') is broken down
to a simple match of header data at a specific offset. Sadly this does
not work with ICMP(v6) since header structure depends on the packet's
ICMP type and on return path there is no information about which type of
message the user wanted to match against.

My idea was to build something like the protocol dependencies we have
for e.g. TCP header fields but with ICMP, a given header field might be
present in multiple message types (e.g. icmp6_id is present in echo
request as well as reply).

I already considered inserting a match for icmp6 type against an
anonymous set (like 'icmp6 type { echo-request, echo-reply }'), but
having this as an implicit dependency and resolving with previous
matches, etc. becomes pretty complex.

Do you think I should try following a different approach (via userdata
e.g.)?

Thanks, Phil

[1] https://bugzilla.netfilter.org/show_bug.cgi?id=949

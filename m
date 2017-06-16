From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/4] restrict meta nfproto to inet family
Date: Fri, 16 Jun 2017 22:34:07 +0200
Message-ID: <20170616203411.16408-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39944 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751923AbdFPUdw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Jun 2017 16:33:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo reports following test case failure:

any/ct.t: ERROR: line 94: src/nft add rule --debug=netlink ip6
test-ip6 output meta nfproto ipv4 ct original saddr 1.2.3.4: This rule should not have failed.

We can't find upper layer protocol in this case, but even if we'd
"fix" this it is still non-sensical, as

  meta nfproto ipv4

will never match except in the inet family and the
ip family, but in the latter case it will always match so it
has no effect).

So, first step is to move this to an inet specific test to
get rid of the test case failure.

The followup changes then get rid of meta nfproto tests or
move them to inet-family-only tests.

The last patch makes nft reject 'meta nfproto' in all families
except inet, where this expression is needed in case one wants to
explicitly restrict a rule to only ipv4 or ipv6.

From: Florian Westphal <fw@strlen.de>
Subject: netfilter: x_tables: ratelimit most printks
Date: Wed,  7 Feb 2018 14:48:21 +0100
Message-ID: <20180207134828.18691-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38812 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753731AbeBGNtp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 08:49:45 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Aeons ago, before namespaces, there was no need to ratelimit this:
all of these error messages got triggered in response to iptables
commands, which need CAP_NET_ADMIN.

Nowadays we have namespaces, so its better to ratelimit these.
This should also help fuzzing (syzkaller), as it can generate a large
volume of error messages (which are useless there).

The patches are split as follows:
- first get rid of printks that should never be triggered, as userland
  doesn't generate such malformed rules anyway.
- second, switch some printks to pr_debug.  This is mostly for messages
  where it might make sense for developers to see what exactly went
  wrong.

Rest of the patches swap remaining pr_foo with pr_foo_ratelimited().

Note that most patches introduce overly long lines, but splitting these
would make it necessary to split the error messages which is worse.

46 files changed, 254 insertions(+), 257 deletions(-)

